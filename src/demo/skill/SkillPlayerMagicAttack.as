package demo.skill
{
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;

	public class SkillPlayerMagicAttack extends SkillShootBase
	{
		public function SkillPlayerMagicAttack()
		{
			super();
			
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.PLAYER_MAGIC_ATTACK);
			_castTime = 100;
			_ballSpeed = 750;
			_isCastTwoHand = false;
		}
		
		override public function tryCastSkill(caster:Avatar3D, skillInfo:SkillDetailVO, targetId:int, targetIds:Array, posList:Array):void
		{
			super.tryCastSkill(caster, skillInfo, targetId, targetIds, posList);
			_castTime = 100;
			_ballSpeed = 750;
			
			if(_receiver)
			{
				var distance:int = _caster.distanceToObject(_receiver.id);
				if(distance > 300)
				{
					_castTime = 150;
				}
				else if(distance > 200)
				{
					_castTime = 80;
				}
				else
				{
					_castTime = 0;
				}
			}
			
		}
		
		override protected function castSkill():void
		{
			super.castSkill();
			_caster.animationController.playAttackEx(_skillDetail.skillLifeTime);
		}
		
		
		override protected function createCastEffect() : Particle3D
		{
			if(Math.random() > 0.4)
			{
				return null;
			}
			return _particleManager.getParticle("range_attack_hand", null);
		}
		
		override protected function createBallEffect() : Particle3D
		{
			return _particleManager.getParticle("range_attack", null);
		}
		
		override protected function createBombEffect() : Particle3D
		{
			return null;
		}
		
		
	}
}