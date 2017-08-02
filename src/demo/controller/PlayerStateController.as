package demo.controller {

	import flash.utils.getTimer;
	
	import demo.display3D.Player3D;
	import demo.display3D.Avatar3D;
	import demo.state.PlayerStateBase;
	import demo.state.PlayerStateCast;
	import demo.state.PlayerStateCastMove;
	import demo.state.PlayerStateCastReady;
	import demo.state.PlayerStateCasting;
	import demo.state.PlayerStateDead;
	import demo.state.PlayerStateHurt;
	import demo.state.PlayerStateIdle;
	import demo.state.PlayerStateMove;
	import demo.state.PlayerStateStun;

	public class PlayerStateController {
		
		// 各状态的名字
		public static const STATE_IDLE 		: int = 1; 	// 待机
		public static const STATE_MOVE 		: int = 2; 	// 移动
		public static const STATE_CAST 		: int = 3; 	// 施法
		public static const STATE_CASTING 	: int = 4; 	// 持续施法
		public static const STATE_HURT 		: int = 6; 	// 受伤
		public static const STATE_DEAD 		: int = 7; 	// 死亡
		public static const STATE_STUN 		: int = 8; 	// 眩晕
		public static const STATE_CAST_MOVE : int = 9; 	// 移动施法
		public static const STATE_CAST_READY: int = 10; // 施法准备
		// 各状态对象
		public var stateIdle 	  : PlayerStateIdle;
		public var stateMove 	  : PlayerStateMove;
		public var stateCast 	  : PlayerStateCast;
		public var stateCasting   : PlayerStateCasting;
		public var stateHurt 	  : PlayerStateHurt;
		public var stateDead 	  : PlayerStateDead;
		public var stateStun 	  : PlayerStateStun;
		public var stateCastMove  : PlayerStateCastMove;
		public var stateCastReady : PlayerStateCastReady;

		private var _currentState : PlayerStateBase; // 当前状态
		private var _curTime 	  : int;
		private var _player		  : Player3D;
		
		public function PlayerStateController() {
			initStates();
			_currentState = stateIdle;
		}

		public function get state() : int {
			return _currentState.stateId;
		}

		public function get currentState() : PlayerStateBase {
			return _currentState;
		}
				
		public function get player() : Avatar3D {
			return _player;
		}
		
		public function initRole(player : Player3D) : void {
			_player = player;
			if (_player) {
				_currentState.onEnterState(null, getTimer());
			}
		}
		
		public function update(curTime : int, deltaTime : int) : void {
			_curTime = curTime;
			if (_player == null) {
				return;
			}
			_currentState.render(curTime, deltaTime);
		}
		
		protected function initStates() : void {
			stateIdle = new PlayerStateIdle(this);
			stateMove = new PlayerStateMove(this);
			stateCast = new PlayerStateCast(this);
			stateHurt = new PlayerStateHurt(this);
			stateDead = new PlayerStateDead(this);
			stateStun = new PlayerStateStun(this);
			stateCasting = new PlayerStateCasting(this);
			stateCastMove = new PlayerStateCastMove(this);
			stateCastReady = new PlayerStateCastReady(this);
		}

		// 此函数由状态对象调用
		public function onStateChange(newStateId : int) : void {
			if (newStateId == state) {
				return;
			}
			
			var newState : PlayerStateBase = null;
			var oldState : PlayerStateBase = _currentState;
			
			switch (newStateId) {
				case STATE_IDLE:
					newState = stateIdle;
					break;
				case STATE_MOVE:
					newState = stateMove;
					break;
				case STATE_CAST:
					newState = stateCast;
					break;
				case STATE_CASTING:
					newState = stateCasting;
					break;
				case STATE_HURT:
					newState = stateHurt;
					break;
				case STATE_DEAD:
					newState = stateDead;
					break;
				case STATE_STUN:
					newState = stateStun;
					break;
				case STATE_CAST_MOVE:
					newState = stateCastMove;
					break;
				case STATE_CAST_READY:
					newState = stateCastReady;
					break;
				default:
					throw new Error("change to unknown state");
					break;
			}

			newState.lastTime = 0;
			newState.onEnterState(_currentState, _curTime);
			
			_currentState.onLeaveState(newState, _curTime);
			_currentState = newState;
		}
		
		public function move() : Boolean {
			return _currentState.move();
		}
		
		public function canMoveTo() : Boolean {
			return _currentState.canMoveTo();
		}

		public function stop() : Boolean {
			return _currentState.stop();
		}

		public function cast(isCritical : Boolean = false) : Boolean {
			return _currentState.cast(isCritical);
		}

		public function castEnable(isCritical : Boolean = false) : Boolean {
			return _currentState.castEnable(isCritical);
		}

		public function hurt() : Boolean {
			return _currentState.hurt();
		}

		public function stun() : Boolean {
			return _currentState.stun();
		}

		public function dead() : Boolean {
			return _currentState.die();
		}

		public function reborn() : void {
			if (_currentState == stateDead)
				_currentState.reborn();
		}
		
	}

}


