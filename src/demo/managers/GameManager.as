package demo.managers {
	
	import com.game.engine3D.controller.CameraController;
	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.system.IME;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import demo.controller.PlayerActionController;
	import demo.controller.PlayerStateController;
	import demo.display3D.Avatar3D;
	import demo.display3D.Player3D;
	import demo.enum.RoleEnum;
	import demo.skill.SkillDetailVO;
	import demo.ui.UIPanel;
	
	import org.client.mainCore.utils.Tick;
	
	public class GameManager {
		
		/** 怪物上限 */
		public static var MAX_MONSTER_COUNT : int = 0;
		/** NPC上限 */
		public static var MAX_NPC_COUNT		: int = 0;
		
		/** 是否自动攻击 */
		public var autoAttack 		: Boolean;
		
		private var _inputEnable 	: Boolean = false;					// 是否启用键盘
		private var _actionAvatar 	: Avatar3D;						// 角色
		private var _overAvatar 	: Avatar3D;						// 角色
		private var _mainRole		: Player3D;						// 主角
		private var _playerCtrl 	: PlayerActionController;			// 控制器
		private var _stateCtrl 		: PlayerStateController;			// 状态机
		private var _targetPosition : Vector3D = new Vector3D();		// 目标点
		
		private var _startTime 		: Number = 0;
		private var _lastTime 		: int = -1;
		private var _curTime 		: Number = 0;
		private var _loopFrame 		: Boolean;
		
		// 单例模式
		private static var _instance : GameManager;
		
		public static function getInstance() : GameManager {
			_instance = _instance || new GameManager();
			return _instance;
		}
		
		public function GameManager() {
			if (_instance) {
				throw new Error("Sinlgeton");
			}
			_playerCtrl = new PlayerActionController();
			_stateCtrl  = new PlayerStateController();
		}
		
		public function get playerController() : PlayerActionController {
			return _playerCtrl;
		}
		
		public function get stateController()  : PlayerStateController {
			return _stateCtrl;
		}
		public function get mainRole() : Player3D {
			return _mainRole;
		}
		
		public function set mainRole(role : Player3D) : void {
			autoAttack = false;
			
			if (_mainRole == role) {
				return;
			}
			
			if (_mainRole) {
				_mainRole.isMainChar  = false;
				_mainRole.mouseEnable = false;
			}
			
			_mainRole = role;
			
			if (_mainRole) {
				_mainRole.isMainChar  = true;
				_mainRole.mouseEnable = false;
				_mainRole.mesh.entityGlass = true;
				if (_mainRole.weaponMesh) {
					_mainRole.weaponMesh.entityGlass = true;
				}
			}
			
			actionAvatar = null;
			
			_playerCtrl.initRole(_mainRole);
			_stateCtrl.initRole(_mainRole);
			
			if (_mainRole) {
				configSkill(_mainRole.playerType);
			}
			
			var gs3d : GameScene3D = WorldManager.instance.gameScene3D;
			gs3d.mainChar = role;
		}
		
		public function configSkill(playerType : int) : void {
			
			UIPanel.instance.skillBar.clear();
			var skillIds   : Vector.<int> = SkillManager.getInstance().copySkillIdsByRole(playerType);
			var skillIndex : int = 0;
			for each (var skillId : int in skillIds) {
				var skillInfo  : SkillDetailVO = SkillManager.getInstance().getSkillInfo(skillId);
				if (skillInfo) {
					UIPanel.instance.skillBar.addSkillCdIcon(skillInfo, (skillIndex + 1).toString());
					skillIndex++;
				}
			}
			UIPanel.instance.skillBar.updatePos();
		}
		
		public function set overAvatar(avatar : Avatar3D) : void {
			if (_overAvatar && _overAvatar != avatar) {
				_overAvatar.overSelected = false;
			} else if (avatar) {
				avatar.overSelected = true;
			}
			_overAvatar = avatar;
		}
		
		public function get overAvatar() : Avatar3D {
			return _overAvatar;
		}
		
		public function set actionAvatar(avatar : Avatar3D) : void {
			_actionAvatar = avatar;
			autoAttack    = _actionAvatar && _actionAvatar.isDead == false && _actionAvatar.attackAble;
		}
		
		public function get actionAvatar() : Avatar3D {
			return _actionAvatar;
		}
		
		public function get inputEnable() : Boolean {
			return _inputEnable;
		}
		
		/**
		 * 是否启用键盘 
		 * @param value
		 * 
		 */		
		public function set inputEnable(value : Boolean) : void {
			IME.enabled = !value;
			
			if (_inputEnable == value) {
				return;
			}
			
			_inputEnable = value;
			if (_inputEnable) {
				Stage3DLayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, 		keyDownHandler);
				Stage3DLayerManager.stage.addEventListener(KeyboardEvent.KEY_UP, 		keyUpHandler);
			} else {
				Stage3DLayerManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, 	keyDownHandler);
				Stage3DLayerManager.stage.removeEventListener(KeyboardEvent.KEY_UP, 	keyUpHandler);
			}
		}
		
		/**
		 * key 
		 * @param e
		 * 
		 */		
		private function keyDownHandler(e : KeyboardEvent) : void {
			var manager : GameManager = GameManager.getInstance();
			switch (e.keyCode) {
				case Keyboard.W:
				case Keyboard.UP:
					manager.playerController.walkForward();
					e.stopImmediatePropagation();
					break;
				case Keyboard.S:
				case Keyboard.DOWN:
					manager.playerController.walkBackward();
					e.stopImmediatePropagation();
					break;
				case Keyboard.A:
				case Keyboard.LEFT:
					manager.playerController.walkLeft();
					e.stopImmediatePropagation();
					break;
				case Keyboard.D:
				case Keyboard.RIGHT:
					manager.playerController.walkRight();
					e.stopImmediatePropagation();
					break;
				default:
					break;
			}
		}
		
		/**
		 * key 
		 * @param e
		 * 
		 */		
		private function keyUpHandler(e : KeyboardEvent) : void {
			var gm : GameManager = GameManager.getInstance();
			var sv : SkillDetailVO = null;
			var sm : SkillManager = SkillManager.getInstance();
			
			switch (e.keyCode) {
				case Keyboard.W:
				case Keyboard.UP:
					gm.playerController.walkForward(false);
					e.stopImmediatePropagation();
					break;
				case Keyboard.S:
				case Keyboard.DOWN:
					gm.playerController.walkBackward(false);
					e.stopImmediatePropagation();
					break;
				case Keyboard.A:
				case Keyboard.LEFT:
					gm.playerController.walkLeft(false);
					e.stopImmediatePropagation();
					break;
				case Keyboard.D:
				case Keyboard.RIGHT:
					gm.playerController.walkRight(false);
					e.stopImmediatePropagation();
					break;
				case Keyboard.NUMBER_1:
					sv = sm.getSkillAtIndex(0);
					break;
				case Keyboard.NUMBER_2:
					sv = sm.getSkillAtIndex(1);
					break;
				case Keyboard.NUMBER_3:
					sv = sm.getSkillAtIndex(2);
					break;
				case Keyboard.NUMBER_4:
					sv = sm.getSkillAtIndex(3);
					break;
				case Keyboard.NUMBER_5:
					sv = sm.getSkillAtIndex(4);
					break;
				case Keyboard.P:
					if (_mainRole) {
						trace(int(_mainRole.x), int(_mainRole.z));
						trace(_mainRole.x + "," + _mainRole.y + "," + _mainRole.z + "|" + +_mainRole.rotationX + "," + _mainRole.rotationY + "," + _mainRole.rotationZ);
					}
					break;
			}
			if (sv) {
				playerController.onSkillOpearate(sv.clientId);
			}
		}
		
		/**
		 * 切换主角 
		 */		
		public function changeMyRole() : void {
			if (!_mainRole) {
				return;
			}
			var rList : Array = [RoleEnum.ROLE_QSMY, RoleEnum.ROLE_TIAN_DAO];
			var index : int = rList.indexOf(_mainRole.playerType) + 1;
			if (index >= rList.length) {
				index = 0;
			}
			_mainRole.changeRole(rList[index]);
			configSkill(rList[index]);
		}
		
		public function get loopFrame() : Boolean {
			return _loopFrame;
		}
		
		public function set loopFrame(value : Boolean) : void {
			_loopFrame = value;
		}
		
		/**
		 * 鼠标点击了角色
		 * @param avatar
		 * 
		 */		
		public function onAvatarClicked(avatar : Avatar3D) : void {
			actionAvatar = avatar;
			WorldManager.instance.hideMouseClickEffect();
			if (avatar) {
				_playerCtrl.onAvatarClicked(avatar);
			}
		}
		
		/**
		 * 鼠标点击了场景 
		 * @param pos3d
		 * 
		 */		
		public function onSceneClicked(pos3d : Vector3D) : void {
			_targetPosition.copyFrom(pos3d);
			
			var world : WorldManager = WorldManager.instance;
			
			var dx : Number = CameraController.lockedOnPlayerController.mouseDownPosition.x - Stage3DLayerManager.stage.mouseX;
			var dy : Number = CameraController.lockedOnPlayerController.mouseDownPosition.y - Stage3DLayerManager.stage.mouseY;
			
			if (mainRole) {
				autoAttack = false;
				if (mainRole.walkTo(_targetPosition)) {
					world.showMouseClickEffect(pos3d);
					_playerCtrl.setNextPosition(null);
				} else if (world.district && world.district.isPointInSide(pos3d, 10)) {
					_playerCtrl.setNextPosition(_targetPosition);
				} else {
					_playerCtrl.setNextPosition(null);
				}
			}
		}
		
		/**
		 *  开始更新
		 */		
		public function update(gap : int = 0) : void {
			var deltaTime : int = 17;
			if (_lastTime == -1) {
				_startTime = new Date().time;
				_lastTime = 0;
			} else {
				var nowTime : Number = new Date().time - _startTime;
				deltaTime = nowTime - _lastTime;
				_lastTime = nowTime;
			}
			
			//deltaTime /= 3;
			
			WorldManager.instance.update(_lastTime, deltaTime);
			SkillManager.getInstance().update(_lastTime, deltaTime);
			BattleSystemManager.getInstance().update(_lastTime, deltaTime);
			ParticleManager.getInstance().update(_lastTime, deltaTime);
			
			_playerCtrl.update(_lastTime, deltaTime);
			_stateCtrl.update(_lastTime, deltaTime);
		}
		
		/**
		 * start update
		 */		
		public function start() : void {
			Tick.addCallback(update);
		}
		
		/**
		 *  stop update
		 */		
		public function stop() : void {
			Tick.removeCallback(update);	
		}
		
		public function nextScene():void {
						
		}
	}
}
