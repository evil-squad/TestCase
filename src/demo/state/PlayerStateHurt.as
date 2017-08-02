package demo.state {

	import demo.controller.PlayerStateController;

	public class PlayerStateHurt extends PlayerStateBase {

		private var hurtTime : uint = 200; // 被攻击僵硬时间
		private var isInAttackState : Boolean;

		public function PlayerStateHurt(context : PlayerStateController) {
			super(PlayerStateController.STATE_HURT, context);
		}

		override public function onEnterState(lastState : PlayerStateBase, curTime : int) : void {
			super.onEnterState(lastState, curTime);
			isInAttackState = lastState.stateId == PlayerStateController.STATE_IDLE;
			player.animationController.playHurt();
		}

		override public function stop() : Boolean {
			return false;
		}

		override public function move() : Boolean {
			return false;
		}

		override public function cast(isCritical : Boolean = false) : Boolean {
			return castEnable(isCritical);
		}

		override public function castEnable(isCritical : Boolean = false) : Boolean {
			return false;
		}

		override public function hurt() : Boolean {
			player.animationController.playHurt();
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

		override public function render(curTime : int, deltaTime : int) : void {
			super.render(curTime, deltaTime);
			if (lastTime > hurtTime) { // 退出受伤状态
				_controller.onStateChange(PlayerStateController.STATE_IDLE);
			}
		}
		
	}
}
