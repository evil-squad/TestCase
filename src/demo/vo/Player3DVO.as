package demo.vo {

	import demo.enum.RoleEnum;
	import demo.path.ModelRolePath;

	public class Player3DVO extends Avatar3DVO {

		private var _playerType : int;

		public function get playerType() : int {
			return _playerType;
		}
		
		public function set playerType(value : int) : void {
			type = value;
			_playerType = value;
			if (_playerType == 0) {
				return;
			}
			name = RoleEnum.roleName(_playerType);
			url  = ModelRolePath.instance.getRolePath(_playerType);
			weaponUrl  = ModelRolePath.instance.getWeaponPath(_playerType);
			weaponBone = (_playerType % 2 == 1) ? "b_r_wq_01" : "b_l_wq_01";
			nameTextContainer = "c_0_name_01";
			nameShowContainer = "b_0_body_01";
		}
		
	}
}
