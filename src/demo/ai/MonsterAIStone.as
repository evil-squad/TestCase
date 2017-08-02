package demo.ai {

	import demo.controller.MonsterAIController;

	public class MonsterAIStone extends MonsterAIBase {
		
		/** 石化s计时器 */
		private var delayTime : int;
		
		public function MonsterAIStone(ctrl : MonsterAIController) {
			super(ctrl);
			this.delayTime = 0;
		}
		
		override public function update(curTime : int, deltaTime : int) : void {
			super.update(curTime, deltaTime);
			if (owner.isDead) {
				return;
			}
			delayTime -= deltaTime;
			if (delayTime <= 0) {
				ctrl.idle();
			}
		}
		
		override public function enter() : void {
			delayTime 			  = 3000 + Math.random() * 2000;
			ctrl.lockTarget   	  = null;
			owner.godMode 		  = true;
			owner.currentGray 	  = true;
			owner.targetAnimSpeed = 0;
			owner.stopWalk();
		}
		
		override public function leave() : void {
			owner.godMode         = false;
			owner.currentGray     = false;
			owner.targetAnimSpeed = 1;
		}
		
	}
}

