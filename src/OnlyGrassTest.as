package
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	import away3d.animators.IAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.AwayStats;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.library.assets.IAsset;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.Parsers;
	import away3d.plant.PlantGroup;
	import away3d.tick.Tick;
	
	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW", width = "1600", height = "900")]
	public class OnlyGrassTest extends ExampleTemplate
	{
		
		private var awdPath:String = "../assets/map/yl_scene01_wc02/yl_scene01_wc_only_grass.awd";
		
		private var loader:AssetLoader;
		
		private var root:ObjectContainer3D;
		
		public function OnlyGrassTest()
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
			root = new ObjectContainer3D;
			Stage3DLayerManager.getView(0).camera.position = new Vector3D(70349, 9500, 54535);
			Stage3DLayerManager.getView(0).camera.lookAt(new Vector3D(70349, 6200, 54535));
			//addChild(root);
			test();
			return root;
		}
		
		private function test():void
		{
			if(loader)
			{
				loader.stop();
				loader.disposeGPUResource();
			}
			loader = new AssetLoader();
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			loader.load(new URLRequest(awdPath), null, null, new AWD2Parser());
		}
		
		private function onAssetComplete(e : AssetEvent) : void {
			if (e.type == AssetEvent.ASSET_COMPLETE)
			{
				var obj : IAsset = e.asset as IAsset;
				switch (e.asset.assetType)
				{
					case AssetType.PLANT_GROUP:
						var plantGroup : PlantGroup = obj as PlantGroup;
						plantGroup.merge();
						root.addChild(plantGroup);
						break;
					case AssetType.ANIMATOR:
						IAnimator(obj).start();
						break;
					default:
						break;
				}
			}
		}
		
		private function onResourceComplete(e:LoaderEvent):void
		{
			setTimeout(test, 7000);
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


