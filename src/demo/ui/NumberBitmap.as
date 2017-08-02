package demo.ui
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.BitmapFontTexture;
	
	/**
	 * 数字显示控件 
	 * @author guoqing.wen
	 * 
	 */
	public class NumberBitmap extends Sprite
	{
		private var _numberText:String;
		private var _fractionDigits:int = 0;
		private var _numberGap:int = 0;
		private var _bitmapFontTexture:BitmapFontTexture;
		public function NumberBitmap(bitmapFontTexture:BitmapFontTexture)
		{
			super();
			_bitmapFontTexture = bitmapFontTexture;
		}
		
		public function get number():Number
		{
			return Number(_numberText);
		}

		/**
		 * 设置要显示的数字，显示的小数点的位数由 fractionDigits属性决定
		 * @param value
		 * 
		 */
		public function set number(value:Number):void
		{
			var number:String = value.toFixed(_fractionDigits);
			if (_numberText != number)
			{
				_numberText = number;
				updateNumber();
			}
		}
		
		public function set numberText(value:String):void
		{
			if (_numberText != value)
			{
				_numberText = value;
				updateNumber();
			}
		}
		
		public function get numberText():String
		{
			return _numberText;
		}
		
		private function updateNumber():void
		{
			var image:Image = null;
			var posX:int = 0;
			var text:String = _numberText;
			var len:int = this.numChildren;
			var textLen:int = text.length;
			for (var i:int = 0; i < len; i++) 
			{
				image = this.getChildAt(i) as Image;
				if (image && i < textLen)
				{
					image.visible = true;
					image.texture = _bitmapFontTexture.getTexture(text.charAt(i));
					image.x = posX;
					posX += (image.width + _numberGap);
				}
				else
				{
					this.getChildAt(i).visible = false;
				}
			}
			for (var j:int = i; j < textLen; j++) 
			{
				image = new Image(_bitmapFontTexture.getTexture(text.charAt(j)));
				image.x = posX;
				posX += (image.width + _numberGap);
				addChild(image);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			var len:int = this.numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				this.getChildAt(i).dispose();
			}
			this.removeChildren();
			_bitmapFontTexture = null;
		}

		/** 介于 0 和 20（含）之间的整数，表示所需的小数位数*/
		public function get fractionDigits():int
		{
			return _fractionDigits;
		}

		/**
		 * @private
		 */
		public function set fractionDigits(value:int):void
		{
			_fractionDigits = value;
		}

		public function get numberGap():int
		{
			return _numberGap;
		}

		public function set numberGap(value:int):void
		{
			_numberGap = value;
		}


	}
}