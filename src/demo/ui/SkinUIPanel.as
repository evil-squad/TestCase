package demo.ui
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import demo.enum.LayerEnum;
	import demo.enum.PanelPosType;
	import demo.vo.AppInfo;
	
	import feathers.controls.StateSkin;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDragSource;
	import feathers.events.DragDropEvent;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 *基于skinState配置的app面板基类,
	 *有拖动功能:dargAble=true; 模态功能:model=true; Esc快捷关闭功能:escExcuteAble=true;
	 * @author wewell
	 */
	public class SkinUIPanel extends SkinUI implements IDragSource
	{
		protected var _escAble : Boolean = true;
		protected var _model : Boolean = false;
		protected var _appInfo : AppInfo;
		protected var _data : Object;
		protected var _openTab : String;

		public function SkinUIPanel(skin : StateSkin)
		{
			super(skin);

			dragAble = true;
		}

		/**
		 * esc快捷关闭是否可用
		 * @param value
		 *
		 */
		public function set escExcuteAble(value : Boolean) : void
		{
			_escAble = value;
		}

		/**
		 *模态,设置为true时 esc快捷关闭键以及面板拖动功能将自动失效
		 */
		public function set model(value : Boolean) : void
		{
			if (_model == value)
				return;
			if (value)
			{
				escExcuteAble = dragAble = false;
			}
			switchModel(value);
		}

		/**
		 * 当舞台尺寸变化后
		 * @param sw 舞台宽
		 * @param sh 舞台高
		 *
		 */
		override protected function onStageResize(sw : int, sh : int) : void
		{
//			if(_blackShape)_blackShape.removeFromParent();

			var xx : int, yy : int;
			if (!_appInfo)
			{
				xx = (sw - this.width) / 2;
				yy = (sh - this.height) / 2;
				this.x = xx;
				this.y = yy;
			}
			else
			{
				switch (_appInfo.posType)
				{
					case PanelPosType.MIDDLE_CENTRAL:
						xx = (sw - this.width) / 2;
						yy = (sh - this.height) / 2;
						break;
					case PanelPosType.MIDDLE_LEFT:
						xx = 0;
						yy = (sh - this.height) / 2;
						break;
					case PanelPosType.MIDDLE_RIGHT:
						xx = sw - this.width;
						yy = (sh - this.height) / 2;
						break;
					case PanelPosType.TOP_CENTRAL:
						xx = (sw - this.width) / 2;
						yy = 0;
						break;
					case PanelPosType.TOP_LEFT:
						xx = 0;
						yy = 0;
						break;
					case PanelPosType.TOP_RIGHT:
						xx = sw - this.width;
						yy = 0;
						break;
					case PanelPosType.BOTTOM_CENTRAL:
						xx = (sw - this.width) / 2;
						yy = sh - this.height;
						break;
					case PanelPosType.BOTTOM_LEFT:
						xx = 0;
						yy = sh - this.height;
						break;
					case PanelPosType.BOTTOM_RIGHT:
						xx = sw - this.width;
						yy = sh - this.height;
						break;
				}
				this.x = xx + _appInfo.pX;
				this.y = yy + _appInfo.pY;
			}
			switchModel(_model);
		}

		private function switchModel(value : Boolean) : void
		{
			_model = value;
//			UIModel.instence.switchModel(_model);
		}

		//==================================DragDrop============================================
		private static const DRAG_FORMAT : String = "draggablePanel";
		private var _dragAble : Boolean = true;
		private var _touchID : int = -1;
		private var _draggedObject : DisplayObject;
		private var _touchOffX : int;
		private var _touchOffY : int;

		public function set dragAble(b : Boolean) : void
		{
			_dragAble = b;
			b ? activeDragDrop() : inactiveDragDrop();
		}

		public function get dragAble() : Boolean
		{
			return _dragAble;
		}

		private function activeDragDrop() : void
		{
			this.addEventListener(starling.events.TouchEvent.TOUCH, touchHandler);
			this.addEventListener(DragDropEvent.DRAG_START, dragStartHandler);
			this.addEventListener(DragDropEvent.DRAG_COMPLETE, dragCompleteHandler);
		}

		private function inactiveDragDrop() : void
		{
			this.removeEventListener(starling.events.TouchEvent.TOUCH, touchHandler);
			this.removeEventListener(DragDropEvent.DRAG_START, dragStartHandler);
			this.removeEventListener(DragDropEvent.DRAG_COMPLETE, dragCompleteHandler);
		}

		private function touchHandler(event : starling.events.TouchEvent) : void
		{
			if (DragDropManager.isDragging)
			{
				//one drag at a time, please
				return;
			}
			if (this._touchID >= 0)
			{
				var touch : Touch = event.getTouch(this._draggedObject, null, this._touchID);
				if (!touch)
				{
					this._touchID = -1;
					return;
				}

				if (touch.phase == TouchPhase.MOVED)
				{
					//仅点中背景层时才允许被拖动,bg必须是第０层
					if (this.getChildAt(0) != touch.target)
					{
						return;
					}

					this._touchID = -1;
					this._touchOffX = touch.globalX - this.x;
					this._touchOffY = touch.globalY - this.y;

					var dragData : DragData = new DragData();
					dragData.setDataForFormat(DRAG_FORMAT, this._draggedObject);
					DragDropManager.startDrag(this, touch, dragData);
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
					this._touchID = -1;
				}
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if (!touch)
				{
					return;
				}
				this._touchID = touch.id;
				this._draggedObject = touch.target;
			}
		}

		private function dragStartHandler(event : DragDropEvent, dragData : DragData) : void
		{
			this.addEventListener(starling.events.TouchEvent.TOUCH, onDragMove);
		}

		private function onDragMove(event : starling.events.TouchEvent) : void
		{
			var touch : Touch = event.getTouch(this);
			if (touch && touch.phase == TouchPhase.MOVED)
			{
				this.x = int(touch.globalX - _touchOffX);
				this.y = int(touch.globalY - _touchOffY);
			}
		}

		private function dragCompleteHandler(event : DragDropEvent, dragData : DragData) : void
		{
			this.removeEventListener(starling.events.TouchEvent.TOUCH, onDragMove);
			if (event.isDropped)
			{

			}
			else
			{
				//the drag cancelled and the object was not dropped
			}
		}

		//==========================model==============================
		//
		//==========================implements==============================
		//
		public function set appinfo(value : AppInfo) : void
		{
			if (_appInfo == value)
				return;
			_appInfo = value;
		}
		
		public function get appinfo() : AppInfo
		{
			return _appInfo;
		}
		
		/**
		 *  添加到显示列表
		 * @param data 界面显示需要的自定义数据
		 * @param openTable 需要打开的tab页，兼容古剑代码
		 * @param parentContiner 被添加到的父容器
		 *
		 */
		public function show(data : * = null, openTable : String = "", parentContiner : DisplayObjectContainer = null) : void
		{
			_data = data;
			_openTab = openTable;
			if (parentContiner == null)
			{
				parentContiner = Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_APP);
			}
			_parentContainer = parentContiner;

			_parentContainer.addChild(this);

		}

		/**
		 *从显示列表移除，但并不销毁
		 */
		public function hide() : void
		{
			this.removeFromParent();
		}

		public function get parentContainer() : DisplayObjectContainer
		{
			return _parentContainer;
		}

		public function isHideEffecting() : Boolean
		{
			return true;
		}

		public function showCloseGuide(isShowBg : Boolean, bgAlpha : Number) : void
		{

		}

		/**
		 *当Panel被点击时置顶
		 */
		override protected function onTouch(e : TouchEvent) : void
		{
			var t : Touch = e.getTouch(this, TouchPhase.BEGAN);
			if (t != null && t.target != null && this.stage != null)
			{
				if (this.parent.getChildIndex(this) != this.parent.numChildren - 1)
				{
					this.parent.addChild(this);
				}
			}

			super.onTouch(e);
		}

		override protected function onTouchTarget(target : DisplayObject) : void
		{
			var name : String = target.name;
			switch (name)
			{
				case "btnClose":
				case "closeBtn":
					this.hide();
					break;
			}
		}

		//==========================implements IEscExcute==============================
		//
		public function excute() : void
		{
			if (_escAble)
				hide();
		}

		override public function dispose() : void
		{
			super.dispose();
			model = false;
			_appInfo = null;
			_data = null;
			_openTab = null;
			_parentContainer = null;
		}
	}
}

