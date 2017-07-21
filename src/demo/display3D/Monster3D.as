package demo.display3D {

	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import demo.controller.MonsterAIController;
	import demo.controller.PlayerAnimationController;
	import demo.vo.Monster3DVO;


	/**
	 * @author 	chenbo
	 * @email  	470259651@qq.com
	 * @time	Mar 22, 2016 8:44:15 PM
	 */
	public class Monster3D extends Avatar3D {

		private var _aiCtrl   : MonsterAIController;
		private var _aiEnable : Boolean = true;
		
		public function Monster3D(vo : Monster3DVO) {
			super(vo);
			this.pickEnable = true;
			this.attackAble = true;
			this._aiCtrl    = new MonsterAIController(this, new Vector3D(vo.posX, 0, vo.posY));
		}

		public function get aiEnable() : Boolean {
			return _aiEnable;
		}

		public function set aiEnable(value : Boolean) : void {
			_aiEnable = value;
		}

		override public function run(gapTm : uint) : void {
			super.run(gapTm);
			if (_aiEnable) {
				_aiCtrl.update(getTimer(), gapTm);
			}
		}
		
		override public function get aiController() : MonsterAIController {
			return _aiCtrl;
		}

		public function enterIntro() : void {
			_aiCtrl.intro();
		}

		override public function notifyInterest(target : Avatar3D) : void {
			_aiCtrl.notifyInterest(target);
		}
		
		override protected function notifyEnemy() : void {
			var players : Vector.<Player3D> = _worldManager.players;
			for each (var player : Player3D in players) {
				player.notifyInterest(this);
			}
		}
		
		override public function stopWalk(executeIdleAction : Boolean = true) : void {
			super.stopWalk(true);
			_aiCtrl.onStopWalk();
		}
			
		override public function dispose() : void {
			if (_aiCtrl) {
				_aiCtrl = null;
			}
			super.dispose();

		}
		
	}
}
