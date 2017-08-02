package demo.controller
{
	

	public class HideOrShowEventInfo extends AnimationEventInfo
	{
		public var objName:String;
		public var objs:Array = [];
		public var show:Boolean;
		
		public function HideOrShowEventInfo(time:int,objName:String,show:Boolean,handled:Boolean = false)
		{
			super(time,handled);
			this.objName = objName;
			this.show = show;
		}
		
		public function showOrHide(visible:Boolean = true):void
		{
			for(var i:int = objs.length - 1; i >= 0; i--)
			{
				if(objs[i].visible != visible)
					objs[i].visible = visible;
			}
		}
	}
}