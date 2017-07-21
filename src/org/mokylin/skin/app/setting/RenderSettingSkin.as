package org.mokylin.skin.app.setting
{
	import feathers.controls.text.Fontter;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Slider;
	import feathers.controls.Label;
	import feathers.controls.NumericStepper;
	import feathers.controls.StateSkin;
	import feathers.controls.UIAsset;
	import org.mokylin.skin.component.button.ButtonSkin_close;
	import org.mokylin.skin.component.checkbox.CheckBoxSkin_1;
	import org.mokylin.skin.component.slider.HSliderChatSkin;
	import org.mokylin.skin.component.stepper.NumericStepperSkin;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class RenderSettingSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var antialiasStepper:feathers.controls.NumericStepper;

		public var btnClose:feathers.controls.Button;

		public var cbx_district:feathers.controls.Check;

		public var cbx_hdr:feathers.controls.Check;

		public var cbx_ringDepth:feathers.controls.Check;

		public var cbx_screenShadow:feathers.controls.Check;

		public var cbx_ssao:feathers.controls.Check;

		public var displayLevelStepper:feathers.controls.NumericStepper;

		public var renderQualityBar:feathers.controls.Slider;

		public var shadowLevelStepper:feathers.controls.NumericStepper;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function RenderSettingSkin()
		{
			super();
			
			this.currentState = "normal";
			this.height = 365;
			this.width = 373;
			this.elementsContent = [__RenderSettingSkin_UIAsset1_i(),antialiasStepper_i(),btnClose_i(),cbx_district_i(),cbx_ringDepth_i(),cbx_hdr_i(),__RenderSettingSkin_Label1_i(),__RenderSettingSkin_UIAsset2_i(),__RenderSettingSkin_UIAsset3_i(),cbx_screenShadow_i(),__RenderSettingSkin_Label2_i(),renderQualityBar_i(),__RenderSettingSkin_Label3_i(),__RenderSettingSkin_Label4_i(),__RenderSettingSkin_Label5_i(),displayLevelStepper_i(),shadowLevelStepper_i(),cbx_ssao_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __RenderSettingSkin_Label1_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.fontSize = 20;
			temp.text = "显示设置";
			temp.color = 0xFABA5B;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.x = 144;
			temp.y = 28;
			return temp;
		}

		private function __RenderSettingSkin_Label2_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.text = "抗锯齿";
			temp.color = 0xEDCFA8;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.width = 100;
			temp.x = 34;
			temp.y = 181;
			return temp;
		}

		private function __RenderSettingSkin_Label3_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.height = 24;
			temp.text = "阴影品质";
			temp.color = 0xEDCFA8;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.width = 100;
			temp.x = 32;
			temp.y = 270;
			return temp;
		}

		private function __RenderSettingSkin_Label4_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.height = 24;
			temp.text = "画面质量";
			temp.color = 0xEDCFA8;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.width = 100;
			temp.x = 32;
			temp.y = 315;
			return temp;
		}

		private function __RenderSettingSkin_Label5_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.height = 24;
			temp.text = "显示等级";
			temp.color = 0xEDCFA8;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.width = 100;
			temp.x = 34;
			temp.y = 227;
			return temp;
		}

		private function __RenderSettingSkin_UIAsset1_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 365;
			temp.styleName = "ui/common/background/di1.png";
			temp.width = 373;
			temp.x = 0;
			temp.y = 0;
			return temp;
		}

		private function __RenderSettingSkin_UIAsset2_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 5;
			temp.styleName = "ui/common/background/title_line.png";
			temp.x = 16;
			temp.y = 74;
			return temp;
		}

		private function __RenderSettingSkin_UIAsset3_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 5;
			temp.styleName = "ui/common/background/title_line.png";
			temp.width = 341;
			temp.x = 16;
			temp.y = 74;
			return temp;
		}

		private function antialiasStepper_i():feathers.controls.NumericStepper
		{
			var temp:feathers.controls.NumericStepper = new feathers.controls.NumericStepper();
			antialiasStepper = temp;
			temp.name = "antialiasStepper";
			temp.height = 18;
			temp.maximum = 4;
			temp.minimum = 0;
			temp.styleClass = org.mokylin.skin.component.stepper.NumericStepperSkin;
			temp.value = 3;
			temp.width = 109;
			temp.x = 142;
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
			temp.x = 340;
			temp.y = 11;
			return temp;
		}

		private function cbx_district_i():feathers.controls.Check
		{
			var temp:feathers.controls.Check = new feathers.controls.Check();
			cbx_district = temp;
			temp.name = "cbx_district";
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.height = 22;
			temp.label = "性能统计";
			temp.styleClass = org.mokylin.skin.component.checkbox.CheckBoxSkin_1;
			temp.textAlign = "left";
			temp.color = 0xC6B595;
			temp.width = 83;
			temp.x = 29;
			temp.y = 107;
			return temp;
		}

		private function cbx_hdr_i():feathers.controls.Check
		{
			var temp:feathers.controls.Check = new feathers.controls.Check();
			cbx_hdr = temp;
			temp.name = "cbx_hdr";
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.height = 22;
			temp.label = "HDR";
			temp.styleClass = org.mokylin.skin.component.checkbox.CheckBoxSkin_1;
			temp.textAlign = "left";
			temp.color = 0xC6B595;
			temp.width = 69;
			temp.x = 290;
			temp.y = 107;
			return temp;
		}

		private function cbx_ringDepth_i():feathers.controls.Check
		{
			var temp:feathers.controls.Check = new feathers.controls.Check();
			cbx_ringDepth = temp;
			temp.name = "cbx_ringDepth";
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.height = 22;
			temp.label = "景深";
			temp.styleClass = org.mokylin.skin.component.checkbox.CheckBoxSkin_1;
			temp.textAlign = "left";
			temp.color = 0xC6B595;
			temp.width = 65;
			temp.x = 215;
			temp.y = 107;
			return temp;
		}

		private function cbx_screenShadow_i():feathers.controls.Check
		{
			var temp:feathers.controls.Check = new feathers.controls.Check();
			cbx_screenShadow = temp;
			temp.name = "cbx_screenShadow";
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.height = 22;
			temp.label = "屏幕阴影";
			temp.styleClass = org.mokylin.skin.component.checkbox.CheckBoxSkin_1;
			temp.textAlign = "left";
			temp.color = 0xC6B595;
			temp.width = 83;
			temp.x = 121;
			temp.y = 107;
			return temp;
		}

		private function cbx_ssao_i():feathers.controls.Check
		{
			var temp:feathers.controls.Check = new feathers.controls.Check();
			cbx_ssao = temp;
			temp.name = "cbx_ssao";
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.height = 22;
			temp.label = "SSAO";
			temp.styleClass = org.mokylin.skin.component.checkbox.CheckBoxSkin_1;
			temp.textAlign = "left";
			temp.color = 0xC6B595;
			temp.width = 69;
			temp.x = 29;
			temp.y = 142;
			return temp;
		}

		private function displayLevelStepper_i():feathers.controls.NumericStepper
		{
			var temp:feathers.controls.NumericStepper = new feathers.controls.NumericStepper();
			displayLevelStepper = temp;
			temp.name = "displayLevelStepper";
			temp.height = 18;
			temp.maximum = 4;
			temp.minimum = 0;
			temp.styleClass = org.mokylin.skin.component.stepper.NumericStepperSkin;
			temp.value = 5;
			temp.width = 109;
			temp.x = 142;
			temp.y = 229;
			return temp;
		}

		private function renderQualityBar_i():feathers.controls.Slider
		{
			var temp:feathers.controls.Slider = new feathers.controls.Slider();
			renderQualityBar = temp;
			temp.name = "renderQualityBar";
			temp.height = 10;
			temp.maximum = 100;
			temp.minimum = 70;
			temp.direction = Slider.DIRECTION_HORIZONTAL
			temp.styleClass = org.mokylin.skin.component.slider.HSliderChatSkin;
			temp.value = 100;
			temp.width = 195;
			temp.x = 142;
			temp.y = 322;
			return temp;
		}

		private function shadowLevelStepper_i():feathers.controls.NumericStepper
		{
			var temp:feathers.controls.NumericStepper = new feathers.controls.NumericStepper();
			shadowLevelStepper = temp;
			temp.name = "shadowLevelStepper";
			temp.height = 18;
			temp.maximum = 5;
			temp.minimum = 0;
			temp.styleClass = org.mokylin.skin.component.stepper.NumericStepperSkin;
			temp.value = 5;
			temp.width = 109;
			temp.x = 142;
			temp.y = 271;
			return temp;
		}

	}
}