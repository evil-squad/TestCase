package demo.state {

	import demo.controller.PlayerStateController;

	public class PlayerStateCast extends PlayerStateBase {

		public var castTime : int = 800; 	// 攻击僵硬时间
		public var castType : int = 0; 		// 是否持续施法
		
		public function PlayerStateCast(stateController : PlayerStateController) {
			super(PlayerStateController.STATE_CAST, stateController);
		}
		
		override public function render(curTime : int, deltaTime : int) : void {
			super.render(curTime, deltaTime);
			if (lastTime > castTime) {
				if (castType == 0) {
					_controller.onStateChange(PlayerStateController.STATE_IDLE); 		// 攻击完毕,转换状态到待机
				} else if (castType == 1) {
					_controller.onStateChange(PlayerStateController.STATE_CASTING); 	// 施法
				} else if (castType == 3) {
					_controller.onStateChange(PlayerStateController.STATE_CASTING); 	// 采矿
				} else {
					_controller.onStateChange(PlayerStateController.STATE_CAST_MOVE); 	// 移动施法
				}
			}
		}
		
		override public function move() : Boolean {
			return false;
		}

		override public function canMoveTo() : Boolean {
			return false;
		}

		override public function stop() : Boolean {
			return false;
		}

		override public function cast(isCritical : Boolean = false) : Boolean {
			lastTime = 0;
			return castEnable(isCritical);
		}

		override public function castEnable(isCritical : Boolean = false) : Boolean {
			return true;
		}

		override public function hurt() : Boolean {
			return false;
		}

		override public function die() : Boolean {
			_controller.onStateChange(PlayerStateController.STATE_DEAD);
			return true;
		}

		override public function stun() : Boolean {
			_controller.onStateChange(PlayerStateController.STATE_STUN);
			return true;
		}

	}
}
