package demo.ui
{
	import feathers.controls.GradientLabel;
	

	/**
	 *提示信息面板 
	 * @author wewell@163.com
	 * 
	 */	
	public class GameInfoPanel extends SkinUI {
		
		private var _lb:GradientLabel;
		
		public function GameInfoPanel(tip : String) {
			super(null);
			this.initInfo(tip);
		}
		
		private function initInfo(tip : String):void {
			_lb =  new GradientLabel();
			_lb.maxWidth = 150;
			_lb.colors = [0xFFFFFF, 0x00FFFF];
			_lb.text = tip;
			_lb.fontSize = 18;
			this.addChild(_lb);
		}
		
		override protected function onStageResize(sw : int, sh : int) : void {
			this.x = sw - 150;
			this.y = 10;
		}
	}
}