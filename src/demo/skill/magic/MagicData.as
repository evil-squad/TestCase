package demo.skill.magic
{
	
	import flash.utils.Dictionary;
	
	public class MagicData
	{
		private static var _MagicClassPool:Dictionary;
		
		public static const Null:int = 0;
		public static const Magic_1:int = 1;//直线飞行的弹道
		public static const Magic_2:int = 2;//未使用
		public static const Magic_3:int = 3;//boss的16个方向飞弹
		public static const Magic_4:int = 4;//boss前面喷出的火
		public static const Magic_5:int = 5;//会拐弯的弹道
		
		public static const Magic_200:int = 200;//弓箭手普通攻击的弹道
		public static const Magic_210:int = 210;//弓箭手210的弹道
		public static const Magic_250:int = 250;//弓箭手250的弹道
		
		public static const Magic_Light:int = 260;//闪电链弹道
		
		public static const JumpPort:int = 10001;
		
		public function MagicData()
		{
		}
		
		public static function getClass(id:int):Class
		{
			if(_MagicClassPool == null)
			{
				_MagicClassPool = new Dictionary();
				_MagicClassPool[Null] = null;
				_MagicClassPool[JumpPort] = MagicJumpPort;
				_MagicClassPool[Magic_1] = MagicObject_1;
				_MagicClassPool[Magic_3] = MagicObject_3;
				_MagicClassPool[Magic_4] = MagicObject_4;
				_MagicClassPool[Magic_5] = MagicObject_5;
				_MagicClassPool[Magic_200] = MagicObject_200;
				_MagicClassPool[Magic_210] = MagicObject_210;
				_MagicClassPool[Magic_250] = MagicObject_250;
				_MagicClassPool[Magic_Light] = MagicObject_Light;
			}
			
			var cls:Class = _MagicClassPool[id];
			return cls;
			
		}
		
		
		
	}
}

