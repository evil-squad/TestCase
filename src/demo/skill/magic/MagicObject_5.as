/**
 * 跟踪目标飞行的弹道
 */	
package demo.skill.magic
{
	import flash.display.BlendMode;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Matrix3DUtils;
	import away3d.materials.TextureMaterial;
	import away3d.ribbon.ParentAsTargetSinglePointRibbon;
	import away3d.ribbon.SinglePointRibbon;
	import away3d.textures.AsyncTexture2D;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.SkillManager;
	import demo.path.ConfigPath;
	import demo.skill.SkillDetailVO;
	
	public class MagicObject_5 extends MagicBase
	{
		private var _ballEffect:Particle3D;
		private var _explodeEffect:Particle3D;
		
		private var _orgX:Number;
		private var _orgY:Number;
		
		private var _vX:Number = 0;
		private var _vY:Number = 0;
		
		private var _ownerPlayer:Avatar3D;
		private var _lastHeightPos:Number = 0;
		
		private var _sufferer:Avatar3D;
		
		private static const TotalTime:int = 1999;
		private static const BallSpeed:Number = 16;
		public static const EffectName1:String = "../assets/effect/skill/mingzhongdandao/mingzhong02.awd";
		private static const EffectName2:String = "../assets/effect/skill/mingzhongdandao/dandao02.awd";
		
		
		private static var ribbonMaterial:TextureMaterial;
		
		private var _singlePointRibbon:SinglePointRibbon;
		private var _inHand:Boolean = true;
		public function MagicObject_5(Id:uint, OwnerId:uint, X:int, Y:int)
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
			
			_inHand = true;
			
			_orgX = X;
			_orgY = Y;
			_ownerPlayer = creater as Avatar3D;
			
			setGroundXY(_orgX, _orgY);
			_lastHeightPos = y = y + 150;
			_sufferer = _world.getAvatar3D(suffererId);
			if(_sufferer)
			{
				_vX = _sufferer.x - x;
				_vY = _sufferer.z - z;
				var tempVector:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
				tempVector.setTo(_vX, 0, _vY);
				tempVector.normalize();
				tempVector.scaleBy(BallSpeed);
				
				_vX = tempVector.x;
				_vY = tempVector.z;
				ObjFaceTo3DSpace(graphicDis, _sufferer.x, _sufferer.z, _sufferer.y);
				graphicDis.rotationY -= 90;//等到修复后，可以删除。
			}

			
			if(_ballEffect == null)
			{
				_ballEffect = _particleManager.getParticle(EffectName2, null);
			}
			var container:ObjectContainer3D = _ownerPlayer.mesh.getChildByName("blade_tag");
			if(container)
			{
				container.addChild(_ballEffect);
			}
			else
			{
				graphicDis.addChild(_ballEffect);
			}
			
			addTimeHandlerAt(TotalTime, on3000Ms);
			addTimeHandlerAt(300, startFly);
			
			if(!_singlePointRibbon)
			{
				_singlePointRibbon = new ParentAsTargetSinglePointRibbon(25, 50, ribbonMaterial);
			}
			_ballEffect.scale(1 / _ownerPlayer.scaleX);
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
		
		private function startFly():void
		{
			_inHand = false;
			_ballEffect.scale(_ownerPlayer.scaleX);
			graphicDis.addChild(_ballEffect);
		}
		
		override public function onNetActive(Value:uint):void
		{
			var explode:Particle3D = _particleManager.getParticle(EffectName1, null, null, 2000);
			_world.addObject(explode);
			explode.position = graphicDis.scenePosition;
			recycleEnable = true;
		}
		
		private var _lastSearchTimer:int;
		override public function run(deltaTime:uint):void
		{
			super.run(deltaTime);
			_sufferer = _world.getAvatar3D(suffererId);
			if(_sufferer == null)
			{
				recycleEnable = true;
				return;
			}
			if(_inHand)
			{
				
			}
			else
			{
				setGroundXY(x + _vX * deltaTime / 17, z + _vY * deltaTime / 17);
				if(_sufferer == null)
				{
					onNetActive(0);
					return;
				}
				y = _lastHeightPos = _lastHeightPos + ((_sufferer.y + 150) - _lastHeightPos) / 20;
				_lastSearchTimer += deltaTime;
				if(_lastSearchTimer > 40)
				{
					checkAttack();
					_lastSearchTimer = 0;
				}
				
				_vX = _sufferer.x - x;
				_vY = _sufferer.z - z;
					
				var tempVector:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
				tempVector.setTo(_vX, 0, _vY);
				tempVector.normalize();
				tempVector.scaleBy(BallSpeed);
				
				_vX = tempVector.x;
				_vY = tempVector.z;
				
				
				ObjFaceTo3DSpace(graphicDis, _sufferer.x, _sufferer.z, _sufferer.y);
				graphicDis.rotationY -= 90;//等到修复后，可以删除。
			}
			
		}
		
		private function checkAttack():void
		{
			if(_ownerPlayer)
			{
				if(_sufferer.distanceToPos(x, z) < 40)
				{
					var skill:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.MONSTER_SKILL_1);
					BattleSystemManager.getInstance().singleAttack(_ownerPlayer, _sufferer, skill);
					onNetActive(0);
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

