package demo.skill
{
	import flash.geom.Vector3D;
	
	import away3d.containers.SkeletonBone;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	
	public class SkillMonsterAttack2 extends SkillBase
	{
		private var _animationName:String;
		private var _avatarToEffect:Object = {};
		public function SkillMonsterAttack2()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.MONSTER_SKILL_2);
			_avatarToEffect["bosstujiu"] = "Bone01";
			_avatarToEffect["dongxueguifu"] = "Bip01 Head";
			_avatarToEffect["jiangshizhanshi"] = "v-effect";
			_avatarToEffect["jibing"] = null;
			_avatarToEffect["jushexi"] = "Bone15";
		}
		
		private static const tempVec:Vector3D = new Vector3D();
		override protected function castSkill():void
		{
			super.castSkill();
			var particleName:String;
			var boneName:String;
			var avatarKey:String;
			for(var key:String in _avatarToEffect)
			{
				if(_caster.vo.url.search(key) >= 0)
				{
					particleName = key;
					boneName = _avatarToEffect[key];
					break;
				}
			}
			
			if(particleName)
			{
				particleName = "../assets/effect/skill/" + particleName + "/250_effect.awd";
			}
			var particle:Particle3D = particleName ? _particleManager.getParticle(particleName, null, null, 3000) : null;
			if(particle)
			{
				var container:SkeletonBone;
				if(boneName)
				{
					container = _caster.mesh.getBoneByName(boneName);
				}
				if(container)
				{
					container.addChild(particle);
				}
				else if(_receiver)
				{
					_world.addObject(particle);
					particle.x = _receiver.x;
					particle.y = _receiver.y;
					particle.z = _receiver.z;
					
					tempVec.copyFrom(_receiver.graphicDis.scenePosition);
					tempVec.decrementBy(_caster.graphicDis.scenePosition);
					tempVec.incrementBy(_receiver.graphicDis.scenePosition);
					
					particle.lookAt(tempVec);
				}
			}
			
			_animationName = PlayerAnimationController.SEQ_ATTACK_250;
			var total:uint = _caster.animationController.getSequenceDuration(_animationName);
			_caster.animationController.playAnimWithDuring(_animationName, total);
			
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

