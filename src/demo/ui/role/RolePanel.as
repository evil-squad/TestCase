package demo.ui.role
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	import com.game.engine3D.vo.FadeAlphaRectData;
	
	import flash.display.Sprite;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.methods.FadeAlphaMethod;
	
	import demo.display3D.Avatar3D;
	import demo.managers.GameManager;
	import demo.ui.SkinUIPanel;
	import demo.vo.Avatar3DVO;
	
	import org.mokylin.skin.app.role.RolePanelSkin;
	
	import starling.display.DisplayObject;
	import starling.display.Interoperation3DContainer;

	public class RolePanel extends SkinUIPanel
	{
		private var skin:RolePanelSkin;
		private var role : Avatar3D;
		private var interoperation3DContainer:Interoperation3DContainer;
		
		private var fadeMethod 	: FadeAlphaMethod;
		private var fadeRectData : FadeAlphaRectData;
		private const roleOffsetX:int = 150;
		private const roleOffsetY:int = 450;
		
		public function RolePanel()
		{
			skin= new RolePanelSkin();
			super(skin);
			initPlayer();
		}
		
		private function initPlayer():void
		{
			fadeRectData = new FadeAlphaRectData(650, 285, 512, 512);
			var vo : Avatar3DVO = new Avatar3DVO();
			vo.url = GameManager.getInstance().mainRole.vo.url;
			vo.id  = GameManager.getInstance().mainRole.vo.id;
			role = new Avatar3D(vo);
			role.setScale(2);
//			role.mesh.addFadeAlpha("../assets/images/dialogFaceMask(2).jpg", fadeRectData);
			
			interoperation3DContainer = new Interoperation3DContainer(Stage3DLayerManager.screenView);
			interoperation3DContainer.x = roleOffsetX;
			interoperation3DContainer.y = roleOffsetY;
			this.addChild(interoperation3DContainer);
			interoperation3DContainer.addChild3D(role.graphicDis);
//			
//			
//			var fadeRectData1 : FadeAlphaRectData = new FadeAlphaRectData(1000, 191, 512, 512);
//			var vo1 : Avatar3DVO = new Avatar3DVO();
//			vo1.url = GameManager.getInstance().mainRole.vo.url;
//			vo1.id  = GameManager.getInstance().mainRole.vo.id;
//			var role1 : Avatar3D = new Avatar3D(vo1);
//			role1.setScale(2);
//			role1.mesh.addFadeAlpha("../assets/images/dialogFaceMask(1).jpg", fadeRectData1);
//			var interoperation3DContainer1 : Interoperation3DContainer = new Interoperation3DContainer(Stage3DLayerManager.screenView);
//			interoperation3DContainer1.x = roleOffsetX + 512;
//			interoperation3DContainer1.y = roleOffsetY;
//			this.addChild(interoperation3DContainer1);
//			interoperation3DContainer1.addChild(role1.graphicDis);
//						
//			var sp1 : Sprite = new Sprite();
//			sp1.graphics.lineStyle(1, 0xFFFFFF);
//			sp1.graphics.drawRect(fadeRectData1.fadeX, fadeRectData1.fadeY, fadeRectData1.fadeWidth, fadeRectData1.fadeHeight);
//			
//			Stage3DLayerManager.stage.addChild(sp1);
//			Stage3DLayerManager.stage.addChild(sp);
		}
				
		private function activeRenderObject(object : ObjectContainer3D, depthWrite : Boolean, rMask : Boolean, gMask : Boolean, bMask : Boolean, aMask : Boolean, srcFactor : String, dstFactor : String) : void {
			for (var i:int = 0; i < object.numChildren; i++) {
				var child : ObjectContainer3D = object.getChildAt(i);
				if (child is Mesh) {
					(child as Mesh).material;
				} else {
					activeRenderObject(child, depthWrite, rMask, gMask, bMask, aMask, srcFactor, dstFactor);
				}
			}
		}
		
		private var sp : Sprite = new Sprite();
		
		
		override protected function onTouchTarget(target:DisplayObject):void
		{
			super.onTouchTarget(target);
			switch(target)
			{
				case skin.btnClose:
					hide();
					break;
			}
		}
		
		override protected function onShow():void
		{
			role.visible = true;
		}
		
		override protected function onHide():void
		{
			role.visible = false;
		}	
	}
}