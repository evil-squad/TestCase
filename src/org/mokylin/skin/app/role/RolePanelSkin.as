package org.mokylin.skin.app.role
{
	import feathers.controls.Button;
	import feathers.controls.SkinnableContainer;
	import feathers.controls.StateSkin;
	import feathers.controls.UIAsset;
	import org.mokylin.skin.app.role.RoleViewSkin;
	import org.mokylin.skin.component.button.ButtonV3_g_guanbi;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class RolePanelSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var bg:feathers.controls.UIAsset;

		public var btnClose:feathers.controls.Button;

		public var head_bg:feathers.controls.UIAsset;

		public var roleView:feathers.controls.SkinnableContainer;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function RolePanelSkin()
		{
			super();
			
			this.currentState = "normal";
			this.height = 575;
			this.width = 635;
			this.elementsContent = [bg_i(),head_bg_i(),btnClose_i(),roleView_i(),__RolePanelSkin_UIAsset1_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __RolePanelSkin_UIAsset1_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.touchable = false;
			temp.touchGroup = false;
			temp.styleName = "ui/app/role/title.png";
			temp.x = 294;
			temp.y = 8;
			return temp;
		}

		private function bg_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			bg = temp;
			temp.name = "bg";
			temp.height = 575;
			temp.styleName = "ui/common/background/di_ban.png";
			temp.width = 635;
			temp.x = 0;
			temp.y = 0;
			return temp;
		}

		private function btnClose_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnClose = temp;
			temp.name = "btnClose";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_g_guanbi;
			temp.x = 609;
			temp.y = -1;
			return temp;
		}

		private function head_bg_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			head_bg = temp;
			temp.name = "head_bg";
			temp.touchGroup = false;
			temp.touchable = false;
			temp.styleName = "ui/common/version_3/T_tongyongbanzi/gao_guang.png";
			temp.width = 581;
			temp.x = 30;
			temp.y = 9;
			return temp;
		}

		private function roleView_i():feathers.controls.SkinnableContainer
		{
			var temp:feathers.controls.SkinnableContainer = new feathers.controls.SkinnableContainer();
			roleView = temp;
			temp.name = "roleView";
			temp.height = 523;
			var skin:StateSkin = new org.mokylin.skin.app.role.RoleViewSkin()
			temp.skin = skin
			temp.width = 618;
			temp.x = 8;
			temp.y = 38;
			return temp;
		}

	}
}