package demo.utils
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	public class ColorUtils
	{ 
		private static const OrangeMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[1, 0, 0, 0, 0,
				0, 0.5, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0, 0.7, 0]);
		
		private static const PurpleMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[1, 0, 1, 0, 0,
				0, 0, 0, 0, 0,
				1, 0, 1, 0, 0,
				0, 0, 0, 0.7, 0]);
		
		private static const GreenMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[0, 0, 0, 0, 0,
				0, 1, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0, 0.7, 0]);
		
		private static const BlueMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[0.03, 0, 0, 0, 0,
				0, 0.9, 0, 0, 0,
				0, 0, 1, 0, 0,
				0, 0, 0, 0.7, 0]);
		
		private static const YellowMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[1, 0, 0, 0, 0,
				0, 0.9, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0, 0.7, 0]);
		
		private static const GrayMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[0.3, 0.3, 0.3, 0, 0,
				0.3, 0.3, 0.3, 0, 0,
				0.3, 0.3, 0.3, 0, 0
				, 0, 0, 0, 1, 0]);
		
		private static const RedMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[0.6, 0.2, 0.2, 0, 0.4,
				0.2, 0.2, 0.2, 0, 0,
				0.2, 0.2, 0.2, 0, 0,
				0, 0, 0, 1, 0]);
		private static const DarkGrayMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[0.25, 0.25, 0.25, 0, 0,
				0.25, 0.25, 0.25, 0, 0,
				0.25, 0.25, 0.25, 0, 0
				, 0, 0, 0, 1, 0]);
		
		private static const NormalGrayMatrix:ColorMatrixFilter = new ColorMatrixFilter(
			[0.3, 0.59, 0.11, 0, 0,
				0.3, 0.59, 0.11, 0, 0,
				0.3, 0.59, 0.11, 0, 0
				, 0, 0, 0, 1, 0]);
		
		private static function stroke(target:DisplayObject,									  
									   color:Number=0x000000,
									   thickness:Number=2,
									   alpha:Number=1, _strength:int = 255,quality : Number = 0 ):void{
			if(target == null)
				return;
			
			var blurX:Number = thickness;
			var blurY:Number = thickness;
			var strength:int = _strength;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			if(quality == 0)
			{
				quality = BitmapFilterQuality.MEDIUM;
			}
			target.filters = [new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout)];
		}
		
		public static function getDefaultStrokeFilter():Array
		{
			//TODO: re-use GlowFilter?
			return [new GlowFilter(0x0A0A0A,1,1.4,1.4,20,BitmapFilterQuality.MEDIUM,false,false)];
		}
		
		public static function clearStroke(target:DisplayObject):void{
			target.filters = [];
		}
		
		public static function defaultStroke(target:DisplayObject):void{
			if(target == null)
				return;
			ColorUtils.stroke(target, 0x0A0A0A, 1.4, 1, 20);
		}
		public static function defaultStrokeSomething(...args):void
		{
			for each(var dis:DisplayObject in args)
			{
				defaultStroke(dis);
			}
		}
		public static function redStroke(target:DisplayObject):void{
			if(target) 
				target.filters = [RedMatrix];
			
		}
		public static function darkGrayStroke(target:DisplayObject):void{
			if(target) 
				target.filters = [DarkGrayMatrix];
		}
		public static function normalGrayStroke(target:DisplayObject):void{
			if(target) 
				target.filters = [GrayMatrix];
		}
		
		// 紫色特效 
		public static function purpleQualityGrayStroke(target:DisplayObject):void{
			if(target) 
				target.filters = [PurpleMatrix];
		}
		
		// 绿色 特效
		public static function greenGrayQualityStroke(target:DisplayObject):void{
			if(target) 
				target.filters = [GreenMatrix];
		}
		
		// 蓝色 特效
		public static function blueGrayQualityStroke(target:DisplayObject):void{
			if(target) 
				target.filters = [BlueMatrix];
		}
		
		// 黄色 特效
		public static function yellowQualityGrayStroke(target:DisplayObject):void{
			if(target) 
				target.filters = [YellowMatrix];
		}
		
		// 橙色 特效
		public static function orangeQualityGrayStroke(target:DisplayObject):void{
			if(target) 
				target.filters = [OrangeMatrix];
		}
		
	}
}


