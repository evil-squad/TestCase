package
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.AwayStats;
	import away3d.events.LoaderEvent;
	import away3d.loaders.parsers.Parsers;
	import away3d.tick.Tick;
	
	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW", width = "1600", height = "900")]
	public class GenNavMeshTest extends ExampleTemplate
	{
		
		private var awdPath:String = "../assets/map/yl_scene01_wc02/yl_scene01_wc02.awd";
		
		private var loader:SceneLoader;
		
		private var root:ObjectContainer3D;
		private var view:View3D;
		
		private var _output:TextField = new TextField();
		private var count:int;
		
		public function GenNavMeshTest()
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
			
			_output.defaultTextFormat = new TextFormat(null, 20, 0xFF0000);
			_output.width = 1024;
			_output.height = 128;
			_output.mouseEnabled = false;
			_output.text = "0";
			addChild(_output);
					
			Stage3DLayerManager.getView(0).lodEnabled = false;
			Stage3DLayerManager.getView(0).camera.lens.far = 100000;
			Stage3DLayerManager.getView(0).scene.addChild(run());
			
			Tick.instance.addCallBack(doGC);
		}
		
		private function run():ObjectContainer3D
		{
			root = new ObjectContainer3D;
			root.x = -50000;
			root.y = -5000;
			root.z = -20000;
			//addChild(root);
			
			loader = new SceneLoader(awdPath);
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			root.addChild(loader);
			
			return root;
		}
				
		private function test():void
		{
			count++;
			_output.text = String(count);
			loader.gen();
		}
		
		private function onResourceComplete(e:LoaderEvent):void
		{
			setInterval(test, 100);
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

import flash.net.URLRequest;
import flash.utils.setTimeout;

import away3d.animators.IAnimator;
import away3d.animators.IAnimatorOwner;
import away3d.audio.SoundBox;
import away3d.containers.ObjectContainer3D;
import away3d.entities.SparticleMesh;
import away3d.events.AssetEvent;
import away3d.events.LoaderEvent;
import away3d.library.assets.AssetType;
import away3d.library.assets.IAsset;
import away3d.loaders.AssetLoader;
import away3d.loaders.parsers.AWD2Parser;
import away3d.pathFinding.DistrictWithPath;
import away3d.plant.PlantGroup;

class SceneLoader extends ObjectContainer3D
{
	private var _loader : AssetLoader;
	
	private var _district:DistrictWithPath;
	
	private var _url:String;
	
	public function SceneLoader(url:String)
	{
		_url = url;
		_loader = new AssetLoader();
		addLoaderEvents();
		_loader.load(new URLRequest(_url), null, null, new AWD2Parser());
	}
	
	private function addLoaderEvents() : void
	{
		if (!_loader)
			return;
		_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
		_loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
	}
	
	
	private function onAssetComplete(e : AssetEvent) : void
	{
		if (e.type == AssetEvent.ASSET_COMPLETE)
		{
			var obj : IAsset = e.asset as IAsset;
			switch (e.asset.assetType)
			{
				case AssetType.LIGHT:
				case AssetType.MESH:
				case AssetType.PROPERTY_ANIMATOR_CONTAINER:
				case AssetType.CONTAINER:
				case AssetType.COMPOSITE_ANIMATOR_GROUP:
				case AssetType.CAMERAS_ACTIVE_CONTROL_GROUP:
				case AssetType.RESOURCE_BUNDLE_INSTANCE:
				case AssetType.RIBBON:
				case AssetType.HALOSET:
				case AssetType.SKYBOX:
				case AssetType.WEATHER:
				case AssetType.CAMERA:
					if (!(obj as ObjectContainer3D).parent)
					{
						addChild(obj as ObjectContainer3D);
					}
					break;
				case AssetType.SPARTICLE_MESH:
					var particle : SparticleMesh = obj as SparticleMesh;
					if (!particle.parent || !(particle.parent is IAnimatorOwner))
					{
						particle.animator.start();
					}
					if (!(obj as ObjectContainer3D).parent)
					{
						addChild(obj as ObjectContainer3D);
					}
					break;
				case AssetType.SOUND_BOX:
					if (!(obj as SoundBox).parent)
					{
						addChild(obj as ObjectContainer3D);
						(obj as SoundBox).animator.start();
					}
					break;
				case AssetType.PLANT_GROUP:
					var plantGroup : PlantGroup = obj as PlantGroup;
					plantGroup.merge();
					if (!(obj as ObjectContainer3D).parent)
					{
						addChild(obj as ObjectContainer3D);
					}
					break;
				case AssetType.DISTRICT:
					_district = obj as DistrictWithPath;
					_district.generateNavMesh(null);
					break;
				case AssetType.ANIMATOR:
					IAnimator(obj).start();
					break;
				default:
					break;
			}
		}
	}
	
	public function gen():void
	{
		_district.generateNavMesh(null);
	}
	
	override public function dispose():void
	{
		_loader.stop();
		_loader.disposeGPUResource();
		super.dispose();
	}
	
	private function onResourceComplete(ev : LoaderEvent) : void
	{
		dispatchEvent(ev);
	}
}
