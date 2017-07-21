package 
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.system.System;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.AwayStats;
	import away3d.loaders.parsers.Parsers;
	import away3d.tick.Tick;
	
	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW", width = "1600", height = "900")]
	public class AWDLoadTest extends ExampleTemplate
	{
		
		private var awdNames:Vector.<String> = new Vector.<String>;
		private var root:String = "../assets/meshes/";
		
		private var container :ObjectContainer3D = new ObjectContainer3D();
		
		public function AWDLoadTest()
		{
			super();	
		}
		
		override public function onSetupComplete():void
		{
			Parsers.enableAllBundled();
			
			Stage3DLayerManager.screenAntiAlias = 0;
			Stage3DLayerManager.viewAntiAlias   = 2;
			Stage3DLayerManager.starlingLayer.setLayer("LAYER_ALERT", 0);				
			Stage3DLayerManager.startRender();
			addChild(new AwayStats(Stage3DProxy.getInstance()));
			
			Stage3DLayerManager.getView(0).lodEnabled = false;
			Stage3DLayerManager.getView(0).camera.lens.far = 100000;
			Stage3DLayerManager.getView(0).scene.addChild(run());
			
			Tick.instance.addCallBack(doGC);
		}
		
		private function run():ObjectContainer3D
		{
			
			awdNames.push("DY_building_001.awd");
			awdNames.push("DY_building_002.awd");
			awdNames.push("DY_building_003.awd");
			awdNames.push("DY_building_004.awd");
			awdNames.push("DY_building_005.awd");
			awdNames.push("DY_building_006.awd");
			awdNames.push("DY_building_007.awd");
			awdNames.push("DY_building_008a.awd");
			awdNames.push("DY_building_tx_051d.awd");
			awdNames.push("DY_building_tx_050a.awd");
			awdNames.push("JH_Object_031.awd");
			awdNames.push("DY_building_wxm_001a.awd");
			awdNames.push("DY_building_037m.awd");
			awdNames.push("DY_building_tx_050.awd");
			awdNames.push("DY_object_030e.awd");
			awdNames.push("DY_rock_011a.awd");
			awdNames.push("DY_building_027h.awd");
						
			for( var k:int=0; k<awdNames.length; k++)
			{
				awdNames[k] = root + awdNames[k];
			}
			
			Tick.instance.addCallBack(onTick);
			
			return container;			
		}
		
		private var frameCount:int;
		
		private function onTick(time:int):void
		{
			if(frameCount==5)
			{
				var awdLoader:AWDAutoLoader = new AWDAutoLoader(awdNames[int(Math.random()*awdNames.length)]);
				awdLoader.scale(0.5*Math.random() + 0.1);
				awdLoader.x = 1000 - Math.random()*2000;
				awdLoader.y = 1000 - Math.random()*2000;
				awdLoader.z = Math.random()*10000 + 1000;
				container.addChild(awdLoader);
				frameCount = 0;
			}
			else
			{
				frameCount++;
			}
			
		}
		
		private var gcTime:int = 600;
		
		private function doGC(t:int):void
		{
			gcTime--;
			if(gcTime==0)
			{
				System.pauseForGCIfCollectionImminent(0);
				System.gc();
				gcTime = 600;
			}
		}
		
	}
}

import com.game.engine3D.loader.Resource3DLoader;

import flash.utils.setTimeout;

import away3d.containers.ObjectContainer3D;
import away3d.events.LoaderEvent;


class AWDAutoLoader extends ObjectContainer3D
{
	private var loader:Resource3DLoader;
	public function AWDAutoLoader(url:String):void
	{
		loader = new Resource3DLoader();
		loader.load(url);
		loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
	}
	
	private function onResourceComplete(e:*):void
	{
		for each(var obj:ObjectContainer3D in loader.elements)
		{
			this.addChild(obj);
		}
		
		setTimeout(removeSelf, 5000);
	}
	
	private function removeSelf():void
	{
		loader.unload();
		loader.dispose();
		this.dispose();
	}
}

