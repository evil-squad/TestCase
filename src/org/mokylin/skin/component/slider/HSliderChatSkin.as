package org.mokylin.skin.component.slider
{
	import feathers.controls.Button;
	import feathers.controls.StateSkin;
	import org.mokylin.skin.component.slider.button.ButtonSkin_thumb;
	import org.mokylin.skin.component.slider.button.ButtonSkin_track;
	import org.mokylin.skin.component.slider.button.ButtonSkin_trackMax;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompilerForFeathers
	 */
	public class HSliderChatSkin extends feathers.controls.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var thumb:feathers.controls.Button;

		public var track:feathers.controls.Button;

		public var trackMin:feathers.controls.Button;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function HSliderChatSkin()
		{
			super();
			
			this.currentState = "normal";
			this.height = 10;
			this.width = 195;
			this.elementsContent = [track_i(),trackMin_i(),thumb_i()];
			
			states = {
			};
			skinNames={};
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function thumb_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			thumb = temp;
			temp.name = "thumb";
			temp.height = 10;
			temp.styleClass = org.mokylin.skin.component.slider.button.ButtonSkin_thumb;
			temp.verticalCenter = 0;
			temp.width = 16;
			temp.x = 135;
			return temp;
		}

		private function trackMin_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			trackMin = temp;
			temp.name = "trackMin";
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 50;
			temp.styleClass = org.mokylin.skin.component.slider.button.ButtonSkin_trackMax;
			temp.top = 0;
			return temp;
		}

		private function track_i():feathers.controls.Button
		{
			var temp:feathers.controls.Button = new feathers.controls.Button();
			track = temp;
			temp.name = "track";
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.styleClass = org.mokylin.skin.component.slider.button.ButtonSkin_track;
			temp.top = 0;
			return temp;
		}

	}
}