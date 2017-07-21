package demo.skill.cq {
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.WorldManager;
	import demo.skill.SkillBase;
	
	
	/**
	 *　　　　　　　　┏┓　　　┏┓+ +
	 *　　　　　　　┏┛┻━━━┛┻┓ + +
	 *　　　　　　　┃　　　　　　　┃ 　
	 *　　　　　　　┃　　　━　　　┃ ++ + + +
	 *　　　　　　 ████━████ ┃+
	 *　　　　　　　┃　　　　　　　┃ +
	 *　　　　　　　┃　　　┻　　　┃
	 *　　　　　　　┃　　　　　　　┃ + +
	 *　　　　　　　┗━┓　　　┏━┛
	 *　　　　　　　　　┃　　　┃　　　　　　　　　　　
	 *　　　　　　　　　┃　　　┃ + + + +
	 *　　　　　　　　　┃　　　┃　　　　　　　　　　　
	 *　　　　　　　　　┃　　　┃ + 　　　　　　
	 *　　　　　　　　　┃　　　┃
	 *　　　　　　　　　┃　　　┃　　+　　　　　　　　　
	 *　　　　　　　　　┃　 　　┗━━━┓ + +
	 *　　　　　　　　　┃ 　　　　　　　┣┓
	 *　　　　　　　　　┃ 　　　　　　　┏┛
	 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
	 *　　　　　　　　　　┃┫┫　┃┫┫
	 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
	 * @author chenbo
	 * 创建时间：Sep 22, 2016 2:51:25 PM
	 */
	public class SkillMaleWarriorAttack4 extends SkillBase {
		
		private var _effect : Particle3D;
		
		public function SkillMaleWarriorAttack4() {
			super();
			_skillDetail = _skillManager.getSkillInfo(SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_4);
		}
		
		override protected function castSkill():void {
			super.castSkill();
			
			var effect:String = _skillManager.getSkillPath("efc_pojijianfa");
			_effect = _particleManager.getParticle(effect, null);
			_effect.rotationY = _caster.rotationY + 180;
			_effect.x = _caster.x;
			_effect.y = _caster.y + 10;
			_effect.z = _caster.z;
			
			WorldManager.instance.gameScene3D.addChild(_effect);
			
			var total:uint = _caster.animationController.getSequenceDuration(PlayerAnimationController.SEQ_ATTACK_210);
			_caster.animationController.playAnimWithDuring(PlayerAnimationController.SEQ_ATTACK_210, total);
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