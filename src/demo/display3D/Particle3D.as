package demo.display3D {

	import away3d.animators.CameraVibrateAnimator;
	import away3d.animators.CompositeAnimator;
	import away3d.animators.IAnimatorOwner;
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.animators.data.CompositeAnimatorInstance;
	import away3d.cameras.iCamera3DAnimator;
	import away3d.containers.CompositeAnimatorGroup;
	import away3d.containers.ObjectContainer3D;
	
	import demo.events.EvilEvent;
	import demo.resource.Particle3DLoader1;
	import demo.utils.FrameDispatch;

	/**
	 * 粒子系统 
	 * @author chenbo
	 * 
	 */	
	public class Particle3D extends ObjectContainer3D {
		
		public var recycleRemainTime: int;
		
		private var _url 			: String;																			
		private var _particle 		: IAnimatorOwner;
		private var _autoPlay 		: Boolean;
		private var _pool 			: Particle3DLoader1;
		private var _cameraPlaying 	: Boolean;
		private var _initHandler 	: Function;
		private var _myScale 		: Number = 1;
		private var _childName 		: String;
		private var _camera3DAnims  : Vector.<iCamera3DAnimator> = new Vector.<iCamera3DAnimator>;
		
		public function get autoPlay() : Boolean {
			return _autoPlay;
		}
		
		public function Particle3D(pool : Particle3DLoader1, childName : String) {
			super();
			_pool = pool;
			_url = _pool.url;
			_childName = childName;
		}

		public function get url() : String {
			return _url;
		}

		public function get particle() : IAnimatorOwner {
			return _particle;
		}

		public function get childName() : String {
			return _childName;
		}

		public function get initSucess() : Boolean {
			return _particle != null;
		}

		public function setMyScale(value : Number) : void {
			if (_myScale == value)
				return;
			scale(value / _myScale);
			_myScale = value;
		}

		public function activeParticle(initHandler : Function = null) : void {
			_initHandler = initHandler;
			if (_particle == null) {
				if (_pool.isReady) {
					initParticel(_pool.cloneParticle(_childName));
				} else {
					_pool.addEventListener(EvilEvent.PARTICLE_SRC_COMPLETE, onParticlePoolComplete);
				}
			} else if (_initHandler != null) {
				FrameDispatch.addFun(_initHandler, this);
				//_initHandler(this);
				_initHandler = null;
			}
		}

		public function deactiveParticle() : void {
			_initHandler = null;
			_pool.removeEventListener(EvilEvent.PARTICLE_SRC_COMPLETE, onParticlePoolComplete);
		}

		private function initParticel(particle : IAnimatorOwner) : void {
			_particle = particle;

			if (_particle) {
				(_particle as ObjectContainer3D).rotationY = 180;
				addChild(_particle as ObjectContainer3D);
			}

			if (_particle is CompositeAnimatorGroup) {
				for each (var instance : CompositeAnimatorInstance in CompositeAnimator(CompositeAnimatorGroup(_particle).animator).subAnimators) {
					if (instance.animator is CameraVibrateAnimator) {
						_camera3DAnims.push(instance.animator as CameraVibrateAnimator);
					}
				}
			}
		
			if (_autoPlay) {
				start();
			} else {
				stop();
			}

			if (_initHandler != null) {
				FrameDispatch.addFun(_initHandler, this);
				_initHandler = null;
					//_initHandler(this);
			}
		}

		private function onParticlePoolComplete(e : EvilEvent) : void {
			if (_pool.isReady) {
				activeParticle(_initHandler);
			}
		}
		
		public function start() : void {
			if (_particle) {
				if (_particle is VertexAnimator) {
					var vertexAnimator : VertexAnimator = _particle as VertexAnimator;
					vertexAnimator.play((vertexAnimator.animationSet as VertexAnimationSet).animationNames[0], null, 0);
				}
				_particle.animator.start(0);
				_cameraPlaying = true;
			}
			_autoPlay = true;
		}


		public function stop() : void {
			if (_particle) {
				_particle.animator.stop(true);
				_cameraPlaying = false;
			}
			_autoPlay = false;
		}

		override public function dispose() : void {
			throw new Error("should not be dispose here!!");
		}
		
	}
}
