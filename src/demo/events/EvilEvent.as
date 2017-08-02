package demo.events {

	import flash.events.Event;

	public class EvilEvent extends Event {
		
		public static const AVATAR_SRC_COMPLETE   : String = "Avatar.Src.Complete";
		public static const PARTICLE_SRC_COMPLETE : String = "Particle.Src.Complete";
		public static const ENABLE_DEPTH_FIELD    : String = "Filter3d.depthOfField.enabel";
		
		public var data : Object;

		public function EvilEvent(Name : String) {
			super(Name);
		}
		
	}
}
