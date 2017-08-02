package demo.ai {

	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import demo.controller.MonsterAIController;

	public class MonsterAIPassBy extends MonsterAIBase {
		
		/** 搜寻计时器 */
		private static const CheckDisTick : int = 1000;
		
		/** 路径点 */
		private var passByPosList 	  	: Vector.<Point>;
		/** 当前点 */
		private var currentTarget 	   	: Point;
		/** 搜寻计时器 */
		private var currentCheckTime	: int;
		
		public function MonsterAIPassBy(ctrl : MonsterAIController) {
			super(ctrl);
		}
		
		override public function update(curTime : int, deltaTime : int) : void {
			super.update(curTime, deltaTime);
			
			currentCheckTime += deltaTime;
			if (currentCheckTime < CheckDisTick) {
				return;
			}
			currentCheckTime = 0;
			
			if (owner.isDead) {
				return;
			}
			if (passByPosList == null) {
				passByPosList = owner.passByPosList;
			}
			if (passByPosList == null) {
				return;
			}
			if (passByPosList.length == 0) {
				return;
			}
			
			var nextPoint : Vector3D = null;
			if (currentTarget) {
				if (owner.distanceToPos(currentTarget.x, currentTarget.y) <= 100) {
					var index : int = passByPosList.indexOf(currentTarget);
					index++;
					if (index == passByPosList.length) {
						index = 0;
					}
					currentTarget = passByPosList[index];
					nextPoint = new Vector3D(currentTarget.x, 0, currentTarget.y);
				}
			} else {
				passByPosList = owner.passByPosList;
				currentTarget = passByPosList[0];
				nextPoint = new Vector3D(currentTarget.x, 0, currentTarget.y);
			}
			
			if (nextPoint) {
				owner.walkTo(nextPoint);
			}
		}
		
		override public function enter() : void {
			currentTarget   = null;
			passByPosList   = null;
			ctrl.lockTarget = null;
		}
		
		override public function leave() : void {
			currentTarget   = null;
			passByPosList   = null;
			ctrl.lockTarget = null;
		}
		
	}
}

