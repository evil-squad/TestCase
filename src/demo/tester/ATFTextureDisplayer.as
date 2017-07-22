package demo.tester
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import away3d.premium.MipmapBytesGenerator;
	import away3d.textures.ATFData;
	import away3d.tools.utils.TextureUtils;
	
	public class ATFTextureDisplayer extends Sprite
	{
		
		private var _imageWidth:int;
		private var _imageHeight:int;
		private var _stage:Stage;
		
		private var _atfBytes:ByteArray;
		private var _context3d:Context3D;
		private var _vertexBuffer:VertexBuffer3D;
		private var _uvBuffer:VertexBuffer3D;
		private var _vertexShader:ByteArray;
		private var _shaderProgram:Program3D;
		private var _fragmentShader:ByteArray;
		
		private var _bmd:BitmapData;
		private var _atf:ATFData;
		public function ATFTextureDisplayer(data:ATFData, bmd:BitmapData, stage:Stage)
		{
			_atf = data;
			_bmd = bmd;
			
			if(_atf)
			{
				_imageWidth = _atf.width;
				_imageHeight = _atf.height;
				_atfBytes = data.data;
			}
			else if(_bmd)
			{
				_imageWidth = _bmd.width;
				_imageHeight = _bmd.height;
			}
			
			_stage = stage;
			
			
			_stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onCreate);
			_stage.stage3Ds[0].requestContext3D();
		}
		
		
		private function onCreate(e:Event):void
		{
			_context3d = _stage.stage3Ds[0].context3D;
			_context3d.configureBackBuffer(1024, 1024, 0, true);
			_context3d.enableErrorChecking = true;
			
			
			var texture:Texture;
			if(_atf)
			{
				var format:String = TextureUtils.getContext3DTextureFormat(_atf.width,_atf.height,_atf.hasAlpha,_atf.compressed);
				texture = _context3d.createTexture(_imageWidth, _imageHeight,format, false);
				texture.uploadCompressedTextureFromByteArray(_atfBytes, 0, false);
			}
			else if(_bmd)
			{
				texture = _context3d.createTexture(_imageWidth, _imageHeight, Context3DTextureFormat.COMPRESSED_ALPHA, false, 0);
				var time:int = getTimer();
				MipmapBytesGenerator.BGRAMipMaps(_bmd.getPixels(_bmd.rect),width,height,texture,-1,true,0)
				//MipmapGenerator.generateMipMaps(_bmd, texture, null, true);
				//				texture.uploadFromBitmapData(_bmd, 0);
				trace("upload bmd texture: ", getTimer() - time);
			}
			
			var _meshVertexData:Vector.<Number> = Vector.<Number>([ 
				//X,  Y, Z
				-1, 1, 0,  
				1, 1, 0,
				1, -1, 0,
				-1, -1, 0,
			]); 
			var _meshUVData:Vector.<Number> = Vector.<Number>([ 
				.0, .0, 1.0, .0, 1.0, 1.0, .0, 1.0
			]); 
			
			var _meshInexData:Vector.<uint> = Vector.<uint>([ 
				0, 1, 2, 0, 2, 3
			]); 
			
			
			_vertexBuffer = _context3d.createVertexBuffer(_meshVertexData.length / 3, 3); 
			_vertexBuffer.uploadFromVector(_meshVertexData, 0, _meshVertexData.length / 3); 
			
			_uvBuffer = _context3d.createVertexBuffer(_meshUVData.length / 2, 2); 
			_uvBuffer.uploadFromVector(_meshUVData, 0, _meshUVData.length / 2); 
			
			_indexBuffer = _context3d.createIndexBuffer(_meshInexData.length); 
			_indexBuffer.uploadFromVector(_meshInexData, 0, _meshInexData.length); 
			
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler(); 
			_vertexShader = vertexShaderAssembler.assemble( 
				Context3DProgramType.VERTEX, 
				"mov op, va0\n" + 
				"mov v0, va1\n"
			); 
			
			var sampler:String;
			if(_atf)
			{
				// color(ft2) = texsample uv(ft0.xy)
				format = TextureUtils.getContext3DTextureFormat(_atf.width,_atf.height,_atf.hasAlpha,_atf.compressed);
				sampler = "tex ft1, ft0.xy, fs0 <2d,clamp,linear,miplinear,dxt" + (format == Context3DTextureFormat.COMPRESSED_ALPHA ? 5 : 1) + "> \n";
			}
			else if(_bmd)
			{
				//				sampler = "tex ft1, ft0.xy, fs0 <2d,clamp,linear> \n";
				sampler = "tex ft1, ft0.xy, fs0 <2d,clamp,linear,miplinear,dxt5> \n";
			}
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler(); 
			_fragmentShader = fragmentShaderAssembler.assemble( 
				Context3DProgramType.FRAGMENT, 
				"mov ft0, v0 \n" +			// ft0 = v0 = uv
				sampler + 
				"mov oc, ft1\n"					// output ft2
			); 
			
			_shaderProgram = _context3d.createProgram(); 
			_shaderProgram.upload(_vertexShader, _fragmentShader); 
			
			
			_context3d.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); 
			_context3d.setVertexBufferAt(1, _uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); 
			
			_context3d.setTextureAt(0, texture);
			
			_context3d.setProgram(_shaderProgram); 
			
			_stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private var _indexBuffer:IndexBuffer3D;
		
		private var _counter:int;
		
		private var _lastB:int = 600;
		
		private function update(e:Event):void
		{
			_counter ++;
			if(_counter % 30 == 29)
			{
				_lastB *= 0.8;
				//				_context3d.configureBackBuffer(_lastB, _lastB, 0, true);
				
				if(_lastB <= 50)
				{
					_stage.removeEventListener(Event.ENTER_FRAME, update);
				}
			}
			
			_context3d.clear(1,1,1,1); 
			_context3d.drawTriangles(_indexBuffer); 
			_context3d.present();
			
			
		}
		
		
		
	}
}

