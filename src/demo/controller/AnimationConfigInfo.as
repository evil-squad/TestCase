package demo.controller
{
	public class AnimationConfigInfo
	{
		public var hideOrShowEvents:Array;
		public var moveEvents:Array;
		public var blendTime:int;
		public var holdTime:int;//触发连招时，当前动作至少要播放多长时间才开始执行连招动作
		public var comboTime:int;//技能可以接受连招输入的最后时间点
		public var cdTime:int;//技能的cd时间，cd时间内不能再次被触发，但是如果有连招，可以接受连招输入，或者其他连其他技能，所以cd时间一定大于接受连招输入时间		
		public var duration:int;//技能可以接受连招输入的最后时间点
		
		public var speed:Number;
		
		public function reset():void
		{
			if(hideOrShowEvents)
			{
				for(var i:int = hideOrShowEvents.length - 1; i >= 0; i--)
				{
					(hideOrShowEvents[i] as HideOrShowEventInfo).handled = false;
				}
			}
			
			if(moveEvents)
			{
				for(i = moveEvents.length - 1; i >= 0; i--)
				{
					(moveEvents[i] as MoveEventInfo).handled = false;
				}
			}
		}
	}
}