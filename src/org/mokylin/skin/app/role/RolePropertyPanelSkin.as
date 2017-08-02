package org.mokylin.skin.app.role
{
	import feathers.controls.text.Fontter;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.StateSkin;
	import feathers.controls.UIAsset;
	import org.mokylin.skin.component.button.ButtonSkin_mount_btn_erji;
	import org.mokylin.skin.component.button.ButtonV3_arrow_right;
	import org.mokylin.skin.component.button.ButtonV3_green;
	import org.mokylin.skin.component.button.ButtonV3_plus_red;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class RolePropertyPanelSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var achievementIcon:feathers.controls.UIAsset;

		public var bg:feathers.controls.UIAsset;

		public var btnAuto:feathers.controls.Button;

		public var btnClear:feathers.controls.Button;

		public var btnjia_js:feathers.controls.Button;

		public var btnjia_ll:feathers.controls.Button;

		public var btnjia_mj:feathers.controls.Button;

		public var btnjia_tz:feathers.controls.Button;

		public var btnjia_zl:feathers.controls.Button;

		public var btnskip_js:feathers.controls.Button;

		public var btnskip_ll:feathers.controls.Button;

		public var btnskip_mj:feathers.controls.Button;

		public var btnskip_tz:feathers.controls.Button;

		public var btnskip_zl:feathers.controls.Button;

		public var honerIcon:feathers.controls.UIAsset;

		public var lb_bang:feathers.controls.Label;

		public var lb_ff:feathers.controls.Label;

		public var lb_fg:feathers.controls.Label;

		public var lb_hp:feathers.controls.Label;

		public var lb_jia:feathers.controls.Label;

		public var lb_js:feathers.controls.Label;

		public var lb_leftPoint:feathers.controls.Label;

		public var lb_ll:feathers.controls.Label;

		public var lb_mj:feathers.controls.Label;

		public var lb_mp:feathers.controls.Label;

		public var lb_pk:feathers.controls.Label;

		public var lb_tz:feathers.controls.Label;

		public var lb_wf:feathers.controls.Label;

		public var lb_wg:feathers.controls.Label;

		public var lb_zl:feathers.controls.Label;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function RolePropertyPanelSkin()
		{
			super();
			
			this.currentState = "normal";
			this.height = 476;
			this.width = 218;
			this.elementsContent = [bg_i(),__RolePropertyPanelSkin_UIAsset1_i(),__RolePropertyPanelSkin_Label1_i(),__RolePropertyPanelSkin_UIAsset2_i(),__RolePropertyPanelSkin_UIAsset3_i(),__RolePropertyPanelSkin_UIAsset4_i(),__RolePropertyPanelSkin_UIAsset5_i(),__RolePropertyPanelSkin_UIAsset6_i(),__RolePropertyPanelSkin_UIAsset7_i(),__RolePropertyPanelSkin_UIAsset8_i(),__RolePropertyPanelSkin_UIAsset9_i(),__RolePropertyPanelSkin_UIAsset10_i(),__RolePropertyPanelSkin_Label2_i(),__RolePropertyPanelSkin_Label3_i(),__RolePropertyPanelSkin_Label4_i(),__RolePropertyPanelSkin_Label5_i(),__RolePropertyPanelSkin_Label6_i(),__RolePropertyPanelSkin_Label7_i(),__RolePropertyPanelSkin_Label8_i(),__RolePropertyPanelSkin_Label9_i(),__RolePropertyPanelSkin_Label10_i(),lb_jia_i(),lb_bang_i(),lb_pk_i(),lb_hp_i(),__RolePropertyPanelSkin_UIAsset11_i(),__RolePropertyPanelSkin_Label11_i(),lb_ff_i(),__RolePropertyPanelSkin_UIAsset12_i(),__RolePropertyPanelSkin_Label12_i(),lb_wf_i(),__RolePropertyPanelSkin_UIAsset13_i(),__RolePropertyPanelSkin_Label13_i(),lb_fg_i(),__RolePropertyPanelSkin_UIAsset14_i(),__RolePropertyPanelSkin_Label14_i(),lb_wg_i(),__RolePropertyPanelSkin_UIAsset15_i(),__RolePropertyPanelSkin_Label15_i(),lb_mp_i(),lb_leftPoint_i(),lb_mj_i(),lb_ll_i(),lb_zl_i(),lb_js_i(),lb_tz_i(),btnjia_ll_i(),btnskip_ll_i(),btnjia_mj_i(),btnskip_mj_i(),btnjia_zl_i(),btnskip_zl_i(),btnjia_js_i(),btnskip_js_i(),btnjia_tz_i(),btnskip_tz_i(),btnAuto_i(),btnClear_i(),honerIcon_i(),achievementIcon_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __RolePropertyPanelSkin_Label10_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "生命：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 129;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label11_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "法防：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 253;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label12_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "物防：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 228;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label13_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "法攻：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 203;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label14_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "物攻：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 178;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label15_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "法力：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 153;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label1_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.leading = 0;
			temp.fontSize = 14;
			temp.text = "属性点数：";
			temp.textAlign = "left";
			temp.color = 0xD69E66;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 80;
			temp.x = 26;
			temp.y = 283;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label2_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "力量：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 311;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label3_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "敏捷：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 336;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label4_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "智力：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 362;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label5_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "精神：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 388;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label6_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "体质：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 414;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label7_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "家族：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 47;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label8_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "帮派：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 72;
			return temp;
		}

		private function __RolePropertyPanelSkin_Label9_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			temp.bold = false;
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "pk值：";
			temp.textAlign = "left";
			temp.color = 0xF9F0CC;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 55;
			temp.x = 11;
			temp.y = 96;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset10_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 412;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset11_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 8;
			temp.y = 250;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset12_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 8;
			temp.y = 225;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset13_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 200;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset14_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 175;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset15_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 150;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset1_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.height = 24;
			temp.styleName = "ui/common/liebiao/lie_biao_di.png";
			temp.width = 208;
			temp.x = 4;
			temp.y = 280;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset2_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 45;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset3_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 70;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset4_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 95;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset5_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 126;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset6_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 310;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset7_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 335;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset8_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 360;
			return temp;
		}

		private function __RolePropertyPanelSkin_UIAsset9_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			temp.styleName = "ui/common/liebiao/property_bg.png";
			temp.x = 6;
			temp.y = 387;
			return temp;
		}

		private function achievementIcon_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			achievementIcon = temp;
			temp.name = "achievementIcon";
			temp.touchable = false;
			temp.touchGroup = false;
			temp.styleName = "ui/common/honor/zhu_gong_zhi_wang.png";
			temp.x = 7;
			temp.y = 6;
			return temp;
		}

		private function bg_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			bg = temp;
			temp.name = "bg";
			temp.height = 439;
			temp.styleName = "ui/common/kang/neikuang1.png";
			temp.width = 218;
			temp.x = 0;
			temp.y = 0;
			return temp;
		}

		private function btnAuto_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnAuto = temp;
			temp.name = "btnAuto";
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.label = "推荐加点";
			temp.styleClass = org.mokylin.skin.component.button.ButtonSkin_mount_btn_erji;
			temp.color = 0xF9F0CC;
			temp.width = 84;
			temp.x = 22;
			temp.y = 444;
			return temp;
		}

		private function btnClear_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnClear = temp;
			temp.name = "btnClear";
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.label = "免费洗点";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_green;
			temp.color = 0xF9F0CC;
			temp.width = 84;
			temp.x = 125;
			temp.y = 444;
			return temp;
		}

		private function btnjia_js_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnjia_js = temp;
			temp.name = "btnjia_js";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_plus_red;
			temp.x = 180;
			temp.y = 390;
			return temp;
		}

		private function btnjia_ll_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnjia_ll = temp;
			temp.name = "btnjia_ll";
			temp.height = 17;
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_plus_red;
			temp.width = 16;
			temp.x = 179;
			temp.y = 313;
			return temp;
		}

		private function btnjia_mj_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnjia_mj = temp;
			temp.name = "btnjia_mj";
			temp.height = 17;
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_plus_red;
			temp.width = 16;
			temp.x = 180;
			temp.y = 338;
			return temp;
		}

		private function btnjia_tz_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnjia_tz = temp;
			temp.name = "btnjia_tz";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_plus_red;
			temp.x = 180;
			temp.y = 415;
			return temp;
		}

		private function btnjia_zl_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnjia_zl = temp;
			temp.name = "btnjia_zl";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_plus_red;
			temp.x = 180;
			temp.y = 363;
			return temp;
		}

		private function btnskip_js_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnskip_js = temp;
			temp.name = "btnskip_js";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_arrow_right;
			temp.x = 200;
			temp.y = 390;
			return temp;
		}

		private function btnskip_ll_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnskip_ll = temp;
			temp.name = "btnskip_ll";
			temp.height = 17;
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_arrow_right;
			temp.width = 16;
			temp.x = 200;
			temp.y = 313;
			return temp;
		}

		private function btnskip_mj_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnskip_mj = temp;
			temp.name = "btnskip_mj";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_arrow_right;
			temp.x = 200;
			temp.y = 338;
			return temp;
		}

		private function btnskip_tz_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnskip_tz = temp;
			temp.name = "btnskip_tz";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_arrow_right;
			temp.x = 200;
			temp.y = 415;
			return temp;
		}

		private function btnskip_zl_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			btnskip_zl = temp;
			temp.name = "btnskip_zl";
			temp.styleClass = org.mokylin.skin.component.button.ButtonV3_arrow_right;
			temp.x = 200;
			temp.y = 363;
			return temp;
		}

		private function honerIcon_i():feathers.controls.UIAsset
		{
			var temp:feathers.controls.UIAsset = new feathers.controls.UIAsset();
			honerIcon = temp;
			temp.name = "honerIcon";
			temp.styleName = "ui/common/tubiao/wang_cheng_zhan.png";
			temp.x = 184;
			temp.y = 65;
			return temp;
		}

		private function lb_bang_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_bang = temp;
			temp.name = "lb_bang";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0xF09E01;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 122;
			temp.x = 58;
			temp.y = 72;
			return temp;
		}

		private function lb_ff_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_ff = temp;
			temp.name = "lb_ff";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 152;
			temp.x = 58;
			temp.y = 253;
			return temp;
		}

		private function lb_fg_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_fg = temp;
			temp.name = "lb_fg";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 152;
			temp.x = 58;
			temp.y = 203;
			return temp;
		}

		private function lb_hp_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_hp = temp;
			temp.name = "lb_hp";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 152;
			temp.x = 58;
			temp.y = 128;
			return temp;
		}

		private function lb_jia_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_jia = temp;
			temp.name = "lb_jia";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0xF09E01;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 83;
			temp.x = 127;
			temp.y = 47;
			return temp;
		}

		private function lb_js_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_js = temp;
			temp.name = "lb_js";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "left";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 60;
			temp.x = 96;
			temp.y = 388;
			return temp;
		}

		private function lb_leftPoint_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_leftPoint = temp;
			temp.name = "lb_leftPoint";
			temp.leading = 0;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "left";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 83;
			temp.x = 96;
			temp.y = 283;
			return temp;
		}

		private function lb_ll_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_ll = temp;
			temp.name = "lb_ll";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "left";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 60;
			temp.x = 96;
			temp.y = 311;
			return temp;
		}

		private function lb_mj_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_mj = temp;
			temp.name = "lb_mj";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "left";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 60;
			temp.x = 96;
			temp.y = 336;
			return temp;
		}

		private function lb_mp_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_mp = temp;
			temp.name = "lb_mp";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 152;
			temp.x = 58;
			temp.y = 153;
			return temp;
		}

		private function lb_pk_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_pk = temp;
			temp.name = "lb_pk";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 83;
			temp.x = 127;
			temp.y = 97;
			return temp;
		}

		private function lb_tz_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_tz = temp;
			temp.name = "lb_tz";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "left";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 60;
			temp.x = 96;
			temp.y = 413;
			return temp;
		}

		private function lb_wf_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_wf = temp;
			temp.name = "lb_wf";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 152;
			temp.x = 58;
			temp.y = 228;
			return temp;
		}

		private function lb_wg_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_wg = temp;
			temp.name = "lb_wg";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "right";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 152;
			temp.x = 58;
			temp.y = 178;
			return temp;
		}

		private function lb_zl_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			lb_zl = temp;
			temp.name = "lb_zl";
			temp.height = 20;
			temp.fontSize = 14;
			temp.text = "754";
			temp.textAlign = "left";
			temp.color = 0x239D02;
			temp.nativeFilters = Fontter.filterObj["labelFilterBlack"];
			temp.width = 60;
			temp.x = 96;
			temp.y = 362;
			return temp;
		}

	}
}