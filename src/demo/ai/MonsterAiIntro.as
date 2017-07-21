package demo.ai {

	import flash.geom.Vector3D;
	
	import demo.controller.MonsterAIController;
	import demo.display3D.Player3D;
	import demo.display3D.Avatar3D;
	import demo.managers.GameManager;

	public class MonsterAiIntro extends MonsterAIBase {
		
		private static const StatusWaitingMesh 	 : int = 0;
		private static const StatusWaitingPlayer : int = 1;
		private static const StatusIntro 		 : int = 2;
		private static const IntroAnimTotalTime  : int = 5000;
		
		private var introStatus : int;
		private var partrolPos  : Vector3D;
		private var introRemain : int;
		
		public function MonsterAiIntro(ctrl : MonsterAIController) {
			super(ctrl);
			this.partrolPos = new Vector3D()
		}
		
		override public function update(curTime : int, deltaTime : int) : void {
			super.update(curTime, deltaTime);
						
			if (introStatus == StatusWaitingMesh) {
				if (owner.mesh) {
					introStatus = StatusWaitingPlayer;
				}
			} else if (introStatus == StatusIntro) {
				introRemain -= deltaTime;
				if (introRemain < 0) {
					owner.godMode = false;
					owner.animationController.playIdle();
					ctrl.idle();
				}
			} else if (introStatus == StatusWaitingPlayer) {
				var mainRole : Avatar3D = GameManager.getInstance().mainRole;
				if (mainRole) {
					owner.faceToTarget(mainRole.id);
				}
			}
		}
		
		override public function notifyInterest(avatar : Avatar3D) : void {
			if (introStatus != StatusWaitingPlayer) {
				return;
			}
			if (owner.isDead || avatar.isDead) {
				return;
			}
			if (owner == null) {
				return;
			}
			if (avatar.isMainChar == false) {
				return;
			}
			var player : Player3D = avatar as Player3D;
			if (player == null) {
				return;
			}
			if (player.distanceToPos(owner.x, owner.y) > 1500) {
				return;
			}
			if (introStatus == StatusWaitingPlayer) {
				introStatus = StatusIntro;
				introRemain = IntroAnimTotalTime;
				owner.animationController.playAnimation("flyidle");
			}
		}
		
		override public function enter() : void {
			owner.stopWalk(true);
			introStatus = StatusWaitingMesh;
			introRemain = IntroAnimTotalTime;
		}
		
		override public function leave() : void {
			introStatus = StatusWaitingMesh;
			introRemain = IntroAnimTotalTime;
		}

	}
}

