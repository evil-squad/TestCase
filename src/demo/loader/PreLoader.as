package demo.loader
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	
	import gs.TweenLite;
	import gs.easing.Linear;
	
	import starling.core.Starling;
	
	/**
	 * 
	 * 在加载完正式游戏进度条之前的预加载进度
	 * @author wewell@163.com
	 * 
	 */	
	public class PreLoader
	{
		private var _firstLoadMc : MovieClip;
		private var _titleTextFlied : TextField;
		private var _loadingMC : MovieClip;
		private var _stage : Stage;
		private var _barPercent : Number = 0;
		
		public function PreLoader()
		{
			_firstLoadMc = new FirstLoadingMc();
			_titleTextFlied = _firstLoadMc["txt"];
			_loadingMC = _firstLoadMc["mc"];
		}
		
		private function removeFirstLoadMc() : void
		{
			if (_firstLoadMc)
			{
				if (_firstLoadMc.parent)
					_firstLoadMc.parent.removeChild(_firstLoadMc);
				_firstLoadMc = null;
			}
			_titleTextFlied = null;
			if (_loadingMC)
			{
				_loadingMC.stop();
				_loadingMC = null;
			}
		}
		
		public function show() : void
		{
			if (_stage)
				return;
			_stage = Starling.current.nativeStage;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			if (_firstLoadMc)
			{
				_stage.addChild(_firstLoadMc);
			}
			onStageResize();
		}
		
		public function hide() : void
		{
			if (_stage)
			{
				_stage.removeEventListener(Event.RESIZE, onStageResize);
				_stage = null;
			}
			if (_firstLoadMc)
			{
				if (_firstLoadMc.parent)
					_firstLoadMc.parent.removeChild(_firstLoadMc);
			}
			if (_loadingMC)
			{
				_loadingMC.stop();
			}
			TweenLite.killTweensOf(this);
		}
		
		private function onStageResize(e : flash.events.Event = null) : void
		{
			if (!_stage)
				return;
			
			if (_firstLoadMc)
			{
				_firstLoadMc.x = int((_stage.stageWidth - _firstLoadMc.width) * 0.5);
				_firstLoadMc.y = int((_stage.stageHeight - _firstLoadMc.height) * 0.5);
			}
		}
		
		public function set percent(value : Number) : void
		{
			if (!_stage)
				return;
			TweenLite.killTweensOf(this);
			if (value > 0 && value < 1 && value > _barPercent)
				TweenLite.to(this, 0.5, {barPercent: value, ease: Linear.easeNone});
			else
				barPercent = value;
		}
		
		public function get barPercent() : Number
		{
			return _barPercent;
		}
		
		public function set barPercent(value : Number) : void
		{
			_barPercent = value;
			if (_titleTextFlied)
			{
				_titleTextFlied.text = int(_barPercent * 100) + "%";
			}
			if (_loadingMC)
			{
				_loadingMC.gotoAndStop(int(_barPercent * 100));
			}
		}
		
		public function destroy() : void
		{
			removeFirstLoadMc();
			if (_stage)
			{
				_stage.removeEventListener(Event.RESIZE, onStageResize);
				_stage = null;
			}
		}
	}
}