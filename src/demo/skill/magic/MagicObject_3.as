//16个方向飞弹
package demo.skill.magic
{
	import com.game.engine3D.config.GlobalConfig;
	
	import flash.geom.Vector3D;
	
	import away3d.core.math.Matrix3DUtils;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.GameManager;
	import demo.managers.SkillManager;
	import demo.skill.SkillDetailVO;
	
	public class MagicObject_3 extends MagicBase
	{
		private var _ballEffect:Particle3D;
		
		private var _orgX:Number;
		private var _orgY:Number;
		
		private var _vX:Number = 0;
		private var _vY:Number = 0;
		
		private var _ownerPlayer:Avatar3D;
		private var _lastHeightPos:Number = 0;
		private static const BallSpeed:Number = 24;
		private static const tempVector:Vector3D = new Vector3D();
		
		public static const EffectName1:String = "../assets/effect/skill/mingzhongdandao/dandao.awd";
		
		public function MagicObject_3(Id:uint, OwnerId:uint, X:int, Y:int)
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
			
			_pathOffset = 1;
			
			tempVector.setTo(_vX, 0, _vY);
			tempVector.normalize();
			tempVector.scaleBy(BallSpeed);
			
			_vX = tempVector.x;
			_vY = tempVector.z;
			
			setGroundXY(_orgX, _orgY);
			_lastHeightPos = y;
			
			_ballEffect = _particleManager.getParticle(EffectName1, null);
			_ballEffect.y = 100;
			ObjFaceTo3DSpace(_ballEffect, _vX, _vY);
			_ballEffect.rotationY += 90;
			graphicDis.addChild(_ballEffect);
			addTimeHandlerAt(1000, on1000Ms);
			_ownerPlayer = creater as Avatar3D;
			
		}
		
		override protected function updatePosition():void
		{
			
		}
		
		private function on1000Ms():void
		{
			onNetActive(0);
		}
		
		override public function onNetActive(Value:uint):void
		{
			var explode:Particle3D = _particleManager.getParticle("../assets/effect/skill/mingzhongdandao/mingzhong.awd", null, null, 1000);
			_world.addObject(explode);
			explode.position = graphicDis.scenePosition;
			explode.y += 100;
			
			if(_ballEffect)
			{
				_particleManager.recycleParticle(_ballEffect);
				_ballEffect = null;
			}
			
			recycleEnable = true;
		}
		
		private var _lastSearchTimer:int;
		private var _pathOffset:Number = 1;
		private static const OrgVec:Vector3D = new Vector3D(0, 1, 0);
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
			
			if(_ballEffect)
			{
				_pathOffset *= 0.99;
				
				tempVector.setTo(_vX, 0, _vY);
				tempVector.normalize();
				var offset:Vector3D = tempVector.crossProduct(OrgVec);
				offset.normalize();
				offset.scaleBy(0.06 * _pathOffset * deltaTime / 17);
				tempVector.incrementBy(offset);
				tempVector.normalize();
				tempVector.scaleBy(BallSpeed);
				_vX = tempVector.x;
				_vY = tempVector.z;
				
				ObjFaceTo3DSpace(_ballEffect, _vX, _vY);
				_ballEffect.rotationY += 90;
			}
			
			
		}
		
		private function checkAttack():void
		{
			if(_ownerPlayer)
			{
				var enemyCount:int = BattleSystemManager.getInstance().searchEnemyCount(_ownerPlayer, 120, x, z);
				if(enemyCount > 0)
				{
					var skill:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_ATTACK250);
					BattleSystemManager.getInstance().circleAttack(_ownerPlayer, 250, skill, 9999, x, z);
					onNetActive(1);
				}
				else
				{
					var pos:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
					pos.setTo(x, 0, z);
					if(_world.district == null || _world.district.isPointInSide(pos) == false)
					{
						onNetActive(0);
					}
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

