package demo.ui
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	import com.game.engine3D.utils.StatsUtil;
	
	import flash.utils.getDefinitionByName;
	
	import away3d.Away3D;
	import away3d.events.Event;
	import away3d.filters.Filter3DBase;
	
	import demo.enum.PanelPosType;
	import demo.events.EvilEvent;
	import demo.managers.WorldManager;
	import demo.path.vo.SceneData;
	import demo.vo.AppInfo;
	
	import feathers.controls.Button;
	
	import gs.TweenLite;
	import gs.TweenMax;
	
	import org.client.mainCore.manager.EventManager;
	import org.mokylin.skin.app.setting.RenderSettingSkin;
	import org.mokylin.skin.component.button.ButtonSkin_setting;
	
	import starling.display.DisplayObject;
	
	/**
	 * 
	 * 渲染参数设置
	 * @author wewell
	 * 
	 */	
	public class SettingPanel extends SkinUIPanel
	{
		private var skin:RenderSettingSkin;
		private var minmaxBtn:Button;
		private var _showStats:Boolean;
		
		private static var _instance:SettingPanel;
		
		private static const HDR_FILTER3D_CLASS_NAME:String = "away3d.filters::HDRFilter3D";
		private static const RINGDEPTHOFFIELD_FILTER3D_CLASS_NAME:String = "away3d.filters::RingDepthOfFieldFilter3D";
		private static const SSAO_FILTER3D_CLASS_NAME:String = "away3d.filters::SSAOFilter3D";
		
		public static function get instance():SettingPanel
		{
			if(_instance == null)_instance = new SettingPanel();
			return _instance;
		}
		
		public function SettingPanel()
		{
			skin = new RenderSettingSkin();
			super(skin);
			
			initPanel();
			initMinmaxBtn();
		}
		
		private function initPanel():void
		{
			skin.displayLevelStepper.minimum = 0;
			skin.displayLevelStepper.maximum = 4;
			
			skin.shadowLevelStepper.minimum = 0;
			skin.shadowLevelStepper.maximum = 5;
			
			_appInfo = new AppInfo();
			_appInfo.posType = PanelPosType.MIDDLE_CENTRAL;
			
			skin.antialiasStepper.addEventListener(Event.CHANGE, onStepperChange);
			skin.displayLevelStepper.addEventListener(Event.CHANGE, onStepperChange);
			skin.shadowLevelStepper.addEventListener(Event.CHANGE, onStepperChange);
			skin.renderQualityBar.addEventListener(Event.CHANGE, onSliderChang);
			setPanelState();
		}
		
		private function initMinmaxBtn():void
		{
			minmaxBtn = new Button();
			minmaxBtn.styleClass = ButtonSkin_setting;
			Stage3DLayerManager.starlingLayer.addChild(minmaxBtn);
			minmaxBtn.addEventListener(Event.TRIGGERED, onMinMaxBtnClick);
		}
		
		private function onMinMaxBtnClick(e:Event):void
		{
			showPanel();
		}
		
		private function showMinMaxBtn():void
		{
			minmaxBtn.visible = true;
			TweenLite.to(minmaxBtn,0.2,{alpha:1});
			hide();
			minmaxBtn.visible = true;
		}
		
		private function showPanel():void
		{
			show();
			this.scale = 1;
			TweenMax.from(this,0.2,{x:0, y:0, scale:0.1});
			TweenLite.to(minmaxBtn,0.2,{alpha:0, onComplete:function():void{minmaxBtn.visible = false}});
			setPanelState();
		}
		
		private function setPanelState():void
		{
			var sceneData : SceneData = WorldManager.instance.currentSceneData;
			if (sceneData == null) {
				return;
			}
			
			showStats = sceneData.fpsStatus.value;
			
			skin.cbx_hdr.isEnabled  = sceneData.hdr.enable;
			skin.cbx_hdr.isSelected = sceneData.hdr.value;
			
			skin.cbx_ringDepth.isEnabled  = sceneData.depthOfField.enable;
			skin.cbx_ringDepth.isSelected = sceneData.depthOfField.value;
			
			skin.cbx_screenShadow.isEnabled  = sceneData.ssShadow.enable;
			skin.cbx_screenShadow.isSelected = sceneData.ssShadow.value;
			
			enableScreenSpaceShadow = sceneData.ssShadow.value;
			
			skin.antialiasStepper.value    = sceneData.antialias.value as int;
			skin.displayLevelStepper.value = sceneData.displayLevel.value as int;
			skin.shadowLevelStepper.value  = sceneData.shadowLevel.value as int;
			skin.renderQualityBar.value    = (sceneData.quality.value as Number) * 100;
			
			skin.cbx_ssao.isEnabled  = sceneData.ssao.enable;
			skin.cbx_ssao.isSelected = sceneData.ssao.value;
		}
		
		override protected function onTouchTarget(target:DisplayObject):void
		{
			var sceneData : SceneData = WorldManager.instance.currentSceneData;
			switch(target)
			{
				case skin.btnClose:
					TweenLite.to(this, 0.2, {x:0, y:0, scale:0.1, onComplete:showMinMaxBtn});
					break;
				case skin.cbx_district:
					showStats = !showStats;
					break;
				case skin.cbx_ringDepth:
					enableFilter(RINGDEPTHOFFIELD_FILTER3D_CLASS_NAME, !filterEnabled(RINGDEPTHOFFIELD_FILTER3D_CLASS_NAME));
					WorldManager.instance.currentSceneData.depthOfField.value = skin.cbx_ringDepth.isSelected;
					if (skin.cbx_ringDepth.isSelected) {
						EventManager.dispatchEvent(EvilEvent.ENABLE_DEPTH_FIELD);
					}
					break;
				case skin.cbx_screenShadow:
					enableScreenSpaceShadow = !enableScreenSpaceShadow;
					break;
				case skin.cbx_hdr:
					enableFilter(HDR_FILTER3D_CLASS_NAME, !filterEnabled(HDR_FILTER3D_CLASS_NAME));
					WorldManager.instance.currentSceneData.hdr.value = skin.cbx_hdr.isSelected;
					break;
				case skin.cbx_ssao:
					enableFilter(SSAO_FILTER3D_CLASS_NAME, !filterEnabled(SSAO_FILTER3D_CLASS_NAME));
					WorldManager.instance.currentSceneData.ssao.value = skin.cbx_ssao.isSelected;
					break;
			}
		}
		
		private function onStepperChange(e:Event):void
		{
			switch(e.target)
			{
				case skin.antialiasStepper:
					antiAlias = int(skin.antialiasStepper.value);
					break;
				case skin.displayLevelStepper:
					displayLevel = int(skin.displayLevelStepper.value);
					break;
				case skin.shadowLevelStepper:
					shadowLevel = int(skin.shadowLevelStepper.value);
					break;
			}
		}
		
		private function onSliderChang(e:Event):void
		{
			switch(e.target)
			{
				case skin.renderQualityBar:
					renderQuality = skin.renderQualityBar.value;
					break;
			}
		}
		
		public function get antiAlias() : int
		{
			return Stage3DLayerManager.viewAntiAlias;
		}
		
		public function set antiAlias(value : int) : void
		{
			Stage3DLayerManager.viewAntiAlias = value;
			if (WorldManager.instance.currentSceneData)
				WorldManager.instance.currentSceneData.antialias.value = value;
		}
		
		public function get screenAntiAlias() : int {
			return Stage3DLayerManager.screenAntiAlias;
		}
		
		public function set screenAntiAlias(value : int) : void {
			Stage3DLayerManager.screenAntiAlias = value;
		}
		
		public function get displayLevel() : int
		{
			return Away3D.DISPLAY_LEVEL;
		}
		
		public function set displayLevel(value : int) : void
		{
			Away3D.DISPLAY_LEVEL = value;
			if (WorldManager.instance.currentSceneData)
				WorldManager.instance.currentSceneData.displayLevel.value = value;
		}
		
		public function get enableScreenSpaceShadow() : Boolean {
			return Stage3DLayerManager.getView(0).enableScreenSpaceShadow;
		}
		
		public function set enableScreenSpaceShadow(value : Boolean) : void {
			Stage3DLayerManager.getView(0).enableScreenSpaceShadow = value;
			if (WorldManager.instance.currentSceneData)
				WorldManager.instance.currentSceneData.ssShadow.value = value;
		}
		
		public function get shadowLevel() : Number
		{
			return WorldManager.instance.gameScene3D.shadowLevel;
		}
		
		public function set shadowLevel(value : Number) : void
		{
			WorldManager.instance.gameScene3D.shadowLevel = value;
			if (WorldManager.instance.currentSceneData)
				WorldManager.instance.currentSceneData.shadowLevel.value = value;
		}
				
		public function get showDistrictWireframe() : Boolean
		{
			return WorldManager.instance.gameScene3D.sceneMapLayer.showDistrictWireframe;
		}
		
		public function set showDistrictWireframe(value : Boolean) : void
		{
			WorldManager.instance.gameScene3D.sceneMapLayer.showDistrictWireframe = value;
		}
		
/*		public function get errorChecking() : Boolean
		{
			return Stage3DLayerManager.errorChecking;
		}
		
		public function set errorChecking(value : Boolean) : void
		{
			Stage3DLayerManager.errorChecking = value;
		}*/
		
		
		public function get showStats():Boolean
		{
			return _showStats;
		}
		
		public function set showStats(value:Boolean):void
		{
			_showStats = value;
			if(value)
				StatsUtil.showAwayStats(Stage3DLayerManager.stage, Stage3DLayerManager.stage3DProxy);
			else
				StatsUtil.hideAwayStats();
			if (WorldManager.instance.currentSceneData)
				WorldManager.instance.currentSceneData.fpsStatus.value = value;
		}
		
/*		public function get lightRange() : Number
		{
			var scene : GameScene3D = GameScene3DManager.getScene(MAIN_SCENE_NAME);
			return scene.lightRange;
		}
		
		public function set lightRange(value : Number) : void
		{
			var scene : GameScene3D = GameScene3DManager.getScene(MAIN_SCENE_NAME);
			scene.lightRange = value;
		}
		
		public function get lightNumSamples() : int
		{
			var scene : GameScene3D = GameScene3DManager.getScene(MAIN_SCENE_NAME);
			return scene.lightNumSamples;
		}
		
		public function set lightNumSamples(value : int) : void
		{
			var scene : GameScene3D = GameScene3DManager.getScene(MAIN_SCENE_NAME);
			scene.lightNumSamples = value;
		}
		
		public function fullScreen(... args) : void
		{
			Stage3DLayerManager.fullScreen();
		}*/
		
		
		public function enableFilter(filterName:String, value:Boolean) : void
		{
			var filterClass:Class = getDefinitionByName(filterName) as Class;
			for(var i:int = 0; i < Stage3DLayerManager.getView(0).filters3d.length; ++i)
			{
				var filter:Filter3DBase = Stage3DLayerManager.getView(0).filters3d[i];
				if(filter is filterClass)
				{
					filter.enabled = value;
				}
			}
		}
		
		public function filterEnabled(filterName:String):Boolean
		{
			var filterClass:Class = getDefinitionByName(filterName) as Class;
			for(var i:int = 0; i < Stage3DLayerManager.getView(0).filters3d.length; ++i)
			{
				var filter:Filter3DBase = Stage3DLayerManager.getView(0).filters3d[i];
				if(filter is filterClass)
				{
					return filter.enabled;
				}
			}
			return false;
		}
		
		public function hasFilter(filterName:String):Boolean
		{
			var filterClass:Class = getDefinitionByName(filterName) as Class;
			for(var i:int = 0; i < Stage3DLayerManager.getView(0).filters3d.length; ++i)
			{
				var filter:Filter3DBase = Stage3DLayerManager.getView(0).filters3d[i];
				if(filter is filterClass)
				{
					return true;
				}
			}
			return false;
		}
		
		public function set renderQuality(value:Number) : void
		{
			Stage3DLayerManager.getView(0).filter3DQuality = value / 100;
			if (WorldManager.instance.currentSceneData)
				WorldManager.instance.currentSceneData.quality.value = value / 100;
		}
		
		public function get renderQuality():Number
		{
			return Stage3DLayerManager.getView(0).filter3DQuality * 100;
		}
	}
}