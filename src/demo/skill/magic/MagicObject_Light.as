/**
 * 闪电链
 */	
package demo.skill.magic
{
	import flash.display.BlendMode;
	import flash.display3D.Context3DCompareMode;
	
	import away3d.animators.CPUSpriteSheetAnimator;
	import away3d.materials.TextureMaterial;
	import away3d.ribbon.LightningRibbon;
	import away3d.textures.AsyncTexture2D;
	
	import demo.display3D.Avatar3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	import demo.path.ConfigPath;
	import demo.skill.SkillDetailVO;
	
	public class MagicObject_Light extends MagicBase
	{
		private var _from:Avatar3D;
		private var _to:Avatar3D;
		private var _ownerPlayer:Avatar3D;
		
		private static const BallSpeed:Number = 80;
		
		//自动追踪最多5个目标
		private var _suffererList:Vector.<Avatar3D>;
		private static const MAX_COUNT:int = 5;
		private var _lightList:Vector.<LightningRibbon>;
		
		private static var LightMaterial:TextureMaterial;
		
		public function MagicObject_Light(Id:uint, OwnerId:uint, X:int, Y:int)
		{
			super(Id, OwnerId, X, Y);
			_lightList = new Vector.<LightningRibbon>();
			
			if(LightMaterial == null)
			{
//				var tex:AsyncTexture2D = Cast.asyncTexture(new EmbedAssets.LightningIMG().bitmapData, true);
				var tex:AsyncTexture2D = new AsyncTexture2D(true, true, false);
				tex.load(ConfigPath.RibbonIMG)
				
				LightMaterial = new TextureMaterial(tex);
				LightMaterial.bothSides = true;
				LightMaterial.blendMode = BlendMode.ADD;
				LightMaterial.depthCompareMode = Context3DCompareMode.LESS;
			}
		}
		
		override public function initMagicData(Id:uint, OwnerId:uint, ConfigId:int, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):void
		{
			super.initMagicData(Id, OwnerId, ConfigId, TargetId, X, Y, Arg1, Arg2);
			_to = _world.getAvatar3D(suffererId);
			_from = _ownerPlayer = creater as Avatar3D;
			
			addTimeHandlerAt(4000, on4000Ms);
			
			collectMonsters();
			
			light(_from, _to);
		}
		
		private function collectMonsters():void
		{
			_suffererList = new Vector.<Avatar3D>();
			var m:Avatar3D;
			
			var fillCount:int = MAX_COUNT * 4;//先多选一些出来用于比较
			for each(m in _world.monsters)
			{
				if(m.isDead || m.godMode || m == _to)
					continue;
				if(creater.distanceToPos(m.x, m.z) < 3000)
				{
					_suffererList.push(m);
					if(_suffererList.length >= fillCount)
						break;
				}
			}
			
			//排序
			var newList:Vector.<Avatar3D> = new Vector.<Avatar3D>();
			
			var last:Avatar3D = _to;
			var distance:int;
			var target:Avatar3D;
			while(last)
			{
				if(last != _to)
				{
					newList.push(last);
					if(newList.length >= MAX_COUNT)
						break;
				}
				distance = 1500;//闪电链之间的最大距离，超过这个就断掉了！
				target = null;
				for each(m in _suffererList)
				{
					var d:int = last.distanceToPos(m.x, m.z);
					if(d < distance)
					{
						distance = d;
						target = m;
					}
				}
				
				if(target)
				{
					_suffererList.splice(_suffererList.indexOf(target), 1);
					last = target;
				}
				else
				{
					last = null;
				}
			}
			_suffererList = newList;
			
		}
		
		
		private function on4000Ms():void
		{
			recycleEnable = true;
		}
		
		override protected function updatePosition():void
		{
		}
		
		override public function onNetActive(Value:uint):void
		{
			
		}
		
		private function light(from:Avatar3D, to:Avatar3D):void
		{
			if(_from && _to)
			{
				var ribbon:LightningRibbon = new LightningRibbon(_from.underAttackContainer, _to.underAttackContainer, 16, 128, LightMaterial);
				ribbon.shakeTimer = 100;
				ribbon.animator = new CPUSpriteSheetAnimator(8, 1, 15, 8);
				ribbon.start();
				
				_lightList.push(ribbon);
				WorldManager.instance.gameScene3D.addChild(ribbon);
			}
			var skill:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_ATTACK270);
			BattleSystemManager.getInstance().singleAttack(_ownerPlayer, _to, skill);
		}
		
		
		private static const excuteInterval:int = 100;
		private var _excuteDelay:int = excuteInterval;
		private var _recycleDelay:int = 200;
		
		override public function run(deltaTime:uint):void
		{
			super.run(deltaTime);
			_excuteDelay -= deltaTime;
			_recycleDelay -= deltaTime;
			
			if(_excuteDelay <= 0)
			{
				_excuteDelay = excuteInterval;
				if(_suffererList.length == 0)
				{
					recycleEnable = true;
				}
				else
				{
					_from = _to;
					_to = _suffererList.shift();
					light(_from, _to);
				}
				
			}
			
			if(_recycleDelay <= 0)
			{
				_recycleDelay = excuteInterval;
				var ribbon:LightningRibbon = _lightList.shift();
				if(ribbon)
				{
					ribbon.stop();
					ribbon.dispose();
					WorldManager.instance.gameScene3D.removeChild(ribbon);
				}
			}
		}
		
		
		
		override public function resetMagic(Id:int=0, Name:String=null):void
		{
			for each(var ribbon:LightningRibbon in _lightList)
			{
				ribbon.stop();
				ribbon.dispose();
			}
			_lightList.length = 0;
			setGroundXY(0, 0);
			_excuteDelay = excuteInterval;
			_recycleDelay = 1000;
			_from = _to = _ownerPlayer = null;
			super.resetMagic(Id, Name);
		}
	}
}

