package demo.ui
{

	import com.game.engine3D.display.Inter3DContainer;
	
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import away3d.events.Event;
	
	import feathers.controls.StateSkin;
	import feathers.core.FeathersControl;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * stateSkin对应的显示容器基类
	 * @author wewell
	 */
	public class SkinUI extends Inter3DContainer
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT : Point = new Point();

		protected var _stage : Stage;
		protected var _stateSkin : StateSkin;
		protected var _parentContainer : DisplayObjectContainer;
		private var _hitArea : Rectangle;

		public function SkinUI(skin : StateSkin = null)
		{
			if (skin != null)
			{
				skin.toSprite(this);
				if (skin.width && skin.height)
				{
					_hitArea = new Rectangle();
					_hitArea.width = skin.width;
					_hitArea.height = skin.height;
				}
			}
			_stateSkin = skin;
			this.addEventListener(Event.ADDED_TO_STAGE, __onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, __onRemoveFromStage);

			_stage = Starling.current.nativeStage;
		}

		private function __onStageResize(e : *) : void
		{
			if (_stage != null)
				onStageResize(_stage.stageWidth, _stage.stageHeight);
		}

		private function __onAddedToStage(e : Event = null) : void
		{
			startRender3D();
			onShow();
			refresh();
			onStageResize(_stage.stageWidth, _stage.stageHeight);
			updateFadeAlphaRectPos();
			_stage.addEventListener(Event.RESIZE, __onStageResize);
			this.addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
		}

		private function __onRemoveFromStage(e : Event = null) : void
		{
			stopRender3D();
			onHide();
			_stage.removeEventListener(Event.RESIZE, __onStageResize);
			this.removeEventListener(starling.events.TouchEvent.TOUCH, onTouch);
		}

		protected function onStageResize(sw : int, sh : int) : void
		{

		}

		/**
		 *当面板被点击时
		 */
		protected function onTouch(e : TouchEvent) : void
		{
			var t : Touch = e.getTouch(this, TouchPhase.ENDED);
			if (t != null && t.target != null && this.stage != null)
			{
				t.getLocation(this.stage, HELPER_POINT);
				var isInBounds : Boolean = true;
				if (t.target is DisplayObjectContainer)
				{
					isInBounds = DisplayObjectContainer(t.target).contains(this.stage.hitTest(HELPER_POINT));
				}
				var isEnabled : Boolean = true;
				if (t.target is FeathersControl)
				{
					isEnabled = FeathersControl(t.target).isEnabled;
				}
				if (isInBounds && isEnabled)
					onTouchTarget(t.target);
			}
		}

		/**
		 *当子对象被点击后的处理。默认已实现关闭按钮被点击后的处理，关闭按钮名称为"btnClose"或"closeBtn"时生效
		 *子类可以覆盖此方法以实现特定目标被点击后的处理
		 */
		protected function onTouchTarget(target : DisplayObject) : void
		{
			var name : String = target.name;
			switch (name)
			{
				case "btnClose":
				case "closeBtn":
					this.removeFromParent();
					break;
			}
		}

		/**
		 * 被动方法，当SkinUI子类实例被添加到显示列表后会被调用
		 *
		 */
		protected function onShow() : void
		{
			//增加事件监听
			//启动计时器
			//..
		}

		/**
		 *
		 * 被动方法,当SkinUI子类实例从显示列表移除后会被调用
		 */
		protected function onHide() : void
		{
			//移除事件监听
			//停止计时器
			//..
		}

		override public function getBounds(targetSpace : DisplayObject, resultRect : Rectangle = null) : Rectangle
		{
			return _hitArea ? _hitArea : super.getBounds(targetSpace, resultRect);
		}

		/**
		 * 当外部设置visible属性时
		 * visible=true,播放3D动画,监听鼠标事件，执行onShow
		 * visible=false,则停止3D动画,删除鼠标监听，执行onHide
		 * @param value
		 *
		 */
		override public function set visible(value : Boolean) : void
		{
			if (super.visible == value)
				return;
			super.visible = value;
			if (value)
			{
				if (stage != null)
					__onAddedToStage();
			}
			else
			{
				__onRemoveFromStage();
			}
		}

		//刷新显示
		public function refresh() : void
		{

		}

		override public function dispose() : void
		{
			this.removeEventListener(starling.events.TouchEvent.TOUCH, onTouch);
			this.removeEventListener(Event.ADDED_TO_STAGE, __onAddedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, __onRemoveFromStage);
			while (this.numChildren)
				this.removeChildAt(0);
			if (_stage)
			{
				_stage.removeEventListener(Event.RESIZE, __onStageResize);
				_stage = null;
			}
			super.dispose();
		}
	}
}
