package demo.resource
{
	import flash.events.Event;
	
	import away3d.animators.IAnimatorOwner;
	import away3d.containers.CompositeAnimatorGroup;
	import away3d.containers.ObjectContainer3D;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.ParserEvent;
	import away3d.library.assets.AssetType;
	import away3d.materials.MaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	
	import demo.display3D.Particle3D;
	import demo.events.EvilEvent;
	
	public class Particle3DLoader1 extends Resource3DLoader1
	{
		private var _materialList:Vector.<SinglePassMaterialBase>;
		private var _particleOrigDic:Object;
		private var _particlePoolDic:Object;
		private var _ready:Boolean;
		private var _count:int;
		private var _alone:Boolean;
		
		public function Particle3DLoader1(Url:String, alone:Boolean)
		{
			_url = Url;
			_particleOrigDic = {};
			_particlePoolDic = {};
			_alone = _alone;
			_materialList = new Vector.<SinglePassMaterialBase>();
			load(_url);
		}
		
		public function get particleNum():int
		{
			return _count;
		}
		
		public function get isReady():Boolean
		{
			return _ready;
		}
		
		public function cloneParticle(childName:String):IAnimatorOwner
		{
			var particle:IAnimatorOwner;
			if(childName)
			{
				particle = _particleOrigDic[childName];
			}
			else
			{
				for each(particle in _particleOrigDic)
				{
					break;
				}
			}
			
			if(particle)
				particle = particle.clone() as IAnimatorOwner;
			return particle;
		}

		
		private function getPoolVector(childName:String):Vector.<Particle3D>
		{
			if(_alone)
				childName = _url;
			var vector:Vector.<Particle3D> = _particlePoolDic[childName] || new Vector.<Particle3D>();
			_particlePoolDic[childName] = vector;
			return vector;
		}
		
		override protected function onAssetComplete(e:AssetEvent):void
		{
			var obj:ObjectContainer3D;
			switch (e.asset.assetType) 
			{
				case AssetType.MESH:
				case AssetType.RIBBON:
				case AssetType.SPARTICLE_MESH:
					obj = e.asset as ObjectContainer3D;
					if(obj.parent == null)
					{
						_particleOrigDic[obj.name] = obj;
						getPoolVector(obj.name);
						_count ++;
					}
					break;
				case AssetType.MATERIAL:
					if(e.asset is MaterialBase)
					{
						var material:SinglePassMaterialBase = e.asset as SinglePassMaterialBase;
						_materialList.push(material);
					}
					break;
				case AssetType.CONTAINER:
				case AssetType.COMPOSITE_ANIMATOR_GROUP:
				case AssetType.PROPERTY_ANIMATOR_CONTAINER:
				case AssetType.CAMERAS_ACTIVE_CONTROL_GROUP:
				case AssetType.RESOURCE_BUNDLE_INSTANCE:
				case AssetType.SPRITE3D:	
					obj = e.asset as ObjectContainer3D;
					if(obj.parent == null)
					{
						if(obj is CompositeAnimatorGroup)
						{
							_particleOrigDic[obj.name] = obj;
							getPoolVector(obj.name);
							_count ++;
						}
					}
					break;
				
				default:
					break;
			}
		}
		
		override protected function onResourceComplete(e:LoaderEvent):void
		{
			_ready = true;
			removeLoaderEvents();
			this.dispatchEvent(new Event(e.type));
			
			var event:EvilEvent = new EvilEvent(EvilEvent.PARTICLE_SRC_COMPLETE);
			dispatchEvent(event);
		}
		
		override protected function onParseError(e:ParserEvent):void
		{
			removeLoaderEvents();
			this.dispatchEvent(new Event(e.type));
		}
		
		override protected function onLoadError(e:LoaderEvent):void
		{
			removeLoaderEvents();
			this.dispatchEvent(new Event(e.type));
		}
		
		public function getOne(childName:String):Particle3D
		{
			var vector:Vector.<Particle3D> = getPoolVector(childName);
			var ptc:Particle3D = vector.shift();
			if(ptc == null)
			{
				ptc = new Particle3D(this, childName);
			}
			
			ptc.start();
			ptc.setMyScale(1);
			ptc.x = ptc.y = ptc.z = 0;
			ptc.rotationX = ptc.rotationY = ptc.rotationZ = 0;
			return ptc;
		}
		
		public function setOne(ptc:Particle3D):void
		{
			if(ptc.parent)
			{
				ptc.parent.removeChild(ptc);
			}
			ptc.stop();
			ptc.setMyScale(1);
			ptc.x = ptc.y = ptc.z = 0;
			ptc.rotationX = ptc.rotationY = ptc.rotationZ = 0;
			var childName:String = ptc.childName;
			var vector:Vector.<Particle3D> = getPoolVector(childName);
			if(vector.indexOf(ptc) == -1)
			{
				vector.push(ptc);
			}
		}
		
		
		
		
		
	}
}