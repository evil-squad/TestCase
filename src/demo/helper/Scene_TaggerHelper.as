package demo.helper {

	import com.game.engine3D.manager.Stage3DLayerManager;
	import com.game.mainCore.libCore.handle.HandleThread;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import demo.display2D.AttackFace;
	import demo.display3D.Avatar3D;
	import demo.enum.LayerEnum;
	
	import gs.TimelineLite;
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Circ;
	import gs.easing.Linear;
	
	import starling.display.DisplayObject;

	/**
	 * @private
	 * head控制器(除换装外的一切)
	 * @author Carver
	 */
	public class Scene_TaggerHelper {
		/**
		 * 运行
		 */
		/*		public static function run():void
				{
					//获取系统时间
					var nowTime:Number = GlobalConfig.nowTime;
					//获取场景角色集合，并深度排序
					var scArr:Vector.<SceneCharacter> = Scene.scene.sceneCharacterList;
					var len:int = scArr.length;
					for (var i:int=0; i<len; i++)
					{
						var sc:SceneChar = scArr[i] as SceneChar;
						if(!sc || null==sc.headFace || !UserManager.isShowUserInfo)//如果不是就跳出单次循环
							continue;

						var str:String = "<font color='#cccccc'>" + sc.tile_x + "  " + sc.tile_y + "</font><br><font color='#FF0000'>" + sc.id + "</font><br><font color='#00FF00'>" + sc.status + "</font>";
						var baseInfo:BaseCharacterInfo = sc.data as BaseCharacterInfo;
						if(baseInfo)
						{
							str += "<br><font color='#FFFF00'>" + baseInfo.hp + "/" + baseInfo.hpMax + "</font>";
							str += "<br><font color='#00FF00'>" + sc.isServerLiving + "</font>";
						}
						sc.headFace.setCustomTitle(str);
					}
				}*/

		private static var _queueThread : HandleThread = new HandleThread(null, true, 20);

		/** 对方伤害掉血 **/
		public static function tweenTypeEnemyHurt(attackFace : DisplayObject, $offset : Point, $from : Point, $end : Point, isLeftShow : Boolean = false, onComplete : Function = null) : void {
			if (null == $from) {
				$from = new Point(0, -130);
			}

			if (null == $end) {
				$end = new Point(0, -180);
			}
			$from.offset($offset.x, $offset.y);
			$end.offset($offset.x, $offset.y);
			attackFace.x = (-attackFace.width >> 1) + $from.x;
			attackFace.y = $from.y;
			attackFace.scaleX = attackFace.scaleY = 0.2;
			attackFace.alpha = 1;
			$end.x += (-attackFace.width >> 1);
			var timeLine : TimelineLite = new TimelineLite();
			timeLine.insert(TweenLite.to(attackFace, 0.1, {x:$end.x, y:$end.y, scaleX:1, scaleY:1, ease:Linear.easeOut}));

			var tX : Number = attackFace.x + (isLeftShow ? -1 : 1) * 50;
			var tXAbs : int = Math.abs(tX) / tX;
			//执行缓动
			//然后以抛物线向左右飘50像素.
			var midPos : Point = new Point(tX, $end.y * 1.5);
			var endPos : Point = new Point(tX + tXAbs * 50, $from.y);
			timeLine.append(TweenMax.to(attackFace, 1, {scaleX:0.5, scaleY:0.5, alpha:0.5, bezier:[{x:midPos.x, y:midPos.y}, {x:endPos.x, y:endPos.y}], onComplete:onComplete, onCompleteParams:[attackFace], ease:Linear.easeNone}), 0.3);
		}

		/** 属性 **/
		public static function tweenTypeAttribute(attackFace : DisplayObject, $offset : Point, $from : Point, $end : Point, isLeftShow : Boolean = false, onComplete : Function = null) : void {
			if (null == $from) {
				$from = new Point(0, -60);
			}

			if (null == $end) {
				$end = new Point(0, -140);
			}
			$from.offset($offset.x, $offset.y);
			$end.offset($offset.x, $offset.y);

			attackFace.alpha = 1;
			attackFace.x = (-attackFace.width >> 1) + $from.x;
			attackFace.y = $from.y;

			$end.x += (-attackFace.width >> 1);
			var timeLine : TimelineLite = new TimelineLite();
			timeLine.insert(TweenLite.to(attackFace, 0.9, {x:$end.x, y:$end.y, ease:Linear.easeNone}));
			timeLine.append(TweenLite.to(attackFace, 0.2, {scaleX:0.8, scaleY:0.8, alpha:0, onComplete:onComplete, onCompleteParams:[attackFace], ease:Linear.easeInOut}));
		}

		/** 敌方扣血 **/
		public static function tweenTypeEnemyHpDecrease(attackFace : DisplayObject, $offset : Point, $from : Point, $end : Point, isLeftShow : Boolean = false, onComplete : Function = null) : void {
			if (null == $from) {
				$from = new Point(0, -60);
			}

			if (null == $end) {
				$end = new Point(0, -140);
			}
			$from.offset($offset.x, $offset.y);
			$end.offset($offset.x, $offset.y);

			attackFace.alpha = 1;
			attackFace.x = (-attackFace.width >> 1) + $from.x;
			attackFace.y = $from.y;
			$end.x += (-attackFace.width >> 1);
			var timeLine : TimelineLite = new TimelineLite();
			timeLine.insert(TweenLite.to(attackFace, 0.5, {x:$end.x, y:$end.y, ease:Circ.easeOut}));
			timeLine.append(TweenLite.to(attackFace, 0.2, {transformAroundCenter:{scaleX:0.8, scaleY:0.8}, alpha:0, onComplete:onComplete, onCompleteParams:[attackFace], ease:Linear.easeInOut}));
		}

		/** 属性 **/
		public static function tweenTypeGuJianLevelUp(attackFace : DisplayObject, $offset : Point, $from : Point, $end : Point, isLeftShow : Boolean = false, onComplete : Function = null) : void {
			if (null == $from) {
				$from = new Point();
			}

			if (null == $end) {
				$end = new Point();
			}
			$from.offset($offset.x, $offset.y);
			$end.offset($offset.x, $offset.y);

			attackFace.x = (-attackFace.width >> 1) + $from.x;
			attackFace.y = $from.y;
			$end.x += (-attackFace.width >> 1);
			attackFace.alpha = 1;
			var timeLine : TimelineLite = new TimelineLite();
			timeLine.insert(TweenLite.to(attackFace, 1, {x:$end.x, y:($end.y * 5 / 6)}));
			timeLine.append(TweenLite.to(attackFace, 0.5, {y:$end.y, alpha:0, onComplete:onComplete, onCompleteParams:[attackFace], ease:Linear.easeInOut}));
		}

		/** 自己伤害掉血 **/
		public static function tweenTypeMyHurt(attackFace : DisplayObject, $offset : Point, $from : Point, $end : Point, isLeftShow : Boolean = false, onComplete : Function = null) : void {
			if (null == $from) {
				$from = new Point(0, -50);
			}

			if (null == $end) {
				$end = new Point(0, -200);
			}
			$from.offset($offset.x, $offset.y);
			$end.offset($offset.x, $offset.y);

			attackFace.alpha = 1;
			attackFace.x = (-attackFace.width >> 1);
			attackFace.y = $from.y;
			$end.x += (-attackFace.width >> 1);
			var timeLine : TimelineLite = new TimelineLite();
			timeLine.insert(TweenLite.to(attackFace, 0.5, {y:$end.y, ease:Linear.easeNone}));
			timeLine.append(TweenLite.to(attackFace, 0.2, {scaleX:0.8, scaleY:0.8, alpha:0, onComplete:onComplete, onCompleteParams:[attackFace], ease:Linear.easeInOut}));
		}

		/** 闪避 **/
		public static function tweenTypeBlink(attackFace : DisplayObject, $offset : Point, $from : Point, $end : Point, isLeftShow : Boolean = false, onComplete : Function = null) : void {
			if (null == $from) {
				$from = new Point(-25, -85);
			}

			if (null == $end) {
				$end = new Point(-75, -120);
			}
			$from.offset($offset.x, $offset.y);
			$end.offset($offset.x, $offset.y);

			attackFace.alpha = 1;
			attackFace.x = (-attackFace.width >> 1) + $from.x;
			attackFace.y = $from.y;
			$end.x += (-attackFace.width >> 1);
			var timeLine : TimelineLite = new TimelineLite();
			timeLine.insert(TweenLite.to(attackFace, 0.7, {x:$end.x, y:$end.y, alpha:0, ease:Linear.easeNone}));
			timeLine.append(TweenLite.to(attackFace, 0.2, {transformAroundCenter:{scaleX:0.8, scaleY:0.8}, alpha:0, onComplete:onComplete, onCompleteParams:[attackFace], ease:Linear.easeInOut}));
		}

		//-----------------------------------------------------------以上是运动轨迹函数-----------------------------------------------------------//

		/**
		 * 从指定场景对象处飘出一个AttackFace对象
		 * @param $sc 开始飘字的场景对象
		 * @param $attackType 飘字类型
		 * @param $attackValue 飘出的数值
		 * @param $specialType 飘出的数值类型
		 * @param $specialPos 飘出的数值的偏移值
		 * @param $tweenFun
		 * @param $from
		 * @param $end
		 * @param $isLeftShow
		 * @param $queueTm
		 *
		 */
		public static function showQueueAttackFace($sc : Avatar3D, $attackType : String = "", $attackValue : * = 0, $specialType : String = null, $specialPos : Point = null, $tweenFun : Function = null, $from : Point = null, $end : Point = null, $isLeftShow : Boolean = false, $queueTm : uint = 250) : void {
			/*			if (!$sc.usable || !$sc.avatar.visible || $attackValue == 0)
						{
							return;
						}*/
			_queueThread.push(showAttackFace, [$sc, $attackType, $attackValue, $specialType, $specialPos, $tweenFun, $from, $end, $isLeftShow], $queueTm);
		}

		public static function showAttackFace(showContainer : *, $attackType : String = "", $attackValue : * = 0, $specialType : String = null, $specialPos : Point = null, $tweenFun : Function = null, $from : Point = null, $end : Point = null, isLeftShow : Boolean = false) : void {
			//todo  2015-1-2 刘阳修改 这里有$attackValue为0 的判断， 
			//比如“免疫”的飘字是没有数值变化的
			/*			if (!$sc.usable || !$sc.avatar.visible)
						{
							return;//因为showAttackFace方法显示的效果都只持续1.2秒，所以这个可以如此判断而直接返回,助于提升性能,HeadFace不能做类似此操作
						}*/

			//获取AttackFace
			var attackFace : AttackFace = AttackFace.createAttackFace($attackType, $attackValue, $specialType, $specialPos);
			tweenFromSceneChar(showContainer, attackFace, $from, $end, $tweenFun, isLeftShow, onAtackFaceComplete);
		}

		public static function showQueueTweenFromSceneChar($sc : Avatar3D, $displayObject : AttackFace, $from : Point, $end : Point, $funTween : Function = null, $isLeftShow : Boolean = false, $onComplete : Function = null, $queueTm : uint = 250) : void {
			_queueThread.push(tweenFromSceneChar, [$sc, $displayObject, $from, $end, $funTween, $isLeftShow, $onComplete], $queueTm);
		}

		/**
		 * 显示打击效果
		 *  @param $sc 角色
		 *  @param $attackType 伤害类型
		 *  @param $attackValue 伤害数值
		 */
		public static function tweenFromSceneChar(showContainer : *, $displayObject : AttackFace, $from : Point, $end : Point, $funTween : Function = null, $isLeftShow : Boolean = false, $onComplete : Function = null) : void {
			/*			if (!$sc.usable || !$sc.avatar.visible)
						{
							$onComplete($displayObject);		// 动画就算不播放，也要调用完成函数
							return;//因为showAttackFace方法显示的效果都只持续1.2秒，所以这个可以如此判断而直接返回,助于提升性能,HeadFace不能做类似此操作
						}
						//先保证$sc的container被启用
						$sc.enableContainer();*/
			tweenFrom(showContainer, $displayObject, $from, $end, $funTween, $isLeftShow, $onComplete);
		}

		public static function showQueueTweenFrom($displayObjectContainer : DisplayObjectContainer, $displayObject : DisplayObject, $from : Point, $end : Point, $funTween : Function = null, $isLeftShow : Boolean = false, $onComplete : Function = null, $queueTm : uint = 250) : void {
			_queueThread.push(tweenFrom, [$displayObjectContainer, $displayObject, $from, $end, $funTween, $isLeftShow, $onComplete], $queueTm);
		}

		public static function tweenFrom($displayObjectContainer : DisplayObjectContainer, $displayObject : AttackFace, $from : Point, $end : Point, $funTween : Function = null, $isLeftShow : Boolean = false, $onComplete : Function = null) : void {
			if (null == $displayObjectContainer) {
				$onComplete($displayObject); // 动画就算不播放，也要调用完成函数
				return;
			}
			Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ATTACK).addChild($displayObject);

			var offset : Point = new Point();
			offset = $displayObjectContainer.localToGlobal(offset);
			offset = Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ATTACK).globalToLocal(offset);

			if (null != $funTween) {
				$funTween($displayObject, offset, $from, $end, $isLeftShow, $onComplete);
			}
		}

		private static function onAtackFaceComplete($displayObject : DisplayObject) : void {
			var attackFace : AttackFace = $displayObject as AttackFace;

			if (null == attackFace)
				return;
			attackFace.alpha = attackFace.scaleX = attackFace.scaleY = 1;
			//
			TweenLite.killTweensOf(attackFace);

			//从场景中移除
			if (attackFace.parent)
				attackFace.parent.removeChild(attackFace);
			//池回收
			AttackFace.recycleAttackFace(attackFace);
		}
	}
}
