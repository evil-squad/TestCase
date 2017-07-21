package org.mokylin.skin.app.backpack
{
	import feathers.controls.text.Fontter;
	import feathers.data.ListCollection;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.controls.StateSkin;
	import feathers.controls.TabBar;
	import feathers.controls.UIAsset;
	import feathers.layout.HorizontalLayout;
	import org.mokylin.skin.app.backpack.button.ButtonChong_zhi;
	import org.mokylin.skin.app.backpack.button.ButtonShang_cheng;
	import org.mokylin.skin.app.backpack.radio.RadioButtonQuality0;
	import org.mokylin.skin.app.backpack.radio.RadioButtonQuality1;
	import org.mokylin.skin.app.backpack.radio.RadioButtonQuality2;
	import org.mokylin.skin.app.backpack.radio.RadioButtonQuality3;
	import org.mokylin.skin.app.backpack.radio.RadioButtonQuality4;
	import org.mokylin.skin.app.backpack.radio.RadioButtonQualityAll;
	import org.mokylin.skin.component.button.ButtonSkin_mount_btn_erji;
	import org.mokylin.skin.component.button.ButtonV3_g_guanbi;
	import org.mokylin.skin.component.tabbar.TabBarSkin_mount_fenye_heng;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class BackpackPanelSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var baitanBtn:feathers.controls.Button;

		public var bg:feathers.controls.UIAsset;

		public var btnBindGold:feathers.controls.Label;

		public var btnBindSilver:feathers.controls.Label;

		public var btnChongZhi:feathers.controls.Button;

		public var btnClearUp:feathers.controls.Button;

		public var btnClose:feathers.controls.Button;

		public var btnGold:feathers.controls.Label;

		public var btnShop:feathers.controls.Button;

		public var btnSilver:feathers.controls.Label;

		public var labBindGold:feathers.controls.Label;

		public var labBindSilver:feathers.controls.Label;

		public var labGold:feathers.controls.Label;

		public var labSilver:feathers.controls.Label;

		public var lbCount:feathers.controls.Label;

		public var quality0:feathers.controls.Radio;

		public var quality1:feathers.controls.Radio;

		public var quality2:feathers.controls.Radio;

		public var quality3:feathers.controls.Radio;

		public var quality4:feathers.controls.Radio;

		public var qualityAll:feathers.controls.Radio;

		public var tabBar:feathers.controls.TabBar;

		public var title:feathers.controls.UIAsset;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function BackpackPanelSkin()
		{
			super();
			
			this.currentState = "normal";
			this.height = 575;
			this.width = 380;
			this.elementsContent = [bg_i(),__BackpackPanelSkin_UIAsset1_i(),__BackpackPanelSkin_UIAsset2_i(),__BackpackPanelSkin_UIAsset3_i(),__BackpackPanelSkin_UIAsset4_i(),__BackpackPanelSkin_UIAsset5_i(),btnClose_i(),btnShop_i(),btnChongZhi_i(),baitanBtn_i(),btnClearUp_i(),__BackpackPanelSkin_UIAsset6_i(),__BackpackPanelSkin_UIAsset7_i(),__BackpackPanelSkin_UIAsset8_i(),__BackpackPanelSkin_UIAsset9_i(),labGold_i(),labBindGold_i(),labSilver_i(),labBindSilver_i(),btnGold_i(),btnBindGold_i(),btnSilver_i(),btnBindSilver_i(),title_i(),lbCount_i(),tabBar_i(),__BackpackPanelSkin_UIAsset10_i(),__BackpackPanelSkin_UIAsset11_i(),__BackpackPanelSkin_UIAsset12_i(),__BackpackPanelSkin_UIAsset13_i(),qualityAll_i(),quality0_i(),quality1_i(),quality2_i(),quality3_i(),quality4_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __BackpackPanelSkin_ArrayCollection1_i():feathers.data.ListCollection
		{
			var temp:feathers.data.ListCollection = new feathers.data.ListCollection();
			temp.data = ['全 部','装 备','材 料','其 它'];
			return temp;
		}

		private function __BackpackPanelSkin_HorizontalLayout1_i():feathers.layout.HorizontalLayout
		{
			var temp:feathers.layout.HorizontalLayout = new feathers.layout.HorizontalLayout();
			temp.gap = 6;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset10_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 20;
			temp.styleName = "ui/common/icon/bang_jin.png";
			temp.width = 20;
			temp.x = 14;
			temp.y = 497;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset11_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 20;
			temp.styleName = "ui/common/icon/bang_yin.png";
			temp.width = 20;
			temp.x = 161;
			temp.y = 497;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset12_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 20;
			temp.styleName = "ui/common/icon/jin_zi.png";
			temp.width = 20;
			temp.x = 14;
			temp.y = 468;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset13_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 20;
			temp.styleName = "ui/common/icon/yin_zi.png";
			temp.width = 20;
			temp.x = 161;
			temp.y = 469;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset1_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/app/backpack/hei_bian.png";
			temp.x = 21;
			temp.y = 528;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset2_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 65;
			temp.styleName = "ui/app/backpack/di.png";
			temp.width = 343;
			temp.x = 15;
			temp.y = 458;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset3_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/app/backpack/hong_di.png";
			temp.x = 248;
			temp.y = 431;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset4_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.touchGroup = false;
			temp.touchable = false;
			temp.styleName = "ui/common/version_3/T_tongyongbanzi/gao_guang.png";
			temp.width = 274;
			temp.x = 48;
			temp.y = 4;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset5_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 366;
			temp.styleName = "ui/common/version_3/D_di/di_1.png";
			temp.width = 353;
			temp.x = 11;
			temp.y = 61;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset6_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/version_3/S_shurukuang/shu_ru_kuang_1.png";
			temp.width = 87;
			temp.x = 74;
			temp.y = 466;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset7_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/version_3/S_shurukuang/shu_ru_kuang_1.png";
			temp.width = 87;
			temp.x = 74;
			temp.y = 492;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset8_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/version_3/S_shurukuang/shu_ru_kuang_1.png";
			temp.width = 140;
			temp.x = 221;
			temp.y = 466;
			return temp;
		}

		private function __BackpackPanelSkin_UIAsset9_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/version_3/S_shurukuang/shu_ru_kuang_1.png";
			temp.width = 140;
			temp.x = 221;
			temp.y = 492;
			return temp;
		}

		private function baitanBtn_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			baitanBtn = temp;
			temp.name = "baitanBtn";
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.label = "摆 摊";
			temp.fontSize = 14;
			temp.styleClass = org.mokylin.skin.app.backpack.button.ButtonChong_zhi;
			temp.textAlign = "center";
			temp.color = 0xDFC8AF;
			temp.x = 67;
			temp.y = 528;
			return temp;
		}

		private function bg_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			bg = temp;
			temp.name = "bg";
			temp.height = 577;
			temp.styleName = "ui/common/background/di_ban.png";
			temp.width = 377;
			temp.x = 0;
			temp.y = 0;
			return temp;
		}

		private function btnBindGold_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			btnBindGold = temp;
			temp.name = "btnBindGold";
			temp.bold = false;
			temp.leading = 0;
			temp.fontSize = 14;
			temp.text = "绑金：";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.x = 33;
			temp.y = 495;
			return temp;
		}

		private function btnBindSilver_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			btnBindSilver = temp;
			temp.name = "btnBindSilver";
			temp.bold = false;
			temp.leading = 0;
			temp.fontSize = 14;
			temp.text = "绑银：";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.x = 182;
			temp.y = 495;
			return temp;
		}

		private function btnChongZhi_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnChongZhi = temp;
			temp.name = "btnChongZhi";
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.label = "充 值";
			temp.fontSize = 14;
			temp.styleClass = org.mokylin.skin.app.backpack.button.ButtonChong_zhi;
			temp.textAlign = "center";
			temp.color = 0xDFC8AF;
			temp.x = 167;
			temp.y = 528;
			return temp;
		}

		private function btnClearUp_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnClearUp = temp;
			temp.name = "btnClearUp";
			temp.height = 31;
			temp.label = "整";
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_mount_btn_erji;
			temp.color = 0xC9B489;
			temp.width = 26;
			temp.x = 334;
			temp.y = 428;
			return temp;
		}

		private function btnClose_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnClose = temp;
			temp.name = "btnClose";
			temp.height = 25;
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_g_guanbi;
			temp.width = 25;
			temp.x = 351;
			temp.y = 1;
			return temp;
		}

		private function btnGold_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			btnGold = temp;
			temp.name = "btnGold";
			temp.bold = false;
			temp.leading = 0;
			temp.fontSize = 14;
			temp.text = "金子：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.x = 33;
			temp.y = 466;
			return temp;
		}

		private function btnShop_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnShop = temp;
			temp.name = "btnShop";
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.label = "商 店";
			temp.labelOffsetX = 25;
			temp.labelOffsetY = 0;
			temp.fontSize = 14;
			temp.styleClass = org.mokylin.skin.app.backpack.button.ButtonShang_cheng;
			temp.textAlign = "center";
			temp.color = 0xDFC8AF;
			temp.x = 266;
			temp.y = 528;
			return temp;
		}

		private function btnSilver_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			btnSilver = temp;
			temp.name = "btnSilver";
			temp.bold = false;
			temp.leading = 0;
			temp.fontSize = 14;
			temp.text = "银子：";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.x = 183;
			temp.y = 467;
			return temp;
		}

		private function labBindGold_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			labBindGold = temp;
			temp.name = "labBindGold";
			temp.fontSize = 14;
			temp.text = "999999";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 115;
			temp.x = 76;
			temp.y = 494;
			return temp;
		}

		private function labBindSilver_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			labBindSilver = temp;
			temp.name = "labBindSilver";
			temp.fontSize = 14;
			temp.text = "100锭50两9文";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 152;
			temp.x = 224;
			temp.y = 496;
			return temp;
		}

		private function labGold_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			labGold = temp;
			temp.name = "labGold";
			temp.fontSize = 14;
			temp.text = "9999999";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 115;
			temp.x = 76;
			temp.y = 469;
			return temp;
		}

		private function labSilver_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			labSilver = temp;
			temp.name = "labSilver";
			temp.fontSize = 14;
			temp.text = "10000锭 99两 99文";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 134;
			temp.x = 223;
			temp.y = 469;
			return temp;
		}

		private function lbCount_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lbCount = temp;
			temp.name = "lbCount";
			temp.bold = false;
			temp.height = 24;
			temp.touchable = false;
			temp.touchGroup = false;
			temp.fontSize = 16;
			temp.text = "0/120";
			temp.textAlign = "center";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 77;
			temp.x = 262;
			temp.y = 431;
			return temp;
		}

		private function quality0_i():feathers.controls.Radio
		{
			var temp:feathers.controls.Radio = new feathers.controls.Radio();
			quality0 = temp;
			temp.name = "quality0";
			temp.groupName = "backpackquality";
			temp.styleClass = org.mokylin.skin.app.backpack.radio.RadioButtonQuality0;
			temp.x = 41;
			temp.y = 430;
			return temp;
		}

		private function quality1_i():feathers.controls.Radio
		{
			var temp:feathers.controls.Radio = new feathers.controls.Radio();
			quality1 = temp;
			temp.name = "quality1";
			temp.groupName = "backpackquality";
			temp.styleClass = org.mokylin.skin.app.backpack.radio.RadioButtonQuality1;
			temp.x = 67;
			temp.y = 430;
			return temp;
		}

		private function quality2_i():feathers.controls.Radio
		{
			var temp:feathers.controls.Radio = new feathers.controls.Radio();
			quality2 = temp;
			temp.name = "quality2";
			temp.groupName = "backpackquality";
			temp.styleClass = org.mokylin.skin.app.backpack.radio.RadioButtonQuality2;
			temp.x = 92;
			temp.y = 430;
			return temp;
		}

		private function quality3_i():feathers.controls.Radio
		{
			var temp:feathers.controls.Radio = new feathers.controls.Radio();
			quality3 = temp;
			temp.name = "quality3";
			temp.groupName = "backpackquality";
			temp.styleClass = org.mokylin.skin.app.backpack.radio.RadioButtonQuality3;
			temp.x = 118;
			temp.y = 430;
			return temp;
		}

		private function quality4_i():feathers.controls.Radio
		{
			var temp:feathers.controls.Radio = new feathers.controls.Radio();
			quality4 = temp;
			temp.name = "quality4";
			temp.groupName = "backpackquality";
			temp.styleClass = org.mokylin.skin.app.backpack.radio.RadioButtonQuality4;
			temp.x = 144;
			temp.y = 430;
			return temp;
		}

		private function qualityAll_i():feathers.controls.Radio
		{
			var temp:feathers.controls.Radio = new feathers.controls.Radio();
			qualityAll = temp;
			temp.name = "qualityAll";
			temp.groupName = "backpackquality";
			temp.isSelected = true;
			temp.styleClass = org.mokylin.skin.app.backpack.radio.RadioButtonQualityAll;
			temp.x = 15;
			temp.y = 430;
			return temp;
		}

		private function tabBar_i():feathers.controls.TabBar
		{
			var temp:feathers.controls.TabBar = new feathers.controls.TabBar();
			tabBar = temp;
			temp.name = "tabBar";
			temp.btnWidth = 51;
			temp.gap = 0;
			temp.styleClass = org.mokylin.skin.component.tabbar.TabBarSkin_mount_fenye_heng;
			temp.width = 311;
			temp.x = 23;
			temp.y = 35;
			temp.layout = __BackpackPanelSkin_HorizontalLayout1_i();
			temp.dataProvider = __BackpackPanelSkin_ArrayCollection1_i();
			return temp;
		}

		private function title_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			title = temp;
			temp.name = "title";
			temp.touchable = false;
			temp.styleName = "ui/app/backpack/bao_guo.png";
			temp.x = 163;
			temp.y = 4;
			return temp;
		}

	}
}