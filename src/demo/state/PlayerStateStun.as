package demo.state {

	import flash.utils.Dictionary;

	import demo.controller.PlayerStateController;

	public class PlayerStateStun extends PlayerStateBase {

		private var _stunTime : int = 800; // 眩晕时间
		private var _stunDic  : Dictionary = new Dictionary();


		public function PlayerStateStun(stateController : PlayerStateController) {
			super(PlayerStateController.STATE_STUN, stateController);
		}

		public function addStunTime(id : int, value : int) : void {
			_stunDic[id] = value + lastTime;
			var maxTime : int = 0;
			for each (value in _stunDic) {
				maxTime = Math.max(value, maxTime);
			}
			_stunTime = maxTime;
		}

		public function removeStunTime(id : int) : void {
			delete _stunDic[id];
			var maxTime : int = 0;
			for each (var value : int in _stunDic) {
				maxTime = Math.max(value, maxTime);
			}
			_stunTime = maxTime;
		}
		
		override public function onEnterState(lastState : PlayerStateBase, curTime : int) : void {
			super.onEnterState(lastState, curTime);
			player.animationController.playStun();
		}

		override public function onLeaveState(nextState : PlayerStateBase, curTime : int) : void {
			super.onLeaveState(nextState, curTime);
			_stunDic  = new Dictionary();
			_stunTime = 0;
		}

		override public function render(curTime : int, deltaTime : int) : void {
			super.render(curTime, deltaTime);
			if (lastTime > _stunTime) {
				// 眩晕完毕，转入待机状态
				_controller.onStateChange(PlayerStateController.STATE_IDLE);
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

	}
}
