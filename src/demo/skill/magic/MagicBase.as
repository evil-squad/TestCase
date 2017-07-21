package demo.skill.magic
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.WireframeLines;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Operator3D;
	import demo.enum.EleEnum;
	import demo.managers.ParticleManager;
	
	public class MagicBase extends Operator3D
	{
		private var _angle:Number;
		private var _ownerId:uint;
		private var _suffererId:uint;
		private var _createrTarget:Avatar3D;
		private var _debuging:Boolean;
		protected var _particleManager:ParticleManager;
		
		//该数据应该在对象创建完毕之后变为true，同时移除圈圈
		private var _circleNode:ObjectContainer3D;
		private var _timeHandler:Dictionary;
		protected var _configId:int;
		
		public function get configId():int{ return _configId;}
		public function get creater():Avatar3D{ return _createrTarget;}
		public function get isDebuging():Boolean{ return _debuging;}
		public function get suffererId():uint{ return _suffererId; }
		public var recycleEnable:Boolean;
		public function MagicBase(Id:uint, OwnerId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0)
		{
			super(Id);
			setGroundXY(X, Y);
		}
		
		public function initMagicData(Id:uint, OwnerId:uint, ConfigId:int, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):void
		{
			resetMagic(Id);
			_suffererId = TargetId;
			_configId = ConfigId;
			_eleType = EleEnum.ELE_TYPE_MAGIC;
			_ownerId = OwnerId;
			_createrTarget = _world.getAvatar3D(OwnerId);
			_particleManager = ParticleManager.getInstance();
		}
		
		public function resetMagic(Id:int = 0, Name:String = null):void
		{
			_debuging = false;
			_angle = 0;
			_ownerId = 0;
			_createrTarget = null;
			_configId = 0;
			_timeHandler = null;
			recycleEnable = false;
			//
			resetElement(Id, Name);
		}
		
		
		private function showDebug():void
		{
			_debuging = true;
			if(_circleNode == null)
			{
				_circleNode = createDebugCircle();
				graphicDis.addChild(_circleNode);
			}
		}
		
		public static function reduceCache():int
		{
			var result:int;
			var count:int;
			var magic:MagicBase;
			
			for each(var pool:Array in _MagicPool)
			{
				if(pool == null)
					continue;
				count = pool.length * 0.4;
				while(count > 0)
				{
					magic = pool.shift() as MagicBase;
					magic.dispose();
					count --;
					result ++;
				}
			}
			
			return result;
			
		}
		
		private static var _MagicPool:Object = {};
		
		public static function RecycleMagic(magic:MagicBase):void
		{
//			var list:Array = _MagicPool[magic.configId];
//			if(list == null)
//			{
//				list = [];
//				_MagicPool[magic.configId] = list;
//			}
//			
//			magic.resetMagic();
//			list.push(magic);
		}
		
		public static function CreateMagic(Id:uint, OwnerId:uint, ConfigId:uint, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):MagicBase
		{
			var list:Array = _MagicPool[ConfigId];
			if(list == null)
			{
				list = [];
				_MagicPool[ConfigId] = list;
			}
			
			var magic:MagicBase;
			if(list.length > 0)
			{
				magic = list.shift() as MagicBase;
			}
			else
			{
				var cls:Class = MagicData.getClass(ConfigId);
				if(cls == null)
				{
					magic = new MagicBase(Id, OwnerId, X, Y);
					magic.showDebug();
				}
				else
				{
					magic = new cls(Id, OwnerId, X, Y);
				}
			}
			
			magic.recycleEnable = false;
			magic.initMagicData(Id, OwnerId, ConfigId, TargetId, X, Y, Arg1, Arg2);
			return magic;
		}
		
		private function createDebugCircle():ObjectContainer3D
		{
			var points:Vector.<Vector3D> = new Vector.<Vector3D>;
			var p:Vector3D;
			var span:int = 150;
			var color:int = 0x00FF00;
			var avatar:Avatar3D = _createrTarget as Avatar3D;
			if(avatar)
			{
				color = avatar.attackAble ? 0xFF0000 : 0x00FF00;
			}
			
			for (var i:int = 0; i < 16; i++)
			{
				p = new Vector3D;
				p.x = Math.cos(Number(i) / 16 * Math.PI * 2 + Math.PI / 16) * span;
				p.y = 0;
				p.z = Math.sin(Number(i) / 16 * Math.PI * 2 + Math.PI / 16) * span;
				points.push(p);
				p = new Vector3D;
				p.x = Math.cos(Number(i + 1) / 16 * Math.PI * 2 + Math.PI / 16) * span;
				p.y = 0;
				p.z = Math.sin(Number(i + 1) / 16 * Math.PI * 2 + Math.PI / 16) * span;
				points.push(p);
			}
			
			_circleNode = graphicDis.addChild(new WireframeLines(points, color));
			_circleNode.y = 40;
			
			return _circleNode;
		}
		
		protected function init(Angle:Number = 0, Radius:Number = 0) : void
		{
			setAngle(Angle);
		}
		
		private function setAngle(angle:Number) : void
		{
			_angle = angle;
		}
		
		protected function updatePosition():void
		{
			if(_createrTarget)
			{
				setGroundXY(_createrTarget.x, _createrTarget.z);
			}
			else
			{
				setGroundXY(x, z);
			}
		}
		
		override public function run(deltaTime:uint) : void
		{
			super.run(deltaTime);
			handlerWithCurTime();
			updatePosition();
		}
		
		protected function addTimeHandlerAt(time:int, fun:Function):void
		{
			_timeHandler = _timeHandler || new Dictionary();
			_timeHandler[time] = fun;
		}
		
		
		private function handlerWithCurTime():void
		{
			var fun:Function;
			var minTime:int = int.MAX_VALUE;
			for(var time:* in _timeHandler)
			{
				if(time < minTime)
				{
					minTime = time;
				}
			}
			
			if(lastTime > minTime)
			{
				fun = _timeHandler[minTime];
				delete _timeHandler[minTime];
				fun();
			}
		}
		
		override public function dispose():void
		{
			resetMagic(0, null);
			super.dispose();
		}
		
		//该对象开始作用。
		public function onNetActive(Value:uint):void
		{
			
		}
		
		
	}
}

