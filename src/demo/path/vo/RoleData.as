package demo.path.vo {
	
	import demo.enum.RoleEnum;
	
	public class RoleData {
		
		private var _x  : Number = 0;
		private var _y  : Number = 0;
		private var _z  : Number = 0;
		private var _id : int = RoleEnum.ROLE_TIAN_DAO;
		
		public function RoleData(node : XML) {
			_x  = node.@x;
			_y  = node.@y;
			_z  = node.@z;
			_id = node.@id;
		}
		
		public function get id():int {
			return _id;
		}

		public function get z():Number {
			return _z;
		}

		public function get y():Number {
			return _y;
		}

		public function get x():Number {
			return _x;
		}
		
		public function toString() : String {
			return "id=" + _id + ",x=" + _x + ",y=" + _y + ",z=" + _z;
		}
		
	}
}