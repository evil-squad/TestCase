package demo.managers {

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import demo.display3D.Avatar3D;
	import demo.enum.SkillDefineEnum;
	import demo.events.SkillEvent;
	import demo.path.SkillRolePath;
	import demo.skill.SkillAttack210;
	import demo.skill.SkillAttack250;
	import demo.skill.SkillAttack260;
	import demo.skill.SkillAttack270;
	import demo.skill.SkillBase;
	import demo.skill.SkillDetailVO;
	import demo.skill.SkillDragonAttack1;
	import demo.skill.SkillDragonAttack3;
	import demo.skill.SkillFatBossAttack;
	import demo.skill.SkillLionAttack1;
	import demo.skill.SkillMonsterAttack1;
	import demo.skill.SkillMonsterAttack2;
	import demo.skill.SkillMonsterNormalAttack;
	import demo.skill.SkillOnHeal;
	import demo.skill.SkillOnHit;
	import demo.skill.SkillOnSelect;
	import demo.skill.SkillPlayerMagicAttack;
	//import demo.skill.SkillPlayerNormalAttack;
	import demo.skill.SkillPlayerShootAttack;
	import demo.skill.SkillPool;
	import demo.skill.cq.SkillMaleMageAttack1;
	import demo.skill.cq.SkillMaleMageAttack2;
	import demo.skill.cq.SkillMaleMageAttack3;
	import demo.skill.cq.SkillMaleMageAttack4;
	import demo.skill.cq.SkillMaleMageAttack5;
	import demo.skill.cq.SkillMaleWarriorAttack1;
	import demo.skill.cq.SkillMaleWarriorAttack2;
	import demo.skill.cq.SkillMaleWarriorAttack3;
	import demo.skill.cq.SkillMaleWarriorAttack4;
	import demo.skill.cq.SkillMaleWarriorAttack5;
	import demo.skill.knight.SkillKnight210;
	import demo.skill.knight.SkillKnight250;
	import demo.skill.knight.SkillKnight260;
	import demo.skill.knight.SkillKnight270;
	import demo.skill.magic.MagicData;
	import demo.skill.special.SkillAttackARCH210;
	import demo.skill.special.SkillAttackARCH250;
	import demo.skill.special.SkillAttackARCH260;
	import demo.skill.special.SkillAttackARCH270;
	import demo.skill.special.SkillQinglongAttack8;
	import demo.skill.special.SkillQinglongAttack9;
	import demo.skill.special.SkillQinglongHealing7;
	import demo.skill.taotie.SkillTaoTie210;
	import demo.skill.taotie.SkillTaoTie250;
	import demo.skill.td.SkillTianXiangAttack1;
	import demo.skill.td.SkillTianXiangAttack2;
	import demo.skill.td.SkillTianXiangAttack3;
	import demo.ui.UIPanel;

	public class SkillManager extends EventDispatcher {

		public var publicCdTime:int = 300;//释放完一个技能之后，只要要多久才会响应另外一个技能的请求
		
		public static var allLiveSkillEffCount 	: int;
		public static var allSkillEffCount 		: int;
		
		private static var supportSkills : Dictionary = new Dictionary;
		private static var skillClassMap : Dictionary = new Dictionary;
		
		private var _SkillImplPool : Dictionary = new Dictionary;
		private var _uiInstance    : UIPanel;
		private var _skillRolePath : SkillRolePath;

		private static var _instance : SkillManager;

		public static function getInstance() : SkillManager {
			_instance = _instance || new SkillManager();
			return _instance;
		}

		public function SkillManager() {
			init();
			_skillRolePath = new SkillRolePath();
			_uiInstance = UIPanel.instance;
		}

		private function init() : void {
			initSkillClass();

			initBattleSkillDetail();
			initCustomSkillDetail();
		}


		private function initBattleSkillDetail() : void {

		}

		private function initSkillClass() : void {
//			skillClassMap[SkillDefineEnum.RUN_TO_TOUCH] 	= SkillRunToTouch;
//			skillClassMap[SkillDefineEnum.RUN_TO_TARGET] 	= SkillRunToTarget;
			skillClassMap[SkillDefineEnum.ON_SELECT] = SkillOnSelect;
			skillClassMap[SkillDefineEnum.ON_HIT] = SkillOnHit;
			skillClassMap[SkillDefineEnum.ON_HEAL] = SkillOnHeal;
			//skillClassMap[SkillDefineEnum.PLAYER_NORMAL_ATTACK] = SkillPlayerNormalAttack;
			skillClassMap[SkillDefineEnum.PLAYER_MAGIC_ATTACK] = SkillPlayerMagicAttack;
			skillClassMap[SkillDefineEnum.PLAYER_SHOOT_ATTACK] = SkillPlayerShootAttack;
			skillClassMap[SkillDefineEnum.MONSTER_NORMAL_ATTACK] = SkillMonsterNormalAttack;

			skillClassMap[SkillDefineEnum.MONSTER_SKILL_1] = SkillMonsterAttack1;
			skillClassMap[SkillDefineEnum.MONSTER_SKILL_2] = SkillMonsterAttack2;

			skillClassMap[SkillDefineEnum.SKILL_ATTACK210] = SkillAttack210;
			skillClassMap[SkillDefineEnum.SKILL_ATTACK250] = SkillAttack250;
			skillClassMap[SkillDefineEnum.SKILL_ATTACK260] = SkillAttack260;
			skillClassMap[SkillDefineEnum.SKILL_ATTACK270] = SkillAttack270;

			skillClassMap[SkillDefineEnum.SKILL_ATTACK_ARCH210] = SkillAttackARCH210;
			skillClassMap[SkillDefineEnum.SKILL_ATTACK_ARCH250] = SkillAttackARCH250;
			skillClassMap[SkillDefineEnum.SKILL_ATTACK_ARCH260] = SkillAttackARCH260;
			skillClassMap[SkillDefineEnum.SKILL_ATTACK_ARCH270] = SkillAttackARCH270;

			skillClassMap[SkillDefineEnum.SKILL_KNIGHT210] = SkillKnight210;
			skillClassMap[SkillDefineEnum.SKILL_KNIGHT250] = SkillKnight250;
			skillClassMap[SkillDefineEnum.SKILL_KNIGHT260] = SkillKnight260;
			skillClassMap[SkillDefineEnum.SKILL_KNIGHT270] = SkillKnight270;

			skillClassMap[SkillDefineEnum.SKILL_TAOTIE210] = SkillTaoTie210;
			skillClassMap[SkillDefineEnum.SKILL_TAOTIE250] = SkillTaoTie250;

			skillClassMap[SkillDefineEnum.SKILL_LION_SKILL_1] = SkillLionAttack1;
			skillClassMap[SkillDefineEnum.SKILL_DRAGON_SKILL_1] = SkillDragonAttack1;
//			skillClassMap[SkillDefineEnum.SKILL_DRAGON_SKILL_2]		= SkillDragonAttack2;
			skillClassMap[SkillDefineEnum.SKILL_DRAGON_SKILL_3] = SkillDragonAttack3;

			skillClassMap[SkillDefineEnum.FAT_BOSS_ATTACK] = SkillFatBossAttack;
			
			skillClassMap[SkillDefineEnum.SKILL_QINGLONG_SKILL_7] = SkillQinglongHealing7;
			skillClassMap[SkillDefineEnum.SKILL_QINGLONG_SKILL_8] = SkillQinglongAttack8;
			skillClassMap[SkillDefineEnum.SKILL_QINGLONG_SKILL_9] = SkillQinglongAttack9;
			
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_1] = SkillMaleWarriorAttack1;
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_2] = SkillMaleWarriorAttack2;
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_3] = SkillMaleWarriorAttack3;
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_4] = SkillMaleWarriorAttack4;
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_5] = SkillMaleWarriorAttack5;
			
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_1] = SkillMaleMageAttack1;
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_2] = SkillMaleMageAttack2;
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_3] = SkillMaleMageAttack3;
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_4] = SkillMaleMageAttack4;
			skillClassMap[SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_5] = SkillMaleMageAttack5;

			
			skillClassMap[SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_1] = SkillTianXiangAttack1;
			skillClassMap[SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_2] = SkillTianXiangAttack2;
			skillClassMap[SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_3] = SkillTianXiangAttack3;
			
			// 初始化SkillImplPool

			for (var val : String in skillClassMap) {
				var skillId : int = int(val);
				_SkillImplPool[skillId] = new SkillPool(skillId);
			}

		}

		private function initCustomSkillDetail() : void {
			var skillInfo : SkillDetailVO;
			// 与NPC说话
			skillInfo = new SkillDetailVO("RUN_TO_TOUCH");
			skillInfo.clientId = SkillDefineEnum.RUN_TO_TOUCH;
			skillInfo.singTime = 0;
			skillInfo.skillAloneCd = 0;
			skillInfo.releaseType = SkillDefineEnum.TARGET_HARMONY;
			skillInfo.skillRange = SkillDefineEnum.TOUCH_TARGET_RANGE;
			supportSkills[skillInfo.clientId] = skillInfo;
			//跑到某个玩家跟前
			skillInfo = new SkillDetailVO("RUN_TO_TARGET");
			skillInfo.clientId = SkillDefineEnum.RUN_TO_TARGET;
			skillInfo.singTime = 0;
			skillInfo.skillAloneCd = 0;
			skillInfo.releaseType = SkillDefineEnum.TARGET_HARMONY;
			skillInfo.skillRange = SkillDefineEnum.TOUCH_TARGET_RANGE;
			supportSkills[skillInfo.clientId] = skillInfo;
			//普通攻击技能
			skillInfo = new SkillDetailVO("PLAYER_NORMAL_ATTACK");
			skillInfo.clientId = SkillDefineEnum.PLAYER_NORMAL_ATTACK;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 500;
			skillInfo.situationTime = 1000;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 1;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 200;
			skillInfo.skillRadius = 100;
			supportSkills[skillInfo.clientId] = skillInfo;
			//普通弓箭手技能
			skillInfo = new SkillDetailVO("PLAYER_SHOOT_ATTACK");
			skillInfo.clientId = SkillDefineEnum.PLAYER_SHOOT_ATTACK;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 600;
			skillInfo.situationTime = 1000;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.2;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.createMagicId = MagicData.Magic_200;
			skillInfo.skillRange = 2000;
			skillInfo.skillRadius = 300;
			supportSkills[skillInfo.clientId] = skillInfo;
			//怪物普通攻击
			skillInfo = new SkillDetailVO("MONSTER_NORMAL_ATTACK");
			skillInfo.clientId = SkillDefineEnum.MONSTER_NORMAL_ATTACK;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 900;
			skillInfo.situationTime = 2000;
			skillInfo.skillAloneCd = 2500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 1;
			skillInfo.damageMulti = 1;
			skillInfo.skillRange = 150;
			skillInfo.skillRadius = 300;
			supportSkills[skillInfo.clientId] = skillInfo;
			//怪物施法1
			skillInfo = new SkillDetailVO("MONSTER_SKILL_1");
			skillInfo.clientId = SkillDefineEnum.MONSTER_SKILL_1;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 800;
			skillInfo.createMagicId = MagicData.Magic_5;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 3000;
			skillInfo.skillAloneCd = 1100;
			skillInfo.releaseType = SkillDefineEnum.TARGET_AREA;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.4;
			skillInfo.skillRange = 600;
			skillInfo.skillRadius = 100;
			skillInfo.excuteExtraCount = 1;
			skillInfo.excuteExtraDelay = 750;
			supportSkills[skillInfo.clientId] = skillInfo;
			//怪物施法2
			skillInfo = new SkillDetailVO("MONSTER_SKILL_2");
			skillInfo.clientId = SkillDefineEnum.MONSTER_SKILL_2;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 800;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 3000;
			skillInfo.skillAloneCd = 1100;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 1;
			skillInfo.damageMulti = 0.8;
			skillInfo.skillRange = 600;
			skillInfo.skillRadius = 100;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;

			//lion skill1
			skillInfo = new SkillDetailVO("SKILL_LION_ATTACK_1");
			skillInfo.clientId = SkillDefineEnum.SKILL_LION_SKILL_1;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 600;
			skillInfo.situationTime = 1500;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 1;
			skillInfo.damageMulti = 2;
			skillInfo.skillRange = 150;
			skillInfo.excuteExtraCount = 1;
			skillInfo.excuteExtraDelay = 200;
			skillInfo.skillRadius = 300;
			supportSkills[skillInfo.clientId] = skillInfo;

			//dragon skill 1
			skillInfo = new SkillDetailVO("SKILL_DRAGON_SKILL_1");
			skillInfo.clientId = SkillDefineEnum.SKILL_DRAGON_SKILL_1;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 1000;
			skillInfo.situationTime = 4000;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 1;
			skillInfo.damageMulti = 2;
			skillInfo.skillRange = 150;
			skillInfo.excuteExtraCount = 4;
			skillInfo.excuteExtraDelay = 100;
			skillInfo.skillRadius = 600;
			supportSkills[skillInfo.clientId] = skillInfo;
			//dragon skill 2
			skillInfo = new SkillDetailVO("SKILL_DRAGON_SKILL_2");
			skillInfo.clientId = SkillDefineEnum.SKILL_DRAGON_SKILL_2;
			skillInfo.singTime = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = 1;
			skillInfo.situationTime = 1500;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.4;
			skillInfo.skillRange = 50;
			skillInfo.skillRadius = 600;
			supportSkills[skillInfo.clientId] = skillInfo;
			//dragon skill 3
			skillInfo = new SkillDetailVO("SKILL_DRAGON_SKILL_3");
			skillInfo.clientId = SkillDefineEnum.SKILL_DRAGON_SKILL_3;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = MagicData.Magic_4;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_2;
			skillInfo.situationTime = 1500;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 150;
			skillInfo.skillRadius = 600;
			supportSkills[skillInfo.clientId] = skillInfo;

			//SKILL_ATTACK210
			skillInfo = new SkillDetailVO("SKILL_ATTACK210");
			skillInfo.clientId = SkillDefineEnum.SKILL_ATTACK210;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 400;
			skillInfo.situationTime = 1000;
			skillInfo.skillAloneCd = 1500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 4;
			skillInfo.damageMulti = 0.2;
			skillInfo.skillRange = 150;
			skillInfo.excuteExtraCount = 3;
			skillInfo.excuteExtraDelay = 150;
			skillInfo.skillRadius = 400;
			supportSkills[skillInfo.clientId] = skillInfo;

			//SKILL_ATTACK250
			skillInfo = new SkillDetailVO("SKILL_ATTACK250");
			skillInfo.clientId = SkillDefineEnum.SKILL_ATTACK250;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 600;
			skillInfo.createMagicId = 0;
			skillInfo.situationTime = 1000;
			skillInfo.skillAloneCd = 800;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 999;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 150;
			skillInfo.skillRadius = 800;
			supportSkills[skillInfo.clientId] = skillInfo;

			//SKILL_ATTACK260
			skillInfo = new SkillDetailVO("SKILL_ATTACK260");
			skillInfo.clientId = SkillDefineEnum.SKILL_ATTACK260;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 400;
			skillInfo.createMagicId = MagicData.Magic_3;
			skillInfo.createMagicType = 1;
			skillInfo.situationTime = 1000;
			skillInfo.skillAloneCd = 3000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.2;
			skillInfo.skillRange = 150;
			skillInfo.skillRadius = 200;
			supportSkills[skillInfo.clientId] = skillInfo;

			//SKILL_ATTACK270
			skillInfo = new SkillDetailVO("SKILL_ATTACK270");
			skillInfo.clientId = SkillDefineEnum.SKILL_ATTACK270;
			skillInfo.stateType = SkillDefineEnum.SKILL_STATE_PETRIFY;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 400;
			skillInfo.createMagicId = MagicData.Magic_Light;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1000;
			skillInfo.skillAloneCd = 1200;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 1500;
			skillInfo.skillRadius = 100;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;

			//knight skill
			skillInfo = new SkillDetailVO("KNIGHT_NORMAL_ATTACK");
			skillInfo.clientId = SkillDefineEnum.FAT_BOSS_ATTACK;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 1500;
			skillInfo.situationTime = 3000;
			skillInfo.skillAloneCd = 4000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 1;
			skillInfo.damageMulti = 0;
			skillInfo.skillRange = 150;
			skillInfo.skillRadius = 300;
			supportSkills[skillInfo.clientId] = skillInfo;

			//弓箭手技能210(指向性非目标放一个直行非命中箭矢)
			skillInfo = new SkillDetailVO("SKILL_ATTACK_ARCH210");
			skillInfo.clientId = SkillDefineEnum.SKILL_ATTACK_ARCH210;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 600;
			skillInfo.createMagicId = MagicData.Magic_210;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_3;
			skillInfo.situationTime = 1000;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.2;
			skillInfo.skillRange = 1200;
			skillInfo.skillRadius = 100;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			//弓箭手技能250(指向性非目标放一个直行非命中箭矢)
			skillInfo = new SkillDetailVO("SKILL_ATTACK_ARCH250");
			skillInfo.clientId = SkillDefineEnum.SKILL_ATTACK_ARCH250;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 700;
			skillInfo.createMagicId = MagicData.Magic_250;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1000;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_SINGLE_ENEMY;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 1500;
			skillInfo.skillRadius = 100;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			//弓箭手技能原地转圈
			skillInfo = new SkillDetailVO("SKILL_ATTACK_ARCH260");
			skillInfo.clientId = SkillDefineEnum.SKILL_ATTACK_ARCH260;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 400;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1500;
			skillInfo.skillAloneCd = 1500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 6;
			skillInfo.damageMulti = 0.2;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 2;
			skillInfo.excuteExtraDelay = 200;
			supportSkills[skillInfo.clientId] = skillInfo;
			//弓箭手技能原地转圈2
			skillInfo = new SkillDetailVO("SKILL_ATTACK_ARCH270");
			skillInfo.clientId = SkillDefineEnum.SKILL_ATTACK_ARCH270;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 500;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 2000;
			skillInfo.skillAloneCd = 2000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 6;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 1;
			skillInfo.excuteExtraDelay = 200;
			supportSkills[skillInfo.clientId] = skillInfo;

			//骑士技能1
			skillInfo = new SkillDetailVO("SKILL_KNIGHT210");
			skillInfo.clientId = SkillDefineEnum.SKILL_KNIGHT210;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 600;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1200;
			skillInfo.skillAloneCd = 1200;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 999;
			skillInfo.damageMulti = 0.2;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 800;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			//骑士技能2
			skillInfo = new SkillDetailVO("SKILL_KNIGHT250");
			skillInfo.clientId = SkillDefineEnum.SKILL_KNIGHT250;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 800;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1200;
			skillInfo.skillAloneCd = 1200;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 999;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 1000;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			//骑士技能3
			skillInfo = new SkillDetailVO("SKILL_KNIGHT260");
			skillInfo.clientId = SkillDefineEnum.SKILL_KNIGHT260;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 500;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1200;
			skillInfo.skillAloneCd = 1200;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 6;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			//骑士技能4
			skillInfo = new SkillDetailVO("SKILL_KNIGHT270");
			skillInfo.clientId = SkillDefineEnum.SKILL_KNIGHT270;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 500;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1200;
			skillInfo.skillAloneCd = 1200;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 6;
			skillInfo.damageMulti = 0.2;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;

			//taotie1
			skillInfo = new SkillDetailVO("SKILL_TAOTIE210");
			skillInfo.clientId = SkillDefineEnum.SKILL_TAOTIE210;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 600;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1200;
			skillInfo.skillAloneCd = 1200;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 999;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 1000;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			//taotie2
			skillInfo = new SkillDetailVO("SKILL_TAOTIE250");
			skillInfo.clientId = SkillDefineEnum.SKILL_TAOTIE250;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 700;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 3200;
			skillInfo.skillAloneCd = 3500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 999;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 1;
			skillInfo.excuteExtraDelay = 1400;
			supportSkills[skillInfo.clientId] = skillInfo;

			//jiruqinglong
			//210 yi wu qing cheng
			skillInfo = new SkillDetailVO("SKILL_QINGLONG_SKILL_7");
			skillInfo.clientId = SkillDefineEnum.SKILL_QINGLONG_SKILL_7;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 700;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 5300;
			skillInfo.skillAloneCd = 5400;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 0;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;

			//250 
			skillInfo = new SkillDetailVO("SKILL_QINGLONG_SKILL_8");
			skillInfo.clientId = SkillDefineEnum.SKILL_QINGLONG_SKILL_8;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 400;
			skillInfo.createMagicId = MagicData.Null;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 3350;
			skillInfo.skillAloneCd = 3400;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.2;
			skillInfo.skillRange = 150;
			skillInfo.skillRadius = 200;
			supportSkills[skillInfo.clientId] = skillInfo;
			
			skillInfo = new SkillDetailVO("SKILL_QINGLONG_SKILL_9");
			skillInfo.clientId = SkillDefineEnum.SKILL_QINGLONG_SKILL_9;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 400;
			skillInfo.createMagicId = MagicData.Null;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 6500;
			skillInfo.skillAloneCd = 6550;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.2;
			skillInfo.skillRange = 150;
			skillInfo.skillRadius = 200;
			supportSkills[skillInfo.clientId] = skillInfo;
			
			// 传奇战士
			// 半月弯刀
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_WARRIOR_SKILL_1");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_1;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1000;
			skillInfo.skillLifeTime = 4000;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			// 刺杀剑术
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_WARRIOR_SKILL_2");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_2;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1000;
			skillInfo.skillLifeTime = 4000;
			skillInfo.skillAloneCd = 1000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			// 烈火剑法
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_WARRIOR_SKILL_3");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_3;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1000;
			skillInfo.skillLifeTime = 3500;
			skillInfo.skillAloneCd = 3500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			// 破击剑法
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_WARRIOR_SKILL_4");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_4;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1500;
			skillInfo.skillLifeTime = 1500;
			skillInfo.skillAloneCd = 1500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			// 狮子吼
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_WARRIOR_SKILL_5");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_WARRIOR_SKILL_5;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1500;
			skillInfo.skillLifeTime = 1500;
			skillInfo.skillAloneCd = 1500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			
			// 传奇法师
			// 火球术
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_MAGE_SKILL_1");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_1;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 750;
			skillInfo.skillLifeTime = 3000;
			skillInfo.skillAloneCd = 3000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			// 疾光电影
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_MAGE_SKILL_2");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_2;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1500;
			skillInfo.skillLifeTime = 3000;
			skillInfo.skillAloneCd = 3000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			// 冰咆哮
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_MAGE_SKILL_3");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_3;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1250;
			skillInfo.skillLifeTime = 3000;
			skillInfo.skillAloneCd = 4000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			// leidian
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_MAGE_SKILL_4");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_4;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1000;
			skillInfo.skillLifeTime = 2500;
			skillInfo.skillAloneCd = 3000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			// 魔法盾
			skillInfo = new SkillDetailVO("SKILL_CQ_MALE_MAGE_SKILL_5");
			skillInfo.clientId = SkillDefineEnum.SKILL_CQ_MALE_MAGE_SKILL_5;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1500;
			skillInfo.skillLifeTime = 12000;
			skillInfo.skillAloneCd = 6000;
			skillInfo.releaseType = SkillDefineEnum.TARGET_FREE;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			supportSkills[skillInfo.clientId] = skillInfo;
			
			skillInfo = new SkillDetailVO("SKILL_TD_TIAN_XIANG_SKILL_1");
			skillInfo.clientId = SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_1;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1000;//5000;
			skillInfo.skillLifeTime = 1000;//10000;
			skillInfo.skillAloneCd = 800;//2500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			skillInfo.baseSkillId = SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_1;
			skillInfo.nextSkillId = SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_2;
			supportSkills[skillInfo.clientId] = skillInfo;
			
			
			skillInfo = new SkillDetailVO("SKILL_TD_TIAN_XIANG_SKILL_2");
			skillInfo.clientId = SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_2;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1300;//6500;
			skillInfo.skillLifeTime = 1500;//10000;
			skillInfo.skillAloneCd = 700;//3500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			skillInfo.baseSkillId = SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_1;
			skillInfo.nextSkillId = SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_3;
			supportSkills[skillInfo.clientId] = skillInfo;
			
			skillInfo = new SkillDetailVO("SKILL_TD_TIAN_XIANG_SKILL_3");
			skillInfo.clientId = SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_3;
			skillInfo.singTime = 0;
			skillInfo.excuteDelay = 0;
			skillInfo.createMagicId = 0;
			skillInfo.createMagicType = SkillDefineEnum.MAGIC_0;
			skillInfo.situationTime = 1000;//5000;
			skillInfo.skillLifeTime = 1500;//10000;
			skillInfo.skillAloneCd = 700;//3500;
			skillInfo.releaseType = SkillDefineEnum.TARGET_DIRECTION;
			skillInfo.damageCount = 0;
			skillInfo.damageMulti = 0.1;
			skillInfo.skillRange = 500;
			skillInfo.skillRadius = 500;
			skillInfo.excuteExtraCount = 0;
			skillInfo.excuteExtraDelay = 0;
			skillInfo.baseSkillId = SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_1;
			supportSkills[skillInfo.clientId] = skillInfo;
		}

		public function update(curTime : uint, deltaTime : uint) : void {
			for each (var pool : SkillPool in _SkillImplPool) {
				pool.render(curTime, deltaTime);
			}
		}

		public function clearSkill() : void {
			for each (var pool : SkillPool in _SkillImplPool) {
				pool.clearSkill();
			}

			reduceCache(true);
		}

		public function reduceCache(clear : Boolean) : int {
			var result : int;

			for each (var pool : SkillPool in _SkillImplPool) {
				result += pool.reduceCache(clear);
			}
			return result;
		}

		static public function getSkillTypeById(skillId : int) : int {
			switch (skillId) {
				case SkillDefineEnum.RUN_TO_TOUCH:
				case SkillDefineEnum.RUN_TO_TARGET:
				case SkillDefineEnum.NO_SKILL:
					return SkillDefineEnum.SKILLTYPE_CLIENT;

				default:
					return SkillDefineEnum.SKILLTYPE_BATTLE;
			}
		}

		public function createSkillById(skillId : int) : SkillBase {
			if (_SkillImplPool[skillId] == null) {
				return null;
			}
			var pool : SkillPool = _SkillImplPool[skillId];
			var skill : SkillBase = pool.getFreeSkill(skillId);
			return skill;
		}

		// 角色被攻击
		public function onHit(player : Avatar3D, bySkillId : int, ModifierId : uint, Arg1 : int) : void {
			var targetId : uint = player.id;
			var caster : Avatar3D = WorldManager.instance.getAvatar3D(ModifierId);
			if (caster == null) {
				return;
			}
			var skillBase : SkillBase = createSkillById(SkillDefineEnum.ON_HIT);
			var bySkill : SkillDetailVO = supportSkills[SkillDefineEnum.ON_HIT];
			var skillInfo : SkillDetailVO = supportSkills[bySkillId];
			if (skillBase && bySkillId) {
				skillBase.parentSkill = bySkill;
				skillBase.tryCastSkill(caster, skillInfo, targetId, [Arg1], null);
				skillBase.skillCastTargetId = targetId;
				skillBase.checkNowCastEnable();
			}
		}

		// 角色加血
		public function onHeal(player : Avatar3D, bySkillId : uint) : void {
			var targetId : uint = player ? player.id : 0;
			var skillBase : SkillBase = createSkillById(SkillDefineEnum.ON_HEAL);
			var skillInfo : SkillDetailVO = supportSkills[SkillDefineEnum.ON_HEAL];
			var bySkill : SkillDetailVO = supportSkills[bySkillId];
			if (skillBase) {
				skillBase.parentSkill = bySkill;
				skillBase.tryCastSkill(player, skillInfo, targetId, null, null);
				skillBase.checkNowCastEnable();
			}
		}


		private var _selectSkill : SkillBase;

		// 角色选中
		public function onSelect(player : Avatar3D) : void {
			var targetId : uint = player ? player.id : 0;
			_selectSkill ||= createSkillById(SkillDefineEnum.ON_SELECT);
			var skillInfo : SkillDetailVO = supportSkills[SkillDefineEnum.ON_SELECT];
			var me : Avatar3D = GameManager.getInstance().mainRole;
			if (_selectSkill) {
				_selectSkill.tryCastSkill(me, skillInfo, targetId, null, null);
				_selectSkill.skillCastTargetId = targetId;
				_selectSkill.checkNowCastEnable();
			}

		}


		public function getSkillCachCount() : int {
			var pool : SkillPool;
			var count : int;

			for each (pool in _SkillImplPool) {
				count += pool.getSkillCacheCount();
			}
			return count;
		}

		public function onSkillOpearate(skillId : int) : void {
			var event : SkillEvent = new SkillEvent(SkillEvent.SKILL_OPEARATE);
			event.skillID = skillId;
			_instance.dispatchEvent(event);
		}

		public function getSkillAtIndex(index : int) : SkillDetailVO {
			return _uiInstance.skillBar.getSkillAtIndex(index);
		}

		public function getSkillPath(skillType : String) : String {
			var roleType : int = GameManager.getInstance().mainRole.playerType;
			return _skillRolePath.getSkillPathByRole(roleType, skillType);
		}

		public function getSkillClass(skillId : int) : Class {
			var skillClass : Class = skillClassMap[skillId];
			return skillClass;
		}

		public function getSkillInfo(skillId : int) : SkillDetailVO {
			var skillInfo : SkillDetailVO = supportSkills[skillId];
			return skillInfo;
		}

		public function updateSkillCd(deltaTime : Number) : void {
			for each (var skill : SkillDetailVO in supportSkills) {
				skill.cdRemain -= deltaTime;
			}
		}

		public function copySkillIdsByRole(role : int) : Vector.<int> {
			return _skillRolePath.copySkillIdsByRole(role);
		}

	}
}


