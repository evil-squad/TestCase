package demo.path {

	import demo.enum.PathEnum;
	import demo.enum.RoleEnum;

	public class ModelRolePath {
		
		private static var _instance : ModelRolePath;		// single ton
		
		private var _modelPaths : Object = {};
		private var _scaleData  : Object = {};
		
		/**
		 * single ton 
		 * @return 
		 * 
		 */		
		public static function get instance() : ModelRolePath {
			if (_instance == null) {
				_instance = new ModelRolePath();
			}
			return _instance;
		}

		public function ModelRolePath() {
			if (_instance) {
				throw new Error("Single ton");
			}
//			//人类游侠男
//			addRoleType(RoleEnum.ARCH_MALE, 	 1,  "an_suit_arch1_001", 	   	"an_wq_arch1_001");
//			//人类骑士男
//			addRoleType(RoleEnum.KNIGHT_MALE, 	 1,  "an_suit_knife1_001", 	   	"an_wq_knife1_001");
//			//人类游侠女
//			addRoleType(RoleEnum.ARCH_FEMALE, 	 1,  "an_suit_arch2_002",		"an_wq_arch2_002");
//			//人类骑士女
//			addRoleType(RoleEnum.KNIGHT_FEMALE,  1,  "an_suit_knife2_002",		"an_wq_knife2_002");
//			//老角色绿皮肤女
//			addRoleType(RoleEnum.OLD_FEMALE, 	 3,  "an_suit_old_002", 	    "");
//			//饕餮
//			addRoleType(RoleEnum.MONSTER_TAOTIE, 1,  "an_monster_taotie01_001", "");
//			//staff
//			addRoleType(RoleEnum.STAFF, 		 1.5, "an_suit_staff_001", 		"");
			
//			addRoleType(RoleEnum.ROLE_TIAN_DAO, 1, "character_all", "");
//			addRoleType(RoleEnum.ROLE_QSMY_NEW, 1, "qinshiRole", "");
//			addRoleType(RoleEnum.ROLE_QSMY, 1, "jiruqianlong_xiugai", "");
//			addRoleType(RoleEnum.ROLE_CQ_MALE_MAGE, 1, "male_fashi_animation", "male_fashi_weapon");
//			addRoleType(RoleEnum.ROLE_CQ_MALE_WARRIOR, 1, "male_zhanshi_animation", "male_zhanshi_weapon");
//			addRoleType(RoleEnum.ROLE_TIAN_DAO_NEW, 1, "tiandao_new", "");
		}

		public function addRoleType(roleType : int, scale : Number, path : String, weaponPath : String) : void {
			_modelPaths[roleType] = [path, weaponPath];
			_scaleData[roleType] = scale;
		}
		
		public function getRoleName(roleType : int) : String {
			return _modelPaths[roleType][1] + PathEnum.RES_AWD;
		}
		
		public function getRoleDir(roleType : int) : String {
			return PathEnum.ROLE_PATH + roleType + "/";	
		}
		
		public function getRoleScale(roleType : int) : Number {
			return _scaleData[roleType] || 1;
		}

		public function getRolePath(roleType : int) : String {
			return PathEnum.ROLE_PATH + roleType + "/" + _modelPaths[roleType][0] + PathEnum.RES_AWD;
		}

		public function getWeaponPath(roleType : int) : String {
			if (_modelPaths[roleType][1] == null || _modelPaths[roleType][1] == "")
				return null;
			return getRoleDir(roleType) + getRoleName(roleType);
		}

	}
}
