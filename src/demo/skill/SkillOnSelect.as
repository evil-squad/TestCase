package demo.skill
{
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.ParticleManager;
	import demo.managers.SkillManager;

	public class SkillOnSelect extends SkillBase
	{
		private static var _selectEffect : Particle3D;		// 选择特效
		private static var _selectEffectR : Particle3D;		// 红色特效
		
		public function SkillOnSelect()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.ON_SELECT);
			noDead();
		}
		
		override protected function checkFaceTarget():void
		{
		}
		
		
		override public function tryCastSkill(caster:Avatar3D, skillInfo:SkillDetailVO, targetId:int, targetIds:Array, posList:Array):void
		{
			
			super.tryCastSkill(caster, skillInfo, targetId, targetIds, posList);
			
			_selectEffect ||= ParticleManager.getInstance().getParticle("selector", null);
//			_selectEffect.noLifeTime();
//			_selectEffect.reset();
			
			_selectEffectR ||= ParticleManager.getInstance().getParticle("selector_r", null);
//			_selectEffectR.noLifeTime();
//			_selectEffectR.reset();
			
			improveEffect();
			
//			if(_receiver)
//			{
//				var aniSelectEffect2 : Particle3D;
//				if(_receiver.attackAble == false)
//				{
//					_receiver.addChild(_selectEffect);
//					aniSelectEffect2 = EffectManager.getInstance().createEffect("selector2");
//				}
//				else
//				{
//					_receiver.addChild(_selectEffectR);
//					aniSelectEffect2 = EffectManager.getInstance().createEffect("selector2_r");
//				}
//				
//				//  选择动画
//				if(aniSelectEffect2)
//				{
//					aniSelectEffect2.y = 10;
//					_receiver.addChild(aniSelectEffect2);
//				}
//			}
//			else if(_selectEffect.parent || _selectEffectR.parent)
//			{
//				if(_selectEffect.parent)
//					_selectEffect.parent.removeChild(_selectEffect);
//				if(_selectEffectR.parent)
//					_selectEffectR.parent.removeChild(_selectEffectR);
//			}
//			var scale:Number = 1;
//			if(_receiver && _receiver.careerData && _receiver.careerData)
//			{
//				scale = _receiver.careerData.scaleAvatar * 1.2 * _receiver.careerData.bodySize.x / 100;
//			}
//			if(_selectEffect)
//			{
//				_selectEffect.scaleXYZ(scale);
//			}
//			if(_selectEffectR)
//			{
//				_selectEffectR.scaleXYZ(scale);
//			}
//			
//			
			super.castSkill();
		}
		
		
		private function improveEffect() : void
		{
			_selectEffect.x = 0;
			_selectEffect.y = 10;
			_selectEffect.z = 0;
			
			_selectEffectR.x = 0;
			_selectEffectR.y = 10;
			_selectEffectR.z = 0;
			
		}
	}
}