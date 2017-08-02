package demo.controller {

	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.core.pick.RaycastPicker;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Player3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.GameManager;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;
	import demo.skill.SkillBase;
	import demo.skill.SkillDetailVO;
	import demo.vo.ServerSkillVO;
	
	public class PlayerActionController {
		
		
		/** 移动计时器 */
		private var walkTimeCounter : int;			
		/** 前进方向 */
		private var dirFront 		: int;			
		/** 平移方向 */
		private var dirRight 		: int;	
		/** 最终位置 */
		private var finalOffset 	: Vector3D = new Vector3D();	
								
		private var _role			: Player3D;										// role
		private var _actionSkillId  : int;											// 技能ID
		private var _targetPoint    : Point;										// 目标点
		private var _nextPosition 	: Vector3D;										// 下一个点
		// ------------------------- 各种 update -------------------------
		private var _updateFrame 	: int;
		private var _last66msTime   : int = 0;
		private var _last100msTime  : int = 0;
		private var _last200msTime  : int = 0;
		private var _last500msTime  : int = 0;
		private var _last1000msTime : int = 0;

		public function PlayerActionController() {
			
		}
		
		/**
		 * 初始化控制器 
		 * @param role
		 * 
		 */		
		public function initRole(role : Player3D) : void {
			_role = role;
			actionSkillId = SkillDefineEnum.NO_SKILL;
		}
		
		public function update(curTime : int, deltaTime : int) : void {
			if (_role == null) {
				return;
			}
			//技能cd计算
			SkillManager.getInstance().updateSkillCd(deltaTime);
			// 间隔2针
			_updateFrame++;
			if (_updateFrame % 2 == 0) {
				Update2Frame(curTime);
			}
			// 间隔66ms做一次计算
			if ((curTime - _last66msTime) > 66) {
				Update66ms(curTime);
				_last66msTime = curTime;
			}
			// 间隔100ms做一次计算
			if ((curTime - _last100msTime) > 100) {
				_last100msTime = curTime;
			}
			// 间隔200ms做一次计算
			if ((curTime - _last200msTime) > 200) {
				_last200msTime = curTime;
				Update200ms(curTime);
			}
			// 间隔500ms做一次计算
			if ((curTime - _last500msTime) > 500) {
				_last500msTime = curTime;
			}
			// 间隔1000ms做一次计算
			if ((curTime - _last1000msTime) > 1000) {
				_last1000msTime = curTime;
			}
			// 每帧做一次计算
			UpdateFrame(curTime, deltaTime);
			// move
			UpdateMove(deltaTime);
		}
		
		/**
		 * 移动方法 
		 * @param deltaTime
		 * 
		 */				
		private function UpdateMove(deltaTime : int) : void 
		{
			var view:View3D=Stage3DLayerManager.getView(0);
			
			if(!view)return;
			
			var camera : Camera3D =view.camera;
			
			if (!camera)return;
			
			// walk
			walkTimeCounter += deltaTime;
			if (walkTimeCounter < 30) {
				return;
			}
			walkTimeCounter = 0;
			// 移动方向
			if (dirFront == 0 && dirRight == 0) {
				_role.walkToward(null);
			} else {
				finalOffset.setTo(0, 0, 0);
				var vec0 : Vector3D = null;
				if (dirRight != 0) {
					vec0 = camera.rightVector;
					vec0.normalize();
					vec0.scaleBy(dirRight);
					finalOffset.incrementBy(vec0);
				}
				if (dirFront != 0) {
					vec0 = camera.forwardVector;
					vec0.normalize();
					vec0.scaleBy(dirFront);
					finalOffset.incrementBy(vec0);
				}
				_role.walkToward(finalOffset);
				_nextPosition = null;
				GameManager.getInstance().autoAttack = false;
			}
		}
		
		/**
		 * 选中了目标 
		 * @param avatar
		 * 
		 */		
		public function onAvatarClicked(avatar : Avatar3D) : void {
			if (avatar == null || avatar.isDead) {
				return;
			}
			if (avatar.attackAble) {
				actionSkillId = getDefaultSkillId();
			}
		}
		
		public function walkForward(bool : Boolean = true) : void {
			dirFront = bool ? 1 : 0;
		}

		public function walkBackward(bool : Boolean = true) : void {
			dirFront = bool ? -1 : 0;
		}

		public function walkLeft(bool : Boolean = true) : void {
			dirRight = bool ? -1 : 0;
		}

		public function walkRight(bool : Boolean = true) : void {
			dirRight = bool ? 1 : 0;
		}

		public function setNextPosition(position : Vector3D) : void {
			_nextPosition = position;
		}

		public function set actionSkillId(skillId : int) : void {
			if (_actionSkillId == skillId) {
				return;
			}
			_actionSkillId = skillId;
		}
		
		public function get actionSkillId() : int {
			return _actionSkillId;
		}

		/**
		 * 使用技能 
		 */		
		private function tryCastSkill() : void {
			if (_role == null) {
				return;
			}

			if (!GameManager.getInstance().stateController.castEnable()) {
				return;
			}
			
			var skillVO : SkillDetailVO = SkillManager.getInstance().getSkillInfo(_actionSkillId);
			if (!skillVO) {
				return;
			}
			
			var skillBase:SkillBase = _role.skillController.lastCastingSkill();//如果处于公共cd时间，则不接受任何技能释放请求
			if(skillBase && skillBase.lastTime < skillBase.detail.holdTime)
				return;
			
			if(skillVO.baseSkillId)
			{
				trace("-----------------释放连招!",getTimer(),skillVO.clientId);
			}
			
			var target : Avatar3D = GameManager.getInstance().actionAvatar;
			var isBattleSkill : Boolean  = SkillManager.getSkillTypeById(skillVO.clientId) == SkillDefineEnum.SKILLTYPE_BATTLE;
			// 修正一个问题，如果选择的技能处于cd状态。默认使用默认技能跑近目标。
			// 释放完毕之后，将之前选择的技能再次放回到下次施法的技能对象
			// step1
			var lastSkillId : int = actionSkillId;
			var replaced    : Boolean = false;
			
			if (isBattleSkill) {
				var inCd : Boolean = skillVO.cdRemain > 0;
				if (inCd) {
					var defaultSkillId : int = getDefaultSkillId();
					var defaultSkill   : SkillDetailVO = SkillManager.getInstance().getSkillInfo(defaultSkillId);
					if (defaultSkill == null) {
						return;
					}
					skillVO = defaultSkill;
					replaced = true;
				}
			}
			
			isBattleSkill = SkillManager.getSkillTypeById(skillVO.clientId) == SkillDefineEnum.SKILLTYPE_BATTLE;
			if (skillVO.releaseType == SkillDefineEnum.TARGET_AREA) {
				if (_targetPoint == null) {
					return;
				}
			} else if (skillVO.releaseType == SkillDefineEnum.TARGET_DIRECTION) {
				if (_targetPoint == null) {
					return;					
				}
			} else if (skillVO.releaseType == SkillDefineEnum.TARGET_SINGLE_ENEMY) {
				if (target == null) {
					return;
				}
				if (target.attackAble == false) {
					return;
				}
				if (target.isDead) {
					return;
				}
			} else if (skillVO.releaseType == SkillDefineEnum.TARGET_HARMONY) {
				if (target == null) {
					return;
				}
			}
			
			//目标位置是否能够让技能够得到
			var dist 		: Number = 0;
			var skillRange 	: Number = 0;
			var targetPos 	: Point  = null;
			
			if (skillVO.releaseType == SkillDefineEnum.TARGET_AREA || skillVO.releaseType == SkillDefineEnum.TARGET_SINGLE_ENEMY || skillVO.releaseType == SkillDefineEnum.TARGET_HARMONY) {
				
				if (skillVO.releaseType == SkillDefineEnum.TARGET_AREA) {
					targetPos = new Point(_targetPoint.x, _targetPoint.y);
				} else {
					targetPos = new Point(target.x, target.z);
				}
				
				dist = _role.distanceToPos(targetPos.x, targetPos.y);
				skillRange = skillVO.skillRange + _role.radius;
				
				if (target) {
					skillRange += target.radius;
				}
				
				if (dist > skillRange) {
					if (_updateFrame % 10 == 0) {
						_role.walkTo(new Vector3D(targetPos.x, 0, targetPos.y));
					}
					_nextPosition = null;
					return;
				}
			}
			
			var castMsgSended : Boolean = false;
			if (skillVO.releaseType == SkillDefineEnum.TARGET_FREE || skillVO.releaseType == SkillDefineEnum.TARGET_AREA || skillVO.releaseType == SkillDefineEnum.TARGET_DIRECTION) {
				castMsgSended = tryUseSkill(skillVO.clientId);
			} else if (skillVO.releaseType == SkillDefineEnum.TARGET_SINGLE_ENEMY || skillVO.releaseType == SkillDefineEnum.TARGET_HARMONY) {
				castMsgSended = tryUseSkill(skillVO.clientId, target.id);
			}
		
			// 施法协议发送成功
			if (castMsgSended) {
				actionSkillId = SkillDefineEnum.NO_SKILL;
				_targetPoint = null;
			}
			// step2
			if (replaced) {
				actionSkillId = lastSkillId;
			}
		}
		
		private function Update66ms(curTime : int) : void {
			tryAutoAddDefaultSkill();
		}
				
		protected function Update2Frame(curTime : int) : void {
			//检测是否需要移除目标
			tryAutoRemoveTarget();
			//检测是否需要移除技能
			tryAutoRemoveBattleSkill();
			//尝试释放技能
			tryCastSkill();
		}
		
		protected function Update200ms(curTime : int) : void {
			if (_nextPosition) {
				if (_role.walkTo(_nextPosition)) {
					_nextPosition = null;
				}
			}
		}
		
		private function tryAutoAddDefaultSkill() : void {
			var targetRole : Avatar3D = GameManager.getInstance().actionAvatar;
			var autoAttack : Boolean   = GameManager.getInstance().autoAttack;
			if (targetRole == null) {
				return;
			}
			if (autoAttack == false) {
				return;
			}
			if (GameManager.getInstance().stateController.currentState.stateId != PlayerStateController.STATE_IDLE) {
				return;
			}
			if (targetRole.attackAble == false) {
				return;
			}
			if (targetRole.isDead) {
				return;
			}
			// 不能攻击 当前已有选择过的攻击技能
			if (actionSkillId != SkillDefineEnum.NO_SKILL && actionSkillId != SkillDefineEnum.PLAYER_NORMAL_ATTACK && actionSkillId != SkillDefineEnum.PLAYER_SHOOT_ATTACK && actionSkillId != SkillDefineEnum.PLAYER_MAGIC_ATTACK) {
				return;
			}
			actionSkillId = getDefaultSkillId();
		}
		
		protected function UpdateFrame(curTime : int, deltaTime : int) : void {
						
		}
		
		private function tryAutoRemoveTarget() : void {
			var targetRole : Avatar3D = GameManager.getInstance().actionAvatar;
			if (targetRole == null) {
				return;
			}
			// 目标不存在了
			if (!WorldManager.instance.getAvatar3D(targetRole.id)) {
				targetRole = null;
				return;
			}
			if (_role.distanceToObject(targetRole.id) > SkillDefineEnum.MAX_RANGE_WITH_TARGET && actionSkillId != SkillDefineEnum.RUN_TO_TOUCH) {
				targetRole = null;
				return;
			}
			var isBattleSkill : Boolean = SkillManager.getSkillTypeById(actionSkillId) == SkillDefineEnum.SKILLTYPE_BATTLE;
			if (targetRole.attackAble == false) {
				if (isBattleSkill) {
					targetRole = null;
					return;
				}
			} else {
				if (targetRole.isDead) {
					targetRole = null;
					return;
				}
			}
		}
				
		private function getDefaultSkillId() : int {
			return SkillDefineEnum.PLAYER_NORMAL_ATTACK;
		}
		
		private function tryAutoRemoveBattleSkill() : void {
			if (actionSkillId == SkillDefineEnum.NO_SKILL) {
				return;
			}
			var autoAttack : Boolean = GameManager.getInstance().autoAttack;
			if (autoAttack == false) {
				actionSkillId = SkillDefineEnum.NO_SKILL;
				return;
			}
			var actionTarget  : Avatar3D = GameManager.getInstance().actionAvatar;
			var isBattleSkill : Boolean = SkillManager.getSkillTypeById(actionSkillId) == SkillDefineEnum.SKILLTYPE_BATTLE;
			//无技能信息
			var skill : SkillDetailVO = SkillManager.getInstance().getSkillInfo(actionSkillId);
			if (skill == null) {
				actionSkillId = SkillDefineEnum.NO_SKILL;
				return;
			}
			//移除战斗技能
			if (isBattleSkill) {
				//不需要目标的技能，不需要判断目标属性。
				if (skill.releaseType == SkillDefineEnum.TARGET_AREA || skill.releaseType == SkillDefineEnum.TARGET_DIRECTION) {
					if (_targetPoint == null) {
						actionSkillId = SkillDefineEnum.NO_SKILL;
					}
					return;
				}
				if (skill.releaseType == SkillDefineEnum.TARGET_SINGLE_ENEMY) {
					if (actionTarget == null) {
						actionSkillId = SkillDefineEnum.NO_SKILL;
						return;
					}
					if (actionTarget.attackAble == false) {
						actionSkillId = SkillDefineEnum.NO_SKILL;
						return;
					}
				} else if (skill.releaseType == SkillDefineEnum.TARGET_HARMONY) {
					if (actionTarget == null) {
						actionSkillId = SkillDefineEnum.NO_SKILL;
						return;
					}
					if (actionTarget.attackAble) {
						actionSkillId = SkillDefineEnum.NO_SKILL;
						return;
					}
				}
			}
		}
		
		public function onSkillOpearate(skillId : int) : void {
			var skillBase:SkillBase = _role.skillController.lastCastingSkill();//如果处于公共cd时间，则不接受任何技能释放请求
			if(skillBase && skillBase.lastTime < SkillManager.getInstance().publicCdTime)
				return;
				
			var skillVO : SkillDetailVO = SkillManager.getInstance().getSkillInfo(skillId);//得到请求释放技能的信息
			if(skillVO.baseSkillId && skillBase && skillBase.detail.baseSkillId == skillVO.baseSkillId)//如果请求的技能和当前技能是连招的不同招式，则请求的技能为当前技能的下一个招式
			{
				if(skillBase.detail.nextSkillId && skillBase.lastTime <= skillBase.detail.comboTime)
				{
					skillId = skillBase.detail.nextSkillId;
					skillVO = SkillManager.getInstance().getSkillInfo(skillId);
					trace("尝试释放连招!",getTimer(),skillId);
				}
			}
				
			if (skillVO == null) {
				return;
			}
			if (skillVO.cdRemain > 0) {
				_role.popTextAnim("技能未冷却", 0xFF0000);
				_actionSkillId = SkillDefineEnum.NO_SKILL;
				return;
			}
			
			GameManager.getInstance().autoAttack = true;
			
			_actionSkillId = skillId;
			_targetPoint   = null;
			
			if (skillVO.releaseType == SkillDefineEnum.TARGET_SINGLE_ENEMY || skillVO.releaseType == SkillDefineEnum.TARGET_HARMONY) {
				//移除目标
				var target : Avatar3D = GameManager.getInstance().actionAvatar;
				if (target && target.isDead) {
					GameManager.getInstance().actionAvatar = null;
				}
				//自动选择目标
				if (GameManager.getInstance().actionAvatar == null) {
					var dist  : Number = 5000;
					var lastM : Avatar3D = null;
					for each (var m : Avatar3D in WorldManager.instance.monsters) {
						if (m.isDead || m.godMode) {
							continue;
						}
						if (m.distanceToPos(_role.x, _role.z) < dist) {
							lastM = m;
							dist = m.distanceToPos(_role.x, _role.z);
						}
					}
					GameManager.getInstance().actionAvatar = lastM;
				}
			} else if (skillVO.releaseType == SkillDefineEnum.TARGET_AREA || skillVO.releaseType == SkillDefineEnum.TARGET_DIRECTION) {
				var mouseX : Number = Stage3DLayerManager.stage.mouseX;
				var mouseY : Number = Stage3DLayerManager.stage.mouseY;
				var playerHeight  : Number = _role.y;
				var rayCastPicker : RaycastPicker = Stage3DLayerManager.getView(0).mousePicker as RaycastPicker;
				var pickPosition  : Vector3D = rayCastPicker.getXZPlaneCollison(mouseX, mouseY, playerHeight, Stage3DLayerManager.getView(0));
				_targetPoint = new Point(pickPosition.x, pickPosition.z);
			}
		}
		
		private function tryUseSkill(skillId : int, targetId : int = 0) : Boolean {
			if (_role == null) {
				return false;
			}
			
			var stateController : PlayerStateController = GameManager.getInstance().stateController;
			if (stateController.castEnable() == false) {
				return false;
			}
			
			var skillVO : SkillDetailVO = SkillManager.getInstance().getSkillInfo(skillId);
			if (skillVO == null) {
				return false;
			}

			if (skillVO.cdRemain > 0) {
				return false;
			}
			
			stateController.stop();
			
			_role.stopWalk(false);
			
			stateController.stateCast.castTime = skillVO.situationTime; 	// 出招时间
			stateController.stateCast.castType = skillVO.castType; 			// 是否需要持续施法
			stateController.stateCasting.castingTime = skillVO.singTime; 	// 持续施法时间
			stateController.cast();

			var target : Avatar3D = GameManager.getInstance().actionAvatar;
			// 使用技能效果
			var obj : Object = {};
			
			if (_targetPoint) {
				obj.x = _targetPoint.x;
				obj.y = _targetPoint.y;
			} else {
				obj.x = 0;
				obj.y = 0;
			}

			var skillSeq  : uint = _role.skillController.tryCastSkill(skillVO, targetId, [targetId], [obj]);
			var skillBase : SkillBase = _role.skillController.getSkillBySeq(skillSeq);
			if (skillBase == null) {
				throw new Error("no skill : " + skillId);
				return false;
			}
			
			stateController.stateCastReady.skill = skillBase;
			//传入给模拟计算伤害
			var action : ServerSkillVO = new ServerSkillVO();
			action.casterId = _role.id;
			action.suffererId = targetId;
			action.x = obj.x;
			action.y = obj.y;
			action.seq = skillSeq;
			
			BattleSystemManager.getInstance().addAction(action, skillVO);
			//主角技能的cd
			skillVO.cdRemain = skillVO.skillAloneCd;
			return true;
		}

	}
}
