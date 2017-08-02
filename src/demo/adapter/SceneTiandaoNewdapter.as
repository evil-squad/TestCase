package demo.adapter {
	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import away3d.enum.ShadowMapperType;
	import away3d.lights.DirectionalLight;
	
	import demo.managers.WorldManager;
	import demo.ui.GameInfoPanel;
	import demo.ui.UIPanel;
	
	
	public class SceneTiandaoNewdapter extends SceneAdapterBase {
		
		public function SceneTiandaoNewdapter() {
			super();
		}
		
		override protected function onCameraDistanceChange():void {
			
			var light : DirectionalLight = WorldManager.instance.gameScene3D.entityAreaDirectionalLight;
			
			if (light == null) {
				return;
			}
			
			var farMin0 : Number = 8000;
			var farMax0 : Number = 50000;
			var farMin1 : Number = 3000;
			var farMax1 : Number = 8000;
			
			var dist : Number = CameraController.lockedOnPlayerController.distance;
			var bias : Number = (dist - CameraController.lockedOnPlayerController.minDist) / (CameraController.lockedOnPlayerController.maxDist - CameraController.lockedOnPlayerController.minDist);
						
			if (light.shadowMapperType == ShadowMapperType.CASCADE) {
				light.farPlane = clamp(farMin0, farMax0, (farMax0 - farMin0) * bias + farMin0);
			} else {
				light.farPlane = clamp(farMin1, farMax1, (farMax1 - farMin1) * bias + farMin1);
			}
		}
		
		override public function onSceneLoadComplete(gameScene3D:GameScene3D):void {
			
			super.onSceneLoadComplete(gameScene3D);
						
			var txt : String = "";
			txt += "技能快捷键：\n1 天女散花 \n";
			
			Stage3DLayerManager.starlingLayer.addChild(new GameInfoPanel(txt));
			UIPanel.instance.show();
		}
		
	}
}