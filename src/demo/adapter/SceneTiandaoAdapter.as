package demo.adapter {
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.CompositeAnimatorGroup;
	import away3d.containers.ObjectContainer3D;
	
	import demo.managers.WorldManager;
	import demo.ui.GameInfoPanel;
	import demo.ui.UIPanel;
	
	public class SceneTiandaoAdapter extends SceneAdapterBase {
		
		private var customMode   : int = 2;
		private var customCamera : Camera3D;
		
		public function SceneTiandaoAdapter() {
			super();
		}
		
		override public function onLeave():void {
			super.onLeave();
			Stage3DLayerManager.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUP);
		}
		
		override public function onSceneLoadComplete(gameScene3D:GameScene3D):void {
			
			super.onSceneLoadComplete(gameScene3D);
			
			var txt : String = "";
			txt += "漫游快捷键：\n1 漫游场景 \n";
			txt += "自由模式快捷键：\n2 自由模式 \n";
			
			Stage3DLayerManager.starlingLayer.addChild(new GameInfoPanel(txt));
			UIPanel.instance.show();
			
			Stage3DLayerManager.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUP);
		}
		
		/**
		 * 通过名称搜寻Child
		 * @param parent
		 * @return 
		 * 
		 */		
		private static function findChildByName(parent : ObjectContainer3D, name : String) : ObjectContainer3D {
			for (var i:int = 0; i < parent.numChildren; i++) {
				var child : ObjectContainer3D = parent.getChildAt(i);
				if (child.name == name) {
					return child;
				} else {
					child = findChildByName(child, name);
					if (child) {
						return child;
					}
				}
			}
			return null;
		}
		
		protected function onKeyUP(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.NUMBER_1) {
				if (customMode == 2) {
					customCamera = Stage3DLayerManager.getView().camera;
					var animatorGroup : CompositeAnimatorGroup = WorldManager.instance.gameScene3D.sceneMapLayer.rootObjectByName.getValue("camera") as CompositeAnimatorGroup;
					Stage3DLayerManager.getView().camera = findChildByName(animatorGroup, "camera1") as Camera3D;
					animatorGroup.animator.start(0);
					customMode = 1;
				}
			} else if (event.keyCode == Keyboard.NUMBER_2) {
				if (customMode == 1) {
					Stage3DLayerManager.getView().camera = customCamera;
					customMode = 2;
				}
			}
		}
				
	}
}