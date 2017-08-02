package demo.state {

	import demo.controller.PlayerStateController;
	import demo.display3D.Avatar3D;

	/**
	 * 状态机基类
	 * @author chenbo
	 *
	 */
	public class PlayerStateBase implements IPlayerState {

		public var lastTime 	  : uint; 								
		public var lastLeaveTime  : uint; 							
		
		protected var _controller : PlayerStateController;
		protected var _stateId 	  : int;

		public function PlayerStateBase(stateId : int, stateController : PlayerStateController) {
			this._stateId = stateId;
			this._controller = stateController;
		}
		
		public function get stateId() : int {
			return _stateId;
		}
		
		protected function get player() : Avatar3D {
			return _controller.player;
		}
		
		public function onEnterState(lastState : PlayerStateBase, curTime : int) : void {
			lastTime = 0;
		}

		public function onLeaveState(nextState : PlayerStateBase, curTime : int) : void {
			lastLeaveTime = curTime;
		}

		public function render(curTime : int, deltaTime : int) : void {
			lastTime += deltaTime;
		}

		public function move() : Boolean {
			return false;
		}

		public function canMoveTo() : Boolean {
			return false;
		}

		public function stop() : Boolean {
			return false
		}

		public function cast(isCritical : Boolean = false) : Boolean {
			return castEnable(isCritical);
		}

		public function castEnable(isCritical : Boolean = false) : Boolean {
			return false;
		}

		public function dodge() : Boolean {
			return false;
		}

		public function loot() : Boolean {
			return false;
		}

		public function stun() : Boolean {
			return false;
		}

		public function hurt() : Boolean {
			return false;
		}

		public function die() : Boolean {
			return false;
		}

		public function reborn() : void {
			_controller.onStateChange(PlayerStateController.STATE_IDLE);
		}

	}

}
