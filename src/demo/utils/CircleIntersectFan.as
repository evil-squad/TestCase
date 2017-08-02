package demo.utils
{
	public class CircleIntersectFan
	{
		// 判断圆与扇形是否相交
		// 圆心p(x, y), 半径r, 扇形圆心p1(x1, y1), 扇形正前方最远点p2(x2, y2), 扇形夹角弧度值theta(0,pi)
		public static  function IsCircleIntersectFan(x:Number, y:Number, r:Number, x1:Number, y1:Number, x2:Number, y2:Number, theta:Number):Boolean
		{
			// 计算扇形正前方向量 v = p1p2
			var vx:Number = x2 - x1;
			var vy:Number = y2 - y1;
			
			// 计算扇形半径 R = v.length()
			var R:Number = Math.sqrt(vx * vx + vy * vy);
			assert(R > 0.00001);
			
			// 圆不与扇形圆相交，则圆与扇形必不相交
			if ((x - x1) * (x - x1) + (y - y1) * (y - y1) > (R + r) * (R + r))
				return false;
			
			assert(theta > 0.00001 && theta < 3.1416);
			
			// 根据夹角 theta/2 计算出旋转矩阵，并将向量v乘该旋转矩阵得出扇形两边的端点p3,p4
			var h:Number = theta * 0.5;
			var c:Number = Math.cos(h);
			var s:Number = Math.sin(h);
			var x3:Number = x1 + (vx * c - vy * s);
			var y3:Number = y1 + (vx * s + vy * c);
			var x4:Number = x1 + (vx * c + vy * s);
			var y4:Number = y1 + (-vx * s + vy * c);
			
			// 如果圆心在扇形两边夹角内，则必相交
			var d1:Number = EvaluatePointToLine(x, y, x1, y1, x3, y3);
			var d2:Number = EvaluatePointToLine(x, y, x4, y4, x1, y1);
			if (d1 >= 0 && d2 >= 0)
				return true;
			
			// 如果圆与任一边相交，则必相交
			if (IsCircleIntersectLineSeg(x, y, r, x1, y1, x3, y3))
				return true;
			if (IsCircleIntersectLineSeg(x, y, r, x1, y1, x4, y4))
				return true;
			
			return false;
		}
		
		
		// 判断点P(x, y)与有向直线P1P2的关系. 小于0表示点在直线左侧，等于0表示点在直线上，大于0表示点在直线右侧
		public static function EvaluatePointToLine(x:Number, y:Number, x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var a:Number = y2 - y1;
			var b:Number = x1 - x2;
			var c:Number = x2 * y1 - x1 * y2;
			
			assert(Math.abs(a) > 0.00001 || Math.abs(b) > 0.00001);
			
			return a * x + b * y + c;
		}
		
		// 判断点P(x, y)是否在点P1(x1, y1), P2(x2, y2), P3(x3, y3)构成的三角形内（包括边）
		public static function IsPointInTriangle(x:Number, y:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Boolean
		{
			// 分别计算点P与有向直线P1P2, P2P3, P3P1的关系，如果都在同一侧则可判断点在三角形内
			// 注意三角形有可能是顺时针(d>0)，也可能是逆时针(d<0)。
			var d1:Number = EvaluatePointToLine(x, y, x1, y1, x2, y2);
			var d2:Number = EvaluatePointToLine(x, y, x2, y2, x3, y3);
			if (d1 * d2 < 0)
				return false;
			
			var d3:Number = EvaluatePointToLine(x, y, x3, y3, x1, y1);
			if (d2 * d3 < 0)
				return false;
			
			return true;
		}
		// 圆与线段碰撞检测
		// 圆心p(x, y), 半径r, 线段两端点p1(x1, y1)和p2(x2, y2)
		public static function IsCircleIntersectLineSeg(x:Number, y:Number, r:Number, x1:Number, y1:Number, x2:Number, y2:Number):Boolean
		{
			var vx1:Number = x - x1;
			var vy1:Number = y - y1;
			var vx2:Number = x2 - x1;
			var vy2:Number = y2 - y1;
			
			assert(Math.abs(vx2) > 0.00001 || Math.abs(vy2) > 0.00001);
			
			// len = v2.length()
			var len:Number = Math.sqrt(vx2 * vx2 + vy2 * vy2);
			
			// v2.normalize()
			vx2 /= len;
			vy2 /= len;
			
			// u = v1.dot(v2)
			// u is the vector projection length of vector v1 onto vector v2.
			var u:Number = vx1 * vx2 + vy1 * vy2;
			
			// determine the nearest point on the lineseg
			var x0:Number = 0;
			var y0:Number = 0;
			if (u <= 0)
			{
				// p is on the left of p1, so p1 is the nearest point on lineseg
				x0 = x1;
				y0 = y1;
			}
			else if (u >= len)
			{
				// p is on the right of p2, so p2 is the nearest point on lineseg
				x0 = x2;
				y0 = y2;
			}
			else
			{
				// p0 = p1 + v2 * u
				// note that v2 is already normalized.
				x0 = x1 + vx2 * u;
				y0 = y1 + vy2 * u;
			}
			
			return (x - x0) * (x - x0) + (y - y0) * (y - y0) <= r * r;
		}
		
		
		public static function assert(enable:Boolean):void
		{
			if(!enable)
			{
				throw new Error("error!");
			}
		}
	}
}