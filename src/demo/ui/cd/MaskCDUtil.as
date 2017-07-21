package demo.ui.cd
{
	import flash.utils.Dictionary;
	
	import starling.display.Canvas;
	import starling.geom.Polygon;
	import starling.utils.AssetManager;
	
	
	/**
	 * CD遮罩工具类
	 * @author wewell
	 * 
	 */	
	public class MaskCDUtil
	{
		/**CD的半径**/
		public static const MASK_RADIUS:int = 12;
		
		private static var _assetManager:AssetManager;
		public static function get assetManager():AssetManager
		{
			if(_assetManager == null)_assetManager = new AssetManager();
			return _assetManager;
		}
		
		
		//------------------------------------------------------wewell-------------------------------------------------
		public static function drawPolygonMask(canvas:Canvas, angle:int):void
		{
			canvas.clear();
			if(!polygon360.hasOwnProperty(angle))
			{
				polygon360[angle] = new Polygon(getPolygonVertex(angle, MASK_RADIUS,MASK_RADIUS));
			}
			var polygon:Polygon =  polygon360[angle];
			canvas.beginFill(0,0.5);
			canvas.drawPolygon(polygon);
			canvas.endFill();
		}
		
		/**
		 * 画一个CD遮罩
		 * @param $angle	角度
		 * @param _w		格子宽半径
		 * @param _h		格子高半径
		 * @return 
		 * 
		 */	
		private static var polygon360:Dictionary = new Dictionary();
		private static function getPolygonVertex( $angle:Number, _w:Number, _h:Number ):Array
		{
			//画遮罩
			var xx:Number;
			var yy:Number;
			var vertex:Array;
			if($angle == 0 || $angle == 360)
			{
				return [0,0, _w, 0, _w, _h, -_w,-_h];
			}
			//取得正切值
			var tanA:Number= Math.tan($angle*Math.PI/180);
			if($angle>=0 && $angle<45)
			{
				xx = _w*tanA;
				yy = -_h;
				vertex = [0,0, xx, yy,  _w, -_h, _w, _h, -_w, _h, -_w, -_h];
			}
			else if($angle>=45 && $angle<135)
			{
				xx = _w;
				yy = -_w/tanA;
				vertex = [0,0,  xx,yy,  _w,_h,  -_w,_h,   -_w,-_h];
			}
			else if($angle>=135 && $angle<225)
			{
				xx = -_h*tanA;
				yy = _h;
				vertex = [0,0, xx, yy, -_w, _h, -_w, -_h];
			}
			else if($angle>=225 && $angle<315)
			{
				xx = -_w;
				yy = _w/tanA;
				vertex = [0,0, xx, yy, -_w, -_h];
			}
			else if($angle>=315 && $angle<360)
			{
				xx = _w*tanA;
				yy = -_h;
				vertex = [0,0, xx, yy];
			}
			vertex.push(0, -_h);
			return vertex;
		}
		//------------------------------------------------------wewell-------------------------------------------------
		
	}
}