package demo.path.vo {
		
	public class SceneData {
		
		private static const REF_NAMES : Object = {
			"fpsStatus"			: "_fpsStatus",
			"screenSpaceShadow"	: "_ssShadow",
			"depthOfField"			: "_depthOfField",
			"hdr"					: "_hdr",
			"ssao"					: "_ssao",
			"antiAlias"			: "_antialias",
			"displayLevel"			: "_displayLevel",
			"shadowLevel"			: "_shadowLevel",
			"quality"				: "_quality"
		};
		
		private var _path    		: String;
		private var _name    		: String;
		private var _sceneID 		: int;
		private var _bgImage       : String;
		private var _comment 		: String;
		private var _hdr 			: SceneOption;
		private var _ssao 			: SceneOption;
		private var _quality 		: SceneOption;
		private var _ssShadow 		: SceneOption;
		private var _fpsStatus     	: SceneOption;
		private var _antialias 	    : SceneOption;
		private var _shadowLevel 	: SceneOption;
		private var _displayLevel 	: SceneOption;
		private var _depthOfField 	: SceneOption;
		private var _defaultRole   : RoleData;
		private var _xmlNode       : XML;
		
		/**
		 *  
		 * @param path     URL
		 * @param name     名称
		 * @param sceneID  ID
		 * 
		 */		
		public function SceneData(node : XML) : void {
			
			_path = node.@path;
			_name = node.@name;
			_sceneID = node.@sceneID;
			_bgImage = node.@bg;
			// option
			var options : XMLList = node.option;
			for each (var option:XML in options) {
				var name : String = option.@name;
				var so   : SceneOption = new SceneOption(option);
				this[REF_NAMES[name]] = so;
			}
			// role
			var roles : XMLList = node.role;
			for each (var role:XML in roles) {
				_defaultRole = new RoleData(role);
				break;
			}
			if (_defaultRole == null) {
				_defaultRole = new RoleData(<role id="10" x="22369" y="3882" z="25650" />);
			}
		}
		
		public function get xmlNode():XML {
			return _xmlNode;
		}

		public function get bgImage():String {
			return _bgImage;
		}

		public function get defaultRole():RoleData {
			return _defaultRole;
		}

		public function get depthOfField():SceneOption {
			return _depthOfField;
		}

		public function get displayLevel():SceneOption {
			return _displayLevel;
		}

		public function get shadowLevel():SceneOption {
			return _shadowLevel;
		}

		public function get antialias():SceneOption {
			return _antialias;
		}

		public function get fpsStatus():SceneOption {
			return _fpsStatus;
		}

		public function get ssShadow():SceneOption {
			return _ssShadow;
		}

		public function get quality():SceneOption {
			return _quality;
		}

		public function get ssao():SceneOption {
			return _ssao;
		}

		public function get hdr():SceneOption {
			return _hdr;
		}

		public function get comment():String {
			return _comment;
		}

		public function get sceneID():int {
			return _sceneID;
		}

		public function get name():String {
			return _name;
		}

		public function get path():String {
			return _path;
		}
		
	}
	
}