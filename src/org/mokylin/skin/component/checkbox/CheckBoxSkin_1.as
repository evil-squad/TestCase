package org.mokylin.skin.component.checkbox
{
	import feathers.controls.text.Fontter;
	import feathers.controls.Label;
	import feathers.controls.StateSkin;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class CheckBoxSkin_1 extends feathers.controls.StateSkin
	{
		public var labelDisplay:feathers.controls.Label;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function CheckBoxSkin_1()
		{
			super();
			
			this.currentState = "up";
			this.height = 22;
			this.width = 184;
			this.elementsContent = [];
			
			states = {
				disabled:[
						{target:"labelDisplay",
							name:"color",
							value:0x594E43
						}
						,
						{target:"labelDisplay",
							name:"nativeFilters",
							value:Fontter.filterObj["textFilterBlack"]
						}
					]
				,
				disabledAndSelected:[
						{target:"labelDisplay",
							name:"color",
							value:0x594E43
						}
						,
						{target:"labelDisplay",
							name:"nativeFilters",
							value:Fontter.filterObj["textFilterBlack"]
						}
					]
				,
				init:[
						{target:"labelDisplay",
							name:"bold",
							value:true
						}
						,
						{target:"labelDisplay",
							name:"fontName",
							value:"黑体"
						}
						,
						{target:"labelDisplay",
							name:"fontSize",
							value:12
						}
						,
						{target:"labelDisplay",
							name:"textAlign",
							value:"left"
						}
						,
						{target:"labelDisplay",
							name:"color",
							value:0xC4A689
						}
						,
						{target:"labelDisplay",
							name:"nativeFilters",
							value:Fontter.filterObj["textFilterBlack"]
						}
						,
						{target:"labelDisplay",
							name:"verticalAlign",
							value:"middle"
						}
					]
			};
			skinNames={"disabled":"ui/component/checkbox/skin_1/normal_disabled.png",
			"disabledAndSelected":"ui/component/checkbox/skin_1/select_disabled.png",
			"down":"ui/component/checkbox/skin_1/normal_down.png",
			"downAndSelected":"ui/component/checkbox/skin_1/select_down.png",
			"hover":"ui/component/checkbox/skin_1/normal_over.png",
			"overAndSelected":"ui/component/checkbox/skin_1/select_over.png",
			"up":"ui/component/checkbox/skin_1/normal_up.png",
			"upAndSelected":"ui/component/checkbox/skin_1/select_up.png"};
		}


		private function labelDisplay_i():feathers.controls.Label
		{
			var temp:feathers.controls.Label = new feathers.controls.Label();
			labelDisplay = temp;
			temp.name = "labelDisplay";
			temp.bold = true;
			temp.fontName = "黑体";
			temp.height = 22;
			temp.fontSize = 12;
			temp.text = "标签";
			temp.textAlign = "left";
			temp.color = 0xC4A689;
			temp.nativeFilters = Fontter.filterObj["textFilterBlack"];
			temp.verticalAlign = "middle";
			temp.width = 147;
			temp.x = 25;
			temp.y = 0;
			return temp;
		}

	}
}