package demo.loader {
	
	import com.game.engine3D.events.MapLoadEvent;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import away3d.events.Event;
	
	import demo.path.ConfigPath;
	
	import feathers.themes.ThemeBatchLoader;
	
	import gs.TweenLite;
	
	import org.client.mainCore.manager.EventManager;
	import org.mokylin.skin.loading.ResLoadingViewSkin;
	
	import starling.core.Starling;
	import starling.display.Canvas;
	import starling.display.Sprite;

	/**
	 *  loading...
	 * @author wewell
	 * 
	 */	
	public class DemoLoader extends Sprite {
		private var _currentProgress:int;
		private var skin:ResLoadingViewSkin;
		private var bgMask:Canvas;
		private var preLoader:PreLoader;
		private var onbgLoadedCallback : Function;
		private var _loadingBgName:String;
		
		public function DemoLoader() {
		}
		
		//=====================================pre load================================
		//
		private function init():void
		{
			if(!bgMask)
				bgMask = new Canvas();
			
			bgMask.beginFill(0,1);
			bgMask.drawRectangle(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			bgMask.endFill();
			Stage3DLayerManager.starlingLayer.addChildAt(bgMask, 0);
			onStageResize();
			
			showPreLoader();
			loadUI();
			
			this.addEventListener(away3d.events.Event.RESIZE,onStageResize);
		}
		
		private function showPreLoader():void
		{
			if(preLoader == null)
				preLoader = new PreLoader();
			preLoader.show();
		}
		
		
		//=====================================load ui================================
		//
		/**
		 * setup defatul starling ui skin assets. code by wewell
		 * 
		 */
		private function loadUI():void
		{
			var themeBatchLoader:ThemeBatchLoader = new ThemeBatchLoader();
			
			/**ConfigPath.APP_SETTING_UI资源包含有游戏进度条贴图**/
			var paths:Array = [ConfigPath.APP_SETTING_UI];
			
			/**如果需要战斗飘字或显示角色背包等界面则额外加载以下资源**/
//			paths = [ConfigPath.NUMUI, ConfigPath.STARLING_TEXTURE, ConfigPath.APP_SETTING_UI];
			
			themeBatchLoader.loadBatch(paths, onUILoad, onUILoadProgress);
		}
		
		
		private function onUILoadProgress(value:Number):void
		{
			preLoader.percent = value;
		}
		
		private function onUILoad():void
		{
			showWorldLoader();
		}
		
		//=====================================load world================================
		//
		private function showWorldLoader():void
		{
			skin = new ResLoadingViewSkin();
			skin.progressBar.value = 0;
			skin.lb_progress.width = 500;
			skin.lb_progress.text = "";
			
			skin.toSprite(this);
			skin.bgImage.styleName = "ui/loading/"+ (_loadingBgName || "di.jpg");
			skin.bgImage.addEventListener(Event.COMPLETE, onBgLoad);
			
			Stage3DLayerManager.starlingLayer.addChild(this);
			onStageResize();
		}
		
		private function onBgLoad(e:Event):void
		{
			preLoader.hide();
			skin.bgImage.removeEventListener(Event.COMPLETE, onBgLoad);
			
			loadWorld();
		}
		
		private function loadWorld():void {
			
			if (onbgLoadedCallback != null) {
				onbgLoadedCallback();
			}
			
			EventManager.addEvent(MapLoadEvent.MAP_LOAD_PROGRESS,  onWorldLoadProgress);
			EventManager.addEvent(MapLoadEvent.MAP_PARSE_PROGRESS, onWorldParseProgress);
			EventManager.addEvent(MapLoadEvent.MAP_LOAD_COMPLETE, onWorldLoad);
		}
		
		private function onWorldLoadProgress(value : Number) : void {
			var v:int = int( value * 100 );
			skin.progressBar.value = v;
			skin.lb_progress.text = "正在加载场景：" + v + "%";
		}
		
		private function onWorldParseProgress(value : Number):void
		{
			var v:int = int( value * 100 );
			skin.progressBar.value = v;
			skin.lb_progress.text = "正在解析场景：" + v + "%";
		}
		
		private function onWorldLoad():void
		{
			//			setTimeout(function():void{
			//				new SettingGUIHelper(stage);
			//				new ChangeSceneTester();
			//				new AddParticleTester();
			//				new AddMonsterTester();
			//			}, 3000);
			
			destroy();
		}
		
		
		private function onStageResize(e:away3d.events.Event=null) : void {
			this.x = Starling.current.stage.stageWidth/2 - this.width/2;
			this.y = Starling.current.stage.stageHeight/2 - this.height/2;
			
			bgMask.beginFill(0,1);
			bgMask.drawRectangle(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			bgMask.endFill();
		}
		
		public function showErrorStr(str : String) : void {
			skin.lb_progress.htmlText = str
		}
		
		public function start(loadingBgName:String = null, bgLoadedCallback : Function = null):void
		{
			_loadingBgName = loadingBgName;
			onbgLoadedCallback = bgLoadedCallback;
			init();
		}
		
		public function destroy() : void {
			if(bgMask)
			{
				bgMask.clear();
				bgMask.removeFromParent(true);
				bgMask = null;
			}
			
			if(preLoader)
			{
				preLoader.destroy();
				preLoader = null;
			}
			
			EventManager.removeEvent(MapLoadEvent.MAP_LOAD_PROGRESS,  onWorldLoadProgress);
			EventManager.removeEvent(MapLoadEvent.MAP_PARSE_PROGRESS, onWorldParseProgress);
			EventManager.removeEvent(MapLoadEvent.MAP_LOAD_COMPLETE, onWorldLoad);
			
			TweenLite.killTweensOf(skin.progressBar);
			
			skin = null;
			this.removeFromParent(true);
		}
	}
}
