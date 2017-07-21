package demo.skill.special
{
	import demo.controller.PlayerAnimationController;
	import demo.enum.SkillDefineEnum;
	import demo.skill.SkillBase;
	
	/**
	 *  男弓箭手250 
	 * @author guoqing.wen
	 * 
	 */
	public class SkillAttackARCH250 extends SkillBase
	{
		private var _animationName:String = PlayerAnimationController.SEQ_ATTACK_250;
		
		public function SkillAttackARCH250()
		{
			super();
			_skillDetail = _skillManager.getSkillInfo(SkillDefineEnum.SKILL_ATTACK_ARCH250);
		}
		
		override protected function castSkill():void
		{
			super.castSkill();
			playDuration(_animationName);
		}
		
		override protected function removeElement():void
		{
			super.removeElement();
		}
		
	}
}

