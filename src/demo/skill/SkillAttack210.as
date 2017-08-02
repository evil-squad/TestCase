package demo.skill
{
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	
	public class SkillAttack210 extends SkillBase
	{
		private var _animationName:String;
		
		private var _effect:Particle3D;
		public function SkillAttack210()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_ATTACK210);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_210;
			super.castSkill();
			playDuration(_animationName);
			showEffect();
		}
		
		private function showEffect():void
		{
			if(_effect == null)
			{
				var effect:String = SkillManager.getInstance().getSkillPath(_animationName);
				_effect = _particleManager.getParticle(effect, null);
			}
			_effect.rotationY = _caster.rotationY + 180;
			_effect.x = _caster.x;
			_effect.y = _caster.y;
			_effect.z = _caster.z;
			_effect.setMyScale(0.6);
			WorldManager.instance.gameScene3D.addChild(_effect);
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

