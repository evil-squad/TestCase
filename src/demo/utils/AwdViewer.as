package demo.utils {
	
	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.GameScene3DManager;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import away3d.animators.IAnimatorOwner;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.PropertyAnimatorContainer;
	import away3d.containers.View3D;
	import away3d.containers.View3DAsset;
	import away3d.core.base.Object3D;
	import away3d.entities.Entity;
	import away3d.events.Event;
	import away3d.filters.Filter3DBase;
	import away3d.filters.RingDepthOfFieldFilter3D;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.BasicSpecularMethod;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.SoftDiffuse2ndMethod;
	import away3d.tools.utils.Bounds;
	
	import demo.enum.LayerEnum;
	
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import feathers.themes.GuiThemeStyle;
	
	import org.mokylin.skin.component.button.ButtonSkin_btn_normal;
	import org.mokylin.skin.component.slider.HSliderChatSkin;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	/**
	 *　　　　　　　　┏┓　　　┏┓+ +
	 *　　　　　　　┏┛┻━━━┛┻┓ + +
	 *　　　　　　　┃　　　　　　　┃ 　
	 *　　　　　　　┃　　　━　　　┃ ++ + + +
	 *　　　　　　 ████━████ ┃+
	 *　　　　　　　┃　　　　　　　┃ +
	 *　　　　　　　┃　　　┻　　　┃
	 *　　　　　　　┃　　　　　　　┃ + +
	 *　　　　　　　┗━┓　　　┏━┛
	 *　　　　　　　　　┃　　　┃　　　　　　　　　　　
	 *　　　　　　　　　┃　　　┃ + + + +
	 *　　　　　　　　　┃　　　┃　　　　　　　　　　　
	 *　　　　　　　　　┃　　　┃ + 　　　　　　
	 *　　　　　　　　　┃　　　┃
	 *　　　　　　　　　┃　　　┃　　+　　　　　　　　　
	 *　　　　　　　　　┃　 　　┗━━━┓ + +
	 *　　　　　　　　　┃ 　　　　　　　┣┓
	 *　　　　　　　　　┃ 　　　　　　　┏┛
	 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
	 *　　　　　　　　　　┃┫┫　┃┫┫
	 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
	 * awd预览工具
	 * @author chenbo
	 * 创建时间：Aug 29, 2016 10:45:51 AM
	 */
	public class AwdViewer extends ObjectContainer3D {
		
		/** 排除一些大物件 */
		private static const LOOK_AT_TARGET_FILTER_FILES : Array = ["Ground","Pants_Body","Tunic","Pants", "SkyBox", "Camera_player", "directionalLight"];
		
		private var awdName     : String;
		private var isPlaying   : Boolean;
		private var gameScene3D : GameScene3D;
		private var btn : feathers.controls.Button;
		private var bar : feathers.controls.Slider;
		private var xCamDefaultDeg : Number;  //默认相机角度
		private var yCamDefaultDeg : Number;  //默认相机角度
		private var camDefaultPos : Vector3D = new Vector3D(0,0,0);  //默认相机位置
		private var targDefaultPos : Vector3D = new Vector3D(0,1254,0);  //目标默认位置
		private var timer : Timer = new Timer(17);
		private var time : Number;  //时间
		private var isCamResetting : Boolean = false;
		private var isMidMouseDown : Boolean = false;
		private var prevDownPosX : Number = 0;
		private var prevDownPosY : Number = 0;
		private var prevTargPos : Vector3D = new Vector3D(0,0,0);
		private var stage : Stage;
		private var btnDof : feathers.controls.Button = new feathers.controls.Button();
		private var isDofEnabled : Boolean;
		private var btnSSAO : feathers.controls.Button = new feathers.controls.Button();
		private var isSSAOEnabled : Boolean;
		private var btnSSShadow : feathers.controls.Button = new feathers.controls.Button();
		private var isSSShadowEnabled : Boolean;
		private var btnAA : feathers.controls.Button = new feathers.controls.Button();
		private var valueAA : Number = 2;
		
		public function AwdViewer(path : String, name : String, stag : Stage) {
			super();
			this.stage = stag;
			this.awdName = name;
			this.initUI();
			this.loadAwd(path, name);
		}
		
		private function initUI() : void {
			
			btn = new feathers.controls.Button();
			btn.name = "btnOk";
			btn.height = 25;
			btn.label = "关闭动画";
			btn.width = 70;
			btn.addEventListener(starling.events.TouchEvent.TOUCH, onTouchButton);
			
			bar = new feathers.controls.Slider();
			bar.name = "renderQualityBar";
			bar.height = 10;
			bar.maximum = 1.0;
			bar.minimum = 0;
			bar.direction = Slider.DIRECTION_HORIZONTAL
			bar.styleClass = org.mokylin.skin.component.slider.HSliderChatSkin;
			bar.value = 1.0;
			bar.width = 195;
			
			isPlaying = true;
			isDofEnabled = false;
			
			if (awdName == "Jade.awd") 
			{
				btn.label = "玉化值";
				btn.removeEventListener(starling.events.TouchEvent.TOUCH, onTouchButton);
				bar.addEventListener(away3d.events.Event.CHANGE,        onSlideChange);
			} 
			else if (awdName == "GOT_Character_Demo.awd")
			{
				//var txt : String = "转动角色：     ";
				//Stage3DLayerManager.starlingLayer.addChild(new GameInfoPanel(txt));
				btn.label = "相机复位";
				btn.removeEventListener(starling.events.TouchEvent.TOUCH, onTouchButton);
				btn.addEventListener(starling.events.TouchEvent.TOUCH, onButtonResetCamPos);
				bar.addEventListener(away3d.events.Event.CHANGE, onSlideChangeGOTRotate);
				bar.addEventListener(away3d.events.Event.ENTER_FRAME, updateBokehDepth);
				timer.addEventListener(TimerEvent.TIMER, onTimerResetCamPos);
				Stage3DLayerManager.getView().backgroundColor = 0x333333;
				isPlaying = false;
				isDofEnabled = true;
				isSSAOEnabled = true;
				isSSShadowEnabled = true;
				
				btnDof.name = "btnDof";
				btnDof.height = 25;
				btnDof.label = "关闭景深";
				btnDof.width = 70;
				btnDof.addEventListener(starling.events.TouchEvent.TOUCH, onTouchButton);
				GuiThemeStyle.setFeatherSkinClass(btnDof, org.mokylin.skin.component.button.ButtonSkin_btn_normal);
				Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ALERT).addChild(btnDof);
				
				btnSSAO.name = "btnSSAO";
				btnSSAO.height = 25;
				btnSSAO.label = "关闭SSAO";
				btnSSAO.width = 70;
				btnSSAO.addEventListener(starling.events.TouchEvent.TOUCH, onTouchButton);
				GuiThemeStyle.setFeatherSkinClass(btnSSAO, org.mokylin.skin.component.button.ButtonSkin_btn_normal);
				Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ALERT).addChild(btnSSAO);
				
				btnSSShadow.name = "btnSSShadow";
				btnSSShadow.height = 25;
				btnSSShadow.label = "屏幕阴影关";
				btnSSShadow.width = 70;
				btnSSShadow.addEventListener(starling.events.TouchEvent.TOUCH, onTouchButton);
				GuiThemeStyle.setFeatherSkinClass(btnSSShadow, org.mokylin.skin.component.button.ButtonSkin_btn_normal);
				Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ALERT).addChild(btnSSShadow);
				
				btnAA.name = "btnAA";
				btnAA.height = 25;
				btnAA.label = "抗锯齿x4";
				btnAA.width = 70;
				btnAA.addEventListener(starling.events.TouchEvent.TOUCH, onTouchButton);
				GuiThemeStyle.setFeatherSkinClass(btnAA, org.mokylin.skin.component.button.ButtonSkin_btn_normal);
				Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ALERT).addChild(btnAA);
			} 
			else
			{
				bar.visible = false;
			}
			
			GuiThemeStyle.setFeatherSkinClass(btn, org.mokylin.skin.component.button.ButtonSkin_btn_normal);
			
			Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ALERT).addChild(bar);
			Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ALERT).addChild(btn);
			
			Stage3DLayerManager.stage.addEventListener(flash.events.Event.RESIZE, onResizeStage);
			
			onResizeStage(null);
		}
		
		private function lerp(a : Number, b : Number, t : Number) : Number {
			return a + (b - a) * t;
		}
				
		private function onSlideChange(e : away3d.events.Event):void {
			var mat : TextureMaterial = gameScene3D.sceneMapLayer.getObj("Mat_Jade") as TextureMaterial;
			var dif : SoftDiffuse2ndMethod = mat.diffuseMethod as SoftDiffuse2ndMethod;
			var spe : BasicSpecularMethod = mat.specularMethod;
			var env : EnvMapMethod = mat.getMethodAt(0) as EnvMapMethod;
			spe.specular = lerp(4.0, 1.7, bar.value);
			spe.gloss = lerp(5.0, 6.0, bar.value);
			dif.sssRange = lerp(0.3, 3.5, bar.value);			
			dif.sssMix = lerp(0.0, 1.08, bar.value);
			env.alpha = lerp(0.07, 0.06, bar.value);
		}
		
		private function onSlideChangeGOTRotate(e : away3d.events.Event):void {
			var GOTCharacter : PropertyAnimatorContainer = gameScene3D.sceneMapLayer.getObj("propertyAnimatorContainer1") as PropertyAnimatorContainer;
			if(GOTCharacter){
				var degree : Number = lerp(0.0, 360.0, bar.value);
				GOTCharacter.rotationY = degree;
			}
		}
		
		private function updateBokehDepth(e : away3d.events.Event):void {
			
			var dist : Number = CameraController.lockedOnPlayerController.distance;
			
			if(gameScene3D){
				var depthOfField : RingDepthOfFieldFilter3D = gameScene3D.ringDepthOfFieldFilter3D;
				if(depthOfField){
					var ratio : Number = (dist - 1350) / 1300;
					if(ratio > 1){
						ratio = 1;
					}else if(ratio < 0){
						ratio = 0;
					}
					var minFocalLength : Number = 4.0;
					var maxFocalLength : Number = 3.08;
					depthOfField.focalLength = lerp(minFocalLength, maxFocalLength, ratio);
				}
			}
		}
				
		private function onTouchButton(e:TouchEvent):void {
			var t:Touch = e.getTouch(btn, TouchPhase.ENDED);
			var tDof:Touch = e.getTouch(btnDof, TouchPhase.ENDED);
			var tSSAO:Touch = e.getTouch(btnSSAO, TouchPhase.ENDED);
			var tSSShadow:Touch = e.getTouch(btnSSShadow, TouchPhase.ENDED);
			var tAntiAlias:Touch = e.getTouch(btnAA, TouchPhase.ENDED);
			if (t) 
			{
				toggleAnimation();
			}
			if (tDof) {
				isDofEnabled = !isDofEnabled;
				
				if (isDofEnabled) {
					btnDof.label = "关闭景深";
				} else {
					btnDof.label = "开启景深";
				}
				gameScene3D.ringDepthOfFieldFilter3D.enabled = isDofEnabled;
			}
			if (tSSAO) {
				isSSAOEnabled = !isSSAOEnabled;
				
				if (isSSAOEnabled) {
					btnSSAO.label = "关闭SSAO";
				} else {
					btnSSAO.label = "开启SSAO";
				}
				
				var filterClass:Class = getDefinitionByName("away3d.filters::SSAOFilter3D") as Class;
				for(var i:int = 0; i < Stage3DLayerManager.getView(0).filters3d.length; ++i)
				{
					var filter:Filter3DBase = Stage3DLayerManager.getView(0).filters3d[i];
					if(filter is filterClass)
					{
						filter.enabled = isSSAOEnabled;
					}
				}
			}
			if (tSSShadow) 
			{
				isSSShadowEnabled = !isSSShadowEnabled;
				
				if (isSSShadowEnabled) 
				{
					btnSSShadow.label = "屏幕阴影关";
				} 
				else 
				{
					btnSSShadow.label = "屏幕阴影开";
				}
				Stage3DLayerManager.getView().enableScreenSpaceShadow = isSSShadowEnabled;
			}
			if (tAntiAlias) 
			{
				valueAA = ++valueAA % 3;
				if(valueAA == 0)
				{
					btnAA.label = "抗锯齿Off"
					Stage3DLayerManager.viewAntiAlias = 0;
				}
				else if(valueAA == 1)
				{
					btnAA.label = "抗锯齿x2"
					Stage3DLayerManager.viewAntiAlias = 2;
				}
				else
				{
					btnAA.label = "抗锯齿x4"
					Stage3DLayerManager.viewAntiAlias = 4;
				}
			}
			
		}
		
		private function onButtonResetCamPos(e:TouchEvent):void {
			var t:Touch = e.getTouch(btn, TouchPhase.ENDED);
			if(t){
				// 立刻复位
				//var camDist : Number = targDefaultPos.subtract(camDefaultPos).length;
				//CameraController.initLockOnControl(0, xCamDefaultDeg, yCamDefaultDeg, camDist, true, true, true, camDist * 0.5, camDist * 5, -90, 90);
				
				// 缓慢复位
				if(!isCamResetting){
					isCamResetting = true;
					CameraController.lockedOnPlayerController.mouseLeftControlable = false;
					CameraController.lockedOnPlayerController.mouseRightControlable = false;
					time = getTimer();
					timer.start();
				}
			}
		}
		
		private function onTimerResetCamPos(event:TimerEvent):void{
			var camDist : Number = CameraController.lockedOnPlayerController.distance;
			var defaultDist : Number = targDefaultPos.subtract(camDefaultPos).length;
			var controlObject3D : ObjectContainer3D = new ObjectContainer3D();
			var resetSpeed : Number = 0.5;
			var f : Number = resetSpeed * (getTimer() - time) / 1000;
			if(f >= 1){
				f = 1;
				timer.stop();
				isCamResetting = false;
				CameraController.lockedOnPlayerController.mouseLeftControlable = true;
				CameraController.lockedOnPlayerController.mouseRightControlable = true;
			}
			camDist = lerp(camDist, defaultDist, f);
			var xDeg : Number = lerp(CameraController.lockedOnPlayerController.xDeg % 360, xCamDefaultDeg, f);
			var yDeg : Number = lerp(CameraController.lockedOnPlayerController.yDeg % 360, yCamDefaultDeg, f);
			var targPos : Vector3D = new Vector3D;
			targPos.x = lerp(prevTargPos.x, targDefaultPos.x, f);
			targPos.y = lerp(prevTargPos.y, targDefaultPos.y, f);
			targPos.z = lerp(prevTargPos.z, targDefaultPos.z, f);
			controlObject3D.position = targPos;
			CameraController.initcontroller(gameScene3D.camera, controlObject3D);
			CameraController.initLockOnControl(0, xDeg, yDeg, camDist, true, true, true, camDist * 0.5, camDist * 5, -90, 90);
			
			prevTargPos = targPos;
		}
		
		private function toggleAnimation() : void {
			
			isPlaying = !isPlaying;
			
			if (isPlaying) {
				btn.label = "关闭动画";
			} else {
				btn.label = "开启动画";
			}
			
			for (var i:int = 0; i < gameScene3D.numChildren; i++) {
				var child:Object3D = gameScene3D.getChildAt(i);
				if (child is IAnimatorOwner) {
					if (IAnimatorOwner(child).animator) {
						if (isPlaying)
							IAnimatorOwner(child).animator.start();
						else
							IAnimatorOwner(child).animator.stop();
					}
				} else if (child is ObjectContainer3D) {
					playAllAnimator(ObjectContainer3D(child));
				}
			}
			
		}
		
		private function playAllAnimator(container:ObjectContainer3D):void {
			
			for (var i:int = 0; i < container.numChildren; i++) {
				var child:Object3D = container.getChildAt(i) as Object3D;
				if (child is IAnimatorOwner) {
					if (IAnimatorOwner(child).animator) {
						if (isPlaying)
							IAnimatorOwner(child).animator.start();
						else
							IAnimatorOwner(child).animator.stop();
					}
				} else if(child is ObjectContainer3D) {
					playAllAnimator(ObjectContainer3D(child));
				}
			}
			
		}
		
		private function onResizeStage(event:flash.events.Event):void {
			btn.x = Stage3DLayerManager.stage.stageWidth - btn.width - 10;
			btn.y = 10;
			
			bar.x = Stage3DLayerManager.stage.stageWidth - bar.width - 10;
			bar.y = btn.y + btn.height + 5;
			
			if (awdName == "GOT_Character_Demo.awd")
			{
				btnDof.x = 10;
				btnDof.y = 10;
				
				btnSSAO.x = 10;
				btnSSAO.y = 45;
				
				btnSSShadow.x = 10;
				btnSSShadow.y = 80;
				
				btnAA.x = 10;
				btnAA.y = 115;
			}
		}
		
		/**
		 * 载入awd文件 
		 */		
		private function loadAwd(path : String, name : String):void {
			this.gameScene3D = GameScene3DManager.createScene(name, Stage3DLayerManager.getView(), 4000, 0);
			this.gameScene3D.disableShadowLevel = true;
			this.gameScene3D.sceneMapLayer.animatorRandom = 0;
			this.gameScene3D.switchScene(path + "/" + name, completeHandler);
		}		
		
		override public function dispose() : void {
			isPlaying = true;
			toggleAnimation();
			Stage3DLayerManager.stage.removeEventListener(flash.events.Event.RESIZE, onResizeStage);
			if (btn) {
				btn.removeEventListener(starling.events.TouchEvent.TOUCH, onTouchButton);
				btn.removeFromParent(true);
				btn = null;
			}
			if (bar) {
				bar.removeEventListener(away3d.events.Event.CHANGE,        onSlideChange);
				bar.removeFromParent(true);
				bar = null;
			}
			if (gameScene3D) {
				GameScene3DManager.removeScene(gameScene3D.sceneName);
			}
			super.dispose();
		}
		
		private function completeHandler(gs : GameScene3D):void {
			
			Stage3DLayerManager.startRender();
			Stage3DLayerManager.getView().visible = true;
			
			focusMouseTarget(gameScene3D);
			
			if (awdName == "GOT_Character_Demo.awd"){
				// 鼠标中键拖拽摄像机功能
				stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMidMouseDown);
				stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMidMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				
				Stage3DLayerManager.viewAntiAlias = 4;
				gameScene3D.ringDepthOfFieldFilter3D.enabled = isDofEnabled;
				Stage3DLayerManager.getView().enableScreenSpaceShadow = isSSShadowEnabled;
			}
			
			// 如果默认为不播放动画
			if(!isPlaying){
				for (var i:int = 0; i < gameScene3D.numChildren; i++) {
					var child:Object3D = gameScene3D.getChildAt(i);
					if (child is IAnimatorOwner) {
						if (IAnimatorOwner(child).animator) {
								IAnimatorOwner(child).animator.stop();
						}
					} else if (child is ObjectContainer3D) {
						playAllAnimator(ObjectContainer3D(child));
					}
				}
			}
		}
		
		protected function onMouseMove(event : MouseEvent):void
		{
			if(isMidMouseDown){
				// 鼠标中键拖动视图
				var controlObject3D : ObjectContainer3D = new ObjectContainer3D();
				var mouseMoveVec : Vector3D = new Vector3D(stage.mouseX-prevDownPosX, stage.height-stage.mouseY-prevDownPosY, 0, 0);
				
				var camMatrix : Matrix3D = new Matrix3D;
				camMatrix.copyFrom(gameScene3D.camera.sceneTransform);
				camMatrix.invert();
				camMatrix.transpose();
				
				var mouseWSpaceVec : Vector3D = new Vector3D;
				mouseWSpaceVec = camMatrix.deltaTransformVector(mouseMoveVec);
				//mouseWSpaceVec.normalize();
				mouseWSpaceVec.negate();
				
				var newTargPos : Vector3D = prevTargPos.add(mouseWSpaceVec);
				controlObject3D.position = newTargPos;
				
				var xDeg : Number = CameraController.lockedOnPlayerController.xDeg;
				var yDeg : Number = CameraController.lockedOnPlayerController.yDeg;
				var camDist : Number = CameraController.lockedOnPlayerController.distance;
				CameraController.initcontroller(gameScene3D.camera, controlObject3D);
				CameraController.initLockOnControl(0, xDeg, yDeg, camDist, true, true, true, camDist * 0.5, camDist * 5, -90, 90);
				prevTargPos = newTargPos;
				
				prevDownPosX = stage.mouseX;
				prevDownPosY = stage.height - stage.mouseY;
			}
		}
		
		protected function onMidMouseUp(event : MouseEvent):void
		{
			isMidMouseDown = false;
		}
		
		private function onMidMouseDown(event : MouseEvent):void
		{
			isMidMouseDown = true;
			prevDownPosX = stage.mouseX;
			prevDownPosY = stage.height - stage.mouseY;
		}
		
		private function focusMouseTarget(obj3D : ObjectContainer3D = null) : void {
			// aabb box
			var bmin : Vector3D = null;
			var bmax : Vector3D = null;
			// calculate bounds
			Bounds.getObjectContainerBounds(obj3D, true, function(entity:Entity):Boolean{
				if (LOOK_AT_TARGET_FILTER_FILES.indexOf(entity.name) != -1) {
					return false;
				} else {
					return true;
				}
			});
			var bounds:Vector.<Number> = Vector.<Number>([Bounds.minX, Bounds.minY, Bounds.minZ, Bounds.maxX, Bounds.maxY, Bounds.maxZ]);
			if (bounds[0] == Infinity || bounds[1] == Infinity || bounds[2] == Infinity || bounds[3] == -Infinity || bounds[4] == -Infinity || bounds[5] == -Infinity) { 
				bmin = new Vector3D(-500, 0, 0);
				bmax = new Vector3D(500, 0, 0);
			} else {
				bmin = new Vector3D(bounds[0], bounds[1], bounds[2]);
				bmax = new Vector3D(bounds[3], bounds[4], bounds[5]);
			}
			// center
			var center : Vector3D = bmax.subtract(bmin);
			var radius : Number = center.length;	
			center.x /= 2;
			center.y /= 2;
			center.z /= 2;
			center = center.add(bmin);
			if (awdName == "GOT_Character_Demo.awd"){
				center.y += 360;
			}
			// 模拟一个target
			var controlObject3D : ObjectContainer3D = new ObjectContainer3D();
			controlObject3D.position = center;
			var view : View3D = Stage3DLayerManager.getView();
			var xDeg : Number = 0;
			var yDeg : Number = 0;
			var view3dAsset : View3DAsset = gameScene3D.sceneMapLayer.view3DAsset;
			// 锁定相机模式下重新计算角度以及距离
			if (view3dAsset.cameraLock) {
				center.x = view3dAsset.posX - center.x;
				center.y = view3dAsset.posY - center.y;
				center.z = view3dAsset.posZ - center.z;
				radius = center.length;
				xDeg = view3dAsset.rotY;
				yDeg = view3dAsset.rotX;
				if (awdName == "GOT_Character_Demo.awd"){
					yDeg = 2;
				}
			}
			xCamDefaultDeg = xDeg % 360;
			yCamDefaultDeg = yDeg % 360;
			camDefaultPos.x = view3dAsset.posX;
			camDefaultPos.y = view3dAsset.posY;
			camDefaultPos.z = view3dAsset.posZ;
			targDefaultPos = controlObject3D.position;
			prevTargPos = targDefaultPos;
			// camera controller
			CameraController.initcontroller(view.camera, controlObject3D);
			CameraController.initLockOnControl(0, xDeg, yDeg, radius, true, true, true, radius * 0.5, radius * 5, -90, 90);
			CameraController.lockedOnPlayerController.mouseRightSpeed = 0.2;
			CameraController.lockedOnPlayerController.mouseWheelSpeed = radius * 0.02;
			CameraController.switchToLockOnControl();
			CameraController.lockedOnPlayerController.mouseLeftControlable = true;
		}
		
	}
}