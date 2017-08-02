package demo.helper
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.system.Capabilities;
	
	import demo.ui.GameAlert;
	import demo.ui.SettingPanel;
	
	import gs.TweenLite;

	/**
	 * 运行环境提示
	 * @author wewell@163.com
	 * 
	 */	
	public class DriverCheckHelper
	{
		public function DriverCheckHelper()
		{
		}
		
		public function check():void
		{
			tryShowDebugInfo();
		}
	
		private function tryShowDebugInfo() : void
		{
			var isShow : Boolean = tryShowDebugPlayerInfo();
			if (!isShow)
			{
				tryShowDriverInfo();
			}
		}
		
		private function tryShowDebugPlayerInfo() : Boolean
		{
			if (Capabilities.isDebugger)
			{
				GameAlert.show("您当前的播放器是Debug版本，所有表现和数据不能用作性能参考！", "提示", onShowDebugPlayerFunc, onShowDebugPlayerFunc);
				return true;
			}
			return false;
		}
		
		private function tryShowDriverInfo() : void
		{
			if (Capabilities.os.indexOf("Windows") == 0 && Stage3DLayerManager.driverInfo.indexOf("OpenGL") == 0)
			{
				GameAlert.show("您当前正在使用windows操作系统的OpenGL驱动，环境性能不佳，请切换到兼容模式！", "提示", showSetting, showSetting);
			}else
			{
				showSetting();
			}
		}
		
		private function onShowDebugPlayerFunc() : void
		{
			TweenLite.delayedCall(0.2, tryShowDriverInfo);
		}
		
		private function showSetting():void
		{
			//弹出设置
			TweenLite.delayedCall(0.2, SettingPanel.instance.show);
		}
	}
}