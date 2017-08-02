package demo.ai {

	import demo.controller.MonsterAIController;
	import demo.display3D.Avatar3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.SkillManager;
	import demo.skill.SkillDetailVO;

	/**
	 * 攻击状态 
	 * @author chenbo
	 * 
	 */	
	public class MonsterAIAttack extends MonsterAIBase {
		
		private const AkLazyTick : int = 500 + Math.random() * 500;				// 打完后休息一下.
		private const FaceToTick : int = 100; 									// 1秒发动10次朝向检测.
		private const AttackTick : int = 100 + Math.random() * 100;				// 切换到攻击状态之后延时攻击时间
		
		/** 技能 */
		private var skillVo 	 : SkillDetailVO;								
		/** 攻击计时 */
		private var attackTime   : int;										
		/** CD计时 */
		private var cdingTime 	 : int;											
		/** 转向计时 */
		private var faceToTime   : int;											
		/** 技能编号 */
		private var skillID 	 : int;											
		/** 技能CD时间 */
		private var skillCD 	 : int;											
		/** 技能范围 */
		private var skillRG 	 : int;				
		
		/**
		 * 攻击状态 
		 * @param ctrl
		 * 
		 */		
		public function MonsterAIAttack(ctrl : MonsterAIController) {
			super(ctrl);
			this.randomSkill();
		}
		
		override public function update(curTime : int, deltaTime : int) : void {
			super.update(curTime, deltaTime);
			
			if (owner.isDead) {
				return;
			}
			if (ctrl.lockTarget && ctrl.lockTarget.isDead) {
				ctrl.lockTarget = null;
			}
			
			attackTime += deltaTime;
			faceToTime += deltaTime;
			cdingTime  -= deltaTime;
			
			if (ctrl.lockTarget == null) {
				if (cdingTime <= AkLazyTick) {
					ctrl.moveFollow(skillVo ? skillVo.skillRange : 0);
				}
			} else if (attackAble()) {
				randomSkill();
				cdingTime = skillCD;
				ctrl.useSkill(skillID, ctrl.lockTarget.id, ctrl.lockTarget.x, ctrl.lockTarget.y);
			}
		}
		
		override public function notifyInterest(avatar : Avatar3D) : void {
			if (owner.isDead || avatar.isDead) {
				return;
			}
			if (ctrl.lockTarget == avatar) {
				return;
			}
			// 是否需要切换目标
			var newTarget : Boolean = false;
			if (ctrl.lockTarget == null) {
				newTarget = true;
			} else {
				newTarget = avatar.isMainChar ? Math.random() < 0.75 : Math.random() < 0.25;
			}
			// 是否在攻击距离内
			if (owner.distanceToPos(avatar.x, avatar.y) <= owner.distanceFindEnemy && newTarget) {
				ctrl.lockTarget = avatar;
			}
		}
		
		/**
		 * 随机技能 
		 */		
		private function randomSkill() : void {
			skillID = owner.vo.skillId;
			skillID = owner.vo.skillId2 > 0 && Math.random() > 0.5 ? owner.vo.skillId2 : skillID;
			skillID = owner.vo.skillId3 > 0 && Math.random() > 0.7 ? owner.vo.skillId3 : skillID;			
			skillVo = SkillManager.getInstance().getSkillInfo(skillID);
			skillCD = skillVo.situationTime + AkLazyTick;
			skillRG = skillVo.skillRadius;
			
			if (skillVo.releaseType == SkillDefineEnum.TARGET_SINGLE_ENEMY || skillVo.releaseType == SkillDefineEnum.TARGET_HARMONY) {
				skillRG = skillVo.skillRange;
			}
		}
		
		/**
		 * 是否可以攻击 
		 * @return 
		 * 
		 */		
		private function attackAble() : Boolean {
			// 延时攻击
			if (attackTime < AttackTick) {
				return false;
			}
			// 正在攻击
			if (cdingTime > AkLazyTick) {
				return false;
			}
			// 自己走太远了回家
			if (owner.distanceToPos(ctrl.orgPos.x, ctrl.orgPos.z) > owner.distanceFollow) {
				ctrl.lockTarget = null;
				return false;
			}
			// 目标距离自己的出生点太远了
			if (ctrl.lockTarget.distanceToPos(ctrl.orgPos.x, ctrl.orgPos.z) > owner.distanceFollow) {
				ctrl.lockTarget = null;
				return false;
			}
			// 太近了
			if (ctrl.lockTarget.distanceToObject(owner.id) < owner.distanceMinFollow) {
				ctrl.moveFollow(skillRG);
				return false;
			}
			// 超出攻击范围
			if (ctrl.lockTarget.distanceToObject(owner.id) - skillRG - owner.radius - ctrl.lockTarget.radius > owner.distanceMaxAttack) {
				ctrl.moveFollow(skillRG);
				return false;
			}
			if (cdingTime > 0) {
				// 既不能打，又不需要动的时候，休息期间检测角度
				if (faceToTime < FaceToTick) {
					return false;
				}
				faceToTime = 0;
				ctrl.owner.faceToTarget(ctrl.lockTarget.id);
				// 偶尔偷懒
				if (ctrl.owner.lazyRandom > Math.random()) {
					ctrl.lazy();
				}
			}
			return true;
		}
		
		override public function enter() : void {
			attackTime = 0;
			faceToTime = 0;
			cdingTime = 0;
			randomSkill();
		}

		override public function leave() : void {
			faceToTime = 0;
			attackTime = 0;
			cdingTime = 0;
			randomSkill();
		}
		
	}
}
