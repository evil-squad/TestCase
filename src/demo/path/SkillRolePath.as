package demo.path {

	import demo.enum.PathEnum;
	import demo.enum.RoleEnum;
	import demo.enum.SkillDefineEnum;

	public class SkillRolePath {
		
		private var _skillPaths : Object = {};
		private var _skillArchs : Object = {};

		public function SkillRolePath() {
			
			//jiruqinglong
			addSkillPath(RoleEnum.ROLE_QSMY, "11/");
			//jiruqinglong skill
//			addSkillClass(RoleEnum.ROLE_QSMY, SkillDefineEnum.PLAYER_NORMAL_ATTACK);
			addSkillClass(RoleEnum.ROLE_QSMY, SkillDefineEnum.SKILL_QINGLONG_SKILL_7);
			addSkillClass(RoleEnum.ROLE_QSMY, SkillDefineEnum.SKILL_QINGLONG_SKILL_8);
			addSkillClass(RoleEnum.ROLE_QSMY, SkillDefineEnum.SKILL_QINGLONG_SKILL_9);
			
			addSkillPath(RoleEnum.ROLE_CQ_MALE_WARRIOR, "15/");
//			addSkillClass(RoleEnum.ROLE_CQ_MALE_WARRIOR, SkillDefineEnum.PLAYER_NORMAL_ATTACK);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_WARRIOR, SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_1);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_WARRIOR, SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_2);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_WARRIOR, SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_3);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_WARRIOR, SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_4);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_WARRIOR, SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_5);
			
			addSkillPath(RoleEnum.ROLE_CQ_MALE_MAGE, "17/");
//			addSkillClass(RoleEnum.ROLE_CQ_MALE_MAGE, SkillDefineEnum.PLAYER_NORMAL_ATTACK);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_MAGE, SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_1);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_MAGE, SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_2);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_MAGE, SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_3);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_MAGE, SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_4);
			addSkillClass(RoleEnum.ROLE_CQ_MALE_MAGE, SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_5);
			
			addSkillPath(RoleEnum.ROLE_TIAN_DAO_NEW, "18/");
			addSkillClass(RoleEnum.ROLE_TIAN_DAO_NEW, SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_1);
			
//			addSkillClass(
			
//			//人类弓箭手男
//			addSkillPath(RoleEnum.ARCH_MALE, "tx_suit_arch1_001/tx_suit_arch1_");
//			//添加弓箭手男 特殊技能处理类
//			addSkillClass(RoleEnum.ARCH_MALE, SkillDefineEnum.PLAYER_SHOOT_ATTACK);
//			addSkillClass(RoleEnum.ARCH_MALE, SkillDefineEnum.SKILL_ATTACK_ARCH210);
//			addSkillClass(RoleEnum.ARCH_MALE, SkillDefineEnum.SKILL_ATTACK_ARCH250);
//			addSkillClass(RoleEnum.ARCH_MALE, SkillDefineEnum.SKILL_ATTACK_ARCH260);
//			addSkillClass(RoleEnum.ARCH_MALE, SkillDefineEnum.SKILL_ATTACK_ARCH270);
			
//			//人类弓箭手女(与男相同)
//			addSkillPath(RoleEnum.ARCH_FEMALE, "tx_suit_arch1_001/tx_suit_arch1_");
//			//添加弓箭手女 特殊技能处理类
//			addSkillClass(RoleEnum.ARCH_FEMALE, SkillDefineEnum.PLAYER_SHOOT_ATTACK);
//			addSkillClass(RoleEnum.ARCH_FEMALE, SkillDefineEnum.SKILL_ATTACK_ARCH210);
//			addSkillClass(RoleEnum.ARCH_FEMALE, SkillDefineEnum.SKILL_ATTACK_ARCH250);
//			addSkillClass(RoleEnum.ARCH_FEMALE, SkillDefineEnum.SKILL_ATTACK_ARCH260);
//			addSkillClass(RoleEnum.ARCH_FEMALE, SkillDefineEnum.SKILL_ATTACK_ARCH270);
//
//			//人类骑士男
//			addSkillPath(RoleEnum.KNIGHT_MALE, "tx_suit_knife1_001/tx_suit_knife1_");
//			//添加骑士男 特殊技能处理类
//			addSkillClass(RoleEnum.KNIGHT_MALE, SkillDefineEnum.PLAYER_NORMAL_ATTACK);
//			addSkillClass(RoleEnum.KNIGHT_MALE, SkillDefineEnum.SKILL_KNIGHT210);
//			addSkillClass(RoleEnum.KNIGHT_MALE, SkillDefineEnum.SKILL_KNIGHT250);
//			addSkillClass(RoleEnum.KNIGHT_MALE, SkillDefineEnum.SKILL_KNIGHT260);
//			addSkillClass(RoleEnum.KNIGHT_MALE, SkillDefineEnum.SKILL_KNIGHT270);
//			//人类骑士女 (与男相同)
//			addSkillPath(RoleEnum.KNIGHT_FEMALE, "tx_suit_knife1_001/tx_suit_knife1_");
//			//添加骑士女 特殊技能处理类
//			addSkillClass(RoleEnum.KNIGHT_FEMALE, SkillDefineEnum.PLAYER_NORMAL_ATTACK);
//			addSkillClass(RoleEnum.KNIGHT_FEMALE, SkillDefineEnum.SKILL_KNIGHT210);
//			addSkillClass(RoleEnum.KNIGHT_FEMALE, SkillDefineEnum.SKILL_KNIGHT250);
//			addSkillClass(RoleEnum.KNIGHT_FEMALE, SkillDefineEnum.SKILL_KNIGHT260);
//			addSkillClass(RoleEnum.KNIGHT_FEMALE, SkillDefineEnum.SKILL_KNIGHT270);
//			//绿皮肤女
//			addSkillPath(RoleEnum.OLD_FEMALE, "tx_old_green2_002/tx_old_green2_");
//			//添加骑士女 特殊技能处理类
//			addSkillClass(RoleEnum.OLD_FEMALE, SkillDefineEnum.PLAYER_NORMAL_ATTACK);
//			addSkillClass(RoleEnum.OLD_FEMALE, SkillDefineEnum.SKILL_ATTACK210);
//			addSkillClass(RoleEnum.OLD_FEMALE, SkillDefineEnum.SKILL_ATTACK250);
//			addSkillClass(RoleEnum.OLD_FEMALE, SkillDefineEnum.SKILL_ATTACK260);
//			addSkillClass(RoleEnum.OLD_FEMALE, SkillDefineEnum.SKILL_ATTACK270);
//			//饕餮
//			addSkillPath(RoleEnum.MONSTER_TAOTIE, "tx_monster_taotie01/tx_monster_taotie01_");
//			//饕餮
//			addSkillClass(RoleEnum.MONSTER_TAOTIE, SkillDefineEnum.PLAYER_NORMAL_ATTACK);
//			addSkillClass(RoleEnum.MONSTER_TAOTIE, SkillDefineEnum.SKILL_TAOTIE210);
//			addSkillClass(RoleEnum.MONSTER_TAOTIE, SkillDefineEnum.SKILL_TAOTIE250);
//			//staff
//			addSkillPath(RoleEnum.STAFF, "tx_monster_staff01/tx_monster_staff01_");
//			addSkillClass(RoleEnum.STAFF, SkillDefineEnum.PLAYER_NORMAL_ATTACK);
		}

		private function addSkillPath(roleType : int, path : String, skillType : String = "") : void {
			_skillPaths[roleType + skillType] = path;
		}

		private function addSkillClass(roleType : int, skillType : int) : void {
			var list : Vector.<int> = _skillArchs[roleType] || new Vector.<int>();
			_skillArchs[roleType] = list;
			list.push(skillType);
		}

		public function getSkillPathByRole(roleType : int, skillType : String) : String {
			var skill : String = _skillPaths[roleType + skillType];

			if (!skill) //如果存在特殊的
				skill = _skillPaths[String(roleType)];
			return PathEnum.SKILL_PATH + skill + skillType + PathEnum.RES_AWD;
		}

		public function copySkillIdsByRole(roleType : int) : Vector.<int> {
			var list : Vector.<int> = _skillArchs[roleType];
			var newList : Vector.<int> = new Vector.<int>();

			for each (var id : int in list) {
				newList.push(id);
			}
			return newList;
		}

	}
}
