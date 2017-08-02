package demo.utils
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 *  分帧执行
	 * @author guoqing.wen
	 * 
	 */
	public class FrameDispatch
	{
		private static var _frameFuns:Array = [];
		private static var _preFrameTime:uint = 0;
		
		public static var maxFrameTime:uint = 8;//每帧执行最大时间，默认8ms
		public function FrameDispatch()
		{
		}
		
		static public function addFun(callFunc:Function, ...callArgs):void
		{
			if (callFunc != null)
			{
				if (_frameFuns.length == 0)
					Stage3DLayerManager.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_frameFuns.push(new FrameBranch(callFunc, callArgs));
			}
		}
		
		protected static function onEnterFrame(event:Event):void
		{
			var branch:FrameBranch = null;
			var frameTime:int = 0;
			
			_preFrameTime = getTimer();
			while(_frameFuns.length > 0)
			{
				branch = _frameFuns.shift();
				branch.runFun.apply(null, branch.runArgs);
				frameTime = getTimer();
				if (frameTime - _preFrameTime > maxFrameTime)
					break;
			}
			if (_frameFuns.length == 0)
				Stage3DLayerManager.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}

class FrameBranch
{
	public var runFun:Function;
	public var runArgs:Array;
	public function FrameBranch(call:Function, args:Array)
	{
		this.runFun = call;
		this.runArgs = args;
	}
}