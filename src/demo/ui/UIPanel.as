package demo.ui {

	import flash.display.Stage;
	
	import away3d.events.Event;
	
	import starling.core.Starling;
	import starling.display.Stage;

	public class UIPanel {
		
		private static var _instance : UIPanel;
		
		public var skillBar : SkillBar;
		public var funBar 	: FunctionBar;
		
		private var _stage 		  : starling.display.Stage;
		private var _nativeStage  : flash.display.Stage = null;
		
		/**
		 * single ton 
		 * @return 
		 * 
		 */		
		public static function get instance() : UIPanel {
			if (!_instance) {
				_instance = new UIPanel();
			}
			return _instance;
		}

		public function init(stage : starling.display.Stage) : void {
			_stage = stage;
			
			skillBar ||= new SkillBar();
			funBar ||= new FunctionBar();
			
			//funBar.optimizeLayerBatch = false;
			_stage.addChild(funBar);
			_stage.addChild(skillBar);

			_nativeStage = Starling.current.nativeStage;
			_nativeStage.addEventListener(Event.RESIZE, onStageResize);
		}

		private function onStageResize(e : Object) : void {
			_nativeStage.addEventListener(Event.ENTER_FRAME, __onResize);
		}
		
		private function __onResize(e : Object) : void {
			if (_nativeStage.stageWidth == _stage.stageWidth && _nativeStage.stageHeight == _stage.stageHeight) {
				_nativeStage.removeEventListener(Event.ENTER_FRAME, __onResize);
				skillBar.updatePos();
			}
		}
		
		public function show() : void {
			funBar.visible = true;
			skillBar.visible = true;
			skillBar.updatePos();
		}
		
		public function hide() : void {
			skillBar.clear();
			funBar.visible = false;
			skillBar.visible = false;
		}
	}
}