package demo.skill.knight
{
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.WorldManager;
	import demo.skill.SkillBase;
	
	public class SkillKnight210 extends SkillBase
	{
		private var _animationName:String;
		private var _effect:Particle3D;
		public function SkillKnight210()
		{
			super();
			_skillDetail = _skillManager.getSkillInfo(SkillDefineEnum.SKILL_KNIGHT210);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_210;
			super.castSkill();
			
			var effect:String = _skillManager.getSkillPath(_animationName);
			_effect = _particleManager.getParticle(effect, null);
			_effect.rotationY = _caster.rotationY + 180;
			_effect.x = _caster.x;
			_effect.y = _caster.y + 10;
			_effect.z = _caster.z;
			
			var total:uint = _caster.animationController.getSequenceDuration(_animationName);
			_caster.animationController.playAnimWithDuring(_animationName, total);
			
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


