package org.mokylin.skin.component.text
{
	import feathers.controls.text.Fontter;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.StateSkin;
	import feathers.controls.UIAsset;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class TextInputV3_4Skin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var bg:feathers.controls.UIAsset;

		public var textDisplay:feathers.controls.text.TextFieldTextEditor;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function TextInputV3_4Skin()
		{
			super();
			
			this.currentState = "focused";
			this.height = 20;
			this.width = 60;
			this.elementsContent = [textDisplay_i()];
			bg_i();
			
			
			states = {
				normal:[
						{target:"textDisplay",
							name:"height",
							value:22
						}
					]
			};
			skinNames={"disabled":"ui/common/kang/shu_ru_kuang_1.png", "enabled":"ui/common/kang/shu_ru_kuang_1.png", "focused":"ui/common/kang/shu_ru_kuang_1.png"};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function bg_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			bg = temp;
			temp.name = "bg";
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.styleName = "ui/common/kang/shu_ru_kuang_1.png";
			temp.top = 0;
			return temp;
		}

		private function textDisplay_i():feathers.controls.text.TextFieldTextEditor
		{
			var temp:feathers.controls.text.TextFieldTextEditor = new feathers.controls.text.TextFieldTextEditor();
			textDisplay = temp;
			temp.name = "textDisplay";
			temp.bottom = 0;
			temp.left = 2;
			temp.right = 2;
			temp.text = "请输入";
			temp.textAlign = "left";
			temp.color = 0xBC9226;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.top = 0;
			return temp;
		}

	}
}