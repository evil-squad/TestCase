/**
 * 直线飞行，不锁定目标的弹道
 */	
package demo.skill.magic
{
	import flash.display.BlendMode;
	import flash.geom.Vector3D;
	
	import away3d.materials.TextureMaterial;
	import away3d.ribbon.ParentAsTargetSinglePointRibbon;
	import away3d.ribbon.SinglePointRibbon;
	import away3d.textures.AsyncTexture2D;
	import away3d.utils.Cast;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.SkillManager;
	import demo.path.ConfigPath;
	import demo.skill.SkillDetailVO;

	public class MagicObject_1 extends MagicBase
	{
		private var _ballEffect:Particle3D;
		private var _explodeEffect:Particle3D;
		
		private var _orgX:Number;
		private var _orgY:Number;
		
		private var _vX:Number = 0;
		private var _vY:Number = 0;
		
		private var _ownerPlayer:Avatar3D;
		private var _lastHeightPos:Number = 0;
		private static const BallSpeed:Number = 16;
		private static const tempVector:Vector3D = new Vector3D();
		public static const EffectName1:String = "../assets/effect/skill/mingzhongdandao/dandao02.awd";
		
		private static var ribbonMaterial:TextureMaterial;
		
		private var _singlePointRibbon:SinglePointRibbon;
		
		public function MagicObject_1(Id:uint, OwnerId:uint, X:int, Y:int)
		{
			super(Id, OwnerId, X, Y);
			if(!ribbonMaterial)
			{
				var tex:AsyncTexture2D = new AsyncTexture2D(true, true, false);
				tex.load(ConfigPath.RibbonMaterial);
				ribbonMaterial = new TextureMaterial(tex);
				ribbonMaterial.blendMode = BlendMode.ADD;
			}
		}
		
		override public function initMagicData(Id:uint, OwnerId:uint, ConfigId:int, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):void
		{
			super.initMagicData(Id, OwnerId, ConfigId, TargetId, X, Y, Arg1, Arg2);
			_vX = Arg1 - X;
			_vY = Arg2 - Y;
			
			_orgX = X;
			_orgY = Y;
			
			tempVector.setTo(_vX, 0, _vY);
			tempVector.normalize();
			tempVector.scaleBy(BallSpeed);
			
			_vX = tempVector.x;
			_vY = tempVector.z;
			
			setGroundXY(_orgX, _orgY);
			_lastHeightPos = y;
			
			if(_ballEffect == null)
			{
				_ballEffect = _particleManager.getParticle(EffectName1, null);
			}
			if(_ballEffect)
			{
				_ballEffect.y = 100;
				ObjFaceTo3DSpace(_ballEffect, _vX, _vY, 100);
				graphicDis.addChild(_ballEffect);
			}
			addTimeHandlerAt(3000, on3000Ms);
			_ownerPlayer = creater as Avatar3D;
			
			if(!_singlePointRibbon)
			{
				_singlePointRibbon = new ParentAsTargetSinglePointRibbon(25, 50, ribbonMaterial);
			}
			_ballEffect.addChild(_singlePointRibbon);
			_singlePointRibbon.start();
		}
		
		override protected function updatePosition():void
		{
			
		}
		
		private function on3000Ms():void
		{
			onNetActive(0);
		}
		
		override public function onNetActive(Value:uint):void
		{
			var explode:Particle3D = _particleManager.getParticle("../assets/effect/skill/mingzhongdandao/mingzhong.awd", null, null, 1000);
			_world.addObject(explode);
			explode.position = graphicDis.scenePosition;
			explode.y += 100;
			recycleEnable = true;
		}

		private var _lastSearchTimer:int;
		override public function run(deltaTime:uint):void
		{
			super.run(deltaTime);
			
			setGroundXY(x + _vX * deltaTime / 17, z + _vY * deltaTime / 17);
			
			y = _lastHeightPos;
			_lastSearchTimer += deltaTime;
			if(_lastSearchTimer > 40)
			{
				checkAttack();
				_lastSearchTimer = 0;
			}
			
		}
		
		private static const CurrentPos:Vector3D = new Vector3D();
		private function checkAttack():void
		{
			if(_ownerPlayer)
			{
				var enemyCount:int = BattleSystemManager.getInstance().searchEnemyCount(_ownerPlayer, 120, x, z);
				if(enemyCount > 0)
				{
					var skill:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.MONSTER_SKILL_1);
					BattleSystemManager.getInstance().circleAttack(_ownerPlayer, 250, skill, 9999, x, z);
					onNetActive(1);
				}
				else
				{
//					CurrentPos.setTo(x, y, z);
//					if(_world.district == null || _world.district.isPointInSide(CurrentPos) == false)
//					{
//						onNetActive(0);
//					}
				}
			}
		}
		
		override public function dispose():void
		{
			if(_singlePointRibbon)
			{
				_singlePointRibbon.stop();
				_singlePointRibbon.dispose();
				_singlePointRibbon = null;
			}
			
			super.dispose();
		}
		
		override public function resetMagic(Id:int=0, Name:String=null):void
		{
			if(_ballEffect)
			{
				_particleManager.recycleParticle(_ballEffect);
				_ballEffect = null;  
			}
			setGroundXY(0, 0);
			super.resetMagic(Id, Name);
		}
	}
}

