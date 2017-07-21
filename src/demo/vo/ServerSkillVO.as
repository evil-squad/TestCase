package demo.vo {

	public class ServerSkillVO {

		/** 技能ID */
		public var skillId		: int;
		/** 施法者ID */
		public var casterId 	: int;
		/** 被攻击者ID */
		public var suffererId 	: int;
		/** x */
		public var x 			: Number = 0;
		/** y */
		public var y 			: Number = 0;
		/** 技能编号 */
		public var seq 			: uint;
				
		public var excuteTimeList 	: Vector.<int>;
		/** 技能存活时间 */
		public var surviveTime 		: int;
		
		public function ServerSkillVO() {
			
		}
	}
}
