package   {
	
	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.manager.Stage3DLayerManager;
	import com.game.engine3d.utils.LogUtils;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import away3d.Away3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.enum.FileFormatEnum;
	import away3d.enum.LoadPriorityType;
	import away3d.loaders.multi.MultiUrlLoadManager;
	import away3d.loaders.parsers.Parsers;
	
	import demo.adapter.SceneAdapterManager;
	import demo.enum.LayerEnum;
	import demo.loader.DemoLoader;
	import demo.managers.GameManager;
	import demo.managers.WorldManager;
	import demo.path.SceneConfigLoader;
	import demo.path.vo.SceneConfig;
	import demo.path.vo.SceneData;
	import demo.display3D.Avatar3D;
	import demo.enum.RoleEnum;
	import demo.managers.GameManager;
	import demo.managers.WorldManager;
	
	import feathers.themes.GuiTheme;
		
	import com.game.engine3D.manager.Stage3DLayerManager;
		
	/**
	 * Application 
	 * @author chenbo
	 * 
	 */	
	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW", width = "1600", height = "900")]
	public class DemoSceneTest extends Sprite {
		
		private var _sceneID : int;
		private var _bgName  : String;
		private var _roleID  : int;	
		private var _sceneIndex : int = -1;
		private var _sceneIdArray : Array = [7,11];
		private var _sceneArrayIndex : int = 0;
		private var _timer : Timer = new Timer(8000, 0);
		private var _isStart : Boolean = false;
		private var _timerCount : Number = 0;
		private var _text : TextField=new TextField();
		private var _textFormat : TextFormat = new TextFormat();
			
		public function DemoSceneTest() {
			super();
			if (!this.stage) {
				this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			} else {
				this.onAddToStage(null);
			}
			MultiUrlLoadManager.getUrlWithVersion = urlWithVersion;
		}
		
		private static function urlWithVersion(input:String):String {
			return input+"?v=333";
		}
		
		/**
		 * add to stage 
		 * @param event
		 * 
		 */		
		private function onAddToStage(event:Event):void {
			
			this.stage.align 	 = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			while(numChildren)
				removeChildAt(0);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.init();
		}
		
		
		/**
		 *  Init ALL
		 */		
		private function init() : void {
			// 整合YLZT Engine、因此将额外的配置放置到GlobalSetting
			// Away3D Setting
			//			Away3D.PARSE_PNG_IN_WORKER = true;
			//			Away3D.PARSE_JPG_IN_WORKER = true;
			//			Away3D.USE_TEXTURES_BPG_FORMAT = true;
			Away3D.USE_ATF_FOR_TEXTURES = true;
			Away3D.EXTEND_MEMORY_SIZE = 150 * 1024 * 1024;
			Away3D.MIN_HEAP_SIZE = 100 * 1024 * 1024;
			new SceneConfigLoader(OnLoadSceneConfigComplete, onLoadSceneConfigFailed);
		}
		
		private function OnLoadSceneConfigComplete(sceneConfig : SceneConfig) : void {	
			WorldManager.instance.sceneConfig = sceneConfig;
			// 初始化Stage3D
			Stage3DLayerManager.setup(stage, this, onSetupComplete, onSetupError, null, 1, 6, CameraController.forceStopPanning);
			//UI控件库初始化
			GuiTheme.RES_ROOT = "../assets/"; 
			GuiTheme.defaultTextureFormat = FileFormatEnum.BPG;
			
		}
		
		private function onLoadSceneConfigFailed() : void {
			LogUtils.log2D(stage,"GameDemo", "LoadSceneConfig error", false);
		}
		
		/**
		 *  YLZT Engine Create Error
		 */		
		private function onSetupError() : void {
			LogUtils.log3D(Stage3DLayerManager.stage3DProxy.profile, Stage3DLayerManager.stage3DProxy.stage3D, "GameDemo");
		}
		
		/**
		 *  YLZT Engine Create Complete
		 */		
		private function onSetupComplete() : void {
			Parsers.enableAllBundled();
			
			Stage3DLayerManager.screenAntiAlias = 0;
			Stage3DLayerManager.viewAntiAlias = 2;
			Stage3DLayerManager.starlingLayer.setLayer(LayerEnum.LAYER_HP, 0);				
			Stage3DLayerManager.starlingLayer.setLayer(LayerEnum.LAYER_NAME, 1);				
			Stage3DLayerManager.starlingLayer.setLayer(LayerEnum.LAYER_ATTACK, 2);			
			Stage3DLayerManager.starlingLayer.setLayer(LayerEnum.LAYER_MAIN, 3);				
			Stage3DLayerManager.starlingLayer.setLayer(LayerEnum.LAYER_APP, 4);
			Stage3DLayerManager.starlingLayer.setLayer(LayerEnum.LAYER_ALERT, 5);
			LogUtils.log3D(Stage3DLayerManager.stage3DProxy.profile, Stage3DLayerManager.stage3DProxy.stage3D, "GameDemo", null, true, stage);
			Stage3DLayerManager.startRender();
			
			var view:View3D=Stage3DLayerManager.getView(0);
			
			view.scene.addChild(view.camera);
			
			var sConfig : SceneConfig = WorldManager.instance.sceneConfig;
			var sData   : SceneData = sConfig.defaultScene;
			
			if (ExternalInterface.available) {
				var urlParmar:Object = ExternalInterface.call("config");
				if (urlParmar) {
					_sceneID = urlParmar["sceneid"] || sData.sceneID;
					_bgName  = urlParmar["bg"] || sData.bgImage;
					_roleID  = urlParmar["role"] || sData.defaultRole.id;
				}
				else{
					_sceneID = sData.sceneID;
					_bgName  = sData.bgImage;
					_roleID  = sData.defaultRole.id;
				}
			} else {
				_sceneID = sData.sceneID;
				_bgName  = sData.bgImage;
				_roleID  = sData.defaultRole.id;
			}
			
			LoadPriorityType.LEVEL_AWD = 5000;
			LoadPriorityType.LEVEL_BUNDLE = 4000;
			LoadPriorityType.LEVEL_GEOMETRY = 4500;
			LoadPriorityType.LEVEL_NORMALMAP = 0;
			LoadPriorityType.LEVEL_SOUND = 0;
			LoadPriorityType.LEVEL_TEXTURE = 4200;
			
			SceneAdapterManager.instance.init();
			
			
			new DemoLoader().start(_bgName, onbgLoadedCallback);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			Stage3DProxy.getInstance().context3D.enableErrorChecking = true;
		}
		
		private function onbgLoadedCallback() : void {
			GameManager.MAX_MONSTER_COUNT = 0;
			GameManager.MAX_NPC_COUNT     = 0;
			WorldManager.instance.changeScene(_sceneID, _roleID);
		}
		
		private function changeSceneByTime(e : TimerEvent) : void {
			_timerCount++;
			_text.text=_timerCount.toString();
			_text.textColor = 0xffffff;
			_text.height = 100;
			_textFormat.size = 40;
			_text.setTextFormat(_textFormat);
			this.stage.addChild(_text);
			
			WorldManager.instance.changeScene(11,10);
		}
		
		private function onKeyDown(e : KeyboardEvent) : void {
			var me : demo.display3D.Avatar3D = GameManager.getInstance().mainRole;
			var _roleType : int = RoleEnum.ROLE_TIAN_DAO;
			
			if (me == null)
				return;
			
			if (e.keyCode == Keyboard.T) {
				if (_isStart) {
					_timer.stop();
					_isStart = !_isStart;
					trace("stop");
				} else {
					_timer.addEventListener(TimerEvent.TIMER,changeSceneByTime);
					_timer.start()
					_isStart = true;
					trace("start");
				}
			}
			
			if (e.keyCode == Keyboard.C)
			{
				if (_sceneIndex != 3 &&_sceneIndex != 4&&_sceneIndex!=6)
				{
					GameManager.getInstance().changeMyRole();
				}
			}
			
			if (e.keyCode == Keyboard.N)
			{
				if (_sceneArrayIndex>_sceneIdArray.length-1) {
					_sceneArrayIndex = 0;
				}
				WorldManager.instance.changeScene(_sceneIdArray[_sceneArrayIndex++],_roleType);
			}
			
			if (e.keyCode == Keyboard.DELETE) {
				if (e.shiftKey) {
					System.gc();
				} else {
					if (_sceneIndex == 2 || _sceneIndex == 3) _sceneIndex=4;
					if (_sceneIndex == 5) _roleType = RoleEnum.ROLE_CQ_MALE_MAGE;
					if (_sceneIndex >=9) _sceneIndex = -1;
					WorldManager.instance.changeScene(++_sceneIndex,_roleType);
					trace("scene id: ",_sceneIndex,"role id: ",_roleType);
				}
				trace(int(me.x) + ", 0, " + int(me.y));
			}
		}
		
	}
}
