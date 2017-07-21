package  
{

	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import away3d.Away3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.loaders.multi.MultiUrlLoadManager;
	import away3d.primitives.WireframePlane;

	/**
	 * ...
	 * @author 
	 */
	[SWF(backgroundColor="#000000", frameRate="60", width="1024", height="768")]
	public class ExampleTemplate extends Sprite 
	{	
		private const nearest:int = 100;
		private const farrest:int = 2000;
		
		protected var _view:View3D;

		private var _cameraController:HoverController;
		private var _move:Boolean = false;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		
		private var awayStats:AwayStats;
		private var groundGrid:WireframePlane = new WireframePlane(2000, 2000, 10, 10, 0xcccccc, 1, WireframePlane.ORIENTATION_XZ);
		
		private var _showDebug:Boolean = true;
		private var _showGrid:Boolean = true;
		
		public function ExampleTemplate() 
		{
			super();

			if (this.stage == null) {
				this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			} else {
				this.onAddToStage(null);
			}
			MultiUrlLoadManager.getUrlWithVersion = urlWithVersion;
		}
		
		private static function urlWithVersion(input : String):String
		{
			return input + "?ver=2";
		}
		
		private function clearAll():void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.clearAll();
			this.init();
		}

		private function init():void
		{
			// Away3D Setting
			Away3D.USE_ATF_FOR_TEXTURES = true;
			Away3D.EXTEND_MEMORY_SIZE = 150 * 1024 * 1024;
			Away3D.MIN_HEAP_SIZE = 100 * 1024 * 1024;
			MultiUrlLoadManager.maxQueueSize = 5;

			// 初始化Stage3D
			Stage3DLayerManager.setup(stage, this, onSetupComplete, onSetupError, null, 1, 6, CameraController.forceStopPanning);

			//UI控件库初始化
			//GuiTheme.RES_ROOT = "../assets/";
			//GuiTheme.defaultTextureFormat = FileFormatEnum.BPG;
		}

		public function onSetupComplete():void
		{
			Stage3DLayerManager.screenAntiAlias = 0;
			Stage3DLayerManager.viewAntiAlias = 2;
			Stage3DLayerManager.startRender();

			_view = Stage3DLayerManager.getView(0);
			//_view.contextMenu = null;
			//_view.width = this.width;
			//_view.height = this.height;
			_view.antiAlias = 2;
			_view.camera.lens.far = 20000;
			_view.scene.addChild(groundGrid);
			addChild(awayStats = new AwayStats(Stage3DLayerManager.stage3DProxy));

			//setup controller to be used on the camera
			_cameraController = new HoverController(_view.camera, null, 160, 20, 1000);
			initListeners();
		}
		
		private function onSetupError() : void
		{
			trace("onSetupError");
		}
		
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, render);
			//stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}
		
		private function onWheel(e:MouseEvent):void
		{
			_cameraController.distance -= e.delta * 5;
			if (_cameraController.distance < nearest)
				_cameraController.distance = nearest;
			else if (_cameraController.distance > farrest)
				_cameraController.distance = farrest;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			_lastPanAngle = _cameraController.panAngle;
			_lastTiltAngle = _cameraController.tiltAngle;
			_lastMouseX = stage.mouseX;
			_lastMouseY = stage.mouseY;
			_move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(event:Event):void
		{
			_move = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
//		private function onResize(e:Event):void
//		{
//			_view.width = stage.stageWidth;
//			_view.height = stage.stageHeight;
//		}
		
		private function render(e:Event):void
		{
			if (_move)
			{
				_cameraController.panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
				_cameraController.tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAngle;
			}
		}
		
		public function get showDebug():Boolean
		{
			return _showDebug;
		}

		public function set showDebug(value:Boolean):void
		{
			_showDebug = value;
			awayStats.visible = _showDebug;
		}

		public function get showGrid():Boolean
		{
			return _showGrid;
		}

		public function set showGrid(value:Boolean):void
		{
			_showGrid = value;
			groundGrid.visible = _showGrid;
		}

	}
}