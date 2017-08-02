package demo.controller {

	import flash.utils.Dictionary;
	
	import demo.display3D.Avatar3D;
	import demo.managers.SkillManager;
	import demo.skill.SkillBase;
	import demo.skill.SkillDetailVO;

	public class PlayerSkillController {
		
		private static var SkillSeqID : int = 0;
		
		private var _player 	 : Avatar3D;
		private var _usingSkillList : Vector.<SkillBase> = new Vector.<SkillBase>();
		private var _usingSkills : Dictionary = new Dictionary(); 	// 正在使用的技能队列
		private var _ndDelSkills : Array = [];						// 需要被删除的技能
		
		public function PlayerSkillController(player : Avatar3D) {
			_player = player;
		}
		
		public function lastCastingSkill() : SkillBase {
			if(_usingSkillList.length > 0)
				return _usingSkillList[_usingSkillList.length -1];
			return null;
		}
		
		/**
		 * 使用技能 
		 * @param skillDetail
		 * @param targetId
		 * @param targetIds
		 * @param posList
		 * @param seq
		 * @return 
		 * 
		 */		
		public function tryCastSkill(skillDetail : SkillDetailVO, targetId : int, targetIds : Array, posList : Array, seq : int = -1) : uint {
			
			if (skillDetail == null) {
				return 0;
			}
			
			// 由于 seq 用于区分不同技能实例，当服务器端不为技能编号时，
			// 基于同一技能不可能嵌套施放的假设，客户端可以通过SkillId来区分不同技能的实例。
			// 否则当技能嵌套时，后发技能会在 _usingSkills 覆盖前面的技能。 -- Logan
			if (seq == 0) {
				seq = skillDetail.clientId;
			}
			
			var skill : SkillBase = SkillManager.getInstance().createSkillById(skillDetail.clientId);
			
			if (!skill) {
				return 0;
			}
			
			if (seq == -1) {
				skill.seq = ++SkillSeqID;
			} else {
				skill.seq = seq;
			}
			
			_usingSkills[skill.seq] = skill;
			_usingSkillList.push(skill);
			
			skill.tryCastSkill(_player, skillDetail, targetId, targetIds, posList);
			//如果不是本人的施法，则直接施法成功
			skill.skillCastTargetId  = targetId;
			skill.skillCastTargetIds = targetIds;
			skill.skillCastPosList 	 = posList;
			skill.skillCastPosX 	 = posList ? posList[0].x : 0;
			skill.skillCastPosY 	 = posList ? posList[0].y : 0;
			skill.checkNowCastEnable();
			
			return SkillSeqID;
		}
		
		private function onCastMoveStateEnd() : void {
			var skill : SkillBase = null;
			for each (skill in _usingSkills) {
				if (skill.isMoveCastSkill) {
					_ndDelSkills.push(skill);
				}
			}
			for each (skill in _ndDelSkills) {
				delete _usingSkills[skill.seq];
				skill.onCastSkillEnd();
			}
			_ndDelSkills.length = 0;
		}
		
		public function getSkillBySeq(SkillSeq : uint) : SkillBase {
			return _usingSkills[SkillSeq];
		}

/*		public function onCastSkillEnd(skillInfo : SkillDetailVO, SkillSeq : uint, targetId : int) : void {
			// 由于 SkillSeq 用于区分不同技能实例，当服务器端不为技能编号时，
			// 基于同一技能不可能嵌套施放的假设，客户端可以通过SkillId来区分不同技能的实例。
			// 否则当技能嵌套时，后发技能会在 _usingSkills 覆盖前面的技能。
			if (SkillSeq == 0) {
				SkillSeq = skillInfo.clientId;
			}
			if (!_usingSkills[SkillSeq]) {
				return;
			}
			
			var skill : SkillBase = _usingSkills[SkillSeq];
			if (skill.isMoveCastSkill == false) {
				skill.onCastSkillEnd(targetId);
				delete _usingSkills[SkillSeq];
			}
		}*/
		
		public function onCastSkillEnd(skill : SkillBase) : void
		{
			var index:int = _usingSkillList.indexOf(skill);
			if(index >= 0)
				_usingSkillList.splice(index,1);
		}
			
		public function onDead() : void {
			//移除所有技能
			var seqs : Array = [];
			var skillSeq : int;

			for (var seqString : String in _usingSkills) {
				skillSeq = int(seqString);
				seqs.push(skillSeq);
			}

			for each (skillSeq in seqs) {
				var skill : SkillBase = _usingSkills[skillSeq];
				if (skill) {
					skill.onCastSkillEnd(0);
				}
				delete _usingSkills[skillSeq];
			}
			
			_usingSkillList.length = 0;
		}
		
		public function dispose() : void {
			for each (var skill : SkillBase in _usingSkills) {
				skill.onCastSkillEnd();
			}
			_usingSkills = new Dictionary();
			_usingSkillList.length = 0;
		}

	}
}
