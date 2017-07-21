package org.mokylin.skin.mainui.shortcut.toolbar
{
	import feathers.controls.Button;
	import feathers.controls.StateSkin;
	import org.mokylin.skin.mainui.shortcut.button.ButtonBeibao;
	import org.mokylin.skin.mainui.shortcut.button.ButtonJuese;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class SimpleToolBarSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var btnBackpack:feathers.controls.Button;

		public var btnRole:feathers.controls.Button;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function SimpleToolBarSkin()
		{
			super();
			
			this.currentState = "normal";
			this.height = 44;
			this.width = 94;
			this.elementsContent = [btnRole_i(),btnBackpack_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function btnBackpack_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnBackpack = temp;
			temp.name = "btnBackpack";
			temp.height = 44;
			temp.styleClass = org.mokylin.skin.mainui.shortcut.button.ButtonBeibao;
			temp.width = 44;
			temp.x = 50;
			return temp;
		}

		private function btnRole_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnRole = temp;
			temp.name = "btnRole";
			temp.height = 44;
			temp.styleClass = org.mokylin.skin.mainui.shortcut.button.ButtonJuese;
			temp.width = 47;
			return temp;
		}

	}
}