package demo.resource
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.ParserEvent;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.parsers.AWD2Parser;
	
	public class Resource3DLoader1 extends EventDispatcher
	{
		protected var _loader:AssetLoader;
		protected var _url:String;
		
		public function Resource3DLoader1()
		{
			super();
		}
		
		public function load(url:String):void
		{
			_url = url;
			_loader = new AssetLoader();
			
			_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			_loader.addEventListener(LoaderEvent.LOAD_ERROR,onLoadError);
			_loader.addEventListener(ParserEvent.PARSE_ERROR,onParseError);
			
			_loader.load(new URLRequest(_url),null,null,new AWD2Parser());
		}
		
		public function get url():String
		{
			return _url;
		}
		
		protected function onAssetComplete(e:AssetEvent):void
		{
			
		}
		
		protected function onResourceComplete(e:LoaderEvent):void
		{
			removeLoaderEvents();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onParseError(e:ParserEvent):void
		{
			removeLoaderEvents();
			this.dispatchEvent(new Event(e.type));
		}
		
		protected function onLoadError(e:LoaderEvent):void
		{
			removeLoaderEvents();
			this.dispatchEvent(new Event(e.type));
		}
		
		protected function removeLoaderEvents():void
		{
			if(_loader)
			{
				_loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
				_loader.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
				_loader.removeEventListener(LoaderEvent.LOAD_ERROR,onLoadError);
				_loader.removeEventListener(ParserEvent.PARSE_ERROR,onParseError);
				_loader = null;
			}
		}
	}
}