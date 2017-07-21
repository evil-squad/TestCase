package demo.ui {

	import demo.ui.pack.PackagePanel;
	import demo.ui.role.RolePanel;
	
	import org.mokylin.skin.mainui.shortcut.toolbar.SimpleToolBarSkin;
	
	import starling.display.DisplayObject;

	public class FunctionBar extends SkinUI {
		
		private var skin:SimpleToolBarSkin;
		private var packUI : PackagePanel;
		private var roleUI : RolePanel;
		
		public function FunctionBar() 
		{
			skin = new SimpleToolBarSkin();
			super(skin);
		}
		
		override protected function onTouchTarget(target : DisplayObject) : void {
			switch (target) {
				case skin.btnBackpack:
					if (packUI == null)
						packUI = new PackagePanel();
					packUI.stage != null ? packUI.hide() : packUI.show();
					break;
				case skin.btnRole:
					if (roleUI == null)
						roleUI = new RolePanel();
					roleUI.stage != null ? roleUI.hide() : roleUI.show();
					break;
			}
		}
		
		override protected function onStageResize(sw:int, sh:int):void
		{
			this.x = sw - this.width
			this.y = sh - this.height;
		}
	}
}
