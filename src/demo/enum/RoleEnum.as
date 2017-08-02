package demo.enum {

	/**
	 * 角色类型 
	 * @author chenbo
	 * 
	 */	
	public class RoleEnum {

//		/** 人类骑士男 */
//		public static const KNIGHT_MALE 	: int = 1;
//		/** 人类弓箭手男 */
//		public static const ARCH_MALE 		: int = 2;
//		/** 人类骑士女 */
//		public static const KNIGHT_FEMALE 	: int = 3;
//		/** 人类弓箭手女 */
//		public static const ARCH_FEMALE 	: int = 4;
//		/** 老角色绿皮肤女 */
//		public static const OLD_FEMALE 		: int = 5;
//		/** 饕餮 */
//		public static const MONSTER_TAOTIE 	: int = 6;
//		/** staff */
//		public static const STAFF 			: int = 7;
		/** 天刀角色 */
		public static const ROLE_TIAN_DAO        : int = 10;
		/** 秦时明月角色 */
		public static const ROLE_QSMY            : int = 11;
		
		public static const ROLE_QSMY_NEW        : int = 12;
		/** 传奇男性法师 */
		public static const ROLE_CQ_MALE_MAGE    : int = 17;
		/** 传奇男性战士 */
		public static const ROLE_CQ_MALE_WARRIOR : int = 15;
		
		public static const ROLE_TIAN_DAO_NEW	 : int = 18;
		
		public function RoleEnum() {

		}
		
		public static function roleName(roleType : int) : String {
			var name : String = "Test";

//			switch (roleType) {
//				case KNIGHT_MALE: {
//					name = "男骑士";
//					break;
//				}
//				case ARCH_MALE: {
//					name = "男弓箭手";
//					break;
//				}
//				case KNIGHT_FEMALE: {
//					name = "女骑士";
//					break;
//				}
//				case ARCH_FEMALE: {
//					name = "女弓箭手";
//					break;
//				}
//				case OLD_FEMALE: {
//					name = "女刺客";
//					break;
//				}
//				case MONSTER_TAOTIE: {
//					name = "饕餮";
//					break;
//				}
//				case STAFF: {
//					name = "STAFF";
//					break;
//				}
//				case ROLE_TIAN_DAO: {
//					name = "TEST";
//					break;
//				}
//				default: {
//					throw new Error("角色类型错误");
//					break;
//				}
//			}
			return name;
		}
	}
}
