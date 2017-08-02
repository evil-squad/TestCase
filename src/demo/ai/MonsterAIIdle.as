package demo.ai {

	import com.game.engine3D.config.GlobalConfig;
	
	import flash.geom.Vector3D;
	
	import away3d.core.math.Matrix3DUtils;
	
	import demo.controller.MonsterAIController;
	import demo.display3D.Avatar3D;
	
	/**
	 * 闲置状态 
	 * @author chenbo
	 * 
	 */	
	public class MonsterAIIdle extends MonsterAIBase {

		/** 搜寻敌人间隔时间 */
		private const SearchTick : int = 200 + Math.random() * 200;
		/** 巡逻间隔时间 */
		private const PatrolTick : int = 4000 + Math.random() * 4000;
		
		/** 巡逻时间 */
		private var partrolTime : int;
		/** 巡逻位置 */
		private var partrolPos  : Vector3D = new Vector3D();
		
		public function MonsterAIIdle(ctrl : MonsterAIController) {
			super(ctrl);
		}

		override public function update(curTime : int, deltaTime : int) : void {
			super.update(curTime, deltaTime);
			
			if (owner.isDead) {
				return;
			}
			
			partrolTime += deltaTime;
			
			if (partrolTime > PatrolTick) {
				partrolTime = 0;
				if (findOnePoint()) {
					owner.walkTo(partrolPos);
				}
			}
			
		}
		
		private function findOnePoint() : Boolean {
			
			var dist  : Number = owner.distanceMinAttack * Math.random();
			var angle : Number = Math.random() * Math.PI * 2;
			var vec0  : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D2;
			var vec1  : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
			
			vec0.setTo(Math.sin(angle) * dist, 0, Math.cos(angle) * dist);
			vec0.incrementBy(ctrl.orgPos);
			vec1.setTo(vec0.x, 0, vec1.z);
			
			if (world.district && world.district.isPointInSide(vec1, 10)) {
				partrolPos.copyFrom(vec0);
				return true;
			}
			
			return false;
		}

		override public function notifyInterest(avatar : Avatar3D) : void {
			if (owner.isDead || avatar.isDead) {
				return;
			}
			if (ctrl.lockTarget && ctrl.lockTarget.isDead) {
				ctrl.lockTarget = null;
			}
			//是否需要切换目标
			var newTarget : Boolean = ctrl.lockTarget == null ? true : Math.random() < 0.1;
			var dist : Number = owner.distanceToPos(avatar.x, avatar.z);
			
			if (dist <= owner.distanceFindEnemy && newTarget) {
				ctrl.lockTarget = avatar;
				ctrl.moveFollow(owner.distanceFindEnemy);
			}
			
		}
		
		override public function enter() : void {
			ctrl.lockTarget = null;
		}

		override public function leave() : void {

		}

	}
}
