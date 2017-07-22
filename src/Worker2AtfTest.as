package
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import away3d.textures.ATFData;
	
	import demo.tester.ATFTextureDisplayer;
	
	import worker.CustomMainToWorker;
	import worker.parser.WorkerProtocol;
	
	
	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW", width = "900", height = "900")]
	public class Worker2AtfTest extends Sprite
	{
		private var textureNames:Vector.<String> = new Vector.<String>;
		private var root:String = "../assets/textures/Worker2AtfTest/";
		private var _stream:URLStream;
		private var _Time:int;
		private var _index:int = 0;
		private var _output : TextField = new TextField();
		
		public function Worker2AtfTest():void
		{
			
			textureNames.push( "Cube1_negX.jpg"); 
			textureNames.push( "dibao.jpg.atf"); 
			textureNames.push( "sky01.png.bpg"); 
			textureNames.push( "skybox2.png"); 
			
			_output.defaultTextFormat = new TextFormat(null, 20, 0xFF0000);
			_output.width = 900;
			_output.height = 900;
			_output.mouseEnabled = false;
			_output.text = "";
			addChild(_output);
			
			loadTexture();
		}	
			
		private function loadTexture():void
		{  
			if (_index>=textureNames.length)
			{
				_index = 0;
			}

			var url : String = root + textureNames[_index++];
			_output.text = "ready 2atf: " + url;
			trace(url);
			
			Security.allowDomain("*");
			
			_stream = new URLStream();	
			_stream.addEventListener(Event.COMPLETE, onStreamLoadComplete);
			_stream.load(new URLRequest(url));	
		}
		
		private function onStreamLoadComplete(e:Event):void
		{
			CustomMainToWorker.getInstance();
			var bytes:ByteArray = new ByteArray();
			_stream.readBytes(bytes);
			_stream.close();
			
			_output.text+="\n"+"org length:"+ (bytes.length / 1024).toFixed(2) + " k";
			bytes.position = 0;
			_Time = getTimer();
			var b0:int = bytes.readUnsignedByte();
			var b1:int = bytes.readUnsignedByte();
			
             if(b0 == 0x89 && b1 == 0x50)
			 {
				 _output.text+="\n"+"org type : png";
				 CustomMainToWorker.getInstance().sendData(WorkerProtocol.MW_PNGFile2BgraBmdBytes, bytes, BgraBmdBytes2ATF,onBytes2ATFError); 
			 }
			 else if (b0 == 0x42 && b1 == 0x50)
			 {
				 _output.text+="\n"+"org type : bpg";
				 CustomMainToWorker.getInstance().sendData(WorkerProtocol.MW_BPGFile2BgraBmdBytes, bytes, BgraBmdBytes2ATF,onBytes2ATFError); 
			 }	 
			 else if (b0 == 0xff && b1 == 0xd8)
			 {
				 _output.text+="\n"+"org type : jpg";
				 CustomMainToWorker.getInstance().sendData(WorkerProtocol.MW_JpegFile2BgraBmdBytes, bytes, BgraBmdBytes2ATF,onBytes2ATFError); 
			 }
			 else if (b0 == 0x41 && b1 == 0x54)
			 {
				 _output.text+="\n"+"org type : atf";
				 onloadAtf(0,0,bytes,0);
			 }
			 else
			 {
				 _output.text+="\n"+"org type : else";
				 trace("type error")
			 } 
		}
		
		private function BgraBmdBytes2ATF(cmd:int,parma1:int,bytes:ByteArray,parama2:int):void
		{
			CustomMainToWorker.getInstance().sendData(WorkerProtocol.MW_BgraBmdBytes2ATF, bytes, onloadAtf,onloadAtfError);
		}
		
		private function onBytes2ATFError(cmd:int,temp:int,error:String):void
		{
			trace(error)
		}
		
		private function onloadAtf(cmd:int,parma1:int,bytes:ByteArray,parama2:int):void
		{
			_output.text+="\n" + "2atfByteArraycomplete , length: " + (bytes.length / 1024).toFixed(2)+ " k";
			_output.text+="\n" + "totaltime : " + ( getTimer() - _Time).toString();
			
			bytes.position=0
			var atf:ATFData = new ATFData(bytes);
			var displayer:ATFTextureDisplayer = new ATFTextureDisplayer(atf, null, stage);
			addChild(displayer);
			_output.text+="\n"+"load complete!";
				
			setTimeout(loadTexture,5000);		
		}
		
		private function onloadAtfError(cmd:int,temp:int,error:String):void
		{
			trace(error)
		}
		
	}
}

