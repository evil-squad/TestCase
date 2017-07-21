package demo.display2D {

	import com.game.engine3D.core.StarlingLayer;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.Matrix3DUtils;
	import away3d.events.Object3DEvent;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Monster3D;
	import demo.enum.LayerEnum;
	import demo.managers.GameManager;
	
	import starling.display.BlendMode;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class TextFieldBind3D extends Sprite implements IBind3D {
		
		private static const Width 	: int = 70;
		
		private static var count 	: int;
		
		protected var _view 		: View3D;
		protected var _bindTarget 	: ObjectContainer3D;
		protected var _avatar3D 	: Avatar3D;
		protected var _bindOffset 	: Vector3D;
		protected var _sTextFiled 	: starling.text.TextField;
		protected var _sHPBar 		: Quad;
		protected var _sHPBgBar 	: Quad;

		private var _lastPercent 	: Number = 0;
		private var _myCount 		: int;
		private var _lastGod 		: Boolean;
			
		public function TextFieldBind3D() {
			super();
			
			_myCount = count++;
			
			_sTextFiled = new starling.text.TextField(Width, 20, "");
			_sTextFiled.y = _sTextFiled.y;

			_sHPBgBar = new Quad(Width, 5, 0x404040);
			_sHPBgBar.blendMode = BlendMode.NONE; //improve performance
			_sHPBar = new Quad(Width, 5, 0xffffff);
			_sHPBar.blendMode = BlendMode.NONE;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}


		public function updateHpBar() : void {
			var newValue : Number = 0;
			if (_avatar3D == null) {
				newValue = 0;
			} else {
				newValue = _avatar3D.hp / _avatar3D.maxHp;
				if (newValue < 0) {
					newValue = 0;
				} else if (newValue > 1) {
					newValue = 1;
				}
			}

			if (_lastPercent != newValue) {
				if (_avatar3D is Monster3D) {
					_sHPBar.color = 0xFF0000;
				} else {
					_sHPBar.color = 0x00FF00;
				}
				_sHPBar.width = Width * newValue;
				_lastPercent = newValue;
			}
			visible = visible && _avatar3D && _avatar3D.isDead == false;
		}
		
		override public function set visible(value : Boolean) : void {
			super.visible = value;
			_sTextFiled.visible = _sHPBar.visible = _sHPBgBar.visible = value;
		}
		
		public function set text(value : String) : void {
			_sTextFiled.text = value;
		}

		public function get bindAvatar() : Avatar3D {
			return _avatar3D;
		}

		public function set bindAvatar(target : Avatar3D) : void {
			_avatar3D = target;
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
				_view.stage.removeEventListener(Event.RESIZE, onViewResize);
			}
			_view = value;
			if (_view) {
				_view.camera.addEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onCameraSceneTransformChanged);
				_view.stage.addEventListener(Event.RESIZE, onViewResize);
			}
		}

		public function get view() : View3D {
			return _view;
		}

		public function addToLayer(layer : StarlingLayer) : void {
			layer.getLayer(LayerEnum.LAYER_HP).addChild(_sHPBgBar);
			layer.getLayer(LayerEnum.LAYER_HP).addChild(_sHPBar);
			layer.getLayer(LayerEnum.LAYER_NAME).addChild(_sTextFiled);
			updateTranform();
		}

		public function get bindOffset() : Vector3D {
			return _bindOffset;
		}

		public function set bindOffset(value : Vector3D) : void {
			_bindOffset = value;
		}

		public function updateTranform() : void {
			if (_view == null) {
				return;
			}
			
			var player : Avatar3D = GameManager.getInstance().mainRole;
			if (player == null) {
				visible = false;
				return;
			}

			if (player.distanceToPos(_avatar3D.x, _avatar3D.y) > 4000) {
				visible = false;
				return;
			}

			var pos3D : Vector3D = _bindTarget.scenePosition;
			if (_bindOffset) {
				pos3D = pos3D.add(_bindOffset);
			}
			
			var pos2D : Vector3D = _view.camera.project(pos3D, Matrix3DUtils.CALCULATION_VECTOR3D);
			if (pos2D.x < -1 || pos2D.x > 1 || pos2D.y < -1 || pos2D.y > 1) {
				visible = false;
				return;
			}

			pos2D = _view.project(pos3D, Matrix3DUtils.CALCULATION_VECTOR3D);
			if (pos2D.z > 0 && pos2D.z < 4000) {
				this.visible = _avatar3D && _avatar3D.godMode == false && _avatar3D.isDead == false;
				pos2D.x -= Width / 2;
				this.x = pos2D.x + _view.x;
				this.y = pos2D.y + _view.y;
			} else {
				this.visible = false;
			}
		}

		override public function set x(value : Number) : void {
			_sTextFiled.x = _sHPBgBar.x = _sHPBar.x = super.x = Math.round(value); // 转化为整数是为了避免文字变模糊
		}

		override public function set y(value : Number) : void {
			_sHPBgBar.y = _sHPBar.y = super.y = Math.round(value);
			_sTextFiled.y = _sHPBgBar.y - _sTextFiled.height;
		}

		public function onGodModeChange() : void {
			updateTranform();
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

		private function onAddedToStage(e : Event) : void {
			updateTranform();

			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		override public function dispose() : void {
			super.dispose();
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			bindAvatar = null;
			bindTarget = null;
			view = null;

			if (_sHPBar.parent) {
				_sHPBar.parent.removeChild(_sHPBar);
			}

			if (_sHPBgBar.parent) {
				_sHPBgBar.parent.removeChild(_sHPBgBar);
			}

			if (_sTextFiled.parent) {
				_sTextFiled.parent.removeChild(_sTextFiled);
			}
		}

	}
}
