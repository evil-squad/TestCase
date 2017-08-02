package demo.ai {

	import com.game.engine3D.config.GlobalConfig;
	
	import flash.geom.Vector3D;
	
	import away3d.core.math.Matrix3DUtils;
	
	import demo.controller.MonsterAIController;
	import demo.display3D.Avatar3D;

	public class MonsterAILazy extends MonsterAIBase {
		
		/** 搜寻路径的频率 */
		private var findPathTick 	 : int = 1000;
		/** 搜寻路径计时器 */
		private var findPathTime 	 : int;
		/** 目的地 */
		private var targetPos 		 : Vector3D;
		/** 偷懒频率 */
		private var lazyRepeatTick  : int;
		
		public function MonsterAILazy(ctrl : MonsterAIController) {
			super(ctrl);
			this.targetPos = new Vector3D();
		}
		
		override public function notifyInterest(avatar : Avatar3D) : void {
			if (owner.isDead || avatar.isDead) {
				return;
			}
			if (ctrl.lockTarget == avatar) {
				return;
			}
			if (ctrl.lockTarget && ctrl.lockTarget.isDead) {
				ctrl.lockTarget = null;
			}
			//是否需要切换目标
			var newTarget : Boolean = false;
			if (ctrl.lockTarget == null) {
				newTarget = true;
			} else {
				newTarget = avatar.isMainChar ? Math.random() < 0.75 : Math.random() < 0.25;
			}
			// 检测距离	
			if (owner.distanceToPos(avatar.x, avatar.y) <= owner.distanceFindEnemy && newTarget) {
				ctrl.lockTarget = avatar;	
			}
		}
		
		override public function update(curTime : int, deltaTime : int) : void {
			super.update(curTime, deltaTime);
			if (owner.isDead) {
				ctrl.lockTarget = null;
				return;
			}
			if (ctrl.lockTarget == null) {
				ctrl.idle();
				return;
			}
			if (ctrl.lockTarget.isDead) {
				ctrl.idle();
				return;
			}
			
			findPathTime += deltaTime;
			if (findPathTime > findPathTick) {
				findPathTime = 0;
				if (lazyRepeatTick <= 0) {
					ctrl.attack();
				} else {
					targetPos.setTo(owner.x, 0, owner.y);
					if (findOnePoint()) {
						owner.walkTo(targetPos);
					}
					lazyRepeatTick--;
				}
			}
		}
		
		private function findOnePoint() : Boolean {
			// 与目标直接的距离
			var distTg : Number = ctrl.lockTarget.distanceToObject(owner.id);
			// 16 ??? 
			for (var i : int = 0; i < 16; i++) {
				var distMe : Number = 100 + 100 * Math.random();
				var angle  : Number = Math.random() * Math.PI * 2;
				var vec0   : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
				var vec1   : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D2;
				
				vec1.setTo(Math.sin(angle) * distMe, 0, Math.cos(angle) * distMe);
				vec1.incrementBy(targetPos);
				//不要走近了，只能走远.
				if (ctrl.lockTarget.distanceToPos(vec1.x, vec1.z) < distTg) {
					continue;
				}
				
				vec0.setTo(vec1.x, 0, vec1.z);
				
				if (world.district && world.district.isPointInSide(vec0, 10)) {
					targetPos.copyFrom(vec1);
					return true;
				}
			}
			return false;
		}
		
		override public function enter() : void {
			findPathTime   = findPathTick = owner.lazyStayMiliSec;
			lazyRepeatTick = 1 + owner.lazyRepeatCount * Math.random();
		}
		
		override public function onStopWalk() : void {

		}
		
		override public function leave() : void {
			findPathTime = findPathTick;
		}
		
	}
}
