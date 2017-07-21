package demo.state {

	import demo.controller.PlayerStateController;

	public class PlayerStateCastMove extends PlayerStateBase {

		public function PlayerStateCastMove(stateController : PlayerStateController) {
			super(PlayerStateController.STATE_CAST_MOVE, stateController);
		}

		override public function move() : Boolean {
			return true;
		}

		override public function canMoveTo() : Boolean {
			return true;
		}

		override public function stop() : Boolean {
			return true;
		}

		override public function cast(isCritical : Boolean = false) : Boolean {
			return castEnable(isCritical);
		}

		override public function castEnable(isCritical : Boolean = false) : Boolean {
			return false;
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
