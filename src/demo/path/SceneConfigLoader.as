package demo.path
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import demo.path.vo.SceneConfig;
	import demo.path.vo.SceneData;

	public class SceneConfigLoader {
		
		private var urlLoader   : URLLoader=null;
		private var successFunc : Function=null;
		private var failedFunc  : Function=null;
		
		private function OnXMLFileLoaded(event : Event) : void {	
			
			var xml  : XML = new XML(urlLoader.data);
			var role : XML = null;
			var roleList  : XMLList = xml.child("role_list");
			var sceneList : XMLList = xml.child("scene_list");
			
			// 角色列表
			for each (role in roleList.role) {
				ModelRolePath.instance.addRoleType(parseInt(role.@id), parseFloat(role.@scale), role.@path, role.@weapon);
			}
			// 默认场景
			var defaultScene : int = xml.child("default").@sceneID;
			var defaultImage : String = xml.child("default").@bg;
			// 场景列表
			var sceneConfig : SceneConfig = new SceneConfig(defaultScene, defaultImage);
			for each (var scene:XML in sceneList.scene) {
				sceneConfig.addSceneData(new SceneData(scene));
			}
			successFunc(sceneConfig);
		}
		
		private function OnError(event : Event) : void {
			failedFunc();
		}		
		
		public function SceneConfigLoader(complete_func : Function, failed_func : Function) : void {
			
			successFunc = complete_func;
			failedFunc  = failed_func;
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,OnXMLFileLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, OnError);
			urlLoader.load(new URLRequest("scene_list.xml"));
		}
	}
}