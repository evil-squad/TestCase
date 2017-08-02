package demo.skill
{
	import demo.controller.PlayerAnimationController;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	
	public class SkillMonsterAttack1 extends SkillBase
	{
		private var _animationName:String;
		
		public function SkillMonsterAttack1()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.MONSTER_SKILL_1);
		}
		
		override protected function castSkill():void
		{
			super.castSkill();
			_animationName = PlayerAnimationController.SEQ_ATTACK_250;
			var total:uint = _caster.animationController.getSequenceDuration(_animationName);
			_caster.animationController.playAnimWithDuring(_animationName, total);
		}
		
		override protected function removeElement():void
		{
			super.removeElement();
		}
		
		override public function update(curTime:int, deltaTime:int):void
		{
			super.update(curTime, deltaTime);
		}
		
		
		
		
		
		
	}
}

