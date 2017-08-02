package demo.tester
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix3D;
	import flash.ui.Keyboard;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Matrix3DUtils;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.managers.GameManager;
	import demo.managers.ParticleManager;
	import demo.managers.WorldManager;
	import demo.skill.magic.MagicBase;
	import demo.skill.magic.MagicData;
	
	public class AddParticleTester
	{
		private var _stage:Stage;
		
		private var _x:int;
		private var _y:int;
		private var _angle:int = -90;
		private var _particle:Particle3D;
		
		public function AddParticleTester()
		{
			
			_stage = Stage3DLayerManager.stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
		}
		
		public static function ObjFaceTo3DSpace(obj:ObjectContainer3D, xPos:Number, zPos:Number, height:Number = 0):void
		{
			if(obj == null)
				return;
			Matrix3DUtils.CALCULATION_VECTOR3D.setTo(xPos, height, zPos);
			obj.lookAt(Matrix3DUtils.CALCULATION_VECTOR3D);
		}
		
		private var _node:ObjectContainer3D;
		
		private function onKeyDown(e:KeyboardEvent):void
		{
//			var me:Avatar3D = GameManager.getInstance().mainPlayer;
			var me:demo.display3D.Avatar3D = GameManager.getInstance().mainRole;
			if(me == null)
				return;
			
			if(e.keyCode == Keyboard.NUMBER_0)
			{
				if(_particle == null)
				{
					_particle = ParticleManager.getInstance().getParticle("../assets/effect/skill/role/tx_suit_arch1_001/tx_suit_arch1_210.awd", "210_dandao");
					_node = new ObjectContainer3D();
					_node.addChild(_particle);
//					_node.x = me.node.x;
//					_node.y = me.node.y + 100;
//					_node.z = me.node.z;
					
					_node.x = me.x;
					_node.y = me.y + 100;
					_node.z = me.z;
					
//					Scene3DManager.addGameObject(_node);
					
//					Matrix3DUtils.CALCULATION_VECTOR3D.setTo(me.node.x + 200, me.node.y + 100, me.node.z + 100);
					Matrix3DUtils.CALCULATION_VECTOR3D.setTo(me.x + 200, me.y + 100, me.z + 100);
					
					_node.lookAt(Matrix3DUtils.CALCULATION_VECTOR3D);
				}
				else
				{
					//
//					var container:ObjectContainer3D = me.node;
					var container:ObjectContainer3D = me.graphicDis;
					var parentMatrix:Matrix3D = container.sceneTransform.clone();
					parentMatrix.invert();
					
					var childMatrix:Matrix3D = _node.sceneTransform.clone();
					parentMatrix.prepend(childMatrix);
					
					container.addChild(_node);
					_node.transform = parentMatrix;
					
				}
				
//				p * n = c;
//				
//				n = c / p;
			}
//						
//			if(e.keyCode == Keyboard.LEFT && _particle)
//			{
//				
//			}
//			
//			
//			
//			
//			
//			
//			
//			
//			
//			
			return;
//			var ribbonTexture:BitmapTexture = Cast.bitmapTexture(EmbedAssets.LightningIMG);
//			var mat:TextureMaterial = new TextureMaterial(ribbonTexture)
//			mat.bothSides = true;
//			mat.blendMode = BlendMode.ADD;
//			mat.depthCompareMode = Context3DCompareMode.LESS;
			
//			var last:Avatar3D = me;
			var last:demo.display3D.Avatar3D = me;
			for each(var obj:demo.display3D.Avatar3D in WorldManager.instance.monsters)
			{
//				if(last.underAttackContainer && obj.underAttackContainer)
//				{
//					var ribbon:LightningRibbon = new LightningRibbon(last.underAttackContainer, obj.underAttackContainer, 16, 128, mat);
//					ribbon.shakeTimer = 100;
//					ribbon.animator = new CPUSpriteSheetAnimator(8, 1, 15, 8);
//					WorldManager.instance.addObject(ribbon);
//					ribbon.start();
//				}
//				last = obj;
			}
			
			return;
			
			if(e.keyCode == Keyboard.NUMBER_0)
			{
				var offsetX:Number = (0.5 - Math.random()) * 100;
				var offsetY:Number = (0.5 - Math.random()) * 100;
				var magic:MagicBase = MagicBase.CreateMagic(10011 + Math.random(), 
							me.id, MagicData.Magic_1, me.x, me.y,
							me.x + offsetX, me.y + offsetY);
				WorldManager.instance.addOperator(magic);
			}
			
			return;
			if(e.keyCode == Keyboard.NUMBER_0)
			{
				if(_particle == null)
				{
					_particle.scale(2);
				}
				
//				_particle.x = me.x;
//				_particle.y = me.height;
//				_particle.z = me.y;
//				_particle.start();
				
				
				
				
				
			}
			else
			{
//				if(_flag)
//				{
//					_flag.onNetActive(1);
//				}
			}
		}
	}
}

