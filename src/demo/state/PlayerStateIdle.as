package demo.state {

	import demo.controller.PlayerStateController;

	public class PlayerStateIdle extends PlayerStateBase {

		private var _switchAniTime : int = 0;
		private var _lastInBattle : Boolean = false;
		private var _nextRandomIdleDelay : int = (1 + Math.random()) * 10000;

		public function PlayerStateIdle(context : PlayerStateController) {
			super(PlayerStateController.STATE_IDLE, context);
		}

		override public function onEnterState(lastState : PlayerStateBase, curTime : int) : void {
			super.onEnterState(lastState, curTime);
			player.stopWalk();
		}

		override public function render(curTime : int, deltaTime : int) : void {
			super.render(curTime, deltaTime);

			// 切换待机动作
			if (_lastInBattle != player.inBattle && player.animationController.isGatherAnim() == false) {
				_lastInBattle = player.inBattle;
				player.animationController.playIdle();
			}
			_switchAniTime += deltaTime;

			if (_switchAniTime > _nextRandomIdleDelay) {
				_nextRandomIdleDelay = (1 + Math.random()) * 10000;
				// 播放随机待机动作
				_switchAniTime = 0;

				if (!_lastInBattle) {
					// 非战斗状态下，播放随机待机。
					// 采矿的时候，不需要播放随机待机。
					if (player.animationController.isGatherAnim() == false) {
//						player.animationController.playIdle1();
						player.animationController.playIdle();
					}
				}
			}
		}

		override public function stop() : Boolean {
			if (player) {
				player.animationController.playIdle();
			}
			return false;
		}

		override public function move() : Boolean {
			// 转换到move状态
			_controller.onStateChange(PlayerStateController.STATE_MOVE);
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
