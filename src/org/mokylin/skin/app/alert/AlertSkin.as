package org.mokylin.skin.app.alert
{
	import feathers.controls.text.Fontter;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.StateSkin;
	import feathers.controls.UIAsset;
	import org.mokylin.skin.component.button.ButtonSkin_btn_normal;
	import org.mokylin.skin.component.button.ButtonSkin_close;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class AlertSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var btnCancel:feathers.controls.Button;

		public var btnClose:feathers.controls.Button;

		public var btnOk:feathers.controls.Button;

		public var lbTip:feathers.controls.Label;

		public var title:feathers.controls.Label;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function AlertSkin()
		{
			super();
			
			this.currentState = "normal";
			this.elementsContent = [__AlertSkin_UIAsset1_i(),lbTip_i(),btnClose_i(),title_i(),btnOk_i(),btnCancel_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __AlertSkin_UIAsset1_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/background/di1.png";
			temp.x = 0;
			temp.y = 0;
			return temp;
		}

		private function btnCancel_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnCancel = temp;
			temp.name = "btnCancel";
			temp.height = 25;
			temp.label = "取消";
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_btn_normal;
			temp.width = 69;
			temp.x = 203;
			temp.y = 183;
			return temp;
		}

		private function btnClose_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnClose = temp;
			temp.name = "btnClose";
			temp.height = 23;
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_close;
			temp.width = 23;
			temp.x = 312;
			temp.y = 6;
			return temp;
		}

		private function btnOk_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnOk = temp;
			temp.name = "btnOk";
			temp.height = 25;
			temp.label = "确定";
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_btn_normal;
			temp.width = 69;
			temp.x = 76;
			temp.y = 183;
			return temp;
		}

		private function lbTip_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lbTip = temp;
			temp.name = "lbTip";
			temp.height = 101;
			temp.maxWidth = 317;
			temp.text = "说明";
			temp.textAlign = "center";
			temp.color = 0x4EFD6F;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 317;
			temp.x = 14;
			temp.y = 64;
			return temp;
		}

		private function title_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			title = temp;
			temp.name = "title";
			temp.height = 25;
			temp.fontSize = 16;
			temp.text = "提示";
			temp.textAlign = "center";
			temp.color = 0xC4A689;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.width = 212;
			temp.x = 67;
			temp.y = 8;
			return temp;
		}

	}
}