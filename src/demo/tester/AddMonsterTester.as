package demo.tester {

	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Monster3D;
	import demo.display3D.Avatar3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.GameManager;
	import demo.managers.WorldManager;
	import demo.vo.Monster3DVO;

	public class AddMonsterTester {
		private var _stage : Stage;


		private var _x : int;
		private var _y : int;
		private var _angle : int = -90;
		private var _monster : Monster3D;

		public function AddMonsterTester() {
			_stage = Stage3DLayerManager.stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onKeyDown(e : KeyboardEvent) : void {

//			var me : Avatar3D = GameManager.getInstance().mainPlayer;
			var me : demo.display3D.Avatar3D = GameManager.getInstance().mainRole;

			if (me == null)
				return;


			var world : WorldManager = WorldManager.instance;

			if (e.keyCode == Keyboard.PAGE_UP) {
				if (_monster == null) {
					_monster = addMonster(0, "狮王", "../assets/monsters/lion/lion.awd", me.x, me.y, SkillDefineEnum.MONSTER_NORMAL_ATTACK, 14)
					_monster = null;
				}
			}
		}

		private function addMonster(id : int, name : String, url : String, posX : int, posY : int, skillId : int, speed : int) : Monster3D {
			var monsterVO : Monster3DVO = new Monster3DVO();
			monsterVO.skillId = skillId;
			monsterVO.id = id;
			monsterVO.name = name;
			monsterVO.url = url;
			monsterVO.walkVelocity = speed;
			monsterVO.posX = posX;
			monsterVO.posY = posY;
			
			var monster3D : Monster3D = new Monster3D(monsterVO);
			WorldManager.instance.addMonster(monster3D);
			return monster3D;
		}

	}
}

