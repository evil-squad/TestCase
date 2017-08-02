package org.mokylin.skin.loading
{
	import feathers.controls.text.Fontter;
	import feathers.themes.GuiThemeStyle;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.controls.StateSkin;
	import feathers.controls.UIAsset;
	import org.mokylin.skin.loading.ProgressBarSkin_1;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class ResLoadingViewSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var bgImage:feathers.controls.UIAsset;

		public var lb_desc:feathers.controls.Label;

		public var lb_progress:feathers.controls.Label;

		public var lb_tip:feathers.controls.Label;

		public var progressBar:feathers.controls.ProgressBar;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function ResLoadingViewSkin()
		{
			super();
			
			this.currentState = "normal";
			this.height = 924;
			this.width = 1643;
			this.elementsContent = [bgImage_i(),lb_progress_i(),lb_tip_i(),lb_desc_i(),progressBar_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function bgImage_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			bgImage = temp;
			temp.name = "bgImage";
			temp.height = 924;
			temp.styleName = "ui/loading/di.jpg";
			temp.width = 1643;
			temp.x = 0;
			temp.y = 0;
			return temp;
		}

		private function lb_desc_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_desc = temp;
			temp.name = "lb_desc";
			temp.height = 24;
			temp.text = "抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。";
			temp.textAlign = "center";
			temp.color = 0x4A4744;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 850;
			temp.x = 396.5;
			temp.y = 877;
			return temp;
		}

		private function lb_progress_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_progress = temp;
			temp.name = "lb_progress";
			temp.bold = true;
			temp.height = 22;
			temp.text = "总进度：50%";
			temp.color = 0x76726D;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 110;
			temp.x = 766;
			temp.y = 840;
			return temp;
		}

		private function lb_tip_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_tip = temp;
			temp.name = "lb_tip";
			temp.bold = true;
			temp.height = 24;
			temp.text = "首次加载将会需要较多时间，请耐心等待";
			temp.textAlign = "center";
			temp.color = 0x5D7DC5;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.width = 260;
			temp.x = 691.5;
			temp.y = 781;
			return temp;
		}

		private function progressBar_i():feathers.controls.ProgressBar
		{
			var temp:feathers.controls.ProgressBar = new feathers.controls.ProgressBar();
			progressBar = temp;
			temp.name = "progressBar";
			temp.progressMode = "mask";
			GuiThemeStyle.setFeatherSkinClass(temp,org.mokylin.skin.loading.ProgressBarSkin_1);
			temp.value = 50;
			temp.width = 638;
			temp.x = 502;
			temp.y = 817;
			return temp;
		}

	}
}