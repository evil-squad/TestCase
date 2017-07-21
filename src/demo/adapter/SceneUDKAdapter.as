package demo.adapter {
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.utils.setTimeout;
	
	import away3d.cameras.Camera3D;
	
	import demo.helper.DriverCheckHelper;
	import demo.managers.WorldManager;
	
	public class SceneUDKAdapter extends SceneAdapterBase {
		
		public function SceneUDKAdapter() {
			super();
		}
		
		override public function onSceneLoadComplete(gameScene3D:GameScene3D):void {
			var camera : Camera3D = WorldManager.instance.gameScene3D.sceneMapLayer.rootObjectByName.getValue("Camera2") as Camera3D;
			Stage3DLayerManager.getView().visible = true;
			Stage3DLayerManager.getView().camera = camera;
			Stage3DLayerManager.startRender();
			new DriverCheckHelper().check();
			camera.animator.stop();
			setTimeout(function():void {camera.animator.start();},3000);
		}
		
	}
}