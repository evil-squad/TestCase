package demo.controller
{
	public class AnimationEventInfo
	{
		public var time:int;
		public var handled:Boolean;
		
		public function AnimationEventInfo(time:int,handled:Boolean = false)
		{
			this.time = time;
			this.handled = handled;
		}
	}
}