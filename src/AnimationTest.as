/*
jing
*/

package
{
	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import away3d.Away3D;
	import away3d.animators.AnimatorBase;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.VertexAnimator;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.assets.AssetType;
	import away3d.lights.PointLight;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.multi.MultiUrlLoadManager;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.Parsers;
	//import away3d.materials.lightpickers.StaticLightPicker;
	
	[SWF(backgroundColor="#000000", frameRate="60", width="1024", height="768")]
	public class AnimationTest extends Sprite
	{
		//engine variables
		private var view:View3D;
		private var cameraController:HoverController;
		
		//scene objects
		private var light:PointLight;
		//private var lightPicker:StaticLightPicker;
		private var headModel:Mesh;
		
		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		private var animName:String = null;
		private var animator:AnimatorBase = null;
		
		private var meshCount:int = 1;
		private var text:TextField = new TextField();
		
		private var awdPath:String ="../assets/role/mazei/mazei.awd";
		/**
		 * Constructor
		 */
		public function AnimationTest()
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
			this.stage.align 	 = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.clearAll();
			this.init();
		}
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			// Away3D Setting
			//Away3D.USE_ATF_FOR_TEXTURES = true;
			Away3D.PARSE_JPG_IN_WORKER = true;
			Away3D.EXTEND_MEMORY_SIZE = 150 * 1024 * 1024;
			Away3D.MIN_HEAP_SIZE = 100 * 1024 * 1024;
			MultiUrlLoadManager.maxQueueSize = 5;
			// 初始化Stage3D
			Stage3DLayerManager.setup(stage, this, onSetupComplete, onSetupError, null, 1, 6, CameraController.forceStopPanning);
			//UI控件库初始化
			//GuiTheme.RES_ROOT = "../assets/";
			//GuiTheme.defaultTextureFormat = FileFormatEnum.BPG;
		}

		/**
		 *  YLZT Engine Create Complete
		 */		
		private function onSetupComplete() : void
		{
			Parsers.enableAllBundled();
			
			Stage3DLayerManager.screenAntiAlias = 0;
			Stage3DLayerManager.viewAntiAlias = 2;
			Stage3DLayerManager.startRender();
			
			view = Stage3DLayerManager.getView(0);
			view.antiAlias = 4;
			addChild(new AwayStats(Stage3DLayerManager.stage3DProxy));

			//setup controller to be used on the camera
			cameraController = new HoverController(view.camera, null, 45, 10, 800);
			
			initText();
			initLights();
			initObjects();
			initListeners();
		}

		private function onSetupError():void
		{
			trace("onSetupError");
		}

		private function initText():void
		{
			text.defaultTextFormat = new TextFormat("Verdana", 15, 0xFF0000);
			text.width = 240;
			text.height = 100;
			text.x = 800;
			text.y = 0;
			text.selectable = false;
			text.mouseEnabled = false;
			text.text = "MeshCount: " + String(meshCount);

			addChild(text);
		}

		/**
		 * Initialise the lights in a scene
		 */
		private function initLights():void
		{
			light = new PointLight();
			light.x = 15000;
			light.z = 15000;
			light.color = 0xffddbb;
			light.ambient = 1;
			//lightPicker = new StaticLightPicker([light]);
			
			view.scene.addChild(light);
		}
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			var _loader : AssetLoader = new AssetLoader();
			_loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			_loader.load(new URLRequest(awdPath), null, null, new AWD2Parser());
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			//stage.addEventListener(Event.RESIZE, onResize);
			//onResize();
		}
		
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if (move) {
				cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			
			light.x = Math.sin(getTimer()/10000)*15000;
			light.y = 1000;
			light.z = Math.cos(getTimer()/10000)*15000;
			
		}
		
		/**
		 * Listener function for asset complete event on loader
		 */
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH)
			{
				headModel = event.asset as Mesh;
				headModel.y = -150;
				
				view.scene.addChild(headModel);
			}
			else if(event.asset.assetType == AssetType.ANIMATION_NODE)
			{
				animName = event.asset.name;
				AnimationNodeBase(event.asset).looping = true;
				play();
			}
			else if(event.asset.assetType == AssetType.ANIMATOR)
			{
				animator = event.asset as AnimatorBase;
				play();
			}
		}
		
		private function play():void
		{
			if(animName && animator)
			{
				if(animator is SkeletonAnimator)
					SkeletonAnimator(animator).play(animName);
				else if(animator is VertexAnimator)
					VertexAnimator(animator).play(animName);
			}
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
		}
		
		/**
		 * Key up listener for swapping between standard diffuse & specular shading, and sub-surface diffuse shading with fresnel specular shading
		 */
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.A:
					for(var i:int = 0; i < 20; i ++)
					{
						headModel = headModel.clone() as Mesh;
						headModel.y = -150;
						view.scene.addChild(headModel);
						if (headModel.animator is SkeletonAnimator)
							SkeletonAnimator(headModel.animator).play(animName);
						else if(headModel.animator is VertexAnimator)
							VertexAnimator(headModel.animator).play(animName);
						meshCount ++;
					}
					
					text.text = "MeshCount: " + String(meshCount);
					break;
			}
		}
		
		/**
		 * stage listener for resize events
		 */
//		private function onResize(event:Event = null):void
//		{
//			view.width = stage.stageWidth;
//			view.height = stage.stageHeight;
//		}
	}
}