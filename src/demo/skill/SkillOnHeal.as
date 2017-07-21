package demo.skill
{
	import demo.display3D.Avatar3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;

	public class SkillOnHeal extends SkillBase
	{
		private var lifeTime : int = 0;
		public function SkillOnHeal()
		{
			lifeTime = 500;
			super();
		}
		
		override protected function checkFaceTarget():void
		{
		}
		
		
		override public function tryCastSkill(caster:Avatar3D, skillInfo:SkillDetailVO, targetId:int, targetIds:Array, posList:Array):void
		{
			super.tryCastSkill(caster, skillInfo, targetId, targetIds, posList);
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.ON_HEAL);
		}
		
		
		override protected function castSkill():void
		{
//			healthbuff
			super.castSkill();
		}
		
		override public function update(curTime:int, deltaTime:int):void
		{
			super.update(curTime, deltaTime);
			
			if(lastTime > lifeTime)
				removeElement();
		}
	}
}