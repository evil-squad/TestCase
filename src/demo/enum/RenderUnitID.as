package demo.enum {

	/**
	 * @author 	chenbo
	 * @email  	470259651@qq.com
	 * @time	Mar 24, 2016 3:41:48 PM
	 */
	public class RenderUnitID {
		
		/**主体ID(一般为衣服，也就是默认的换装类型，这是每个角色必备的换装)*/
		public static const BODY : int = IDEnum.nextID; //ID 会有跟其它换装冲突，要小心。
		
		/**武器ID*/
		public static const WEAPON : int = IDEnum.nextID;
		
		/**副武器ID*/
		public static const DEPUTY_WEAPON : int = IDEnum.nextID;
		
		/**坐骑ID */
		public static const MOUNT : int = IDEnum.nextID;
		
		/**刀光ID */
		public static const KNIFE_LIGHT : int = IDEnum.nextID;
		/**技能自身效果ID */
		public static const SPELL_SELF_EFFECT : int = IDEnum.nextID;
		/**角色被选中光环特效*/
		public static const SELECTED_RING : int = IDEnum.nextID;
		
		/**任务**/
		public static const TASK : int = IDEnum.nextID;
		/**升级**/
		public static const LEVEL : int = IDEnum.nextID;
		/**偷经**/
		public static const SCRIPTURES : int = IDEnum.nextID;
	}
}
