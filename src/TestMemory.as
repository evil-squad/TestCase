package   {
	
	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import away3d.Away3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.AwayStats;
	import away3d.enum.FileFormatEnum;
	import away3d.loaders.multi.MultiUrlLoadManager;
	import away3d.loaders.parsers.Parsers;
	
	import demo.enum.LayerEnum;
	import demo.loader.DemoLoader;
	import demo.utils.AwdViewer;
	
	import feathers.themes.GuiTheme;
	
	
	/**
	 *　　　　　　　　┏┓　　　┏┓+ +
	 *　　　　　　　┏┛┻━━━┛┻┓ + +
	 *　　　　　　　┃　　　　　　　┃ 　
	 *　　　　　　　┃　　　━　　　┃ ++ + + +
	 *　　　　　　 ████━████ ┃+
	 *　　　　　　　┃　　　　　　　┃ +
	 *　　　　　　　┃　　　┻　　　┃
	 *　　　　　　　┃　　　　　　　┃ + +
	 *　　　　　　　┗━┓　　　┏━┛
	 *　　　　　　　　　┃　　　┃　　　　　　　　　　　
	 *　　　　　　　　　┃　　　┃ + + + +
	 *　　　　　　　　　┃　　　┃　　　　　　　　　　　
	 *　　　　　　　　　┃　　　┃ + 　　　　　　
	 *　　　　　　　　　┃　　　┃
	 *　　　　　　　　　┃　　　┃　　+　　　　　　　　　
	 *　　　　　　　　　┃　 　　┗━━━┓ + +
	 *　　　　　　　　　┃ 　　　　　　　┣┓
	 *　　　　　　　　　┃ 　　　　　　　┏┛
	 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
	 *　　　　　　　　　　┃┫┫　┃┫┫
	 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
	 * @author chenbo
	 * 创建时间：Aug 29, 2016 10:12:24 AM
	 */
	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW", width = "1600", height = "900")]
	public class TestMemory extends Sprite {
		
		private var awdPath : String = "../assets/map";
		private var awdName : String = "yl_scene01_wc02.awd";
		private var bgName  : String = "di.jpg";
		
		public function TestMemory() {
			super();
			
			if (this.stage == null) {
				this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			} else {
				this.onAddToStage(null);
			}
			MultiUrlLoadManager.getUrlWithVersion = urlWithVersion;
			
		}
		
		private static function urlWithVersion(input : String) : String {
			return input + "?ver=2";
		}
		
		private function parseArgs() : void {
			if (ExternalInterface.available) {
				var urlParmar : Object = ExternalInterface.call("config");
				if (urlParmar) {
					awdName = urlParmar["awd"] || awdName;
					bgName  = urlParmar["bg"]  || bgName;
				}
			}
			var tokens : Array = awdName.split(".");
			awdPath = awdPath + "/" + tokens[0];
		}
				
		private function clearAll() : void {
			while (numChildren > 0) {
				removeChildAt(0);
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		/**
		 * add to stage 
		 * @param event
		 * 
		 */		
		private function onAddToStage(event:Event):void {
						
			this.stage.align 	 = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.clearAll();
			this.parseArgs();
			this.init();
		}
		
		
		private function init():void {
			// Away3D Setting
			Away3D.USE_ATF_FOR_TEXTURES = true;
			Away3D.EXTEND_MEMORY_SIZE = 150 * 1024 * 1024;
			Away3D.MIN_HEAP_SIZE = 100 * 1024 * 1024;
			// 初始化Stage3D
			Stage3DLayerManager.setup(stage, this, onSetupComplete, null, null, 1, 6, CameraController.forceStopPanning);
			//UI控件库初始化
			GuiTheme.RES_ROOT = "../assets/";
			GuiTheme.defaultTextureFormat = FileFormatEnum.BPG;			
		}
			
		
		/**
		 *  YLZT Engine Create Complete
		 */		
		private function onSetupComplete() : void {
			Parsers.enableAllBundled();
			
			Stage3DLayerManager.screenAntiAlias = 0;
			Stage3DLayerManager.viewAntiAlias   = 2;
			Stage3DLayerManager.starlingLayer.setLayer(LayerEnum.LAYER_ALERT, 0);				
			Stage3DLayerManager.startRender();
			
			new DemoLoader().start(bgName, onbgLoadedCallback);
		}
		
		private var awdViewer : AwdViewer;
		private var text : TextField = new TextField();
		
		private function onbgLoadedCallback():void {
			awdViewer = new AwdViewer(awdPath, awdName,this.stage);
			Stage3DLayerManager.getView().scene.addChild(awdViewer);
			var timer : Timer = new Timer(15000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			text.defaultTextFormat = new TextFormat(null, 20, 0xFF0000);
			text.width = 1024;
			text.height = 128;
			text.mouseEnabled = false;
			text.text = "0";
			addChild(text);
			addChild(new AwayStats(Stage3DProxy.getInstance()));
		}
		
		protected function onTimer(event:TimerEvent):void {
			System.pauseForGCIfCollectionImminent(0);
			System.gc();
			text.text = "" + (parseInt(text.text) + 1);
			if (awdViewer) {
				Stage3DLayerManager.getView().scene.removeChild(awdViewer);
				awdViewer.dispose();
			}
			awdViewer = new AwdViewer(awdPath, awdName,this.stage);
			Stage3DLayerManager.getView().scene.addChild(awdViewer);
		}
		
	}
}