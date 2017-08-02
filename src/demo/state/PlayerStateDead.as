package demo.state {

	import demo.controller.PlayerStateController;

	public class PlayerStateDead extends PlayerStateBase {

		public function PlayerStateDead(context : PlayerStateController) {
			super(PlayerStateController.STATE_DEAD, context);
		}

		override public function onEnterState(lastState : PlayerStateBase, curTime : int) : void {
			super.onEnterState(lastState, curTime);
			player.animationController.playDead();
		}

	}
}
