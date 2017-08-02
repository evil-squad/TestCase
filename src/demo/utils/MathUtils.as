package demo.utils 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author CornFlex
	 */	
	public class MathUtils
	{	
		
		public static function convertToRadian(angle:Number):Number
		{
			return angle * Math.PI / 180;
		}
		
		public static function convertToDegree(angle:Number):Number
		{
			return 180 * angle / Math.PI;
		}	
		
		public static function getVector3DFromUV(uv:Point, radius:Number, bitmapWidth:Number, bitmapHeight:Number):Object 
		{
			var degreesX:Number = (uv.y * 180) / bitmapHeight;
			degreesX = degreesX - 90;
			degreesX = degreesX * -1;
			
			var degreesY:Number = (uv.x * 360) / bitmapWidth;			
			
			var radianX:Number = MathUtils.convertToRadian(degreesX);
			var radianY:Number = MathUtils.convertToRadian(degreesY);			
			
			var xcoordinate:Number = (radius * Math.cos(radianX)) * Math.cos(radianY);
			var ycoordinate:Number = radius * Math.sin(radianX);
			var zcoordinate:Number = (radius * Math.cos(radianX)) * Math.sin(radianY);
			
			return { x:xcoordinate, y:ycoordinate, z:zcoordinate, rotationX:degreesX, rotationY:degreesY };
		}				
		
		public static function getMillerProjectionPoint(long:Number, lat:Number, mapWith:Number, mapHeight:Number):Point
		{
			var point:Point = new Point();
			
			point.x = (mapWith / 2) + (long * (mapWith / 360));
			
			var latrad:Number = MathUtils.convertToRadian(lat);
			var my:Number = 1.25 * Math.log(Math.tan((Math.PI / 4) + (0.4 * latrad)));
			
			point.y = (mapHeight / 2) - (my * (mapHeight / 4.6));						
			
			return point;
		}
		
		public static function random(startValue:Number, endValue:Number, asInt:Boolean=false):Number
		{			
			var range:Number = Math.abs(startValue) + endValue;
			
			if (startValue < 0)
			{
				if (endValue < 0) range = Math.abs(startValue) + endValue;
				else range = Math.abs(startValue) + endValue;
			}
			else
			{
				if (endValue < 0) range = -(startValue - endValue); 
				else range = endValue - startValue;				
			}			
			
			var rdm:Number = 0;			
			if (asInt) rdm = Math.round(Math.random() * range);
			else rdm = Math.random() * range;			
			
			var value:Number = startValue + rdm;
			
			return value;
			
			if( asInt ) 
			{
				return Math.round(Math.random() * (endValue-startValue));
			}
			return Math.random() * (endValue-startValue);
			
		}
		
		
		
		
		
		
		
		private static const DEGREES_TO_RADIANS:Number = Math.PI/180;
		private static const Result:Point = new Point();
		private static const aPoint:Vector3D = new Vector3D();
		private static const rotation:Vector3D = new Vector3D();
		/**
		 * 2d方向旋转一定的角度
		 * @param X
		 * @param Y
		 * @param Angle 0-360
		 * 
		 */		
		public static function rotatePoint2D(X:Number, Y:Number, Angle:Number):Point
		{
			aPoint.setTo(X, 0, Y);
			aPoint.w = 0;
			rotation.setTo(0, Angle, 0);
			rotation.w = 0;
			
			if (rotation.x != 0 || rotation.y != 0 || rotation.z != 0) {
				
				var x1:Number;
				var y1:Number;
				
				var rad:Number = DEGREES_TO_RADIANS;
				var rotx:Number = rotation.x*rad;
				var roty:Number = rotation.y*rad;
				var rotz:Number = rotation.z*rad;
				
				var sinx:Number = Math.sin(rotx);
				var cosx:Number = Math.cos(rotx);
				var siny:Number = Math.sin(roty);
				var cosy:Number = Math.cos(roty);
				var sinz:Number = Math.sin(rotz);
				var cosz:Number = Math.cos(rotz);
				
				var x0:Number = aPoint.x;
				var y0:Number = aPoint.y;
				var z0:Number = aPoint.z;
				
				y1 = y0;
				y0 = y1*cosx + z0* -sinx;
				z0 = y1*sinx + z0*cosx;
				
				x1 = x0;
				x0 = x1*cosy + z0*siny;
				z0 = x1* -siny + z0*cosy;
				
				x1 = x0;
				x0 = x1*cosz + y0* -sinz;
				y0 = x1*sinz + y0*cosz;
				
				aPoint.x = x0;
				aPoint.y = y0;
				aPoint.z = z0;
			}
			
			Result.setTo(aPoint.x, aPoint.z);
			return Result;
		}
		
		
	}

}