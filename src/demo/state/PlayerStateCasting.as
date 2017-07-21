package demo.state {

	import demo.controller.PlayerStateController;

	public class PlayerStateCasting extends PlayerStateBase {

		public var castingTime : int = 800; // 持续施法时间

		public function PlayerStateCasting(stateController : PlayerStateController) {
			super(PlayerStateController.STATE_CASTING, stateController);
		}

		override public function render(curTime : int, deltaTime : int) : void {
			super.render(curTime, deltaTime);
			if (lastTime > castingTime) {
				_controller.onStateChange(PlayerStateController.STATE_IDLE); // 持续施法完毕，转入待机状态
			}
		}

		override public function move() : Boolean {
			_controller.onStateChange(PlayerStateController.STATE_MOVE); // 施法中断
			return true;
		}

		override public function canMoveTo() : Boolean {
			return true;
		}

		override public function stop() : Boolean {
			_controller.onStateChange(PlayerStateController.STATE_IDLE);
			return true;
		}

		override public function cast(isCritical : Boolean = false) : Boolean {
			_controller.onStateChange(PlayerStateController.STATE_CAST_READY);
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
