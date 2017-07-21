package demo.adapter {
	
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import demo.ui.GameInfoPanel;
	import demo.ui.UIPanel;
	
	public class SceneQSMYAdapter extends SceneAdapterBase {
		
		public function SceneQSMYAdapter() {
			super();
		}
		
		override public function onSceneLoadComplete(gameScene3D:GameScene3D):void {
			
			super.onSceneLoadComplete(gameScene3D);
			
			var txt : String = "";
			txt = "技能快捷键：\n1 冰意 \n2 占星律 \n3 一舞倾城 \n";
			if (txt != "") {
				Stage3DLayerManager.starlingLayer.addChild(new GameInfoPanel(txt));
				UIPanel.instance.show();
			}
		}
		
	}
}