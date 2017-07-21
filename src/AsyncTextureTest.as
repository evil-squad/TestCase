package
{
	
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.system.System;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.AsyncTexture2D;
	import away3d.tick.Tick;
	
	
	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW", width = "1600", height = "900")]
	public class AsyncTextureTest extends ExampleTemplate
	{
		private const ROW:int = 5;
		private const COL:int = 5;
		
		private var spheres:Vector.<Mesh>;
		private var container :ObjectContainer3D = new ObjectContainer3D();
		
		private var textureNames:Vector.<String> = new Vector.<String>;
		private var root:String = "../assets/textures/AsyncTextures/";
		
		public function AsyncTextureTest()
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
			textureNames.push("ttt1.png.atf");
			textureNames.push("ttt2.png.atf");
			textureNames.push("ttt3.png.atf");
			textureNames.push("ttt4.png.atf");
			textureNames.push("ttt5.png.atf");
			textureNames.push("ttt6.png.atf");
			textureNames.push("ttt7.png.atf");
			textureNames.push("ttt8.png.atf");
			
			
			for( var k:int=0; k<textureNames.length; k++)
			{
				textureNames[k] = root + textureNames[k];
			}
			
			spheres = new Vector.<Mesh>(ROW*COL,true);
			var cur:int = 0;
			var y:Number = -200;
			
			for(var i:int=0; i<ROW; i++)
			{
				var x:Number = -200;
				for(var j:int = 0; j<COL; j++)
				{
					spheres[cur] = new Mesh(new SphereGeometry(), new TextureMaterial());
					spheres[cur].x = x;
					spheres[cur].y = y;
					container.addChild(spheres[cur]);
					cur++;
					x += 100;
				}
				y += 100;
			}
			
			Tick.instance.addCallBack(onTick);
			
			return container;
		}
		
		private var frameCount:int;
		
		private function onTick(time:int):void
		{
			if(frameCount==5)
			{
				var texture:AsyncTexture2D = new AsyncTexture2D(false);
				texture.load(textureNames[int(Math.random()*textureNames.length)]);
				
				var mesh:Mesh = spheres[int(spheres.length*Math.random())];
				if(TextureMaterial(mesh.material).texture)
				{
					TextureMaterial(mesh.material).texture.dispose();
				}
				TextureMaterial(mesh.material).texture = texture;
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