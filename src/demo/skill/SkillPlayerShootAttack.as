package demo.skill
{
	import com.game.engine3D.scene.render.RenderUnit3D;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	
	/**
	 *  男弓箭手普通攻击
	 * @author guoqing.wen
	 */
	public class SkillPlayerShootAttack extends SkillBase
	{
		private var _animationName:String = PlayerAnimationController.SEQ_ATTACK_210;
		private var _dandaoObj:Particle3D;
		
		public function SkillPlayerShootAttack()
		{
			super();
			_skillDetail = _skillManager.getSkillInfo(SkillDefineEnum.PLAYER_SHOOT_ATTACK);
		}

		override protected function castSkill():void
		{
			super.castSkill();
			
			var effectPath:String = _skillManager.getSkillPath(_animationName);
			_dandaoObj = _particleManager.getParticle(effectPath, "210_dandao");
			
			playDuration(_animationName);
			//挂靠一段时间后，移除引导动作的箭矢特效
			addTimeHandlerAt(_skillDetail.excuteDelay - 100, showGong1Obj);
			addTimeHandlerAt(_skillDetail.excuteDelay, removeGong1Obj);
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
					_dandaoObj.y = -50;
					_dandaoObj.rotationZ = 180;
					_dandaoObj.rotationX = 90;
					weaponMesh.graphicDis.addChild(_dandaoObj);
				}
			}
		}
		
		
		override protected function removeElement():void
		{
			removeGong1Obj();
			super.removeElement();
		}
	}
}

