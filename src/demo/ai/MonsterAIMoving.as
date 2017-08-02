package demo.ai {

	import com.game.engine3D.config.GlobalConfig;
	
	import flash.geom.Vector3D;
	
	import away3d.core.math.Matrix3DUtils;
	
	import demo.controller.MonsterAIController;

	public class MonsterAIMoving extends MonsterAIBase {
		
		/** 寻路频率 */
		private const FindPathTick 	: int = 300 + Math.random() * 300;
		/** 检测距离的频率 */
		private const CheckDisTick 	: int = 100 + 100 * Math.random();
		
		/** 目的地 */
		private var targetPos 		: Vector3D = new Vector3D();
		/** 跟随范围 */
		private var followRange 	: int;
		/** 搜寻计时器 */
		private var findPathTime 	: int;
		/** 检测时间 */
		private var checkDistTime  	: int;
		
		public function MonsterAIMoving(ctrl : MonsterAIController) {
			super(ctrl);
		}
		
		override public function update(curTime : int, deltaTime : int) : void {
			super.update(curTime, deltaTime);
			
			if (owner.isDead) {
				ctrl.lockTarget = null;
				return;
			}
			
			findPathTime  += deltaTime;
			checkDistTime += deltaTime;
			
			if (ctrl.lockTarget && ctrl.lockTarget.isDead) {
				ctrl.lockTarget = null;
			}
			
			if (checkDistTime > CheckDisTick) {
				checkDistTime = 0;
				// 自己距离出生点太远了
				if (owner.distanceToPos(ctrl.orgPos.x, ctrl.orgPos.z) > owner.distanceFollow) {
					ctrl.lockTarget = null;
				}
				// 目标距离自己的出生点太远了
				else if (ctrl.lockTarget && ctrl.lockTarget.distanceToPos(ctrl.orgPos.x, ctrl.orgPos.z) > owner.distanceFollow) {
					ctrl.lockTarget = null;
				}
			}
			
			if (findPathTime > FindPathTick) {
				findPathTime = 0;
				if (ctrl.lockTarget == null) {
					if (owner.distanceToPos(ctrl.orgPos.x, ctrl.orgPos.z) > owner.distanceMaxAttack) {
						targetPos.copyFrom(ctrl.orgPos);
						if (findOnePoint()) {
							owner.walkTo(targetPos);
						}
					} else {
						ctrl.idle();
					}
				} else {
					var dist   : int = owner.distanceToObject(ctrl.lockTarget.id);
					var tooFar : Boolean = dist >= owner.distanceMaxAttack + owner.radius + ctrl.lockTarget.radius + followRange;
					var tooNear: Boolean = dist < owner.distanceMinFollow; // - owner.radius - _ctrl.lockTarget.radius - _skillRadius;
					if (tooFar || tooNear) {
						//找到一个位置
						targetPos.setTo(ctrl.lockTarget.x, 0, ctrl.lockTarget.z);
						if (findOnePoint()) {
							owner.walkTo(targetPos);
						}
					} else {
						ctrl.attack();
					}
				}
			}
		}
		
		private function findOnePoint() : Boolean {
			
			var max : int = owner.distanceMaxAttack + followRange;
			var min : int = owner.distanceMinAttack + followRange;
			
			for (var i : int = 0; i < 10; i++) {
				
				var dist  : Number = min + (max - min) * Math.random();
				var angle : Number = Math.random() * Math.PI * 2;
				var vec0  : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
				var vec1  : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D2;
				
				vec1.setTo(Math.sin(angle) * dist, 0, Math.cos(angle) * dist);
				vec1.incrementBy(targetPos);
				vec0.setTo(vec1.x, 0, vec1.z);
				
				if (world.district && world.district.isPointInSide(vec0, 10)) {
					targetPos.copyFrom(vec1);
					return true;
				}
				
			}
			return false;
		}

		override public function enter() : void {
			followRange  = 0;
			findPathTime = 0;
		}
		
		override public function leave() : void {
			findPathTime = 0;
		}
		
	}
}
