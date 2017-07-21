package demo.display2D {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.Matrix3DUtils;
	import away3d.events.Object3DEvent;
	
	import demo.display3D.Avatar3D;

	public class SpriteBind3D extends Sprite implements IBind3D {
		
		protected var _view       : View3D;
		protected var _bindTarget : ObjectContainer3D;
		protected var _avatar3D   : Avatar3D;
		protected var _bindOffset : Vector3D;

		public function SpriteBind3D() {
			super();
		}

		public function dispose() : void {
			bindTarget = null;
			view = null;
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

		public function get bindAvatar() : Avatar3D {
			return _avatar3D;
		}

		public function set bindAvatar(target : Avatar3D) : void {
			_avatar3D = target;
		}

		public function set view(value : View3D) : void {
			if (_view) {
				_view.camera.removeEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onCameraSceneTransformChanged);
				_view.removeChild(this);
				_view.stage.removeEventListener(Event.RESIZE, onViewResize);
			}
			_view = value;

			if (_view) {
				_view.addChild(this);
				_view.camera.addEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onCameraSceneTransformChanged);
				_view.stage.addEventListener(Event.RESIZE, onViewResize);
				updateTranform();
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
