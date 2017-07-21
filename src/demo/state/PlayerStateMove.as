package demo.state {

	import demo.controller.PlayerStateController;

	public class PlayerStateMove extends PlayerStateBase {

		public function PlayerStateMove(context : PlayerStateController) : void {
			super(PlayerStateController.STATE_MOVE, context);
		}

		public function setTargetPosition(x : Number, y : Number) : void {

		}

		override public function onEnterState(lastState : PlayerStateBase, curTime : int) : void {
			super.onEnterState(lastState, curTime);
			player.animationController.playMove();

		}

		override public function onLeaveState(nextState : PlayerStateBase, curTime : int) : void {
			super.onLeaveState(nextState, curTime);
		}

		override public function stop() : Boolean {
			_controller.onStateChange(PlayerStateController.STATE_IDLE);
			return true;
		}

		override public function move() : Boolean {
			return true;
		}

		override public function canMoveTo() : Boolean {
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
			_controller.onStateChange(PlayerStateController.STATE_HURT);
			return true;
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
