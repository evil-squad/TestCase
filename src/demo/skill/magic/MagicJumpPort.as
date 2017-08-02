package demo.skill.magic
{
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.managers.GameManager;
	
	public class MagicJumpPort extends MagicBase
	{
		private var _circleEffect:Particle3D;
		private var _outSideBefore:Boolean;
		
		private var _checkRemainTime:int;
		private static const CheckDelay:int = 400;
		public function MagicJumpPort(Id:uint, OwnerId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0)
		{
			super(Id, OwnerId, X, Y);
		}
		
		override public function set state(value:int):void
		{
			super.state = value;
			_outSideBefore = value > 0;
		}
		
		override public function initMagicData(Id:uint, OwnerId:uint, ConfigId:int, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):void
		{
			super.initMagicData(Id, OwnerId, ConfigId, TargetId, X, Y, Arg1, Arg2);
			_outSideBefore = false;
			setGroundXY(X, Y);
		}
		
		override protected function updatePosition():void
		{
			super.updatePosition();
		}
		
		override public function resetMagic(Id:int=0, Name:String=null):void
		{
			if(_circleEffect)
			{
				_particleManager.recycleParticle(_circleEffect);
				_circleEffect = null;
			}
			super.resetMagic(Id, Name);
		}
		
		private function checkJump():void
		{
			if(_checkRemainTime < CheckDelay)
				return;
			
			var me:Avatar3D = GameManager.getInstance().mainRole;
			if(me == null)
				return;
			
			if(_outSideBefore == false)
			{
				if(me.distanceToPos(x, z) > 200)
				{
					_outSideBefore = true;
				}
			}
			else
			{
				if(me.distanceToPos(x, z) <= 200)
				{
					GameManager.getInstance().nextScene();
					_outSideBefore = false;
				}
			}
			
		}
		
		override public function run(deltaTime:uint):void
		{
			super.run(deltaTime);
			_checkRemainTime += deltaTime;
			checkJump();
		}
		
		
	}
}

