package demo.events {

	import flash.events.Event;

	public class SkillEvent extends Event {
		
		public static const SKILL_OPEARATE : String = "SkillOpearate";
		
		public var skillID : int;

		public function SkillEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
}
