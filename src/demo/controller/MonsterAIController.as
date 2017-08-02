package demo.controller {

	import flash.geom.Vector3D;
	
	import demo.ai.MonsterAIAttack;
	import demo.ai.MonsterAIBase;
	import demo.ai.MonsterAIIdle;
	import demo.ai.MonsterAILazy;
	import demo.ai.MonsterAIMoving;
	import demo.ai.MonsterAIPassBy;
	import demo.ai.MonsterAIStone;
	import demo.ai.MonsterAiIntro;
	import demo.display3D.Avatar3D;
	import demo.managers.BattleSystemManager;
	import demo.managers.SkillManager;
	import demo.skill.SkillDetailVO;
	import demo.vo.ServerSkillVO;
	
	/**
	 * 怪物AI控制器 
	 * @author chenbo
	 * 
	 */	
	public class MonsterAIController {
		
		private var _aiIdle 	: MonsterAIIdle;					// 闲置状态
		private var _aiMoving 	: MonsterAIMoving;					// 移动状态
		private var _aiAttack 	: MonsterAIAttack;					// 攻击状态
		private var _aiLazy 	: MonsterAILazy;					// 空闲状态
		private var _intro 		: MonsterAiIntro;					// intro?
		private var _passBy 	: MonsterAIPassBy;					// 巡逻状态
		private var _stone 		: MonsterAIStone;					// 石化状态
		private var _owner 		: Avatar3D;						// 所属者
		private var _oriPos 	: Vector3D;							// 出生点
		private var _currentAI 	: MonsterAIBase;					// 当前状态
		private var _lockTarget : Avatar3D;						// 目标
		
		public function MonsterAIController(Owner : Avatar3D, Pos : Vector3D) {
			this._owner 	= Owner;
			this._oriPos 	= Pos;
			this._aiIdle 	= new MonsterAIIdle(this);
			this._aiMoving 	= new MonsterAIMoving(this);
			this._aiAttack 	= new MonsterAIAttack(this);
			this._aiLazy 	= new MonsterAILazy(this);
			this._intro 	= new MonsterAiIntro(this);
			this._passBy 	= new MonsterAIPassBy(this);
			this._stone 	= new MonsterAIStone(this);
			this.idle();
		}
		
		/**
		 * 持有者 
		 * @return 
		 * 
		 */		
		public function get owner() : Avatar3D {
			return _owner;
		}

		/**
		 * 出生点 
		 * @return 
		 * 
		 */		
		public function get orgPos() : Vector3D {
			return _oriPos;
		}

		public function set lockTarget(avatar : Avatar3D) : void {
			_lockTarget = avatar;
		}
		
		/**
		 * 目标 
		 * @return 
		 * 
		 */		
		public function get lockTarget() : Avatar3D {
			return _lockTarget;
		}
		
		/**
		 * 闲置 
		 */		
		public function idle() : void {
			changeAI(_aiIdle);
		}
		
		/**
		 * ??? 
		 * 
		 */		
		public function intro() : void {
			changeAI(_intro);
		}
		
		/**
		 * 跟随 
		 * @param maxRange
		 * 
		 */		
		public function moveFollow(maxRange : int = 0) : void {
			changeAI(_aiMoving);
		}
		
		/**
		 * 攻击 
		 */		
		public function attack() : void {
			changeAI(_aiAttack);
		}
		
		/**
		 * 闲置 
		 */		
		public function lazy() : void {
			changeAI(_aiLazy);
		}

		/**
		 * 巡逻 
		 */		
		public function passBy() : void {
			changeAI(_passBy);
		}
		
		/**
		 * 石化 
		 */		
		public function stone() : void {
			changeAI(_stone);
		}
		
		/**
		 * 切换状态 
		 * @param ai
		 * 
		 */		
		private function changeAI(ai : MonsterAIBase) : void {
			if (_currentAI == ai) {
				return;
			}
			if (_currentAI) {
				_currentAI.leave();
			}
			_currentAI = ai;
			_currentAI.enter();
		}
		
		/**
		 * update 
		 * @param curTime		当前时间
		 * @param deltaTime		差值
		 * 
		 */		
		public function update(curTime : int, deltaTime : int) : void {
			_currentAI.update(curTime, deltaTime);
		}
		
		/**
		 * accept target 
		 * @param target
		 * 
		 */		
		public function notifyInterest(target : Avatar3D) : void {
			_currentAI.notifyInterest(target);
		}
		
		/**
		 *  停止移动
		 */		
		public function onStopWalk() : void {
			_currentAI.onStopWalk();
		}
		
		/**
		 * 使用技能 
		 * @param skillId		技能ID
		 * @param targetId		目标ID
		 * @param x				技能位置X
		 * @param y				技能位置Y
		 * 
		 */		
		public function useSkill(skillId : int, targetId : int, x : Number, y : Number) : void {
			
			var skillVO : SkillDetailVO = SkillManager.getInstance().getSkillInfo(skillId);
			
			if (skillVO == null || skillVO.cdRemain > 0) {
				return; // 技能不存在获取技能正在冷却当中
			}
			// 释放技能时，停止移动
			owner.stopWalk(false);
			
			var skillSeq : uint = owner.skillController.tryCastSkill(skillVO, targetId, [targetId], [{x:x, y:y}]); 
			var skillsVo : ServerSkillVO = new ServerSkillVO();
			skillsVo.x   = x;
			skillsVo.y   = y;
			skillsVo.seq = skillSeq;
			skillsVo.skillId    = skillId;
			skillsVo.casterId   = owner.id;
			skillsVo.suffererId = targetId;
			
			BattleSystemManager.getInstance().addAction(skillsVo, skillVO);
		}
		
	}
}
