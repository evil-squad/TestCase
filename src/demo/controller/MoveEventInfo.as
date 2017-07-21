package demo.controller
{
	public class MoveEventInfo extends AnimationEventInfo
	{
		public var endTime:int;
		public var distance:Number;
		public var movedDistance:Number = 0;
		public var duration:int;
		
		public function MoveEventInfo(startTime:int,endTime:int,distance:Number,handled:Boolean = false)
		{
			super(startTime,handled);
			this.endTime = endTime;
			this.distance = distance;
			this.duration = endTime - startTime;
		}
		
		public function getCurrentDistance(t:int):Number
		{
			var targetDis:Number = distance * (t - time)/duration;
			var deltaDistance:Number = targetDis - movedDistance;
			movedDistance = targetDis;
			return deltaDistance;
		}
	}
}