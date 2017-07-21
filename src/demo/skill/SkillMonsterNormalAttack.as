package demo.skill
{
	import demo.controller.PlayerAnimationController;
	import demo.enum.SkillDefineEnum;
	
	public class SkillMonsterNormalAttack extends SkillBase
	{
		private var _effDelay : int = 0;
		private var _animationName:String;
		
		public function SkillMonsterNormalAttack()
		{
			super();
			_skillDetail = _skillManager.getSkillInfo(SkillDefineEnum.MONSTER_NORMAL_ATTACK);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_210;
			super.castSkill();
			
			if(_receiver && _caster)
			{
				_caster.faceToTarget(_receiver.id);
			}
			
			var total:uint = _caster.animationController.getSequenceDuration(_animationName);
			_caster.animationController.playAnimWithDuring(_animationName, total);
			
		}
		
		override protected function removeElement():void
		{
			super.removeElement();
		}
		
	}
}
