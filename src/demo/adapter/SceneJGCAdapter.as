package demo.adapter {
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import away3d.cameras.Camera3D;
	import away3d.lights.DirectionalLight;
	
	import demo.display3D.Player3D;
	import demo.managers.GameManager;
	import demo.managers.WorldManager;
	import demo.path.vo.SceneData;
	import demo.ui.GameInfoPanel;
	import demo.ui.UIPanel;
	
	public class SceneJGCAdapter extends SceneAdapterBase {
		
		private var customMode    : int = 2;
		private var customCamera  : Camera3D;
				
		public function SceneJGCAdapter() {
			super();
		}
		
		override protected function onCameraDistanceChange():void {
			var light : DirectionalLight = WorldManager.instance.gameScene3D.entityAreaDirectionalLight;
			if (light == null) {
				return;
			}
			if (WorldManager.instance.sceneID == 8) {
				light.farPlane = 35000;
			}
		}
						
		override public function onSceneLoadComplete(gameScene3D:GameScene3D):void {
			
			super.onSceneLoadComplete(gameScene3D);
			
			var sceneID : int = WorldManager.instance.sceneID;
			var roleID  : int = WorldManager.instance.roleID;
			var sceneData : SceneData = WorldManager.instance.currentSceneData;
						
			// 取消glass效果
			var mainRole : Player3D = GameManager.getInstance().mainRole;
			if (mainRole) {
				mainRole.mesh.entityGlass = false;
				if (mainRole.weaponMesh) {
					mainRole.weaponMesh.entityGlass = false;
				}
			}
			// 
			var txt : String = "技能快捷键：\n1 天女散花 \n";
			txt += "漫游快捷键：\n2 漫游场景 \n";
			txt += "自由模式快捷键:\n3 自由模式 \n";
			
			Stage3DLayerManager.starlingLayer.addChild(new GameInfoPanel(txt));
			Stage3DLayerManager.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUP);
			
			UIPanel.instance.show();
		}
		
		override public function onLeave():void {
			super.onLeave();
			Stage3DLayerManager.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUP);
		}
		
		private function onKeyUP(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.NUMBER_2) {
				if (customMode == 2) {
					customCamera = Stage3DLayerManager.getView().camera;
					var camera : Camera3D = WorldManager.instance.gameScene3D.sceneMapLayer.rootObjectByName.getValue("camera") as Camera3D;
					Stage3DLayerManager.getView().camera = camera;
					camera.animator.start(0);
					customMode = 1;
				}
			} else if (event.keyCode == Keyboard.NUMBER_3) {
				if (customMode == 1) {
					Stage3DLayerManager.getView().camera = customCamera;
					customMode = 2;
				}
			}
		}
		
	}
}