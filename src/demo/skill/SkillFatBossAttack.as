package demo.skill
{
	import demo.controller.PlayerAnimationController;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	
	public class SkillFatBossAttack extends SkillBase
	{
		private var _animationName:String;
		
		public function SkillFatBossAttack()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.FAT_BOSS_ATTACK);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_250;
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

