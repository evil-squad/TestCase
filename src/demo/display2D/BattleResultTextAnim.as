package demo.display2D {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.Matrix3DUtils;
	import away3d.events.Object3DEvent;

	import demo.display3D.Avatar3D;
	import demo.utils.ColorUtils;

	public class BattleResultTextAnim extends Sprite implements IBind3D {
		
		private static const Width  : int = 120;
		
		private var _alpha 			: Number = 2;
		
		protected var _view 		: View3D;
		protected var _bindTarget 	: ObjectContainer3D;
		protected var _role3D 		: Avatar3D;
		protected var _bindOffset 	: Vector3D;
		protected var _textField 	: TextField;
		protected var _textFormat 	: TextFormat;

		public function BattleResultTextAnim() {
			super();
			
			mouseChildren = mouseEnabled = false;

			_textFormat = new TextFormat("宋体", 12, 0xff9900);
			_textFormat.align = TextFormatAlign.CENTER;

			_textField = new TextField();
			_textField.width = Width;
			_textField.height = 100;
			_textField.setTextFormat(_textFormat);
			
			addChild(_textField);
			
			ColorUtils.defaultStroke(_textField);
			cacheAsBitmap = true;
		}

		public function init(value : String, color : uint) : void {
			_textFormat.color = color;
			_textField.y = 0;
			_textField.alpha = 1;
			_alpha = 2;
			text = value;
		}

		public function set text(value : String) : void {
			_textField.text = value + "";
			_textField.setTextFormat(_textFormat);
		}

		public function get bindAvatar() : Avatar3D {
			return _role3D;
		}

		public function set bindAvatar(target : Avatar3D) : void {
			_role3D = target;
		}

		public function get bindTarget() : ObjectContainer3D {
			return _bindTarget;
		}

		public function set bindTarget(value : ObjectContainer3D) : void {
			if (_bindTarget) {
				_bindTarget.removeEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onBindTargetSceneTransformChanged);
			}
			_bindTarget = value;

			if (_bindTarget) {
				_bindTarget.addEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onBindTargetSceneTransformChanged);
			}
		}

		public function set view(value : View3D) : void {
			if (_view) {
				_view.camera.removeEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onCameraSceneTransformChanged);
				_view.removeChild(this);
				_view.stage.removeEventListener(Event.RESIZE, onViewResize);
				_view.stage.removeEventListener(Event.ENTER_FRAME, updateTextPosition);
			}
			_view = value;

			if (_view) {
				_view.addChild(this);
				_view.camera.addEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onCameraSceneTransformChanged);
				_view.stage.addEventListener(Event.RESIZE, onViewResize);
				_view.stage.addEventListener(Event.ENTER_FRAME, updateTextPosition);
			}
		}

		public function get view() : View3D {
			return _view;
		}

		public function get bindOffset() : Vector3D {
			return _bindOffset;
		}

		public function set bindOffset(value : Vector3D) : void {
			_bindOffset = value;
		}

		private function updateTextPosition(e : Event) : void {
			_alpha -= 0.05;
			_textField.y -= 2;

			if (_alpha > 1) {
				_textField.alpha = 1;
			} else {
				_textField.alpha = _alpha;
			}

			if (_alpha <= 0) {
				view = null;
				bindAvatar = null;
				bindTarget = null;
			}
		}

		public function updateTranform() : void {
			var pos3D : Vector3D = _bindTarget.scenePosition;

			if (_bindOffset)
				pos3D = pos3D.add(_bindOffset);

			var pos2D : Vector3D = _view.camera.project(pos3D, Matrix3DUtils.CALCULATION_VECTOR3D);

			if (pos2D.x < -1 || pos2D.x > 1 || pos2D.y < -1 || pos2D.y > 1) {
				this.visible = false;
				return;
			}
			pos2D = _view.project(pos3D, Matrix3DUtils.CALCULATION_VECTOR3D);

			if (pos2D.z > 0 && pos2D.z < 4000) {
				this.visible = true;
				pos2D.x -= width / 2;
				pos2D.y -= height / 2 - 50;
				this.x = pos2D.x;
				this.y = pos2D.y;
			} else {
				this.visible = false;
			}
		}


		private function onBindTargetSceneTransformChanged(e : Object3DEvent) : void {
			updateTranform();
		}

		private function onCameraSceneTransformChanged(e : Object3DEvent) : void {
			updateTranform();
		}

		private function onViewResize(e : Event) : void {
			updateTranform();
		}
	}
}

