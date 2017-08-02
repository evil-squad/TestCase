package demo.ai {

	import demo.controller.MonsterAIController;
	import demo.display3D.Avatar3D;
	import demo.managers.WorldManager;
	
	public class MonsterAIBase {
		
		/** AI控制器 */
		protected var ctrl  : MonsterAIController;	
		/** 游戏管理器 */
		protected var world : WorldManager;	
		
		/**
		 * 状态 
		 * @param ctrl
		 * 
		 */		
		public function MonsterAIBase(ctrl : MonsterAIController) {
			this.ctrl  = ctrl;
			this.world = WorldManager.instance;
		}
		
		/**
		 * update 
		 * @param curTime		当前时间
		 * @param deltaTime		与前一帧的差值
		 * 
		 */		
		public function update(curTime : int, deltaTime : int) : void {
			if (ctrl.lockTarget && ctrl.lockTarget.destroyed) {
				ctrl.lockTarget = null;
			}
		}
		
		/**
		 * 接受目标 
		 * @param player
		 * 
		 */		
		public function notifyInterest(player : Avatar3D) : void {

		}
		
		/**
		 * 进入状态
		 * @param t
		 * 
		 */		
		public function enter() : void {

		}
		
		/**
		 *  离开状态
		 */		
		public function leave() : void {
		
		}
		
		/**
		 *  停止移动
		 */		
		public function onStopWalk() : void {
			if (ctrl.lockTarget) {
				owner.faceToTarget(ctrl.lockTarget.id);
			}
		}
		
		/**
		 * 持有者 
		 * @return 
		 * 
		 */		
		protected function get owner() : Avatar3D {
			return ctrl.owner;
		}

	}
}
