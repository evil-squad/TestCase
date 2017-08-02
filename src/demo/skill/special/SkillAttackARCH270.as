package demo.skill.special
{
	import away3d.containers.SkeletonBone;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.PathEnum;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	import demo.skill.SkillBase;
	import demo.skill.SkillDetailVO;
	
	/**
	 *  男弓箭手270 
	 * @author guoqing.wen
	 * 
	 */
	public class SkillAttackARCH270 extends SkillBase
	{
		private static var _skillInfoVO:SkillDetailVO = null;
		public static const BuffEffectName:String = PathEnum.SKILL_PATH + "tx_suit_arch1_001/tx_suit_arch1_270_buff.awd";
		private var _animationName:String = PlayerAnimationController.SEQ_ATTACK_270;
		
		private var _handLObj:Particle3D;
		private var _handRObj:Particle3D;
		private var _baoObj:Particle3D;
		
		public function SkillAttackARCH270()
		{
			super();
			_skillDetail = _skillManager.getSkillInfo(SkillDefineEnum.SKILL_ATTACK_ARCH270);
		}
		
		override protected function castSkill():void
		{
			super.castSkill();
			var effectPath:String = SkillManager.getInstance().getSkillPath(_animationName);
			
			_handLObj = _particleManager.getParticle(effectPath, "hand");
			_handRObj = _particleManager.getParticle(effectPath, "hand");
			_baoObj = _particleManager.getParticle(effectPath, "270");
			
			var lBone:SkeletonBone = _caster.mesh.getBoneByName("b_l_wq_01");
			var rBone:SkeletonBone = _caster.mesh.getBoneByName("b_r_wq_01");
			
			if (lBone)
				lBone.addChild(_handLObj);
			if (rBone)
				rBone.addChild(_handRObj);
			
			if(_baoObj)
			{
				_baoObj.rotationY = _caster.rotationY + 180;
				_baoObj.x = _caster.x;
				_baoObj.y = _caster.y + 10;
				_baoObj.z = _caster.z;
				WorldManager.instance.gameScene3D.addChild(_baoObj);
			}
			
			
			playDuration(_animationName);
			
			addTimeHandlerAt(800, removeHandEffect);
			addTimeHandlerAt(1600, addBuff);
			addTimeHandlerAt(2000, removeBaoEffect);
		}
		
		private function removeHandEffect():void
		{
			if(_handLObj)
			{
				_particleManager.recycleParticle(_handLObj);
				_handLObj = null;
			}
			if(_handRObj)
			{
				_particleManager.recycleParticle(_handRObj);
				_handRObj = null;
			}
		}
		
		private function removeBaoEffect():void
		{
			if(_baoObj)
			{
				_particleManager.recycleParticle(_baoObj);
				_baoObj = null;
			}
		}
		
		private function addBuff():void
		{
			var effect1:Particle3D = _particleManager.getParticle(BuffEffectName, null, null, 8000);
			var effect2:Particle3D = _particleManager.getParticle(BuffEffectName, null, null, 8000);
			
			var lBone:SkeletonBone = _caster.mesh.getBoneByName("b_l_wq_01");
			var rBone:SkeletonBone = _caster.mesh.getBoneByName("b_r_wq_01");
			
			if (lBone)
				lBone.addChild(effect1);
			if (rBone)
				rBone.addChild(effect2);
		}
		
		override protected function removeElement():void
		{
			removeBaoEffect();
			removeHandEffect();
			super.removeElement();
		}
		
	}
}

