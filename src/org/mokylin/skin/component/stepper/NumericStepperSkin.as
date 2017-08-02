package org.mokylin.skin.component.stepper
{
	import feathers.controls.text.Fontter;
	import feathers.controls.Button;
	import feathers.controls.StateSkin;
	import feathers.controls.TextInput;
	import org.mokylin.skin.component.button.ButtonSkin_jia_btn;
	import org.mokylin.skin.component.button.ButtonSkin_jian_btn;
	import org.mokylin.skin.component.text.TextInputV3_4Skin;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class NumericStepperSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var decrementButton:feathers.controls.Button;

		public var incrementButton:feathers.controls.Button;

		public var textDisplay:feathers.controls.TextInput;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function NumericStepperSkin()
		{
			super();
			
			this.currentState = "normal";
			this.height = 18;
			this.elementsContent = [decrementButton_i(),incrementButton_i(),textDisplay_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function decrementButton_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			decrementButton = temp;
			temp.name = "decrementButton";
			temp.bottom = 1;
			temp.left = 0;
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_jian_btn;
			temp.top = 1;
			return temp;
		}

		private function incrementButton_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			incrementButton = temp;
			temp.name = "incrementButton";
			temp.bottom = 1;
			temp.right = 0;
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_jia_btn;
			temp.top = 1;
			return temp;
		}

		private function textDisplay_i():feathers.controls.TextInput
		{
			var temp:feathers.controls.TextInput = new feathers.controls.TextInput();
			textDisplay = temp;
			temp.name = "textDisplay";
			temp.bottom = 0;
			temp.left = 15;
			temp.right = 15;
			temp.styleClass = org.mokylin.skin.component.text.TextInputV3_4Skin;
			temp.text = "1/1";
			temp.textAlign = "center";
			temp.color = 0xE9C099;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.top = 0;
			return temp;
		}

	}
}