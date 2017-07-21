package demo.skill.td {
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.WorldManager;
	import demo.skill.SkillBase;
	

	public class SkillTianXiangAttack3 extends SkillBase {
		
		private var _effect : Particle3D;
		
		public function SkillTianXiangAttack3() {
			super();
			_skillDetail = _skillManager.getSkillInfo(SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_3);
		}
		
		override protected function castSkill():void {
			super.castSkill();
			
			var effect:String = _skillManager.getSkillPath("fx_212");
			_effect = _particleManager.getParticle(effect, null);
			_effect.rotationY = _caster.rotationY + 180;
			_effect.x = _caster.x;
			_effect.y = _caster.y + 10;
			_effect.z = _caster.z;
			
			WorldManager.instance.gameScene3D.addChild(_effect);
			
			var total:uint = _caster.animationController.getSequenceDuration(PlayerAnimationController.SEQ_ATTACK_212);
			_caster.animationController.playAnimWithDuring(PlayerAnimationController.SEQ_ATTACK_212, total);
		}
		
		override protected function removeElement():void {
			if (_effect) {
				_particleManager.recycleParticle(_effect);
				_effect = null;
			}
			super.removeElement();
		}
		
	}
}