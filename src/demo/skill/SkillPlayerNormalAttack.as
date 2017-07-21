package demo.skill
{
	import flash.display.BlendMode;
	import flash.display3D.Context3DCompareMode;
	
	import away3d.animators.SkeletonAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.TextureMaterial;
	import away3d.ribbon.TwoPointsRibbon;
	import away3d.textures.AsyncTexture2D;
	
	import demo.controller.PlayerAnimationController;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.path.ConfigPath;

	public class SkillPlayerNormalAttack extends SkillBase
	{
		private var _animationName:String;
//		private var _ribbon:TwoPointsRibbon;
		
		public function SkillPlayerNormalAttack()
		{
			super();
			_skillDetail = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.PLAYER_NORMAL_ATTACK);
		}
		
		override protected function castSkill():void
		{
			_animationName = PlayerAnimationController.SEQ_ATTACK_210;
			super.castSkill();
			playDuration(_animationName);
			
			if(_caster.mesh.getChildByName("ribbon_tag_1"))
			{
				var total:uint = _caster.animationController.getSequenceDuration(_animationName);
				_caster.animationController.playAnimWithDuring(_animationName, total);
				if(total < 200)
				{
					total = 200;
				}
				addTimeHandlerAt(200, bindRibbon);
				addTimeHandlerAt(total - 200, removeRibbon);
			}
		}
		
		
		override public function update(curTime:int, deltaTime:int):void
		{			
			super.update(curTime, deltaTime);
		}
		
		
		private function bindRibbon():void
		{
//			if(_caster.mesh && _ribbon == null)
//			{
//				var node1:ObjectContainer3D = _caster.mesh.getChildByName("ribbon_tag_1");
//				var node2:ObjectContainer3D = _caster.mesh.getChildByName("ribbon_tag_2");
//				
////				var ribbonTexture:AsyncTexture2D = Cast.asyncTexture(new EmbedAssets.RibbonIMG().bitmapData, true);
//				var ribbonTexture:AsyncTexture2D = new AsyncTexture2D(true, true, false);
//				ribbonTexture.load(ConfigPath.RibbonIMG)
//					
//				_ribbon = new TwoPointsRibbon(node1, node2, 25, new TextureMaterial(ribbonTexture), _caster.mesh.animator as SkeletonAnimator, 2);
//				TextureMaterial(_ribbon.material).bothSides = true;
//				TextureMaterial(_ribbon.material).blendMode = BlendMode.ADD;
//				TextureMaterial(_ribbon.material).depthCompareMode = Context3DCompareMode.ALWAYS;
//				
//			}
//			
//			if(_ribbon)
//			{
//				_ribbon.start();
//				_world.addObject(_ribbon);
//			}
		}
		
		private function removeRibbon():void
		{
//			if(_ribbon)
//			{
//				_world.removeObject(_ribbon);
//				
//				_ribbon.stop();
//				_ribbon.dispose();
//				_ribbon = null;
//			}
		}
		
		override protected function removeElement():void
		{
			removeRibbon();
			super.removeElement();
		}
		
	}
}