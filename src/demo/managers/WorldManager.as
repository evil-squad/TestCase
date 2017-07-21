package demo.managers {

	import com.game.engine3D.core.GameScene3D;
	import com.game.engine3D.manager.GameScene3DManager;
	import com.game.engine3D.manager.Stage3DLayerManager;
	import com.game.engine3D.vo.BaseObj3D;
	
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Vector3D;
	import flash.system.System;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.pathFinding.DistrictWithPath;
	
	import demo.adapter.SceneAdapterManager;
	import demo.display3D.Avatar3D;
	import demo.display3D.Monster3D;
	import demo.display3D.Operator3D;
	import demo.display3D.Particle3D;
	import demo.display3D.Player3D;
	import demo.enum.SkillDefineEnum;
	import demo.path.vo.SceneConfig;
	import demo.path.vo.SceneData;
	import demo.skill.magic.MagicBase;
	import demo.ui.UIPanel;
	import demo.vo.Monster3DVO;
	import demo.vo.Player3DVO;


	public class WorldManager {
		
		private static var _instance: WorldManager;										// singleton
		
		public var centerObject		  : ObjectContainer3D = new ObjectContainer3D();		// 
		private var _mouseClickEffect: Particle3D;											// 鼠标点击特效
		private var _gameScene3D	  : GameScene3D;										// 游戏场景
		private var _gameManager 	  : GameManager;										// 游戏管理器	
		private var _players 		  : Vector.<Player3D>  = new Vector.<Player3D>();		// 玩家列表
		private var _monsters 		  : Vector.<Monster3D> = new Vector.<Monster3D>();		// 怪物列表
		private var _operators 	      : Vector.<Operator3D>  = new Vector.<Operator3D>();	// ???????
		private var _sceneConfig     : SceneConfig;										//场景配置
		private var _sceneID         : int = 0;
		private var _roleType        : int = 0;
		
		/**
		 * single ton 
		 * @return
		 */		
		public static function get instance() : WorldManager {
			if (_instance == null) {
				_instance = new WorldManager();
			}
			return _instance;
		}
		
		public function WorldManager() {
			if (_instance) {
				throw new Error("single ton");
			}			
			
			_gameManager 	  = GameManager.getInstance();
			_mouseClickEffect = ParticleManager.getInstance().getParticle("../assets/effect/mouse/01.awd", null, onLoadMouseClickEffect);
			_mouseClickEffect.setMyScale(0.5);
		}
		
		public function get currentSceneData() : SceneData {
			return _sceneConfig.getSceneByID(_sceneID);
		}
		
		/**
		 * 鼠标点击特效载入完成
		 * @param p
		 * 
		 */		
		private function onLoadMouseClickEffect(p : Particle3D) : void {
			var container : ObjectContainer3D = (_mouseClickEffect.particle as ObjectContainer3D);
			for (var i : int = 0; i < container.numChildren; i++) {
				var mesh : Mesh = container.getChildAt(i) as Mesh;
				if (mesh) {
					mesh.material.depthCompareMode = Context3DCompareMode.ALWAYS;
				}
			}
		}
		
		/**
		 * current game scene 
		 * @return 
		 * 
		 */		
		public function get gameScene3D():GameScene3D {
			return _gameScene3D;
		}
		
		public function get sceneConfig():SceneConfig {
			return _sceneConfig;
		}
		
		public function set sceneConfig(value:SceneConfig):void {
			_sceneConfig = value;
		}
		
		/**
		 * 添加一个AI 
		 * @param withAi
		 * 
		 */				
		public function addTestMonsters(withAi : Boolean = true) : void {
			var me : Avatar3D = GameManager.getInstance().mainRole;
			if (!me) {
				return;
			}
			var TestMonsterID : uint = 10000;
			var myX : Number = me.x;
			var myY : Number = me.z;
			for (var i : int = 0; i < 4; i++) {
				for (var j : int = 0; j < 5; j++) {
					var avatar3D : Monster3D = createMonster(++TestMonsterID, "鹿杖客", "../assets/monsters/monster1/monster1.awd", myX - (i - 1.5) * 200, myY + (j - 2) * 200, SkillDefineEnum.MONSTER_NORMAL_ATTACK, 8);
					avatar3D.hp    = 300;
					avatar3D.maxHp = 300;
					avatar3D.setScale(3);
					avatar3D.aiEnable   = withAi;
					avatar3D.lazyRandom = 0.2;
					avatar3D.lazyStayMiliSec = 1500;
					avatar3D.lazyRepeatCount = 2;
				}
			}
			
			function createMonster(id : int, name : String, url : String, posX : int, posY : int, skillId : int, speed : int) : Monster3D {
				var monsterVO : Monster3DVO = new Monster3DVO();
				monsterVO.skillId = skillId;
				monsterVO.id 	  = id;
				monsterVO.name 	  = name;
				monsterVO.url 	  = url;
				monsterVO.posX 	  = posX;
				monsterVO.posY 	  = posY;
				monsterVO.walkVelocity = speed;
				var monster3D : Monster3D = new Monster3D(monsterVO);
				WorldManager.instance.addMonster(monster3D);
				return monster3D;
			}
		}
		
		/**
		 * 查询地表高度	 
		 * @param x		x轴坐标
		 * @param z		z轴坐标
		 * @return 		地表高度
		 * 
		 */		
		public function queryHeightAt(x : Number, z : Number) : Number {
			if (_gameScene3D) {
				return _gameScene3D.sceneMapLayer.queryHeightAt(x, z) + 2.5;
			} else {
				return 0;
			}
		}
		
		/**
		 * 怪物列表 
		 * @return 
		 * 
		 */		
		public function get monsters() : Vector.<Monster3D> {
			return _monsters;
		}
		
		/**
		 * 玩家列表 
		 * @return 
		 * 
		 */		
		public function get players() : Vector.<Player3D> {
			return _players;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get operators() : Vector.<Operator3D> {
			return _operators;
		}

		/**
		 * navmesh 
		 * @return navmesh导航
		 * 
		 */		
		public function get district() : DistrictWithPath {
			if (!_gameScene3D) {
				return null;
			}
			return _gameScene3D.sceneMapLayer.district;
		}

		/**
		 * 进入地图 
		 * @param mapURL				地图路径
		 * @param mapName				地图名称
		 * @param completeHandler		载入完成回调
		 * 
		 */		
		public function enterMap() : void  {
			// 清除场景
			this.clearScene();
			var sd : SceneData = _sceneConfig.getSceneByID(_sceneID);
			// 载入场景
			this._gameScene3D = GameScene3DManager.createScene(sd.path, Stage3DLayerManager.getView(), 4000, 0);
			this._gameScene3D.disableShadowLevel = sd.shadowLevel.enable;
			this._gameScene3D.switchScene(sd.path, SceneAdapterManager.instance.current.onSceneLoadComplete);
			
			SceneAdapterManager.instance.current.onEnterMap(_sceneID, _gameScene3D);
		}
		
		/**
		 *  清除场景
		 */		
		private function clearScene() : void {
			
			SceneAdapterManager.instance.current.onClearScene();
			
			this.hideMouseClickEffect();
			
			this._gameManager.loopFrame  = false;
			this._gameManager.mainRole   = null;
			this._gameManager.overAvatar = null;
			// 重置战斗系统以及回收所有特效
			BattleSystemManager.getInstance().reset();
			ParticleManager.getInstance().recycleAllAutoParticle();
			
			var avatar : Avatar3D = null;
			for each (avatar in _monsters) {
				avatar.dispose();
			}
			_monsters.length = 0;
			
			for each (avatar in _players) {
				avatar.dispose();
			}
			_players.length = 0;
			
			while (_operators.length > 0) {
				var operator : Operator3D = _operators[0];
				var magic    : MagicBase  = operator as MagicBase;
				if (magic) {
					MagicBase.RecycleMagic(magic);
				}
				removeOperator(operator);
			}
			
			if (_gameScene3D) {
				GameScene3DManager.removeScene(_gameScene3D.sceneName);
			}
			
			System.pauseForGCIfCollectionImminent(0);
			System.gc();
		}
				
		/**
		 * 获取Avatar3D 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getAvatar3D(id : int) : Avatar3D {
			var avatar : Avatar3D = null;
			for each (avatar in _monsters) {
				if (avatar.id == id) {
					return avatar;
				}
			}
			for each (avatar in _players) {
				if (avatar.id == id) {
					return avatar;
				}
			}
			return null;
		}
		
		/**
		 * 添加一个角色
		 * @param o
		 * 
		 */		
		public function addObject(o : ObjectContainer3D) : void {
			if (_gameScene3D) {
				_gameScene3D.sceneRenderLayer.addChild(o);
			}
		}
		
		/**
		 * 移除一个角色
		 * @param o
		 * 
		 */		
		public function removeObject(o : ObjectContainer3D) : void {
			if (o && o.parent) {
				o.parent.removeChild(o);
			}
		}
				
		public function addOperator(operator : Operator3D) : void {
			if (_operators.indexOf(operator) >= 0) {
				return;
			}
			_operators.push(operator);
			addSceneObjToScene(operator, true, true, true);
		}

		public function removeOperator(operator : Operator3D) : void {
			var idx : int = _operators.indexOf(operator);
			if (idx == -1) {
				return;
			}
			_operators.splice(idx, 1);
			removeSceneObj(operator);
		}

		/**
		 * 添加一个怪物 
		 * @param monster3D
		 * 
		 */		
		public function addMonster(monster3D : Monster3D) : void {
			if (_monsters.indexOf(monster3D) >= 0) {
				return;
			}
			_monsters.push(monster3D);
			addSceneObjToScene(monster3D, true, true, true);
		}
		
		/**
		 * 添加一个玩家 
		 * @param player3D
		 * 
		 */		
		public function addPlayer(player3D : Player3D) : void {
			if (_players.indexOf(player3D) >= 0) {
				return;
			}
			_players.push(player3D);
			addSceneObjToScene(player3D, true, true, true);
		}
		
		public function removePlayer(player : Player3D) : void {
			var idx : int = _players.indexOf(player);
			if (idx == -1) {
				return;
			}
			_players.splice(idx, 1);
			removeSceneObj(player);
		}
		
		public function removeMonster(monster : Monster3D) : void {
			var idx : int = _monsters.indexOf(monster);
			if (idx == -1) {
				return;
			}
			_monsters.splice(idx, 1);
			removeSceneObj(monster);
		}

		public function disposeAvatar(avatar : Avatar3D) : void {
			var player : Player3D  = avatar as Player3D;
			if (player) {
				removePlayer(player);
				player.dispose();
			}
			var monstr : Monster3D = avatar as Monster3D;
			if (monstr) {
				removeMonster(monstr);
				monstr.dispose();
			}
		}
		
		/**
		 * 创建主角 
		 * @param id		主角ID
		 * @param posX		主角X位置
		 * @param posZ		主角Z位置
		 * @param type		主角类型
		 * @return 			主角
		 * 
		 */		
		public function createMainRole(id : int, posX : int, posZ : int, type : int) : Player3D {
			var playerVO : Player3DVO = new Player3DVO();
			playerVO.id   = id;
			playerVO.posX = posX;
			playerVO.posY = posZ;
			playerVO.playerType   = type;
			playerVO.walkVelocity = 12;
			var role : Player3D = new Player3D(playerVO, SceneAdapterManager.instance.current.onPlayerLoaded);
			GameManager.getInstance().mainRole = role;
			addSceneObjToScene(role, true, true, true);
			addPlayer(role);
			return role;
		}
				
		public function addSceneObjToScene(obj : BaseObj3D, clingGround : Boolean = false, needInViewDist : Boolean = true, renderLimitable : Boolean = false) : void {
			gameScene3D.addSceneObj(obj, null, needInViewDist, renderLimitable);
			if (clingGround) {
				obj.clingGroundCalculate = gameScene3D.clingGround;
			}
		}
		
		public function removeSceneObj(obj : BaseObj3D, recycle : Boolean = true) : void {
			gameScene3D.removeSceneObj(obj, recycle);
		}
		
		public function update(curTime : int, deltaTime : int) : void {
			for (var i:int = 0; i < _operators.length; i++) {
				var magic : MagicBase = _operators[i] as MagicBase;
				if (magic && magic.recycleEnable) {
					MagicBase.RecycleMagic(magic);
					removeOperator(magic);
					i--;
				}
			}
			
			for(i = _players.length - 1; i >= 0; i--)
			{
				_players[i].animationController.render(curTime,deltaTime);
			}
		}
		
		public function showMouseClickEffect(position : Vector3D) : void {
			if (_mouseClickEffect && position) {
				_mouseClickEffect.start();
				_mouseClickEffect.position = position;
				addObject(_mouseClickEffect);
			}
		}
		
		public function hideMouseClickEffect() : void {
			if (_mouseClickEffect && _mouseClickEffect.parent) {
				removeObject(_mouseClickEffect);
				_mouseClickEffect.stop();
			}
		}
		
		/**
		 * 切换场景 
		 * @param index	0-11
		 */		
		public function changeScene(index : int, roleType : int) : void {
			_sceneID  = index;
			_roleType = roleType;
			
			SceneAdapterManager.instance.switchAdapter(_sceneID);
			SceneAdapterManager.instance.current.onChangeScene(_sceneID, _roleType);
			// 暂停
			GameManager.getInstance().stateController.stop();
			GameManager.getInstance().stop();
			// hide UI Panel
			UIPanel.instance.init(Stage3DLayerManager.starlingView2D.stage);
			UIPanel.instance.hide();
			// load scene
			enterMap();
		}
		
		public function get sceneID():int {
			return _sceneID;
		}
		
		public function get roleID():int {
			return _roleType;
		}
		
	}
}
