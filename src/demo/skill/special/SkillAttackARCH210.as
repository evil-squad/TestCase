package demo.skill.special
{
	import com.game.engine3D.scene.render.RenderUnit3D;
	
	import away3d.containers.SkeletonBone;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.skill.SkillBase;
	
	/**
	 *  男弓箭手210 
	 * @author guoqing.wen
	 * 
	 */
	public class SkillAttackARCH210 extends SkillBase
	{
		private var _animationName:String = PlayerAnimationController.SEQ_ATTACK_210;
		private var _dandaoObj:Particle3D;
		private var _gongObj:Particle3D;
		
		public function SkillAttackARCH210()
		{
			super();
			_skillDetail = _skillManager.getSkillInfo(SkillDefineEnum.SKILL_ATTACK_ARCH210);
		}

		override protected function castSkill():void
		{
			super.castSkill();
			
			var effectPath:String = _skillManager.getSkillPath(_animationName);
			_dandaoObj = _particleManager.getParticle(effectPath, "210_dandao");
			_gongObj = _particleManager.getParticle(effectPath, "210_gong");//挂在武器上的箭矢
			var bone:SkeletonBone = _caster.mesh.getBoneByName("b_l_wq_01");
			if (bone && _gongObj)
				bone.addChild(_gongObj);
			
			playDuration(_animationName);
			//挂靠一段时间后，移除引导动作的箭矢特效
			addTimeHandlerAt(_skillDetail.excuteDelay - 100, showGong1Obj);
			addTimeHandlerAt(_skillDetail.excuteDelay, removeGong1Obj);
			addTimeHandlerAt(_skillDetail.excuteDelay + 300, removeGong2Obj);
		}
		
		private function removeGong1Obj():void
		{
			if(_dandaoObj)
			{
				_particleManager.recycleParticle(_dandaoObj);
				_dandaoObj = null;
			}
		}
		
		private function showGong1Obj():void
		{
			if(_dandaoObj)
			{
				var weaponMesh:RenderUnit3D = _caster.weaponMesh;
				if (weaponMesh && _dandaoObj)
				{
					_dandaoObj.z = -50;
					_dandaoObj.rotationZ = 180;
					_dandaoObj.rotationX = 90;
					weaponMesh.graphicDis.addChild(_dandaoObj);
				}
			}
		}
		
		private function removeGong2Obj():void
		{
			if(_gongObj)
			{
				_particleManager.recycleParticle(_gongObj);
				_gongObj = null;
			}
		}
		
		override protected function removeElement():void
		{
			removeGong1Obj();
			removeGong2Obj();
			super.removeElement();
		}
	}
}

