package demo.skill
{
	import demo.controller.PlayerAnimationController;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	
	public class SkillAttack260 extends SkillBase
	{
		private var _animationName:String;
		public function SkillAttack260()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_ATTACK260);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_210;
			super.castSkill();
			_caster.faceToGround(skillCastPosX, skillCastPosY);
			playDuration(_animationName);
			
		}
		
		
	}
}
