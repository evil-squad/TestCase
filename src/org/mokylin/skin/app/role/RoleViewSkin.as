package org.mokylin.skin.app.role
{
	import feathers.controls.text.Fontter;
	import feathers.data.ListCollection;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.SkinnableContainer;
	import feathers.controls.StateSkin;
	import feathers.controls.TabBar;
	import feathers.controls.UIAsset;
	import feathers.controls.UINumber;
	import feathers.layout.HorizontalLayout;
	import org.mokylin.skin.app.role.RolePropertyPanelSkin;
	import org.mokylin.skin.component.button.ButtonSkin_mount_btn_zd_left;
	import org.mokylin.skin.component.button.ButtonSkin_mount_btn_zd_right;
	import org.mokylin.skin.component.tabbar.TabBarSkin_mount_fenye_heng;
	import org.mokylin.skin.component.uinumber.UINumberSkin_power;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class RoleViewSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var grid0:feathers.controls.UIAsset;

		public var grid1:feathers.controls.UIAsset;

		public var grid10:feathers.controls.UIAsset;

		public var grid11:feathers.controls.UIAsset;

		public var grid2:feathers.controls.UIAsset;

		public var grid3:feathers.controls.UIAsset;

		public var grid4:feathers.controls.UIAsset;

		public var grid5:feathers.controls.UIAsset;

		public var grid6:feathers.controls.UIAsset;

		public var grid7:feathers.controls.UIAsset;

		public var grid8:feathers.controls.UIAsset;

		public var grid9:feathers.controls.UIAsset;

		public var icon_ping:feathers.controls.UIAsset;

		public var lb_country:feathers.controls.Label;

		public var lb_junxian:feathers.controls.Label;

		public var lb_name:feathers.controls.Label;

		public var lb_name0:feathers.controls.Label;

		public var numberPower:feathers.controls.UINumber;

		public var propertyContainer:feathers.controls.SkinnableContainer;

		public var tabBar_pro:feathers.controls.TabBar;

		public var zd_left:feathers.controls.Button;

		public var zd_right:feathers.controls.Button;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function RoleViewSkin()
		{
			super();
			
			this.currentState = "normal";
			this.elementsContent = [__RoleViewSkin_UIAsset1_i(),tabBar_pro_i(),lb_name_i(),lb_name0_i(),lb_country_i(),lb_junxian_i(),grid0_i(),grid1_i(),grid7_i(),grid4_i(),grid3_i(),grid9_i(),grid10_i(),grid11_i(),grid5_i(),grid8_i(),grid2_i(),icon_ping_i(),grid6_i(),numberPower_i(),__RoleViewSkin_UIAsset2_i(),zd_left_i(),zd_right_i(),propertyContainer_i(),__RoleViewSkin_UIAsset3_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __RoleViewSkin_ArrayCollection1_i():feathers.data.ListCollection
		{
			var temp:feathers.data.ListCollection = new feathers.data.ListCollection();
			temp.data = ['基础属性','详细属性'];
			return temp;
		}

		private function __RoleViewSkin_HorizontalLayout1_i():feathers.layout.HorizontalLayout
		{
			var temp:feathers.layout.HorizontalLayout = new feathers.layout.HorizontalLayout();
			temp.gap = 0;
			return temp;
		}

		private function __RoleViewSkin_HorizontalLayout2_i():feathers.layout.HorizontalLayout
		{
			var temp:feathers.layout.HorizontalLayout = new feathers.layout.HorizontalLayout();
			temp.gap = -10;
			return temp;
		}

		private function __RoleViewSkin_UIAsset1_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/app/role/rwmbdt.jpg";
			temp.x = 0;
			temp.y = 0;
			return temp;
		}

		private function __RoleViewSkin_UIAsset2_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/icon/zl.png";
			temp.x = 83;
			temp.y = 475;
			return temp;
		}

		private function __RoleViewSkin_UIAsset3_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/icon/xing.png";
			temp.x = 322;
			temp.y = 47;
			return temp;
		}

		private function grid0_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid0 = temp;
			temp.name = "grid0";
			temp.styleName = "ui/app/role/shi_zhuang.png";
			temp.x = 15;
			temp.y = 82;
			return temp;
		}

		private function grid10_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid10 = temp;
			temp.name = "grid10";
			temp.styleName = "ui/app/role/shou_wan.png";
			temp.x = 319;
			temp.y = 326;
			return temp;
		}

		private function grid11_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid11 = temp;
			temp.name = "grid11";
			temp.styleName = "ui/app/role/xie_zi.png";
			temp.x = 319;
			temp.y = 387;
			return temp;
		}

		private function grid1_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid1 = temp;
			temp.name = "grid1";
			temp.styleName = "ui/app/role/xiang_liang.png";
			temp.x = 15;
			temp.y = 142;
			return temp;
		}

		private function grid2_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid2 = temp;
			temp.name = "grid2";
			temp.styleName = "ui/app/role/wu_qi.png";
			temp.x = 15;
			temp.y = 203;
			return temp;
		}

		private function grid3_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid3 = temp;
			temp.name = "grid3";
			temp.styleName = "ui/app/role/fu_shou.png";
			temp.x = 15;
			temp.y = 264;
			return temp;
		}

		private function grid4_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid4 = temp;
			temp.name = "grid4";
			temp.styleName = "ui/app/role/jie_zhi.png";
			temp.x = 15;
			temp.y = 325;
			return temp;
		}

		private function grid5_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid5 = temp;
			temp.name = "grid5";
			temp.styleName = "ui/app/role/jie_zhi.png";
			temp.x = 15;
			temp.y = 385;
			return temp;
		}

		private function grid6_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid6 = temp;
			temp.name = "grid6";
			temp.styleName = "ui/app/role/tou_kui.png";
			temp.x = 319;
			temp.y = 82;
			return temp;
		}

		private function grid7_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid7 = temp;
			temp.name = "grid7";
			temp.styleName = "ui/app/role/yi_fu.png";
			temp.x = 319;
			temp.y = 142;
			return temp;
		}

		private function grid8_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid8 = temp;
			temp.name = "grid8";
			temp.styleName = "ui/app/role/yao_dai.png";
			temp.x = 319;
			temp.y = 203;
			return temp;
		}

		private function grid9_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			grid9 = temp;
			temp.name = "grid9";
			temp.styleName = "ui/app/role/shou_wan.png";
			temp.x = 319;
			temp.y = 265;
			return temp;
		}

		private function icon_ping_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			icon_ping = temp;
			temp.name = "icon_ping";
			temp.styleName = "ui/common/icon/pingzi/cheng.png";
			temp.x = 344;
			temp.y = 44;
			return temp;
		}

		private function lb_country_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_country = temp;
			temp.name = "lb_country";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "无";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 80;
			temp.x = 300;
			temp.y = 17;
			return temp;
		}

		private function lb_junxian_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_junxian = temp;
			temp.name = "lb_junxian";
			temp.leading = 0;
			temp.fontSize = 14;
			temp.text = "无";
			temp.textAlign = "center";
			temp.color = 0x0066FF;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 152;
			temp.x = 121;
			temp.y = 48;
			return temp;
		}

		private function lb_name0_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_name0 = temp;
			temp.name = "lb_name0";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "国家：";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.x = 257;
			temp.y = 17;
			return temp;
		}

		private function lb_name_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_name = temp;
			temp.name = "lb_name";
			temp.fontSize = 18;
			temp.text = "125级";
			temp.textAlign = "left";
			temp.color = 0xDB9736;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 196;
			temp.x = 48;
			temp.y = 14;
			return temp;
		}

		private function numberPower_i():feathers.controls.UINumber
		{
			var temp:feathers.controls.UINumber = new feathers.controls.UINumber();
			numberPower = temp;
			temp.name = "numberPower";
			temp.height = 41;
			temp.label = "176689";
			temp.styleClass = org.mokylin.skin.component.uinumber.UINumberSkin_power;
			temp.width = 135;
			temp.x = 165;
			temp.y = 477;
			temp.layout = __RoleViewSkin_HorizontalLayout2_i();
			return temp;
		}

		private function propertyContainer_i():feathers.controls.SkinnableContainer
		{
			var temp:feathers.controls.SkinnableContainer = new feathers.controls.SkinnableContainer();
			propertyContainer = temp;
			temp.name = "propertyContainer";
			temp.height = 476;
			var skin:StateSkin = new org.mokylin.skin.app.role.RolePropertyPanelSkin()
			temp.skin = skin
			temp.width = 218;
			temp.x = 388;
			temp.y = 35;
			return temp;
		}

		private function tabBar_pro_i():feathers.controls.TabBar
		{
			var temp:feathers.controls.TabBar = new feathers.controls.TabBar();
			tabBar_pro = temp;
			temp.name = "tabBar_pro";
			temp.btnWidth = 85;
			temp.height = 29;
			temp.styleClass = org.mokylin.skin.component.tabbar.TabBarSkin_mount_fenye_heng;
			temp.width = 184;
			temp.x = 390;
			temp.y = 2;
			temp.layout = __RoleViewSkin_HorizontalLayout1_i();
			temp.dataProvider = __RoleViewSkin_ArrayCollection1_i();
			return temp;
		}

		private function zd_left_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			zd_left = temp;
			temp.name = "zd_left";
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_mount_btn_zd_left;
			temp.x = 142;
			temp.y = 448;
			return temp;
		}

		private function zd_right_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			zd_right = temp;
			temp.name = "zd_right";
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_mount_btn_zd_right;
			temp.x = 219;
			temp.y = 447;
			return temp;
		}

	}
}