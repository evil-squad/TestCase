package demo.display3D {

	import flash.geom.Vector3D;
	
	import demo.controller.MonsterAIController;
	import demo.controller.PlayerAnimationController;
	import demo.path.ModelRolePath;
	import demo.vo.Player3DVO;


	/**
	 * @author 	chenbo
	 * @email  	470259651@qq.com
	 * @time	Mar 23, 2016 9:43:28 AM
	 */
	public class Player3D extends Avatar3D {

		private var _isNpc 		: Boolean;
		private var _aiCtrl 	: MonsterAIController;
		private var _playerType : int;
		private var _loadCompleteCallBack:Function;
		
		public function Player3D(vo : Player3DVO,loadCompleteCallBack:Function = null) {
			super(vo);
			hp = maxHp = 1000000;
			pickEnable = false;
			playerType = vo.playerType;
			_loadCompleteCallBack = loadCompleteCallBack;
		}

		public function changeRole(type : int) : void {
			if (type == _playerType) {
				return;
			}
			_animationCtrl.dispose();
			playerType = type;
			reLoadResource();
		}
		
		public function get isNpc() : Boolean {
			return _isNpc;
		}

		public function set isNpc(value : Boolean) : void {
			pickEnable = isMainChar == false && value == false;

			if (isMainChar) {
				return;
			}
			_isNpc = value;

			if (_isNpc) {
				if (_aiCtrl == null) {
					_aiCtrl = new MonsterAIController(this, new Vector3D(vo.posX, 0, vo.posY));

					if (passByPosList) {
						_aiCtrl.passBy();
					}
				}
			} else if (_isNpc == false) {
				_aiCtrl = null;
			}
		}

		override public function get aiController() : MonsterAIController {
			return _aiCtrl;
		}

		override protected function notifyEnemy() : void {
			var monsters : Vector.<Monster3D> = _worldManager.monsters;
			for each (var monster : Monster3D in monsters) {
				monster.notifyInterest(this);
			}
		}

		override protected function initShowContainer() : void {
			
			super.initShowContainer();
			if(_loadCompleteCallBack != null)
				_loadCompleteCallBack();
		}
		
		override public function notifyInterest(target : Avatar3D) : void {
			if (_aiCtrl) {
				_aiCtrl.notifyInterest(target);
			}
		}

		override public function stopWalk(executeIdleAction : Boolean = true) : void {
			if(_animationCtrl.currentAnimation() == PlayerAnimationController.SEQ_RUN || _animationCtrl.currentAnimation() == PlayerAnimationController.SEQ_WALK)
			{
				super.stopWalk(true);
				if (_aiCtrl) {
					_aiCtrl.onStopWalk();
				}
			}
		}

		override public function dispose() : void {
			if (_aiCtrl) {
				_aiCtrl = null;
			}
			super.dispose();
		}
		
		public function get playerType() : int {
			return (vo as Player3DVO).playerType;
		}

		public function set playerType(value : int) : void {
			(vo as Player3DVO).playerType = value;
			setScale(ModelRolePath.instance.getRoleScale(value));
		}
		
	}
}
