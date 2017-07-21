package demo.skill
{
	import away3d.containers.ObjectContainer3D;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	
	public class SkillOnHit extends SkillBase
	{
		private var _effectLifeTime:int;
		
		public function SkillOnHit()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.ON_HIT);	
		}
		
		override protected function checkFaceTarget():void
		{
		}
		
		override public function tryCastSkill(caster:Avatar3D, skillDetail:SkillDetailVO, targetId:int, targetIds:Array, posList:Array):void
		{
			// 受伤动作
			super.tryCastSkill(caster, skillDetail, targetId, targetIds, posList);
			_receiver = _world.getAvatar3D(targetId);
		}
		
		
		
		override protected function castSkill():void
		{
			super.castSkill();
			if(_receiver == null || _skillDetail == null)
				return;
			//被击白色闪烁
			_receiver.animationController.playHurt();
			// 被攻击音效
			var soundName:String = getHitSoundName();
			// 被攻击特效
			var effName:String = getHitEffectName();
			if (!effName)
				return;
			
			var tag:ObjectContainer3D = _receiver.underAttackContainer;
			if (!tag)
				return;
			var hitEffect:Particle3D = _particleManager.getParticle(effName, null, null, 1000);
			if(hitEffect)
			{
				hitEffect.position = tag.scenePosition;
				_world.addObject(hitEffect);
			}
			
		}
		
		
		private function getHitEffectName():String
		{
//			//根据技能来区分被击特效。
			switch(_skillDetail.clientId)
			{
				case SkillDefineEnum.MONSTER_SKILL_1:
				case SkillDefineEnum.PLAYER_SHOOT_ATTACK:
				case SkillDefineEnum.SKILL_ATTACK_ARCH210:
				case SkillDefineEnum.SKILL_ATTACK_ARCH250:
					return null;
				break;
			}
			
			return "../assets/effect/skill/mingzhongdandao/mingzhong.awd";
		}
		
		private function getHitSoundName():String
		{
			var soundName:String = "sound_name";
			return soundName;
		}
		
		
		override public function update(curTime:int, deltaTime:int):void
		{
			super.update(curTime, deltaTime);
			
			if (lastTime > _effectLifeTime)
				removeElement();
		}
	}
}