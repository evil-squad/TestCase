package demo.adapter {
	
	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.controller.camera.CameraLockOnTargetController;
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.events.SceneEvent;
	import com.game.engine3D.manager.Stage3DLayerManager;
	import com.game.engine3D.vo.BaseObj3D;
	
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import away3d.audio.SoundBox;
	import away3d.containers.ObjectContainer3D;
	import away3d.enum.ShadowMapperType;
	import away3d.events.MouseEvent3D;
	import away3d.filters.RingDepthOfFieldFilter3D;
	import away3d.lights.DirectionalLight;
	import away3d.materials.lightpickers.LightPickerBase;
	
	import demo.controller.AnimationConfigInfo;
	import demo.controller.PlayerAnimationController;
	import demo.enum.RoleEnum;
	import demo.enum.SkillDefineEnum;
	import demo.events.EvilEvent;
	import demo.helper.DriverCheckHelper;
	import demo.managers.CreatureManager;
	import demo.managers.GameCameraManager;
	import demo.managers.GameManager;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	import demo.path.vo.RoleData;
	import demo.path.vo.SceneData;
	import demo.path.vo.SceneOption;
	import demo.skill.SkillDetailVO;
	
	import org.client.mainCore.manager.EventManager;
	
	/**
	 * 场景适配器 
	 * @author chenbo
	 * 
	 */	
	public class SceneAdapterBase {
		
		public function SceneAdapterBase() {
			
		}
		
		public function onLeave():void {
			EventManager.removeEvent(SceneEvent.INTERACTIVE, onSceneInteractive);
			EventManager.removeEvent(SceneEvent.CAMERA_DISTANCE_CHANGE, onCameraDistanceChange);
			EventManager.removeEvent(SceneEvent.CAMERA_DISTANCE_CHANGE, updateCameraBokehDepth);
			EventManager.removeEvent(SceneEvent.VALIDATE_AREA_DIRECTIONALLIGHT, onCameraDistanceChange);
			EventManager.removeEvent(EvilEvent.ENABLE_DEPTH_FIELD, updateCameraBokehDepth);
		}
		
		public function onEnterMap(sceneID : int, gameScene3D : GameScene3D) : void {
			if (gameScene3D) {
				setSoundBoxReference(null, gameScene3D);
			}
			EventManager.addEvent(SceneEvent.INTERACTIVE, onSceneInteractive);
			EventManager.addEvent(SceneEvent.CAMERA_DISTANCE_CHANGE, onCameraDistanceChange);
			EventManager.addEvent(SceneEvent.VALIDATE_AREA_DIRECTIONALLIGHT, onCameraDistanceChange);
			EventManager.addEvent(SceneEvent.CAMERA_DISTANCE_CHANGE, updateCameraBokehDepth);
			EventManager.addEvent(EvilEvent.ENABLE_DEPTH_FIELD, updateCameraBokehDepth);
		}
		
		private function updateCameraBokehDepth() : void {
			
			if (!WorldManager.instance.gameScene3D.ringDepthOfFieldFilter3D) {
				return;
			}
			
			var option : SceneOption = WorldManager.instance.currentSceneData.depthOfField;
			if (option == null || option.enable == false || option.value == false) {
				return;
			}
			
			var depthOfField : RingDepthOfFieldFilter3D = WorldManager.instance.gameScene3D.ringDepthOfFieldFilter3D;
			var controller   : CameraLockOnTargetController = CameraController.lockedOnPlayerController;
			
			if (controller.minDist == controller.distance && depthOfField.enabled == false) {
				depthOfField.enabled = true;
			}
			
			var minNode : XMLList = option.xmlNode.min;
			var maxNode : XMLList = option.xmlNode.max;
			
			var minFocalDepth : Number     = minNode.hasOwnProperty("focalDepth") ? minNode.@focalDepth : depthOfField.focalDepth;
			var minFocalLegth : Number     = minNode.hasOwnProperty("focalLegth") ? minNode.@focalLegth : depthOfField.focalLength;
			var minBlurSharpness : Number  = minNode.hasOwnProperty("blurSharpness") ? minNode.@blurSharpness : depthOfField.blurSharpness;
			var minBloomGain : Number      = minNode.hasOwnProperty("bokehBloomGain") ? minNode.@bokehBloomGain : depthOfField.gain;
			var minBloomThreshold : Number = minNode.hasOwnProperty("bokehBloomThreshold") ? minNode.@bokehBloomThreshold : depthOfField.threshold;
			
			var maxFocalDepth : Number     = maxNode.hasOwnProperty("focalDepth") ? minNode.@focalDepth : depthOfField.focalDepth;
			var maxFocalLegth : Number     = maxNode.hasOwnProperty("focalLegth") ? minNode.@focalLegth : depthOfField.focalLength;
			var maxBlurSharpness : Number  = maxNode.hasOwnProperty("blurSharpness") ? minNode.@blurSharpness : depthOfField.blurSharpness;
			var maxBloomGain : Number      = maxNode.hasOwnProperty("bokehBloomGain") ? minNode.@bokehBloomGain : depthOfField.gain;
			var maxBloomThreshold : Number = maxNode.hasOwnProperty("bokehBloomThreshold") ? minNode.@bokehBloomThreshold : depthOfField.threshold;
						
			var ratio : Number = (controller.distance - controller.minDist) / (controller.maxDist - controller.minDist);
			
			depthOfField.focalDepth = minFocalDepth + (maxFocalDepth - minFocalDepth) * ratio;
			depthOfField.focalLength = minFocalLegth + (maxFocalLegth - minFocalLegth) * ratio;
			depthOfField.blurSharpness = minBlurSharpness + (maxBlurSharpness - minBlurSharpness) * ratio;
			depthOfField.threshold = minBloomGain + (maxBloomGain - minBloomGain) * ratio;
			depthOfField.gain = minBloomThreshold + (maxBloomThreshold - minBloomThreshold) * ratio;
						
			if (controller.distance == controller.maxDist) {
				depthOfField.enabled = false;
			}
		}
		
		protected function onCameraDistanceChange():void {
			
			var light : DirectionalLight = WorldManager.instance.gameScene3D.entityAreaDirectionalLight;
			if (light == null) {
				return;
			}
			
			var farMin0 : Number = 5000;
			var farMax0 : Number = 20000;
			var farMin1 : Number = 1500;
			var farMax1 : Number = 5000;
			
			var dist : Number = CameraController.lockedOnPlayerController.distance;
			var bias : Number = (dist - CameraController.lockedOnPlayerController.minDist) / (CameraController.lockedOnPlayerController.maxDist - CameraController.lockedOnPlayerController.minDist);
						
			if (light.shadowMapperType == ShadowMapperType.CASCADE) {
				light.farPlane = clamp(farMin0, farMax0, (farMax0 - farMin0) * bias + farMin0);
			} else {
				light.farPlane = clamp(farMin1, farMax1, (farMax1 - farMin1) * bias + farMin1);
			}
			
		}
		
		protected static function clamp(min : Number, max : Number, value : Number) : Number {
			if (value < min) {
				return min;
			} else if (value > max) {
				return max;
			} else {
				return value;
			}
		}
		
		protected var mouseClickDeltaTime : uint = 0;
		
		protected function onSceneInteractive(action : String, mosEvt : MouseEvent3D, position : Vector3D, currTarget : BaseObj3D, target : BaseObj3D):void {
			if (action == "scene_map_mouse_down") {
				mouseClickDeltaTime = getTimer();
			}
			if (action == "scene_map_mouse_up") {
				if (getTimer() - mouseClickDeltaTime <= 150) {
					GameManager.getInstance().onSceneClicked(position);
				}
			}
		}
		
		public function onPlayerLoaded():void {
			
			if (int(GameManager.getInstance().mainRole.type) == RoleEnum.ROLE_TIAN_DAO_NEW) {
				GameManager.getInstance().mainRole.animationController.initAllAnimationConfig();
				for(var i:int = 0; i < 3; i++) {
					var skillDetail:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.SKILL_TD_TIAN_XIANG_SKILL_1 + i);
					var animationConfigInfo:AnimationConfigInfo = GameManager.getInstance().mainRole.animationController.getAnimationConfigInfo(String(int(PlayerAnimationController.SEQ_ATTACK_210) + i));
					if (animationConfigInfo) {
						skillDetail.skillAloneCd = animationConfigInfo.cdTime;
						skillDetail.holdTime = animationConfigInfo.holdTime;
						skillDetail.comboTime = animationConfigInfo.comboTime;
						skillDetail.situationTime = animationConfigInfo.duration;
						skillDetail.skillLifeTime = animationConfigInfo.duration + 200;
					}
				}
				animationConfigInfo = GameManager.getInstance().mainRole.animationController.getAnimationConfigInfo(PlayerAnimationController.SEQ_RUN);
				if (animationConfigInfo && !isNaN(animationConfigInfo.speed)) {
					GameManager.getInstance().mainRole.vo.walkVelocity = animationConfigInfo.speed;
					GameManager.getInstance().mainRole.physic.speed = animationConfigInfo.speed;
				}
			}
			
		}
		
		
		/**
		 * 场景载入完成 
		 * @param index
		 * 
		 */		
		public function onSceneLoadComplete(gameScene3D:GameScene3D) : void {
			
			var sceneID : int = WorldManager.instance.sceneID;
			var roleID  : int = WorldManager.instance.roleID;
			var sceneData : SceneData = WorldManager.instance.currentSceneData;
						
			// 获取出生地
			var roleData : RoleData = sceneData.defaultRole;
			
			CreatureManager.getInstance().createMyPlayer(roleData.x, roleData.z, roleID);
			CreatureManager.getInstance().loop = true;
			
			GameManager.getInstance().inputEnable = true;
			GameManager.getInstance().loopFrame   = true;
			
			Stage3DLayerManager.getView().visible = true;
			
			GameManager.getInstance().start();
			
			Stage3DLayerManager.startRender();
			Stage3DLayerManager.getView().visible = true;
			
			GameCameraManager.startPlayerMode(GameManager.getInstance().mainRole.graphicDis);
			CameraController.lockedOnPlayerController.mouseLeftControlable = true;
			
			new DriverCheckHelper().check();
			
			var lightPicker:LightPickerBase = WorldManager.instance.gameScene3D.sceneMapLayer.getLightPickerByName(GameScene3D.SCENE_ENTITY_LIGHT_PICKER_NAME);
			
			if(	lightPicker && WorldManager.instance.gameScene3D.mainChar) {
				WorldManager.instance.gameScene3D.mainChar.avatar.lightPicker = lightPicker;
			}
			
			setSoundBoxReference(WorldManager.instance.gameScene3D.mainChar.avatar.graphicDis, gameScene3D);
			
			if (roleID == RoleEnum.ROLE_TIAN_DAO_NEW) {
				CameraController.lockedOnPlayerController.minDist = 100;
			}
		}
		
		public function setSoundBoxReference(ref:ObjectContainer3D,container:ObjectContainer3D):void {
			var lenI:int = container.numChildren;
			for(var i:int = 0; i < lenI; i++) {
				var child:ObjectContainer3D = container.getChildAt(i);
				if(child is SoundBox)
					(child as SoundBox).reference = ref;
				else
					setSoundBoxReference(ref,child);
			}
		}
				
		public function onEnter():void {
			
		}
		
		public function onClearScene():void {
			
		}
		
		public function onChangeScene(_sceneID : int, _roleType : int):void {
			
		}
		
	}
}