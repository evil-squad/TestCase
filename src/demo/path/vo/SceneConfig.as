package demo.path.vo {
	import flash.utils.Dictionary;
	
	public class SceneConfig {
		
		private var _scenes       : Vector.<SceneData>;
		private var _sceneIDMap   : Dictionary;
		private var _sceneNameMap : Dictionary;
		private var _defaultScene : int = 0;		
		private var _defaultImage : String;
		
		public function SceneConfig(sceneIdx : int, image : String) {
			_scenes       = new Vector.<SceneData>();	
			_sceneIDMap   = new Dictionary();
			_sceneNameMap = new Dictionary();
			_defaultScene = sceneIdx;
			_defaultImage = image;
		}
		
		public function get defaultImage():String {
			return _defaultImage;
		}

		public function getSceneByID(id : int) : SceneData {
			return _sceneIDMap[id];
		}
		
		public function getSceneByName(name : String) : SceneData {
			return _sceneNameMap[name];
		}
		
		public function get defaultScene() : SceneData {
			if (_scenes == null || _scenes.length == 0) {
				return null;
			}
			return _scenes[_defaultScene];
		}
		
		public function addSceneData(data : SceneData) : void {
			_scenes[_scenes.length]   = data;
			_sceneIDMap[data.sceneID] = data;
			_sceneNameMap[data.name]  = data;
		}
		
		public function getSceneData(index : uint) : SceneData {
			if (index >= _scenes.length) {
				throw new Error("...");
			}
			return _scenes[index];
		}
		
	}
}