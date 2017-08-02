package demo.skill
{
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	
	public class SkillAttack250 extends SkillBase
	{
		private var _animationName:String;
		private var _effect:Particle3D;
		public function SkillAttack250()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_ATTACK250);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_250;
			super.castSkill();
			
			var effectName:String = SkillManager.getInstance().getSkillPath(_animationName);
			_effect = _particleManager.getParticle(effectName, null);
			_effect.rotationY = _caster.rotationY + 180;
			_effect.x = _caster.x;
			_effect.y = _caster.y + 10;
			_effect.z = _caster.z;
			
			WorldManager.instance.gameScene3D.addChild(_effect);
			
			_caster.faceToGround(skillCastPosX, skillCastPosY);
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
