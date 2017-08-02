package demo.skill.special
{
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	import demo.skill.SkillBase;
	
	public class SkillQinglongAttack8 extends SkillBase
	{
		private var _animationName:String;
		private var _effect:Particle3D;
		public function SkillQinglongAttack8()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_QINGLONG_SKILL_8);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_250;
			super.castSkill();
			
			var effectName:String = SkillManager.getInstance().getSkillPath(_animationName);
			_effect = _particleManager.getParticle(effectName, "250");
			_effect.rotationY = _caster.rotationY + 180;
			_effect.x = _caster.x;
			_effect.y = _caster.y + 10;
			_effect.z = _caster.z;
			
			WorldManager.instance.gameScene3D.addChild(_effect);
			
			_caster.faceToGround(skillCastPosX, skillCastPosY);
			
			addTimeHandlerAt(300, playDuration300);
			
		}
		
		private function playDuration300():void
		{
			playDuration(_animationName);
		}
		
		override protected function removeElement():void
		{
			if(_effect)
			{
				_particleManager.recycleParticle(_effect);
				_effect = null;
			}
			super.removeElement();
		}
		
	}
}





