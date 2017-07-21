package demo.skill
{
	import away3d.containers.ObjectContainer3D;
	
	import demo.controller.PlayerAnimationController;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	
	public class SkillDragonAttack3 extends SkillBase
	{
		private var _animationName:String;
		
		public function SkillDragonAttack3()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_LION_SKILL_1);
		}
		
		override protected function castSkill():void
		{
			super.castSkill();
			_animationName = PlayerAnimationController.SEQ_ATTACK_260;
			var total:uint = _caster.animationController.getSequenceDuration(_animationName);
			_caster.animationController.playAnimWithDuring(_animationName, total);
			
			var bone:ObjectContainer3D = _caster.mesh.getBoneByName("dummy_fire");
			var container:ObjectContainer3D = _caster.mesh.getChildByName("skill_boss_dummy");
			if(container && bone)
			{
//				var particle:Particle3D = _particleManager.getParticle("../assets/effect/skill/bosslong/atk01/bosslong-atk02.awd", null, null, 3000);
//				container.addChild(particle);
//				bone.addChild(container);
			}
			
//			CameraManager.lockedOnPlayerController.vibrate(20, 300, 19, 4);
			
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
