package demo.skill
{
	import demo.managers.SkillManager;
	
	public class SkillPool
	{
		private var _freeSkill : Vector.<SkillBase> = new Vector.<SkillBase>;
		private var _busySkill : Vector.<SkillBase> = new Vector.<SkillBase>;
		private var _skillId : int;
		
		public function SkillPool(skillId : int)
		{
			_skillId = skillId;
		}
		
		public function get skillId() : int {return _skillId;}
		
		public function render(curTime:int, deltaTime:int):void
		{
			var si:int=0;
			var skill:SkillBase;
			while(si < _busySkill.length)
			{
				skill = _busySkill[si];
				if(skill == null)
				{
					si++;
					continue;
				}
				
				
				if(skill.isDead)
				{
					skill.onCastSkillEnd(0);
					recycle(skill);
				}
				else
				{
					skill.update(curTime, deltaTime);
					si++;
				}
			}
			
		}
		
		public function getFreeSkill(tableId:int) : SkillBase
		{
			var retSkill : SkillBase;
			if( _freeSkill.length > 0 )
			{
				retSkill = _freeSkill[0];
				_freeSkill.splice(0, 1);
				_busySkill.push(retSkill);
				SkillManager.allLiveSkillEffCount++;
			}
			else
			{
				retSkill = AllocateOneSkill(tableId);
				if(retSkill)
				{
					_busySkill.push(retSkill);
					SkillManager.allLiveSkillEffCount++;
				}
			}

			retSkill.reset();
			return retSkill;
		}
		
		private function AllocateOneSkill(tableId:int) : SkillBase
		{
			var skillClass:Class = SkillManager.getInstance().getSkillClass(_skillId);
			var newSkill : SkillBase = new skillClass();
			newSkill.id  = tableId;
			SkillManager.allSkillEffCount++;
			
			return newSkill;
		}
		
		public function recycle(endSkill : SkillBase) : void
		{
			var index:int = _busySkill.indexOf(endSkill);
			if(index < 0)
				throw new Error("skill recycle error");
			else
			{
				_busySkill.splice(index, 1);
				_freeSkill.push(endSkill);
				
				SkillManager.allLiveSkillEffCount--;
			}
		}
		
		public function clearSkill() : void
		{
			while(_busySkill.length>0)
			{
				var skill : SkillBase = _busySkill[0];
				skill.onCastSkillEnd();
				_busySkill.splice(0, 1);
				_freeSkill.push(skill);
				SkillManager.allLiveSkillEffCount--;
			}
		}
		
		private static const SkillStayCount:int = 10;
		public function reduceCache(clear:Boolean) : int
		{
			var result:int = _freeSkill.length;
			var disposeCount:int;
			if(clear)
			{
				disposeCount = _freeSkill.length - 2;
			}
			else
			{
				disposeCount = Math.min(SkillStayCount, (_freeSkill.length - SkillStayCount) * 0.5);
			}
			
			if(disposeCount > 0)
			{
				_freeSkill.length = _freeSkill.length - disposeCount;
			}
			
			return disposeCount;
		}
		
		public function getSkillCacheCount():int
		{
			return _freeSkill.length;
		}
		
		
	}
}