package demo.managers {
	import com.game.engine3D.controller.CameraController;
	
	import away3d.containers.ObjectContainer3D;


	/**
	 * @author chenbo
	 * 创建时间：Apr 27, 2016 11:31:38 AM
	 */
	public class GameCameraManager {
		
		private static var _playerModeDistance 	: int;
		private static var _playerMode 			: Boolean;
					
		/**
		 * 设置镜头控制为玩家模式
		 */
		public static function startPlayerMode(target : ObjectContainer3D) : void {
			_playerMode = true;
			
			CameraController.initcontroller(WorldManager.instance.gameScene3D.camera, target);
			CameraController.initLockOnControl(135, 200, 0, 350, true, true, true, 250, 600, 0, 80);
			CameraController.lockedOnPlayerController.mouseRightSpeed = 0.2;
			CameraController.lockedOnPlayerController.mouseWheelSpeed = 30;
			CameraController.switchToLockOnControl();
		}
		
		/**
		 * 设置镜头控制为动画模式
		 */
		public static function startAnimationMode(target : ObjectContainer3D) : void {
			if (_playerMode) {
				_playerModeDistance = CameraController.lockedOnPlayerController.distance;
			}
			_playerMode = false;
			CameraController.initcontroller(WorldManager.instance.gameScene3D.camera, target);
			CameraController.initLockOnControl(0, 53, 45, _playerModeDistance, false, false, false, 1, 15000, -89, 89);
		}
	}
}
