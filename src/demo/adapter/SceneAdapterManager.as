package demo.adapter {
	
	import flash.utils.Dictionary;
	
	public class SceneAdapterManager {
		
		private static var _instance : SceneAdapterManager;
		
		private var _adapterMap : Dictionary;
		
		private var _current : SceneAdapterBase;
		
		public function SceneAdapterManager() {
			if (_instance) {
				throw new Error("SingleTon");
			}
			_adapterMap = new Dictionary();
		}
		
		public function get current():SceneAdapterBase {
			return _current;
		}

		public static function get instance() : SceneAdapterManager {
			if (_instance == null) {
				_instance = new SceneAdapterManager();
			}
			return _instance;
		}
		
		public function switchAdapter(sceneID : int) : void {
			if (_current) {
				_current.onLeave();
			}
			_current = _adapterMap[sceneID];
			if (_current == null) {
				_current = new SceneAdapterBase();
			}
			_current.onEnter();
		}
		
		public function init() : void {
			this.addSceneAdapter(2, new SceneTiandaoAdapter());
			this.addSceneAdapter(3, new SceneUDKAdapter());
			this.addSceneAdapter(4, new SceneUDKAdapter());
			this.addSceneAdapter(5, new SceneQSMYAdapter());
			this.addSceneAdapter(6, new SceneCQAdapter());
			this.addSceneAdapter(7, new SceneTiandaoNewdapter());
			this.addSceneAdapter(8, new SceneJGCAdapter());
			this.addSceneAdapter(9, new SceneAdapterBase());
			this.addSceneAdapter(12, new SceneTyzAdapter());
		}
		
		public function addSceneAdapter(sceneID : int, adapter : SceneAdapterBase) : void {
			_adapterMap[sceneID] = adapter;	
		}
		
	}
}