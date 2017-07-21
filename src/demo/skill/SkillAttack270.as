package demo.skill
{
	import demo.controller.PlayerAnimationController;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	
	public class SkillAttack270 extends SkillBase
	{
		private var _animationName:String;
		
		public function SkillAttack270()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_ATTACK270);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_210;
			super.castSkill();
			playDuration(_animationName);
		}
		
		
	}
}

