package demo.skill
{
	import com.game.engine3D.scene.render.RenderUnit3D;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	
	public class SkillLionAttack1 extends SkillBase
	{
		private var _animationName:String;
		private var _particle1:Particle3D;
		private var _particle2:Particle3D;
		private var _particle3:Particle3D;
		public static const EffectName:String = "../assets/effect/skill/jixieshizi/effect-02.awd";

		private var _skillTime:int;
		private var _casterMesh:RenderUnit3D;
		private var _lastLayerType:int;
		
		public function SkillLionAttack1()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_LION_SKILL_1);
		}
		
		override protected function castSkill():void
		{
			_skillTime = 0;
			_animationName = PlayerAnimationController.SEQ_ATTACK_250;
			super.castSkill();
			
			if(_particle1 == null)
			{
				_particle1 = _particleManager.getParticle(EffectName, null);
			}
			
			_casterMesh = _caster.mesh ? _caster.mesh : null;
			if(_casterMesh)
			{
				_casterMesh.entityPhantom = true;
			}
			_particle1.x = _caster.x;
			_particle1.y = _caster.y;
			_particle1.z = _caster.z;
			_particle1.setMyScale(1.4);
			_particle1.rotationY = _caster.rotationY + 180;
			
			WorldManager.instance.gameScene3D.addChild(_particle1);
			
			var total:uint = _caster.animationController.getSequenceDuration(_animationName);
			_caster.animationController.playAnimWithDuring(_animationName, total);
			
		}
		
		override protected function removeElement():void
		{
			if(_casterMesh)
			{
				_casterMesh.entityPhantom = false;
			}
			
			if(_particle1)
			{
				_particleManager.recycleParticle(_particle1);
				_particle1 = null;
			}
			super.removeElement();
		}
		
	}
}

