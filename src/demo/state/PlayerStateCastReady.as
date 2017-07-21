package demo.state {

	import demo.controller.PlayerStateController;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.skill.SkillBase;

	public class PlayerStateCastReady extends PlayerStateBase {

		public var skill : SkillBase;

		public function PlayerStateCastReady(stateController : PlayerStateController) {
			super(PlayerStateController.STATE_CAST_READY, stateController);
		}

		override public function onEnterState(lastState : PlayerStateBase, curTime : int) : void {
			//播放战斗待机动作。
			if (skill && skill.detail && SkillManager.getSkillTypeById(skill.detail.clientId) == SkillDefineEnum.SKILLTYPE_BATTLE) {
				_controller.player.animationController.playAttackIdle();
			}
			super.onEnterState(lastState, curTime);

		}

		override public function render(curTime : int, deltaTime : int) : void {
			super.render(curTime, deltaTime);

			if (skill && skill.detail) {
				if (SkillManager.getSkillTypeById(skill.detail.clientId) == SkillDefineEnum.SKILLTYPE_BATTLE) {
					if (skill) {
						_controller.onStateChange(PlayerStateController.STATE_CAST);
					}
				} else {
					_controller.onStateChange(PlayerStateController.STATE_IDLE);
				}
			}
		}

		override public function move() : Boolean {
			return false;
		}

		override public function canMoveTo() : Boolean {
			return false;
		}

		override public function stop() : Boolean {
			return false;
		}

		override public function cast(isCritical : Boolean = false) : Boolean {
			return castEnable(isCritical);
		}

		override public function castEnable(isCritical : Boolean = false) : Boolean {
			return false;
		}

		override public function hurt() : Boolean {
			return false;
		}

		override public function die() : Boolean {
			_controller.onStateChange(PlayerStateController.STATE_DEAD);
			return true;
		}

		override public function stun() : Boolean {
			_controller.onStateChange(PlayerStateController.STATE_STUN);
			return true;
		}

	}
}
