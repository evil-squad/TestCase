package demo.controller {

	import com.game.engine3D.scene.render.RenderUnit3D;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import away3d.animators.AnimatorBase;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.CompositeMesh;
	import away3d.entities.Mesh;
	import away3d.events.AnimatorEvent;
	
	import demo.display3D.Avatar3D;

	/**
	 * 动画控制器 
	 * @author chenbo
	 * 
	 */	
	public class PlayerAnimationController {
		
		public static const SEQ_IDLE 		: String = "100";
		public static const SEQ_IDLE_1 		: String = "110";
		public static const SEQ_RUN 		: String = "130";
		public static const SEQ_ATTACK_210 	: String = "210";
		public static const SEQ_ATTACK_211 	: String = "211";
		public static const SEQ_ATTACK_212 	: String = "212";
		
		public static const SEQ_ATTACK_250 	: String = "250";
		public static const SEQ_ATTACK_260 	: String = "260";
		public static const SEQ_ATTACK_270 	: String = "270";
		public static const SEQ_ATTACK_IDLE : String = "200";
		public static const SEQ_HURT 		: String = "400";
		public static const SEQ_DIE 		: String = "500";
		public static const SEQ_STUN 		: String = "hurt_stun";
		public static const SEQ_SIT 		: String = "sit";
		public static const SEQ_GATHER 		: String = "gather";
		public static const SEQ_MAKE 		: String = "make";
		public static const SEQ_WALK		: String = "walk";
		
		public static const HIDE_EVENT		: String = "hide";
		public static const SHOW_EVENT		: String = "show";
		public static const MOVE_EVENT		: String = "move";
		
		public static const CFG_BLEND		: String = "blend";
		public static const CFG_CD		: String = "cd";
		public static const CFG_HOLD		: String = "hold";
		public static const CFG_COMBO		: String = "life";
		public static const CFG_SPEED		: String = "speed";
		
		private var _player   			: Avatar3D;
		private var _time 				: int;
		private var _lastSeqName 		: String;
		private var _lastAniSpeed 		: Number = 1;
		private var _lastStartTime 		: Number = 0;
		private var _speedScale 		: Number = 1;
		private var _currentAnimation   : String;
		
		private var _animationConfigInfoDict:Dictionary = new Dictionary();
		private var _currentMoveEventInfo:MoveEventInfo;
		
		public function PlayerAnimationController(player : Avatar3D) {
			_player = player;
			playIdle();
			_currentAnimation = SEQ_IDLE;
		}
		
		public function getAnimationConfigInfo(animation:String):AnimationConfigInfo
		{
			return _animationConfigInfoDict[animation];
		}
		
		public function currentAnimation() : String {
			return _currentAnimation;
		}
		
		public function isGatherAnim() : Boolean {
			return _currentAnimation == SEQ_GATHER;
		}
		
		public function isRunAnim() : Boolean {
			return _currentAnimation == SEQ_RUN;
		}

		private function onAnimationComplete(e : AnimatorEvent) : void {
			_time = 0;
			resetAnimationConfig();
			if (animator && !animator.looping) {
				_player.onAnimationComplete();
			}
		}
		
		public function get animator() : AnimatorBase {
			if (_player.mesh && _player.mesh.animator) {
				return _player.mesh.animator;
			}
			return null;
		}
		
		public function set animSpeedScale(value : Number) : void {
			if (value < 0) {
				value = 1 / int.MAX_VALUE;
			}
			if (value == _speedScale) {
				return;
			}
			_speedScale = value;
			_player.mesh.animateSpeed = _lastAniSpeed * _speedScale;
		}

		public function get animSpeedScale() : Number {
			return _speedScale;
		}

		public function get bindRenderUnit() : RenderUnit3D {
			return _player.mesh;
		}
		
		/**
		 * 播放动画 
		 * @param seqName		动画名称
		 * @param aniSpeed		动画速度
		 * @param startTime		起始时间点
		 * 
		 */		
		public function playAnimation(seqName : String, aniSpeed : Number = 1.0, startTime : Number = 0,blendTime:Number = 0.2) : void {
			if (!hasAnimation(seqName)) {
				return;
			}
			var animationConfig:AnimationConfigInfo = _animationConfigInfoDict[_currentAnimation];
			if(animationConfig && animationConfig.blendTime != 0)
				blendTime = animationConfig.blendTime/1000;
			_currentAnimation = seqName;
			if(seqName == null)
			{
				trace("_currentAnimation = null");
			}
			_lastSeqName      = seqName;
			_lastAniSpeed     = aniSpeed;
			_lastStartTime    = startTime;
						
			if (_player.mesh == null) {
				return;
			}
			
			_player.mesh.animateSpeed = _lastAniSpeed * _speedScale;
			
			if (hasAnimation(seqName)) 
			{
				//hyzboy 2017-02-24 原本有settings可以选是否有动画过渡，如果设定为否，则下面调用的第二个参数写null
				_player.mesh.setStatus(_currentAnimation, 0.2, _lastStartTime, _player.mesh.animateSpeed);
			}
			else
			{
				playIdle();
			}
			
			if (_player.isDead && seqName != SEQ_DIE) {
				trace("animation : SEQ_DIE!!!!!!!!!!!!!!!!!!!!!");
			}
			
			if (_player.mesh && _player.mesh.animator) {
				_player.mesh.animator.addEventListener(AnimatorEvent.CYCLE_COMPLETE, onAnimationComplete);
			}
			_time = 0;
			resetAnimationConfig();
			trace("playAnimation",_currentAnimation,getTimer());
		}
		
		/**
		 * 获取动作的持续时间 
		 * @param seqName
		 * @return 
		 * 
		 */		
		public function getAnimationDuration(seqName : String) : uint {
			return getSequenceDuration(seqName);
		}

		public function getSequenceDuration(seqName : String) : uint {
			if (_player.mesh.animator == null) {
				return 1;
			}
			if (!_player.mesh.animator.animationSet.hasAnimation(seqName)) {
				return 1;
			}
			var node : SkeletonClipNode = _player.mesh.animator.animationSet.getAnimation(seqName) as SkeletonClipNode;
			return node.duration;
		}
		
		public function hasAnimation(seqName : String) : Boolean {
			if (!_player.mesh || _player.mesh.animator == null) {
				return false;
			}
			return _player.mesh.animator.animationSet.hasAnimation(seqName);
		}
			
		public function playMove() : void {
			if (_currentAnimation != SEQ_RUN) {
				playAnimation(SEQ_RUN);
			}
		}

		public function playIdle() : void {
			if (_player.inBattle) {
				if (_currentAnimation != SEQ_ATTACK_IDLE) {
					playAnimation(SEQ_ATTACK_IDLE);
				}
			} else {
				if (_currentAnimation != SEQ_IDLE) {
					playAnimation(SEQ_IDLE);
				}
			}
		}

		public function playIdle1() : void {
			playAnimation(SEQ_IDLE_1);
		}
		
		public function playAttackIdle() : void {
			playAnimation(SEQ_ATTACK_IDLE);
		}

		public function playGather() : void {
			playAnimation(SEQ_GATHER);
		}

		public function playKick() : void {
			playAnimation(SEQ_GATHER);
		}


		public function playMake() : void {
			playAnimation(SEQ_MAKE, 1.0);
		}

		public function playStun() : void {
			playAnimation(SEQ_STUN);
		}

		public function playSit() : void {
			playAnimation(SEQ_SIT);
		}

		public function playHurt() : void {
			if (_currentAnimation == SEQ_IDLE || _currentAnimation == SEQ_IDLE_1 || _currentAnimation == SEQ_ATTACK_IDLE) {
				playAnimation(SEQ_HURT);
			}
		}

		public function playDead() : void {
			playAnimation(SEQ_DIE);
		}
		
		public function playdDeath() : void {
			playAnimation(SEQ_DIE, 1, getAnimationDuration(SEQ_DIE));
		}

		public function playAttack() : void {
			playAnimation(SEQ_ATTACK_250);
		}

		public function playAttackEx(durTime : uint) : int {
			var rand : int = Math.random() * 2;
			if (rand == 0) {
				playAttack1Ex(durTime);
				return 0;
			} else {
				playAttack2Ex(durTime);
				return 1;
			}
		}
		
		public function playAttack1(speed : Number = 1) : void {
			playAnimation(SEQ_ATTACK_250, speed);
		}

		public function playAnimWithDuring(seqName : String, during : int, loop : Boolean = false) : void {
			var aniDur : uint = getAnimationDuration(seqName);
			if (aniDur == 0) {
				return;
			}
			var speed : Number = Number(aniDur) / during;
			playAnimation(seqName, speed);
		}
		
		public function playAttack1Ex(durTime : uint) : void {
			var aniDur : uint = getAnimationDuration(SEQ_ATTACK_250);
			var speed : Number = Number(aniDur) / durTime;
			playAttack1(speed);
		}

		public function playAttack2(speed : Number = 1) : void {
			playAnimation(SEQ_ATTACK_260, speed);
		}

		public function playAttack2Ex(durTime : uint) : void {
			var aniDur : uint = getAnimationDuration(SEQ_ATTACK_260);
			var speed : Number = Number(aniDur) / durTime;
			playAttack2(speed);
		}

		public function playCastSkill(skill : int, speed : Number = 1.0) : void {
			switch (skill) {
				case 1:
					playAnimation(SEQ_ATTACK_270, speed);
					break;
				default:
					playAnimation(SEQ_ATTACK_270, speed);
					break;
			}
		}

		public function playCastSkillEx(skill : int, durTime : uint) : void {
			var aniDur : uint;
			switch (skill) {
				case 1:
					aniDur = getAnimationDuration(SEQ_ATTACK_270);
					break;
				default:
					aniDur = getAnimationDuration(SEQ_ATTACK_270);
					break;
			}
			var speed : Number = Number(aniDur) / durTime;
			playCastSkill(skill, speed);
		}

		public function render(curTime : int, deltaTime : int) : void {

			_time += deltaTime;
			if(_currentMoveEventInfo)
			{
				_player.displaceForward(_currentMoveEventInfo.getCurrentDistance(_time));
				if(_time >= _currentMoveEventInfo.endTime)
				{
					//trace("moveEventInfo end **********: " , _time, _currentMoveEventInfo.time,_currentMoveEventInfo.endTime,_currentMoveEventInfo.distance);
					_currentMoveEventInfo = null;
				}
			}
			
			if(animator && animator as SkeletonAnimator)
			{
				var skeletonClipNode:SkeletonClipNode = (animator as SkeletonAnimator).activeAnimation as SkeletonClipNode;
				var animationConfig:Object = skeletonClipNode.extras;
				if(animationConfig)
				{
					var animationConfigInfo:AnimationConfigInfo = _animationConfigInfoDict[_currentAnimation];
					if(!animationConfigInfo)
						animationConfigInfo = initAnimationConfigInfo(animationConfig,_currentAnimation);
					
					var hideOrShowEvents:Array = animationConfigInfo.hideOrShowEvents;
					var lenI:int;
					var i:int;
					if(hideOrShowEvents)
					{
						lenI = hideOrShowEvents.length;
						for(i = 0; i < lenI; i++)
						{
							var hideOrShowEventInfo:HideOrShowEventInfo = HideOrShowEventInfo(hideOrShowEvents[i]);
							if(hideOrShowEventInfo.objs.length == 0)
								checkHideOrShowEventObjs(hideOrShowEventInfo);
							
							if(_time >= hideOrShowEventInfo.time && !hideOrShowEventInfo.handled && hideOrShowEventInfo.objs.length > 0)
							{
								//trace("hideOrShowEventInfo trigger : " , _time, hideOrShowEventInfo.time,hideOrShowEventInfo.objName,hideOrShowEventInfo.show);
								hideOrShowEventInfo.showOrHide(hideOrShowEventInfo.show);
								hideOrShowEventInfo.handled = true;
							}
						}
					}
					
					var moveEvents:Array = animationConfigInfo.moveEvents;
					if(moveEvents)
					{
						lenI = moveEvents.length;
						for(i = 0; i < lenI; i++)
						{
							var moveEventInfo:MoveEventInfo = moveEvents[i] as MoveEventInfo;
							if(_time >= moveEventInfo.time && !moveEventInfo.handled)
							{
								_currentMoveEventInfo = moveEventInfo;
								_currentMoveEventInfo.movedDistance = 0;
								moveEventInfo.handled = true;
								//trace("moveEventInfo trigger : " , _time, moveEventInfo.time,moveEventInfo.endTime,moveEventInfo.distance);
							}
						}
					}
				}
			}
		}

		public function initAllAnimationConfig():void
		{
			if(animator && animator as SkeletonAnimator)
			{
				var animations:Vector.<AnimationNodeBase> = ((animator as SkeletonAnimator).animationSet as SkeletonAnimationSet).animations;
				for(var i:int = animations.length - 1; i>= 0; i--)
				{
					var skeletonClipNode:SkeletonClipNode = animations[i] as SkeletonClipNode;
					var animationConfig:Object = skeletonClipNode.extras;
					if(animationConfig)
					{
						var animationConfigInfo:AnimationConfigInfo = _animationConfigInfoDict[skeletonClipNode.name];
						if(!animationConfigInfo)
						{
							animationConfigInfo = initAnimationConfigInfo(animationConfig,skeletonClipNode.name);
							animationConfigInfo.duration = skeletonClipNode.duration;
						}
					}
				}
			}
		}
		
		private function initAnimationConfigInfo(animationConfig:Object,animationName:String):AnimationConfigInfo
		{
			var animationConfigInfo:AnimationConfigInfo = new AnimationConfigInfo();
			var hideOrShowEvents:Array;
			var moveEvents:Array;
			for(var keyName:String in animationConfig)
			{
				var eventInfoArr:Array = String(animationConfig[keyName]).split(",");
				
				var showEvent:Boolean = (keyName.indexOf(SHOW_EVENT) >= 0);
				var hideEvent:Boolean = (keyName.indexOf(HIDE_EVENT) >= 0);
				if(hideEvent || showEvent)
				{
					if(!hideOrShowEvents) hideOrShowEvents = [];					
					var hideOrShowEventInfo:HideOrShowEventInfo = new HideOrShowEventInfo(Number(eventInfoArr[0]) * 1000,eventInfoArr[1],showEvent);
					hideOrShowEvents.push(hideOrShowEventInfo);
					checkHideOrShowEventObjs(hideOrShowEventInfo);					
					if(hideOrShowEventInfo.objs.length == 0)
					{
						//trace("hideOrShowEventInfo.objs.length == 0",hideOrShowEventInfo.objName,hideOrShowEventInfo.time,animationName);
					}
				}
				
				if(keyName.indexOf(MOVE_EVENT) >= 0)
				{
					if(!moveEvents) moveEvents = [];
					var moveEventInfo:MoveEventInfo = new MoveEventInfo(Number(eventInfoArr[0]) * 1000,Number(eventInfoArr[1]) * 1000,Number(eventInfoArr[2]));
					moveEvents.push(moveEventInfo);
				}
				
				if(keyName.indexOf(CFG_BLEND) >= 0)
				{
					animationConfigInfo.blendTime = Number(eventInfoArr[0]) * 1000;
				}
				
				if(keyName.indexOf(CFG_HOLD) >= 0)
				{
					animationConfigInfo.holdTime = Number(eventInfoArr[0]) * 1000;
				}
				
				if(keyName.indexOf(CFG_CD) >= 0)
				{
					animationConfigInfo.cdTime = Number(eventInfoArr[0]) * 1000;
				}
				
				if(keyName.indexOf(CFG_COMBO) >= 0)
				{
					animationConfigInfo.comboTime = Number(eventInfoArr[0]) * 1000;
				}
				
				if(keyName.indexOf(CFG_SPEED) >= 0)
				{
					animationConfigInfo.speed = Number(eventInfoArr[0]);
				}
				
			}
			if(hideOrShowEvents)
				hideOrShowEvents.sortOn("time",Array.NUMERIC);
			if(moveEvents)
				moveEvents.sortOn("time",Array.NUMERIC);
			
			animationConfigInfo.hideOrShowEvents = hideOrShowEvents;
			animationConfigInfo.moveEvents = moveEvents;
			_animationConfigInfoDict[animationName] = animationConfigInfo;
			return animationConfigInfo;
		}
		
		private function checkHideOrShowEventObjs(hideOrShowEventInfo:HideOrShowEventInfo):void
		{
			var obj:ObjectContainer3D = _player.mesh.getChildByName(hideOrShowEventInfo.objName);
			if(obj)
				hideOrShowEventInfo.objs.push(obj);
			else
			{
				var meshes:Vector.<Mesh> = _player.mesh.renderUnitData.meshes;
				if(meshes)
				{
					for(var j:int = meshes.length - 1; j >= 0; j--)
					{
						var mesh:Mesh = meshes[j];
						if(mesh is CompositeMesh)
						{
							for(var k:int = mesh.subMeshes.length - 1; k >= 0; k--)
							{
								if(mesh.subMeshes[k].partName == hideOrShowEventInfo.objName)
								{
									hideOrShowEventInfo.objs.push(mesh.subMeshes[k]);
								}
							}
						}
					}
				}
			}
		}
		
		private function resetAnimationConfig():void
		{
			var animationConfigInfo:AnimationConfigInfo = _animationConfigInfoDict[_currentAnimation];
			if(animationConfigInfo)
				animationConfigInfo.reset();
			if(_currentMoveEventInfo)
			{
				trace("resetAnimationConfig moveEventInfo end **********: " , _time, _currentMoveEventInfo.time,_currentMoveEventInfo.endTime,_currentMoveEventInfo.distance);
				_currentMoveEventInfo = null;
			}
		}
		
		public function dispose() : void {
			if (_player.mesh && _player.mesh.animator) {
				_player.mesh.animator.removeEventListener(AnimatorEvent.CYCLE_COMPLETE, onAnimationComplete);
			}
		}

	}

}

