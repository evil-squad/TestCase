package demo.managers {

	import flash.utils.Dictionary;

	import demo.display3D.Particle3D;
	import demo.resource.Particle3DLoader1;

	public class ParticleManager {
		
		private var _loaderDic 		: Dictionary = new Dictionary();
		private var _autoRecycleDic : Dictionary = new Dictionary();

		private static var _instance : ParticleManager;

		public static function getInstance() : ParticleManager {
			_instance = _instance || new ParticleManager();
			return _instance;
		}

		public function ParticleManager() {
			
		}
		
		public function getParticle(fileName : String, childName : String, complete : Function = null, autoRecycleTime : int = 0) : Particle3D {
			var loader : Particle3DLoader1 = _loaderDic[fileName];

			if (loader == null) {
				loader = new Particle3DLoader1(fileName, childName == null);
				_loaderDic[fileName] = loader;
			}
			var ptc : Particle3D = loader.getOne(childName);
			ptc.recycleRemainTime = autoRecycleTime;
			ptc.activeParticle(complete);

			var list : Vector.<Particle3D>;

			if (autoRecycleTime > 0) {
				list = _autoRecycleDic[fileName];

				if (list == null) {
					list = new Vector.<Particle3D>();
					_autoRecycleDic[fileName] = list;
				}

				if (list.indexOf(ptc) == -1) {
					list.push(ptc);
				}
			}

			return ptc;
		}


		public function update(curTime : int, deltaTime : int) : void {
			recycleAutoParticleByTime(deltaTime);
		}


		//回收时间结束了的特效
		private function recycleAutoParticleByTime(deltaTime : int) : void {
			var particle : Particle3D;
			var list : Vector.<Particle3D>;

			for each (list in _autoRecycleDic) {
				for (var i : int = 0; i < list.length; i++) {
					particle = list[i];
					particle.recycleRemainTime -= deltaTime;

					if (particle.recycleRemainTime <= 0) {
						list.splice(i, 1);
						recycleParticle(particle);
						i--;
					}
				}
			}
		}

		//回收所有需要自动回收的特效
		public function recycleAllAutoParticle() : void {
			var particle : Particle3D;
			var list : Vector.<Particle3D>;

			for each (list in _autoRecycleDic) {
				for each (particle in list) {
					recycleParticle(particle);
				}
			}

			_autoRecycleDic = new Dictionary();
		}
		
		public function recycleParticle(ptc : Particle3D) : void {
			var pool : Particle3DLoader1 = _loaderDic[ptc.url];
			ptc.deactiveParticle();
			pool.setOne(ptc);
		}

	}

}


