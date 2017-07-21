package demo.path.vo {
	
	/**
	 * 场景选项
	 * @author chenbo
	 * 
	 */	
	public class SceneOption {
		
		private var _name    : String;
		private var _comment : String;
		private var _enable  : Boolean;
		private var _value   : Object;
		private var _xmlNode : XML;
		
		/**
		 *  
		 * @param name    名称
		 * @param comment 注释
		 * @param enable  是否可选
		 * @param value   值
		 * 
		 */		
		public function SceneOption(node : XML) {
			_xmlNode = node;
			_name    = node.@name;;
			_comment = node.@comment;
			_enable  = node.@enable == "true" ? true : false;
			if (node.@value == "true") {
				_value = true;
			} else if (node.@value == "false") {
				_value = false;
			} else {
				_value = parseFloat(node.@value);
			}
		}
				
		public function get xmlNode():XML {
			return _xmlNode;
		}

		public function set value(value:Object) : void {
			_value = value;
		}
		
		public function toString() : String {
			return "name=" + _name + ",comment=" + _comment + ",enable=" + _enable + ",value=" + _value;
		}
		
		public function get value():Object {
			return _value;
		}
		
		public function get enable():Boolean {
			return _enable;
		}

		public function get comment():String {
			return _comment;
		}

		public function get name():String {
			return _name;
		}
		
	}
}