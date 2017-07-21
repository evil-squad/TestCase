package demo.display3D {

	import flash.geom.Vector3D;

	/**
	 * 移动控制器 
	 * @author chenbo
	 * 
	 */	
	public class PhysicActor {
		
		public static const NULL  : int = -1;
		public static const STAY  : int = 0;
		public static const MOVE  : int = 1;
		
		/** 移动速度 */
		public var speed		  : Number = 3;
		
		private var _x 			  : Number = 0;									// x
		private var _z 			  : Number = 0;									// z
		private var _targetX 	  : Number = 0;									// 目的地x
		private var _targetZ 	  : Number = 0;									// 目的地z
		private var _direction 	  : Vector3D = new Vector3D(1, 0, 0);			// 移动方向
		private var _state 		  : int = STAY;									// 当前状态
		private var _role 		  : Avatar3D;									// owner
		private var _posDirty 	  : Boolean = true;								// 位置是否发生了改变
		private var _pathFinished : Boolean = false;							// 移动完成
		
		public function PhysicActor(avatar : Avatar3D) {
			_role = avatar;
		}
		
		public function get x() : Number {
			return _x;
		}

		public function get z() : Number {
			return _z;
		}

		public function get state() : int {
			return _state;
		}
		
		public function get pathFinished() : Boolean {
			return _pathFinished;
		}

		public function moveTo(x : Number, z : Number, State : int) : void {
			_state    = State;
			_posDirty = true;
			_targetX  = x;
			_targetZ  = z;
			_direction.setTo(_targetX - _x, _targetZ - _z, 0);
		}
		
		public function setTo(x : Number, z : Number, State : int) : void {
			_x = x;
			_z = z;
			_state   = State;
			_targetX = x;
			_targetZ = z;
		}
		
		public function setFrom(x : Number, z : Number) : void {
			_x = x;
			_z = z;
			_posDirty = true;
		}
		
		public function update(curTime : int, deltaTime : int) : Boolean {
			_pathFinished = false;
			
			if (_state == STAY && !_posDirty) {
				return false;
			}
			
			_posDirty = false;
			
			deltaTime = 17;
			
			var sdist : Number = Math.sqrt((_targetX - _x) * (_targetX - _x) + (_targetZ - _z) * (_targetZ - _z));		// 剩余距离	surplus dist
			var ndist : Number = speed * deltaTime / 17;																// 当前距离  now passed dist
			
			if (ndist < 0) {
				ndist = 0;
			}
			
			if (sdist < ndist) {
				_x = _targetX;
				_z = _targetZ;
				_pathFinished = true;
			} else {
				_direction.normalize();
				_direction.scaleBy(ndist);
				_x += _direction.x;
				_z += _direction.y;
			}
			
			return true;
		}

		public function dispose() : void {
			_role = null;
		}
		
	}
}
