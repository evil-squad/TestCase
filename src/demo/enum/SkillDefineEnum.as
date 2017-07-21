package demo.enum {

	public class SkillDefineEnum {
		// 客户端技能		
		public static const CLIENT_SKILL 			: int = 99100000; // 客户端技能
		public static const RUN_TO_TOUCH 			: int = 99100001; // 与NPC说话
		public static const RUN_TO_TARGET 			: int = 99100003; // 跑到某个旁边去
		public static const ON_SELECT 				: int = 99100004; // 选择某对象
		public static const ON_HIT 					: int = 99100005; // 被击效果
		public static const ON_HEAL 				: int = 99100006; // 治疗效果

		// 必备技能
		public static const NO_SKILL 			 	: int = 0;
		public static const PLAYER_NORMAL_ATTACK 	: int = 1; // 玩家平砍
		public static const PLAYER_MAGIC_ATTACK  	: int = 2; // 玩家法系远程攻击
		public static const PLAYER_SHOOT_ATTACK  	: int = 3; // 玩家弓箭手普通攻击

		public static const MONSTER_NORMAL_ATTACK 	: int = 11; // 怪物平砍
		public static const MONSTER_SKILL_1 	  	: int = 12; // 怪物施法1
		public static const MONSTER_SKILL_2 	  	: int = 13; // 怪物施法2
		public static const MONSTER_RANKGE_ATTACK 	: int = 15; // 怪物普通远程

		//以下为3个职业的技能，不能乱套
		public static const SKILL_ATTACK210 		: int = 20; //绿色的特效
		public static const SKILL_ATTACK250 		: int = 21; //一圈火弹
		public static const SKILL_ATTACK260 		: int = 22; //十字劈
		public static const SKILL_ATTACK270 		: int = 23; //石化效果

		public static const SKILL_ATTACK_ARCH210 	: int = 24;
		public static const SKILL_ATTACK_ARCH250 	: int = 25;
		public static const SKILL_ATTACK_ARCH260 	: int = 26;
		public static const SKILL_ATTACK_ARCH270 	: int = 27;

		public static const SKILL_KNIGHT210 		: int = 34;
		public static const SKILL_KNIGHT250 		: int = 35;
		public static const SKILL_KNIGHT260 		: int = 36;
		public static const SKILL_KNIGHT270 		: int = 37;

		public static const SKILL_TAOTIE210 		: int = 46;
		public static const SKILL_TAOTIE250 		: int = 47;

		public static const FAT_BOSS_ATTACK 		: int = 31; // 骑士的普通攻击

		public static const SKILL_LION_SKILL_1   	: int = 101;
		public static const SKILL_DRAGON_SKILL_1 	: int = 201;
		public static const SKILL_DRAGON_SKILL_2 	: int = 202;
		public static const SKILL_DRAGON_SKILL_3 	: int = 203;

		public static const MAX_RANGE_WITH_TARGET 	: int = 2500;
		
		public static const SKILL_QINGLONG_SKILL_7	: int = 1107;
		public static const SKILL_QINGLONG_SKILL_8	: int = 1108;  
		public static const SKILL_QINGLONG_SKILL_9	: int = 1109; 
		
		public static const SKILL_CQ_MALE_WARRIOR_SKILL_1 : int = 1201;
		public static const SKILL_CQ_MALE_WARRIOR_SKILL_2 : int = 1202;
		public static const SKILL_CQ_MALE_WARRIOR_SKILL_3 : int = 1203;
		public static const SKILL_CQ_MALE_WARRIOR_SKILL_4 : int = 1204;
		public static const SKILL_CQ_MALE_WARRIOR_SKILL_5 : int = 1205;
		
		public static const SKILL_CQ_MALE_MAGE_SKILL_1 : int = 1301;
		public static const SKILL_CQ_MALE_MAGE_SKILL_2 : int = 1302;
		public static const SKILL_CQ_MALE_MAGE_SKILL_3 : int = 1303;
		public static const SKILL_CQ_MALE_MAGE_SKILL_4 : int = 1304;
		public static const SKILL_CQ_MALE_MAGE_SKILL_5 : int = 1305;
		
		
		public static const SKILL_TD_TIAN_XIANG_SKILL_1 : int = 1401;
		public static const SKILL_TD_TIAN_XIANG_SKILL_2 : int = 1402;
		public static const SKILL_TD_TIAN_XIANG_SKILL_3 : int = 1403;
		public static const SKILL_TD_TIAN_XIANG_SKILL_4 : int = 1404;
		public static const SKILL_TD_TIAN_XIANG_SKILL_5 : int = 1405;
		
		//	技能类型
		public static const SKILLTYPE_CLIENT 		: int = 1; // 客户端技能
		public static const SKLLLTYPE_MUST   		: int = 2; // 必备技能
		public static const SKILLTYPE_LIVE   		: int = 3; // 生活技能
		public static const SKILLTYPE_BATTLE 		: int = 4; // 战斗技能

		//	技能作用对象
		public static const TARGET_SINGLE_ENEMY 	: int = 1; //单个怪
		public static const TARGET_FREE 	 		: int = 2; //没有目标
		public static const TARGET_AREA 			: int = 3; //区域
		public static const TARGET_DIRECTION 		: int = 4; //方向
		public static const TARGET_HARMONY 			: int = 5;
		//			1=选择敌人释放
		//			2＝选择友方释放
		//			3＝直接释放
		//			4＝选择区域释放
		//   伤害结果
		public static const RS_NULL 				: int = -1;
		public static const RS_NORMAL 				: int = 0;
		public static const RS_MISS 				: int = 1; //未命中
		public static const RS_BLOCK 				: int = 2; //格挡
		public static const RS_CRITICAL 			: int = 3; //暴击
		public static const RS_RESIST 				: int = 4; // 抵抗
		public static const RS_AGAINST 				: int = 5; // 反弹

		/**
		 * 技能附加状态类型：石化
		 */
		public static const SKILL_STATE_PETRIFY 	: int = 1;
		
		public static const TOUCH_TARGET_RANGE  	: int = 40;

		//magic对象创建时候的类型
		//0:从施法者位置出发，到技能指定位置
		//1:从施法者出发，圆形散开多个飞出
		//2:从目标位置出发，到技能指定位置
		//3:类似寒冰射手的n发子弹.
		public static const MAGIC_0 				: int = 0;
		public static const MAGIC_1 				: int = 1;
		public static const MAGIC_2 				: int = 2;
		public static const MAGIC_3 				: int = 3;

	}
}
