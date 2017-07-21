package demo.adapter {
	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.lights.DirectionalLight;
	
	import demo.display3D.Player3D;
	import demo.enum.RoleEnum;
	import demo.managers.GameManager;
	import demo.managers.WorldManager;
	import demo.path.vo.SceneData;
	import demo.ui.GameInfoPanel;
	import demo.ui.UIPanel;
	
	public class SceneCQAdapter extends SceneAdapterBase {
		
		public function SceneCQAdapter() {
			super();
		}
		
		override public function onLeave():void {
			super.onLeave();
			Stage3DLayerManager.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUP);
		}
		
		override protected function onCameraDistanceChange():void {
			var light : DirectionalLight = WorldManager.instance.gameScene3D.entityAreaDirectionalLight;
			if (light == null) {
				return;
			}
			var dist : Number = CameraController.lockedOnPlayerController.distance;
			var roleID : int = WorldManager.instance.roleID;
			if (roleID == RoleEnum.ROLE_CQ_MALE_MAGE || roleID == RoleEnum.ROLE_CQ_MALE_WARRIOR) {
				light.farPlane = clamp(4000, 7000, dist * 2);
			}
		}
		
		override public function onSceneLoadComplete(gameScene3D:GameScene3D):void {
			
			super.onSceneLoadComplete(gameScene3D);
						
			var sceneID : int = WorldManager.instance.sceneID;
			var roleID  : int = WorldManager.instance.roleID;
			var sceneData : SceneData = WorldManager.instance.currentSceneData;
			
			CameraController.lockedOnPlayerController.minDist    = 800;
			CameraController.lockedOnPlayerController.maxDist    = 2600;
			CameraController.lockedOnPlayerController.distance   = 2600;
			CameraController.lockedOnPlayerController.tiltAngle  = 40;
			CameraController.lockedOnPlayerController.panAngle   = 135;
			CameraController.lockedOnPlayerController.checkBlock = false;
			CameraController.lockedOnPlayerController.mouseRightSpeed = 0;
			CameraController.lockedOnPlayerController.mouseWheelSpeed = 20;
			CameraController.lockedOnPlayerController.mouseLeftControlable = false;
			CameraController.lockedOnPlayerController.mouseRightControlable = false;
			CameraController.lockedOnPlayerController.mouseWheelCallback = onCQMouseWheel;
			
			PerspectiveLens(Stage3DLayerManager.getView().camera.lens).fieldOfView = 40;
			
			var light : DirectionalLight = gameScene3D.entityAreaDirectionalLight;
			if (light) {
				light.shadowFade = false;
			}
			
			var txt : String = "";
			if (roleID == RoleEnum.ROLE_CQ_MALE_MAGE) {
				txt = "技能快捷键：\n1 火球术 \n2 极光电影 \n3 冰咆哮 \n4 雷电术 \n5 魔法盾 \n6 切换角色 \n";
			} else if (roleID == RoleEnum.ROLE_CQ_MALE_WARRIOR) {
				txt = "技能快捷键：\n1 半月弯刀 \n2 刺杀剑术 \n3 烈火剑法 \n4 破击剑法 \n5 狮子吼 \n6 切换角色 \n";
			}
			if (txt != "") {
				Stage3DLayerManager.starlingLayer.addChild(new GameInfoPanel(txt));
				UIPanel.instance.show();
			}
			
			Stage3DLayerManager.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUP);
		}
		
		protected function onKeyUP(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.NUMBER_6) {
				changeCQRole();
			}
		}
		
		public function changeCQRole() : void {
			var role : Player3D = GameManager.getInstance().mainRole;
			if (!role) {
				return;
			}
			role.walkTo(new Vector3D(role.x, 0, role.z));
			var rList : Array = [RoleEnum.ROLE_CQ_MALE_MAGE, RoleEnum.ROLE_CQ_MALE_WARRIOR];
			var index : int = rList.indexOf(role.playerType) + 1;
			if (index >= rList.length) {
				index = 0;
			}
			role.changeRole(rList[index]);
			GameManager.getInstance().configSkill(rList[index]);
		}
		
		private function onCQMouseWheel(event : MouseEvent) : void {
			var delta : int = -1 * clamp(-30, 30, event.delta);
			CameraController.lockedOnPlayerController.yFactor += delta * 0.016;
			CameraController.lockedOnPlayerController.distance += delta  * 40;
			if (CameraController.lockedOnPlayerController.yFactor >= 1) {
				CameraController.lockedOnPlayerController.yFactor = 1;
			} else if (CameraController.lockedOnPlayerController.yFactor <= 0.25) {
				CameraController.lockedOnPlayerController.yFactor = 0.25;
			}
		}
		
	}
}