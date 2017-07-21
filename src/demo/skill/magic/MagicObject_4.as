package demo.skill.magic
{
	import flash.geom.Vector3D;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.SkillManager;
	import demo.skill.SkillDetailVO;
	
	public class MagicObject_4 extends MagicBase
	{
		private var _explodeEffect:Particle3D;
		
		private var _ownerPlayer:Avatar3D;
		private var _lastHeightPos:Number = 0;
		private static const BallSpeed:Number = 24;
		private static const tempVector:Vector3D = new Vector3D();
		
		public function MagicObject_4(Id:uint, OwnerId:uint, X:int, Y:int)
		{
			super(Id, OwnerId, X, Y);
		}
		
		override public function initMagicData(Id:uint, OwnerId:uint, ConfigId:int, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):void
		{
			super.initMagicData(Id, OwnerId, ConfigId, TargetId, X, Y, Arg1, Arg2);
			setGroundXY(X, Y);
			addTimeHandlerAt(400, on400Ms);
			addTimeHandlerAt(3000, on3000Ms);
			_ownerPlayer = creater as Avatar3D;
		}
		
		override protected function updatePosition():void
		{
			
		}
		
		private function on3000Ms():void
		{
			recycleEnable = true;
		}
		
		private function on400Ms():void
		{
			if(_explodeEffect == null)
			{
//				_explodeEffect = _particleManager.getParticle("../assets/effect/skill/bosslong/atk01/bosslong-atk02-1.awd", null);
//				addChild(_explodeEffect);
//				var dirX:Number = x - _ownerPlayer.x;
//				var dirY:Number = y - _ownerPlayer.y;
//				ObjFaceTo3DSpace(_explodeEffect, dirX, dirY);
			}
		}
		
		override public function onNetActive(Value:uint):void
		{
			
		}
		
		private var _lastAttackTimer:int;
		override public function run(deltaTime:uint):void
		{
			super.run(deltaTime);
			
			_lastAttackTimer += deltaTime;
			if(_lastAttackTimer > 300)
			{
				checkAttack();
				_lastAttackTimer = 0;
			}
			
		}
		
		private function checkAttack():void
		{
			if(_ownerPlayer && lastTime < 2000 && lastTime > 500)
			{
				var skill:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_DRAGON_SKILL_3);
				BattleSystemManager.getInstance().circleAttack(_ownerPlayer, 600, skill, 9999, x, z);
			}
		}
		
		override public function resetMagic(Id:int=0, Name:String=null):void
		{
			if(_explodeEffect)
			{
				_particleManager.recycleParticle(_explodeEffect);
				_explodeEffect = null;
			}
			setGroundXY(0, 0);
			super.resetMagic(Id, Name);
		}
	}
}
