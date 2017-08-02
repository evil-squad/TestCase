package demo.ui.pack
{
	import demo.ui.SkinUIPanel;
	
	import org.mokylin.skin.app.backpack.BackpackPanelSkin;

	public class PackagePanel extends SkinUIPanel
	{
		public function PackagePanel()
		{
			super(new BackpackPanelSkin())
		}
	}
}