/**
 * 弓箭手210的弹道
 */	
package demo.skill.magic
{
	import com.game.engine3D.config.GlobalConfig;
	
	import flash.geom.Vector3D;
	
	import away3d.core.math.Matrix3DUtils;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.PathEnum;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.SkillManager;
	import demo.skill.SkillDetailVO;

	public class MagicObject_210 extends MagicBase
	{
		private var _ballEffect:Particle3D;
		private var _explodeEffect:Particle3D;
		
		private var _orgX:Number;
		private var _orgY:Number;
		
		private var _vX:Number = 0;
		private var _vY:Number = 0;
		
		private var _ownerPlayer:Avatar3D;
		private var _lastHeightPos:Number = 0;
		private static const BallSpeed:Number = 80;
		
		public function MagicObject_210(Id:uint, OwnerId:uint, X:int, Y:int)
		{
			super(Id, OwnerId, X, Y);
		}
		
		override public function initMagicData(Id:uint, OwnerId:uint, ConfigId:int, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):void
		{
			super.initMagicData(Id, OwnerId, ConfigId, TargetId, X, Y, Arg1, Arg2);
			_vX = Arg1 - X;
			_vY = Arg2 - Y;
			
			_orgX = X;
			_orgY = Y;
			
			var vector:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
			vector.setTo(_vX, 0, _vY);
			vector.normalize();
			vector.scaleBy(BallSpeed);
			
			_vX = vector.x;
			_vY = vector.z;
			
			setGroundXY(_orgX, _orgY);
			_lastHeightPos = y;
			var effectPath:String = SkillManager.getInstance().getSkillPath(PlayerAnimationController.SEQ_ATTACK_210);
			_ballEffect = _particleManager.getParticle(effectPath, "210_dandao");
			if(_ballEffect)
			{
				_ballEffect.y = 150;
				ObjFaceTo3DSpace(_ballEffect, _vX, _vY, 150);
				graphicDis.addChild(_ballEffect);
			}
			addTimeHandlerAt(600, on600Ms);
			_ownerPlayer = creater as Avatar3D;
		}
		
		override protected function updatePosition():void
		{
			
		}
		
		
		private function on600Ms():void
		{
			onNetActive(0);
		}
		
		override public function onNetActive(Value:uint):void
		{
			var explode:Particle3D = _particleManager.getParticle(PathEnum.SKILL_PATH + "tx_suit_arch1_001/tx_suit_arch1_400.awd", null, null, 1000);
			_world.addObject(explode);
			explode.position = graphicDis.scenePosition;
			explode.y += 150;
			recycleEnable = true;
		}

		private var _lastSearchTimer:int;
		override public function run(deltaTime:uint):void
		{
			super.run(deltaTime);
			
			setGroundXY(x + _vX * deltaTime / 17, z + _vY * deltaTime / 17);
			y = _lastHeightPos;
			_lastSearchTimer += deltaTime;
			if(_lastSearchTimer > 1)
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
					var skill:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_ATTACK_ARCH210);
					BattleSystemManager.getInstance().circleAttack(_ownerPlayer, 250, skill, 9999, x, z);
					onNetActive(1);
				}
			}
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

