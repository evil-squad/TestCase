package demo.adapter
{
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.utils.setTimeout;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.PropertyAnimatorContainer;
	
	import demo.helper.DriverCheckHelper;
	import demo.managers.WorldManager;
	
	public class SceneTyzAdapter extends SceneAdapterBase
	{
		public function SceneTyzAdapter()
		{
			super();
		}
		
		override public function onSceneLoadComplete(gameScene3D:GameScene3D):void {
			var propertyAnimatorContainer : PropertyAnimatorContainer = WorldManager.instance.gameScene3D.sceneMapLayer.rootObjectByName.getValue("Camera1propertyAnimatorContainer1") as PropertyAnimatorContainer;
			Stage3DLayerManager.getView().visible = true;
			Stage3DLayerManager.getView().camera = propertyAnimatorContainer.getChildAt(0) as Camera3D;
			Stage3DLayerManager.startRender();
			new DriverCheckHelper().check();
			
			propertyAnimatorContainer.animator.stop();
			setTimeout(function():void {propertyAnimatorContainer.animator.start();},1500);
		}
	}
}