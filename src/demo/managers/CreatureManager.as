package demo.managers {

	import com.game.engine3D.config.GlobalConfig;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.setInterval;
	
	import away3d.core.math.Matrix3DUtils;
	import away3d.pathFinding.DistrictWithPath;
	
	import demo.display3D.Monster3D;
	import demo.display3D.Player3D;
	import demo.display3D.Avatar3D;
	import demo.enum.IDEnum;
	import demo.enum.RoleEnum;
	import demo.enum.SkillDefineEnum;
	import demo.skill.magic.MagicBase;
	import demo.skill.magic.MagicData;
	import demo.vo.Monster3DVO;
	import demo.vo.Player3DVO;
	
	/**
	 * 角色创建器 
	 * @author chenbo
	 * 
	 */	
	public class CreatureManager {
		
		private var _world 			: WorldManager;													// world
		private var _district 		: DistrictWithPath;												// navmesh
		private var _mainRole		: Player3D;													// 主角
		private var _vector 		: Vector3D = new Vector3D();									// temp vector
		private var _point 			: Point = new Point();											// temp point
		private var _looping 		: Boolean;														// loop
		private var _avatarList 	: Vector.<String> = new Vector.<String>();						// 角色列表
		private var _recycleAvatars : Vector.<Avatar3D> = new Vector.<Avatar3D>();
		
		private static var _instance : CreatureManager;
		
		/**
		 * 实例 
		 * @return 
		 * 
		 */		
		public static function getInstance() : CreatureManager {
			_instance = _instance || new CreatureManager();
			return _instance;
		}

		public function CreatureManager() {
			if (_instance) {
				throw new Error("Singleton");
			}
			_avatarList.push("monsters/char/dongxueguifu/an_npc_monster_001.awd");
			_avatarList.push("monsters/char/jiangshizhanshi/an_npc_monster_003.awd");
			_avatarList.push("monsters/char/jibing/an_npc_monster_002.awd");
			_avatarList.push("monsters/char/jushexi/an_npc_monster_004.awd");
			_avatarList.push("monsters/char/nanyouxia/an_suit_arch1_001.awd");
			_avatarList.push("monsters/char/nvqishi/an_suit_arch2_001.awd");
			_avatarList.push("monsters/char/nvyouxia/an_suit_arch2_002.awd");
			_avatarList.push("monsters/char/bosstujiu/an_npc_boss_001.awd");

			setInterval(onInterval, 500);
		}
		
		private function onInterval() : void {
			if (_looping == false) {
				return;
			}
			//加怪
			var monCount : int = GameManager.MAX_MONSTER_COUNT - _world.monsters.length;
			var npcCount : int = GameManager.MAX_NPC_COUNT - _world.players.length;
			npcCount = 0;
			
			if (monCount > 0) {
				creatRandomMonster(1);
				monCount--;
				if (Math.random() > 0.9 && monCount > 0) {
					createDragon();
					monCount--;
				}
				if (Math.random() > 0.8 && monCount > 0) {
					createLions();
					monCount--;
				}
				if (Math.random() > 0.7 && monCount > 0) {
					createDarkWarrior();
					monCount--;
				}
			}
			
			if (npcCount > 0) {
				if (GameManager.MAX_MONSTER_COUNT > 1) {
					createPassBy(1);
				}
			}
			
			//移除怪物.
			_recycleAvatars.length = 0;
			var avatar : Avatar3D = null;
			
			for each (avatar in _world.players) {
				if (avatar == _mainRole) {
					continue;
				}
				if (avatar.distanceToPos(_mainRole.x, _mainRole.z) > 5000) {
					_recycleAvatars.push(avatar);
					continue;
				}
				if (avatar.deadRecycleEnable) {
					_recycleAvatars.push(avatar);
					continue;
				}
			}
			
			for each (avatar in _world.monsters) {
				if (avatar.distanceToPos(_mainRole.x, _mainRole.z) > 5000) {
					_recycleAvatars.push(avatar);
					continue;
				}
				if (avatar.deadRecycleEnable) {
					_recycleAvatars.push(avatar);
					continue;
				}
			}
			
			for each (avatar in _recycleAvatars) {
				_world.disposeAvatar(avatar);
			}
			_recycleAvatars.length = 0;
			
		}
		
		public function set loop(value : Boolean) : void {
			_looping = value;
		}
		
		public function createMyPlayer(x : int, z : int, type : int) : void {
			_world 	  = WorldManager.instance;
			_district = _world.district;
			_mainRole = _world.createMainRole(IDEnum.nextID, x, z, type);
		}
			
		public function createJumpPort() : void {
			var port : MagicBase = MagicBase.CreateMagic(IDEnum.nextID, 0, MagicData.JumpPort, 0, 2312, 11749);
			WorldManager.instance.addOperator(port);
		}
		
		/**
		 * 校验坐标点 
		 * @param pos
		 * @return 		True:成功 | False:失败
		 * 
		 */		
		private function isAvailablePosition(pos : Vector3D) : Boolean {
			if (_district == null) {
				return false;
			}
			var pos3d : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
			pos3d.x = pos.x;
			pos3d.y = 0;
			pos3d.z = pos.z;
			return _district.isPointInSide(pos3d, WorldManager.instance.district.pixelToTerrainSize * 2);
		}
		
		/**
		 * 搜寻一个正确的坐标点 
		 * @param x		起始X坐标
		 * @param y		起始Y坐标
		 * @param d		搜寻范围
		 * 
		 */
		private function getAvailablePosition(x : Number, y : Number, d : Number = 3000) : void {
			var maxTry : int = 100;
			while (true) {
				_vector.setTo(Math.random() - 0.5, 0, Math.random() - 0.5);
				_vector.scaleBy(2 * d);
				_vector.setTo(x + _vector.x, 0, y + _vector.z);
				if (isAvailablePosition(_vector)) {
					break;
				}
				maxTry--;
				if (maxTry <= 0) {
					return;
				}
			}
		}
		
		/**
		 * 创建一个怪物 
		 * @param count
		 * 
		 */		
		private function creatRandomMonster(count : int) : void {
			
			getAvailablePosition(_mainRole.x, _mainRole.z);
			
			for (var i:int = 0; i < count; i++) {
				
				var randomAvatar : Boolean = Math.random() > 0.2;
				var avatarUrl	 : String = randomAvatar ? ("../assets/" + _avatarList[int(_avatarList.length * Math.random())]) : "../assets/monsters/monster1/monster1.awd";
				var rangeMonster : Boolean = (randomAvatar == false && Math.random() > 0.5);
				
				var skillId : int = rangeMonster ? SkillDefineEnum.MONSTER_SKILL_1 : SkillDefineEnum.MONSTER_NORMAL_ATTACK;
				skillId = randomAvatar ? SkillDefineEnum.MONSTER_SKILL_2 : skillId;

				var avatar3D : Monster3D = addMonster("怪", avatarUrl, skillId, 8, _vector.x, _vector.z);
				avatar3D.hp = avatar3D.maxHp = 200 + Math.random() * 200;
				avatar3D.lazyRepeatCount = 2;
				avatar3D.lazyStayMiliSec = 1500;
				avatar3D.lazyRandom = 0.2;
								
				if (avatarUrl.search("an_npc_boss_001") >= 0) {
					avatar3D.setScale(1);
				} else {
					avatar3D.setScale(randomAvatar ? 2 : 3);
				}
				
				if (rangeMonster) {
					avatar3D.distanceFindEnemy += 600;
					avatar3D.distanceMaxAttack += 600;
					avatar3D.distanceMinAttack += 600;
				}
				
			}
		}
		
		/**
		 *  创建狮子...
		 */		
		private function createLions() : void {
			
			getAvailablePosition(_mainRole.x, _mainRole.z);
			
			var avatar3D : Monster3D = addMonster("狮王", "../assets/monsters/lion/lion.awd", SkillDefineEnum.SKILL_LION_SKILL_1, 14, _vector.x, _vector.z);
			avatar3D.setScale(3);
			avatar3D.distanceFindEnemy += 400;
			avatar3D.distanceMaxAttack += 100;
			avatar3D.distanceMinFollow += 100;
			avatar3D.lazyRepeatCount = 1;
			avatar3D.lazyStayMiliSec = 600;
			avatar3D.lazyRandom = 0.1;
			avatar3D.grayScaleRadom = 0.3;
			avatar3D.hp = avatar3D.maxHp = 6000;
			
			getAvailablePosition(_mainRole.x, _mainRole.z);
			avatar3D = addMonster("狮王", "../assets/monsters/lion01/lion01.awd", SkillDefineEnum.SKILL_LION_SKILL_1, 14, _vector.x, _vector.z);
			avatar3D.setScale(3);
			avatar3D.distanceFindEnemy += 400;
			avatar3D.distanceMaxAttack += 100;
			avatar3D.distanceMinFollow += 100;
			avatar3D.lazyRepeatCount = 1;
			avatar3D.lazyStayMiliSec = 600;
			avatar3D.lazyRandom = 0.1;
			avatar3D.grayScaleRadom = 0.3;
			avatar3D.hp = avatar3D.maxHp = 6000;
		}
		
		private function createDarkWarrior() : void {
			getAvailablePosition(_mainRole.x, _mainRole.z);
			var avatar3D : Monster3D = addMonster("黑暗战士", "../assets/monsters/darkwarrior/darkwarrior.awd", SkillDefineEnum.MONSTER_NORMAL_ATTACK, 14, _vector.x, _vector.z);
			avatar3D.setScale(3);
			avatar3D.distanceFindEnemy += 800;
			avatar3D.distanceMaxAttack += 100;
			avatar3D.lazyRepeatCount = 1;
			avatar3D.lazyStayMiliSec = 600;
			avatar3D.lazyRandom = 0.1;
			avatar3D.grayScaleRadom = 0.4;
			avatar3D.hp = avatar3D.maxHp = 10000;
		}
		
		private function createPassBy(count : int) : void {
			var avatar3D : Avatar3D = null;
			var pbList   : Vector.<Point> = new Vector.<Point>();
			var pos 	 : Vector3D = null;
			var point 	 : Point = null;
			var i 		 : int = 0;
			//巡逻点
			for (i = 0; i < 6; i++) {
				getAvailablePosition(_mainRole.x, _mainRole.z);
				point = new Point();
				point.setTo(_vector.x, _vector.z);
				pbList.push(point);
			}
			//巡逻的人
			var posList : Vector.<Vector3D> = new Vector.<Vector3D>();
			for (i = 0; i < count; i++) {
				getAvailablePosition(_mainRole.x, _mainRole.z);
				pos = new Vector3D();
				pos.copyFrom(_vector);
				posList.push(pos);
			}
			
			for (i = 0; i < count; i++) {
				pos = posList[int(posList.length * Math.random())];
				var playerVO : Player3DVO = new Player3DVO();
				playerVO.id = IDEnum.nextID;
				playerVO.playerType = RoleEnum.ROLE_QSMY;
				playerVO.walkVelocity = 12;
				playerVO.posX = pos.x;
				playerVO.posY = pos.z;
				playerVO.walkVelocity = 6;
				playerVO.skillId = SkillDefineEnum.PLAYER_NORMAL_ATTACK;

				var player3D : Player3D = new Player3D(playerVO);
				player3D.lazyRepeatCount = 1;
				player3D.lazyStayMiliSec = 600;
				player3D.lazyRandom = 0.05;
				player3D.hp = player3D.maxHp = 20000;
				player3D.passByPosList = Math.random() > 0.6 ? pbList : null;
				player3D.isNpc = true;
				WorldManager.instance.addPlayer(player3D);
			}
			
		}
		
		private function createDragon() : void {
			getAvailablePosition(_mainRole.x, _mainRole.z);
			
			var avatar3D : Monster3D = addMonster("冰龙", "../assets/monsters/dragon/boss.awd", SkillDefineEnum.SKILL_DRAGON_SKILL_1, 14, _vector.x, _vector.z);
			avatar3D.setScale(12);
			avatar3D.vo.skillId2 = SkillDefineEnum.SKILL_DRAGON_SKILL_3;
			avatar3D.lazyRepeatCount = 1;
			avatar3D.lazyStayMiliSec = 600;
			avatar3D.lazyRandom = 0.1;
			avatar3D.grayScaleRadom = 0.4;
			avatar3D.hp = avatar3D.maxHp = 10000;
			avatar3D.distanceFindEnemy += 400;
			avatar3D.distanceMaxAttack += 100;
			avatar3D.distanceMinFollow += 100;
			avatar3D.godMode = true;
			avatar3D.enterIntro();
		}
		
		private function addPlayer(name : String, url : String, skillId : int, speed : int, posX : int, posY : int) : Player3D {
			var playerVO : Player3DVO = new Player3DVO();
			playerVO.skillId = skillId;
			playerVO.id = IDEnum.nextID;
			playerVO.name = name;
			playerVO.url = url;
			playerVO.walkVelocity = speed;
			playerVO.posX = posX;
			playerVO.posY = posY;
			var player3D : Player3D = new Player3D(playerVO);
			WorldManager.instance.addPlayer(player3D);
			return player3D;
		}
		
		private function addMonster(name : String, url : String, skillId : int, speed : int, posX : int, posY : int) : Monster3D {
			var monsterVO : Monster3DVO = new Monster3DVO();
			monsterVO.skillId = skillId;
			monsterVO.id = IDEnum.nextID;
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
