package demo.display3D {

	import com.game.engine3D.vo.BaseRole;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Matrix3DUtils;
	
	import demo.enum.EleEnum;
	import demo.enum.IDEnum;
	import demo.managers.WorldManager;


	/**
	 * @author 	chenbo
	 * @email  	470259651@qq.com
	 * @time	Mar 23, 2016 10:54:14 AM
	 */
	public class Operator3D extends BaseRole {

		protected var _state : int = -1;
		protected var _eleType : int = EleEnum.ELE_TYPE_UNKNOWN;
		protected var _radius : int = EleEnum.ELE_DEFAULT_RADIUS;
		protected var _world : WorldManager;
		
		private var _destroyed : Boolean;
		private var _lastTime : int = 0; // 已存活时间

		public function Operator3D(Id : int) {
			super("" + EleEnum.ELE_TYPE_OPERATOR, IDEnum.nextID);
			id = Id;
			_eleType = EleEnum.ELE_TYPE_OPERATOR;
			_world   = WorldManager.instance;
		}

		public function set state(value : int) : void {
			_state = value;
		}

		public function get state() : int {
			return _state;
		}

		protected function resetElement(Id : int = 0, Name : String = null) : void {
			_state = -1;
			_lastTime = 0;
			id = Id;
		}
		
		public function get eleType() : int {
			return _eleType;
		}
		
		public function get lastTime() : int {
			return _lastTime;
		}
		
		public static function ObjFaceTo3DSpace(obj:ObjectContainer3D, xPos:Number, zPos:Number, height:Number = 0):void {
			if(obj == null)
				return;
			Matrix3DUtils.CALCULATION_VECTOR3D.setTo(xPos, height, zPos);
			obj.lookAt(Matrix3DUtils.CALCULATION_VECTOR3D);
		}
		
		public function distanceToPos(X:Number, Y:Number):Number {
			Matrix3DUtils.CALCULATION_VECTOR3D.setTo(X - x, Y - z, 0);
			var value:Number = Matrix3DUtils.CALCULATION_VECTOR3D.length;
			return value;
		}
		
	}
}
