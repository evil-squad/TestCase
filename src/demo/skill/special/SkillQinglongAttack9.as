package demo.skill.special
{
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	import demo.skill.SkillBase;
	
	public class SkillQinglongAttack9 extends SkillBase
	{
		private var _animationName:String;
		private var _effect:Particle3D;
		public function SkillQinglongAttack9()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_QINGLONG_SKILL_9);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_270;
			super.castSkill();
			
			var effectName:String = SkillManager.getInstance().getSkillPath(_animationName);
			_effect = _particleManager.getParticle(effectName, "270");
			_effect.rotationY = _caster.rotationY + 180;
			_effect.x = _caster.x;
			_effect.y = _caster.y + 10;
			_effect.z = _caster.z;
			
			WorldManager.instance.gameScene3D.addChild(_effect);
			
			_caster.faceToGround(skillCastPosX, skillCastPosY);
			
			addTimeHandlerAt(200, playDuration200);
			
		}
		
		private function playDuration200():void
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





