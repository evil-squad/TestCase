package demo.skill
{
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	
	import away3d.core.base.data.OverrideMaterialProps;
	import away3d.entities.Mesh;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Particle3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	
	public class SkillDragonAttack1 extends SkillBase
	{
		private var _animationName:String;
		private var _particle1:Particle3D;
		private var _particle2:Particle3D;
		private var _particle3:Particle3D;
		private var _particle4:Particle3D;
		
//		public static const EffectName3:String = "";//破碎
		public static const EffectName1:String = "../assets/effect/skill/bosslong/atk01/mesh/bosslong-01.awd";//冰块突起
//		public static const EffectName2:String = "../assets/effect/skill/bosslong/atk01/atk01.awd";//爆炸
		public static const EffectName3:String = "../assets/effect/skill/bosslong/atk01/mesh/bosslong-posuida01.awd";//破碎
//		public static const EffectName4:String = "../assets/effect/skill/bosslong/atk01/002.awd";//爆炸2
		
		private var _alphaProgress:Number = int.MAX_VALUE;
		private var _alphaMesh:Mesh;
		
		public function SkillDragonAttack1()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_LION_SKILL_1);
		}
		
		override protected function castSkill():void
		{
			super.castSkill();
			_alphaProgress = int.MAX_VALUE;
			addTimeHandlerAt(500, handler500);
			addTimeHandlerAt(1000, handler1000);
			addTimeHandlerAt(1001, handler1001);
			addTimeHandlerAt(2400, handler2400);
			
			_animationName = PlayerAnimationController.SEQ_ATTACK_250;
			if(_particle1 == null)
			{
				_particle1 = _particleManager.getParticle(EffectName1, null);
			}
			
			_particle1.setMyScale(2.0);
			_particle1.x = _caster.x;
			_particle1.y = _caster.y;
			_particle1.z =  _caster.z;
			WorldManager.instance.gameScene3D.addChild(_particle1);
			
//			if(_particle4 == null)
//			{
//				_particle4 = _particleManager.getParticle(EffectName4, null);
//			}
//			_particle4.setMyScale(2.0);
//			_particle4.x = _caster.x;
//			_particle4.y = _caster.height;
//			_particle4.z =  _caster.z3d;
//			
//			Scene3DManager.addGameObject(_particle4);
			
//			CameraManager.lockedOnPlayerController.vibrate(20, 300, 19, 4);
		}
		
		override protected function removeElement():void
		{
			_alphaProgress = int.MAX_VALUE;
			if(_particle1)
			{
				_particleManager.recycleParticle(_particle1);
				_particle1 = null;
			}
			if(_particle4)
			{
				_particleManager.recycleParticle(_particle4);
				_particle4 = null;
			}
			if(_particle2)
			{
				_particleManager.recycleParticle(_particle2);
				_particle2 = null;
			}
			
			if(_particle3)
			{
				_particleManager.recycleParticle(_particle3);
				_particle3 = null;
			}
			
			if(_props)
			{
				_props.colorTransform.greenMultiplier = _props.colorTransform.redMultiplier = _props.colorTransform.blueMultiplier = 1;
				_props.colorTransform.alphaMultiplier = 1;
				_props = null;
			}
			super.removeElement();
		}
		
		private var _props:OverrideMaterialProps;
		override public function update(curTime:int, deltaTime:int):void
		{
			super.update(curTime, deltaTime);
			if(_alphaProgress < 1 && _alphaProgress > 0)
			{
				_alphaProgress -= 0.03;
				if(_alphaProgress < 0)
				{
					_alphaProgress = 0;
				}
				
				if(_particle3 && _particle3.particle)
				{
					var mesh:Mesh = _particle3.particle as Mesh;
					_props = mesh.overrideMaterialProps || new OverrideMaterialProps();
					mesh.overrideMaterialProps = _props;
					_props.colorTransform = _props.colorTransform || new ColorTransform();
					_props.colorTransform.greenMultiplier = _props.colorTransform.redMultiplier = _props.colorTransform.blueMultiplier = _alphaProgress;
					_props.colorTransform.alphaMultiplier = _alphaProgress;
					_props.appendColorTransform = true;
					_props.overrideBlendMode = true;
					_props.blendMode = BlendMode.LAYER;
				}
				
			}
		}
		
		
		private function handler500():void
		{
			var total:uint = _caster.animationController.getSequenceDuration(_animationName);
			_caster.animationController.playAnimWithDuring(_animationName, total);
		}
		
		private function handler1000():void
		{
//			_particle2 = _particleManager.getParticle(EffectName2, null);
//			_particle2.x = _caster.x;
//			_particle2.y = _caster.height + 30;
//			_particle2.z =  _caster.z3d;
//			_particle2.setMyScale(2);
//			Scene3DManager.addGameObject(_particle2);
		}
		
		private function handler1001():void
		{
			_particle3 = _particleManager.getParticle(EffectName3, null);
			_particle3.setMyScale(2);
			_particle3.x = _caster.x;
			_particle3.y = _caster.y;
			_particle3.z =  _caster.z;
			
			WorldManager.instance.gameScene3D.addChild(_particle3);
			
			if(_particle1)
			{
				_particleManager.recycleParticle(_particle1);
				_particle1 = null;
			}
		}
		
		//冰块开始alpha消失.
		private function handler2400():void
		{
			_alphaProgress = 0.99;
		}
		
		
		
		
		
		
		
		
		
	}
}

