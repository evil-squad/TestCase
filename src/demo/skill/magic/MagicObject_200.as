/**
 * 弓箭手普通射击的弹道
 */	
package demo.skill.magic
{
	import com.game.engine3D.config.GlobalConfig;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Matrix3DUtils;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.SkillManager;
	import demo.skill.SkillDetailVO;
	
	public class MagicObject_200 extends MagicBase
	{
		private var _ballEffect:Particle3D;
		private var _explodeEffect:Particle3D;
		
		private var _orgX:Number;
		private var _orgY:Number;
		
		private var _vX:Number = 0;
		private var _vY:Number = 0;
		private var _sufferer:Avatar3D;
		private var _ownerPlayer:Avatar3D;
		private var _step:int = 0;//0为飞行搜索阶段，1为结束延迟
		private var _stayDelay:int;
		
		private static const BallSpeed:Number = 80;
		private var _suffererTag:ObjectContainer3D;
		
		public function MagicObject_200(Id:uint, OwnerId:uint, X:int, Y:int)
		{
			super(Id, OwnerId, X, Y);
		}
		
		override public function initMagicData(Id:uint, OwnerId:uint, ConfigId:int, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):void
		{
			super.initMagicData(Id, OwnerId, ConfigId, TargetId, X, Y, Arg1, Arg2);
			_sufferer = _world.getAvatar3D(suffererId);
			_suffererTag = _sufferer.underAttackContainer;
			
			_ownerPlayer = creater as Avatar3D;
			_vX = _suffererTag.scenePosition.x - _ownerPlayer.x;
			_vY = _suffererTag.scenePosition.z - _ownerPlayer.z;
			_orgX = _ownerPlayer.x;
			_orgY = _ownerPlayer.z;
			var vector:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
			vector.setTo(_vX, 0, _vY);
			vector.normalize();
			vector.scaleBy(BallSpeed);
			
			_vX = vector.x;
			_vY = vector.z;
			setGroundXY(_orgX, _orgY);
			y = y + 150;
			var effectPath:String = SkillManager.getInstance().getSkillPath(PlayerAnimationController.SEQ_ATTACK_210);
			_ballEffect = _particleManager.getParticle(effectPath, "210_dandao");
			if(_ballEffect)
			{
				graphicDis.addChild(_ballEffect);
				
				ObjFaceTo3DSpace(graphicDis, _suffererTag.scenePosition.x, _suffererTag.scenePosition.z, _suffererTag.scenePosition.y);
			}
			addTimeHandlerAt(1600, on1600Ms);
		}
		
		private function on1600Ms():void
		{
			onNetActive(0);
			recycleEnable = true;
		}
		
		override protected function updatePosition():void
		{
			
		}
		private var _lastMatrix:Matrix3D = new Matrix3D();
		override public function onNetActive(Value:uint):void
		{
			var container:ObjectContainer3D = _sufferer.underAttackContainer;
			var parentMatrix:Matrix3D = container.sceneTransform.clone();
			parentMatrix.invert();
			
			_lastMatrix.copyFrom(_ballEffect.sceneTransform);
			parentMatrix.prepend(_lastMatrix);
			
			container.addChild(_ballEffect);
			_ballEffect.transform = parentMatrix;
			
			
			_step = 1;
			_stayDelay = 600;
			
			var skill:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.PLAYER_SHOOT_ATTACK);
			BattleSystemManager.getInstance().singleAttack(_ownerPlayer, _sufferer, skill);
		}
		
		override public function run(deltaTime:uint):void
		{
			super.update(deltaTime);
			_sufferer = _world.getAvatar3D(suffererId);
			if(_sufferer == null)
			{
				recycleEnable = true;
				return;
			}
			if(_step == 0)
			{
				var lastHeight:Number = y;
				setGroundXY(x + _vX * deltaTime / 17, z + _vY * deltaTime / 17);
				var distance:Number = distanceToPos(_suffererTag.scenePosition.x, _suffererTag.scenePosition.z);
				var ratio:Number = (BallSpeed / distance) * (deltaTime / 17);
				y = ratio * (_suffererTag.scenePosition.y - lastHeight) + lastHeight;
				
				ObjFaceTo3DSpace(graphicDis, _suffererTag.scenePosition.x, _suffererTag.scenePosition.z, _suffererTag.scenePosition.y);
				
				_vX = _suffererTag.scenePosition.x - x;
				_vY = _suffererTag.scenePosition.z - z;
				var tempVector:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
				tempVector.setTo(_vX, 0, _vY);
				tempVector.normalize();
				tempVector.scaleBy(BallSpeed);
				
				_vX = tempVector.x;
				_vY = tempVector.z;
				
				checkAttack();
			}
			
			else if(_step == 1)
			{
				_stayDelay -= deltaTime;
				if(_stayDelay <= 0)
				{
					recycleEnable = true;
				}
			}
			
		}
		
		private function checkAttack():void
		{
			if(distanceToPos(_suffererTag.scenePosition.x, _suffererTag.scenePosition.z) < (100 + _sufferer.radius))
			{
				onNetActive(1);
			}
		}
		
		override public function resetMagic(Id:int=0, Name:String=null):void
		{
			_step = 0;
			_stayDelay = 0;
			if(_ballEffect)
			{
				_ballEffect.transform = _lastMatrix;
				_particleManager.recycleParticle(_ballEffect);
				_ballEffect = null;  
			}
			
			setGroundXY(0, 0);
			super.resetMagic(Id, Name);
		}
	}
}

