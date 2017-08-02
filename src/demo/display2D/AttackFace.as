package demo.display2D {

	import com.game.mainCore.libCore.pool.IPoolClass;
	import com.game.mainCore.libCore.pool.Pool;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;

	/**
	 * 伤害效果
	 * @author Carver
	 */
	public class AttackFace extends starling.display.Sprite implements IPoolClass {
		
		/** 打击效果池 */
		private static var attackFacePool : Pool = new Pool("attackFacePool", 500);
		
		private var _specialOffsetPos 	: Point; 		// 特殊类型,带来的特殊坐标偏移
		private var _geBmpStarling 		: Image; 		// 个
		private var _shiBmpStarling 	: Image; 		// 十
		private var _baiBmpStarling 	: Image; 		// 百
		private var _qianBmpStarling 	: Image; 		// 千
		private var _wanBmpStarling 	: Image; 		// 万
		private var _shiwanBmpStarling 	: Image; 		// 十万
		private var _baiwanBmpStarling 	: Image; 		// 百万
		private var _qianwanBmpStarling : Image; 		// 千万
		private var _yiBmpStarling 		: Image; 		// 亿
		private var _shiyiBmpStarling 	: Image; 		// 十亿
		private var _plusBmpStarling 	: Image; 		// +-
		private var _txtBmpStarling 	: Image; 		// 类型,名称等..

		private var _type				: String = ""; 	// 类型
		private var _value 				: Object = 0; 	// 值(可以是数字,也可以是字符串)
		private var _specialType 		: String; 		// 特殊类型会有组合(例如暴击...)

		public function AttackFace(type : String = "", value : Object = 0, specialType : String = null, specialOffsetPos : Point = null) {
			_specialOffsetPos = specialOffsetPos || new Point();
			reSet([type, value, specialType, _specialOffsetPos]);
		}
		
		/**
		 * 生成一个AttackFace
		 * @param $type
		 * @param $value
		 */
		public static function createAttackFace(type : String = "", value : Object = 0, specialType : String = null, specialOffsetPos : Point = null) : AttackFace {
			//利用池生成AttackFace
			return attackFacePool.createObj(AttackFace, type, value, specialType, specialOffsetPos) as AttackFace;
		}
		
		/**
		 * @private
		 * 回收一个AttackFace
		 * @param $avatar
		 */
		public static function recycleAttackFace(attFace : AttackFace) : void {
			//利用池回收AttackFace
			attackFacePool.disposeObj(attFace);
		}

		/**
		 * @private
		 * 释放
		 */
		override public function dispose() : void {
			super.dispose();
			
			_type = "";
			_value = 0;
			_specialType = null;
			_specialOffsetPos.x = _specialOffsetPos.y = 0;
			
			if (parent) {
				parent.removeChild(this);
			}
		}
		
		/**
		 * @private
		 * reSet
		 */
		public function reSet(parameters : Array) : void {
			removeChildren();
			_type = parameters[0];
			_value = parameters[1];
			_specialType = parameters[2];
			_specialOffsetPos = parameters[3] || new Point();
			/////////////////////////文字//////////////////////////
			var tX : Number = 0;
			var gap : Number = 5;
			var bmpName : String = _type + "_" + _value;

			if (!(_value is String) && _value == 0) {
				bmpName = _type;
			}

			//
			if (_specialType) {
				bmpName = _specialType;
			}
			//
//			var texture : IStarlingTexture = GlobalSetting.starlingAssets.getTexture(bmpName);
//
//			if (texture) {
//				if (!_txtBmpStarling)
//					_txtBmpStarling = new Image(texture);
//				else
//					_txtBmpStarling.texture = texture;
//				addChild(_txtBmpStarling);
//				_txtBmpStarling.y = -gap;
//				tX = _txtBmpStarling.width;
//			}
//
//			if (!(_value is String) && (_value != 0)) //非字符串...那就是数值
//			{
//				/////////////////////////符号//////////////////////////
//				if (_value > 0)
//					texture = GlobalSetting.starlingAssets.getTexture(_type + "_jia");
//				else
//					texture = GlobalSetting.starlingAssets.getTexture(_type + "_jian");
//
//				if (!_plusBmpStarling)
//					_plusBmpStarling = new Image(texture);
//				else
//					_plusBmpStarling.texture = texture;
//				addChild(_plusBmpStarling);
//				_plusBmpStarling.x = tX + _specialOffsetPos.x;
//				_plusBmpStarling.y = _specialOffsetPos.y;
//				tX += _plusBmpStarling.width;
//				/////////////////////////数字//////////////////////////
//				var numStr : String = (Math.abs(_value as Number)).toString();
//				
//				for (var i : uint = 0; i < numStr.length; i++) {
//					var nStr : String = numStr.charAt(i);
//					var image : Image;
//					texture = GlobalSetting.starlingAssets.getTexture(_type + "_" + nStr);
//
//					switch (i) {
//						case 0: //个位
//							if (!_geBmpStarling)
//								_geBmpStarling = new Image(texture);
//							else
//								_geBmpStarling.texture = texture;
//							image = _geBmpStarling;
//							break;
//						case 1: //十位
//							if (!_shiBmpStarling)
//								_shiBmpStarling = new Image(texture);
//							else
//								_shiBmpStarling.texture = texture;
//							image = _shiBmpStarling;
//							break;
//						case 2: //百位
//							if (!_baiBmpStarling)
//								_baiBmpStarling = new Image(texture);
//							else
//								_baiBmpStarling.texture = texture;
//							image = _baiBmpStarling;
//							break;
//						case 3: //千位
//							if (!_qianBmpStarling)
//								_qianBmpStarling = new Image(texture);
//							else
//								_qianBmpStarling.texture = texture;
//							image = _qianBmpStarling;
//							break;
//						case 4: //万位
//							if (!_wanBmpStarling)
//								_wanBmpStarling = new Image(texture);
//							else
//								_wanBmpStarling.texture = texture;
//							image = _wanBmpStarling;
//							break;
//						case 5: //十万位
//							if (!_shiwanBmpStarling)
//								_shiwanBmpStarling = new Image(texture);
//							else
//								_shiwanBmpStarling.texture = texture;
//							image = _shiwanBmpStarling;
//							break;
//						case 6: //百万位
//							if (!_baiwanBmpStarling)
//								_baiwanBmpStarling = new Image(texture);
//							else
//								_baiwanBmpStarling.texture = texture;
//							image = _baiwanBmpStarling;
//							break;
//						case 7: //千万位
//							if (!_qianwanBmpStarling)
//								_qianwanBmpStarling = new Image(texture);
//							else
//								_qianwanBmpStarling.texture = texture;
//							image = _qianwanBmpStarling;
//							break;
//						case 8: //亿位
//							if (!_yiBmpStarling)
//								_yiBmpStarling = new Image(texture);
//							else
//								_yiBmpStarling.texture = texture;
//							image = _yiBmpStarling;
//							break;
//						case 9: //十亿位
//							if (!_shiyiBmpStarling)
//								_shiyiBmpStarling = new Image(texture);
//							else
//								_shiyiBmpStarling.texture = texture;
//							image = _shiyiBmpStarling;
//							break;
//					}
//					addChild(image);
//					image.x = (image.width - gap) * i + tX - 5 + _specialOffsetPos.x;
//					image.y = _specialOffsetPos.y;
//				}
//			}
		}
	}
}
