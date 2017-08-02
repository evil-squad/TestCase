package demo.display3D {

	import com.game.engine3D.manager.Stage3DLayerManager;
	import com.game.engine3D.scene.render.RenderSet3D;
	import com.game.engine3D.scene.render.RenderUnit3D;
	import com.game.engine3D.scene.render.vo.RenderParamData3D;
	import com.game.engine3D.utils.MathUtil;
	import com.game.engine3D.vo.BaseRole;
	import com.game.engine3D.vo.SoftOutlineData;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.MathConsts;
	import away3d.core.math.Matrix3DUtils;
	import away3d.enum.LoadPriorityType;
	import away3d.events.MouseEvent3D;
	
	import demo.controller.MonsterAIController;
	import demo.controller.PlayerAnimationController;
	import demo.controller.PlayerSkillController;
	import demo.display2D.BattleResultTextAnim;
	import demo.display2D.SpriteBind3D;
	import demo.display2D.TextFieldBind3D;
	import demo.enum.EleEnum;
	import demo.enum.RenderUnitID;
	import demo.enum.RenderUnitType;
	import demo.managers.GameManager;
	import demo.managers.ParticleManager;
	import demo.managers.WorldManager;
	import demo.vo.Avatar3DVO;


	/**
	 * @author 	chenbo
	 * @email  	470259651@qq.com
	 * @time	Mar 22, 2016 10:56:38 AM
	 */
	public class Avatar3D extends BaseRole {
		
		private const GRAYSCALE_SPEED	: Number = 0.01;
		
		public var showContainer 		: SpriteBind3D;	 	// 掉血文字飘出点
		public var showContainer2 		: SpriteBind3D; 	// 掉血文字飘出点
		public var hp 					: int = 1000;
		public var maxHp 				: int = 1000;
		public var isDead 				: Boolean;
		public var inBattle 			: Boolean;
		public var attackAble 			: Boolean;
		public var distanceFindEnemy 	: int = 600;
		public var distanceFollow 		: int = 1400;
		public var distanceMinFollow 	: int = 60;
		public var distanceMinAttack 	: int = 200;
		public var distanceMaxAttack 	: int = 300;
		public var lazyRepeatCount 		: int;
		public var lazyStayMiliSec 		: int = 1000;
		public var lazyRandom 			: Number = 0;
		public var grayScaleRadom 		: Number = 0.2;
		public var passByPosList 		: Vector.<Point>;
		public var godMode				: Boolean;
		public var mesh					: RenderUnit3D;
		public var weaponMesh			: RenderUnit3D;
		
		protected var _path 			: Vector.<Vector3D>;
		protected var _pathBak 			: Vector.<Vector3D>;
		protected var _physic 			: PhysicActor;

		protected var _nameTxt 			: TextFieldBind3D;
		protected var _nameTxt2 		: TextFieldBind3D;
		protected var _nameTxtOc 		: ObjectContainer3D;
		protected var _pickEnable 		: Boolean;
		protected var _overSelected 	: Boolean;
		protected var _particleMg 		: ParticleManager;
		protected var _underAttackBD 	: ObjectContainer3D;
		protected var _gameManager 		: GameManager;
		protected var _skillController 	: PlayerSkillController;
		protected var _animationCtrl 	: PlayerAnimationController;
		protected var _lastNotifyEnemyT : int;
		protected var _godMode 			: Boolean;
		protected var _grayScale 		: Number = 0;
		protected var _eleType 			: int = EleEnum.ELE_TYPE_UNKNOWN;
		protected var _radius 			: int = EleEnum.ELE_DEFAULT_RADIUS;
		protected var _worldManager 	: WorldManager;
		protected var _softOutlineData  : SoftOutlineData;
				
		private var _targetAnimSpeed 	: Number = 1;
		private var _moveNextPos 		: Vector3D = new Vector3D();
		private var _walkDirectionDelay : int = 0;
		private var _deadAndRecycleTime : int = 5 * 1000;
		private var _vo 				: Avatar3DVO;
		private var _walkDirection 		: Vector3D;
		private var _destroyed 			: Boolean;
		private var _lastTime 			: int = 0; // 已存活时间
		private var _lastPopValue 		: String;
		private var _lastPopTimer 		: int;
		private var _currentGray		: Boolean;
		
		private var _tempVector:Vector3D = new Vector3D();
		
		public function Avatar3D(vo : Avatar3DVO) {
			super("" + vo.type, vo.id);
			
			_worldManager = WorldManager.instance;
			_gameManager  = GameManager.getInstance();
			_particleMg   = ParticleManager.getInstance();
			
			_vo  = vo;
			id   = vo.id;
			type = "" + vo.type;
			
			_pathBak = new Vector.<Vector3D>;
			
			_physic  = new PhysicActor(this);
			_physic.speed = vo.walkVelocity;
			
			_skillController = new PlayerSkillController(this);
			_animationCtrl   = new PlayerAnimationController(this);
			
			_softOutlineData = new SoftOutlineData(0xee0000, 0.8, 0.005);
						
			setGroundXY(vo.posX, vo.posY);
			forcePosition(vo.posX, vo.posY);
			
			loadResource();
		}
				
		public function get targetAnimSpeed():Number {
			return _targetAnimSpeed;
		}

		public function set targetAnimSpeed(value:Number):void {
			_targetAnimSpeed = value;
		}
		
		public function get underAttackContainer():ObjectContainer3D {
			return _underAttackBD;
		}

		public function get overSelected():Boolean {
			return _overSelected;
		}

		public function set overSelected(value:Boolean):void {
			if(_overSelected == value) {
				return;
			}
			_overSelected = value;
			if (mesh == null) {
				return;
			}
			mesh.setSoftOutline(_overSelected ? _softOutlineData : null);
		}

		public function get physic():PhysicActor
		{
			return _physic;
		}
		
		public function get destroyed():Boolean {
			return _destroyed;
		}

		public function set destroyed(value:Boolean):void {
			_destroyed = value;
		}

		public function get pickEnable():Boolean {
			return _pickEnable;
		}
		
		public function set pickEnable(value:Boolean):void {
			_pickEnable = value;
		}
		
		public function get skillController():PlayerSkillController {
			return _skillController;
		}

		public function get animationController():PlayerAnimationController {
			return _animationCtrl;
		}

		public function get vo():Avatar3DVO {
			return _vo;
		}
		
		protected function reLoadResource() : void {
			
			if (mesh) {
				avatar.removeRenderUnit(mesh);
			}
			
			if (weaponMesh) {
				avatar.removeRenderUnit(weaponMesh);
			}
			
			if (_nameTxt) {
				_nameTxt.dispose();
				_nameTxt = null;
			}
			
			if (_nameTxt2) {
				_nameTxt2.dispose();
				_nameTxt2 = null;
			}
			
			_underAttackBD = null;
			
			if(showContainer) {
				showContainer.dispose();
				showContainer = null;
			}
						
			loadResource();
		}
		
		protected function loadResource():void {
			avatar.buildSyncInfo(RenderUnitType.BODY, RenderUnitID.BODY);
			avatar.buildSyncInfo(RenderUnitType.WEAPON, RenderUnitID.WEAPON);
			avatar.removeRenderUnitByID(RenderUnitType.BODY, RenderUnitID.BODY);
			avatar.removeRenderUnitByID(RenderUnitType.WEAPON, RenderUnitID.WEAPON);
			var rpd : RenderParamData3D = new RenderParamData3D(
				RenderUnitID.BODY, RenderUnitType.BODY,
				vo.url,
				vo.name
			);
			rpd.priority = LoadPriorityType.LEVEL_AWD;
			mesh = avatar.addRenderUnit(rpd);
			mesh.defalutStatus = PlayerAnimationController.SEQ_IDLE;
			mesh.entityGlass   = false;
			mesh.castsShadows  = true;
			mesh.useLight	   = true;
			mesh.setStatus(PlayerAnimationController.SEQ_IDLE);
			avatar.applySyncInfo(RenderUnitType.BODY, RenderUnitID.BODY);
			// 添加回调函数
			mesh.setAddedCallBack(initResource);
			
			avatar.setMouseUpCallBack(handleMouseUp);
			avatar.setMouseOverCallBack(handlerMouseOver);
			avatar.setMouseOutCallBack(handlerMouseOut);
			
			if (vo.weaponUrl && vo.weaponUrl != "") {
				loadWeaponResource();
			}
		}
		
		/**
		 * 鼠标弹起
		 * @param rs
		 *
		 */
		private function handleMouseUp(e : MouseEvent3D, ru : RenderUnit3D, rs : RenderSet3D) : void {
			_gameManager.onAvatarClicked(this);
		}
		
		/**
		 * 鼠标滑过
		 * @param rs
		 *
		 */
		private function handlerMouseOver(e : MouseEvent3D, ru : RenderUnit3D, rs : RenderSet3D) : void {
			this.overSelected = true;
		}
		
		/**
		 * 鼠标移出
		 * @param rs
		 *
		 */
		private function handlerMouseOut(e : MouseEvent3D, ru : RenderUnit3D, rs : RenderSet3D) : void {
			this.overSelected = false;
		}
		
		protected function initResource(ru : RenderUnit3D) : void {
			_nameTxtOc = ru.getChildByName(_vo.nameTextContainer);
			//构造一个受击点
			_underAttackBD = ru.getChildByName(_vo.nameShowContainer);
			if(_underAttackBD == null) {
				_underAttackBD = new ObjectContainer3D();
				_underAttackBD.name = _vo.nameShowContainer;
//				_underAttackBD.y = mesh.getHeight() * scaleY * 0.5;
				ru.graphicDis.addChild(_underAttackBD);
			}
			initNameField();
			initShowContainer();
		}
				
		protected function loadWeaponResource():void {
			var rpd : RenderParamData3D = new RenderParamData3D(
				RenderUnitID.WEAPON, RenderUnitType.WEAPON,
				vo.weaponUrl,
				vo.name
			);
			weaponMesh = avatar.addRenderUnitToBone(RenderUnitType.BODY, RenderUnitID.BODY, vo.weaponBone, rpd);
			weaponMesh.entityGlass   = false;
			weaponMesh.castsShadows  = true;
			weaponMesh.useLight		 = true;
			weaponMesh.play();
		}
		
		protected function initNameField() : void {
			if (!_nameTxtOc) {
				return;
			}
			
			_nameTxt = new TextFieldBind3D();
			_nameTxt.text = _vo.name;
			_nameTxt.bindTarget = _nameTxtOc;
			_nameTxt.view = Stage3DLayerManager.getView(0);
			_nameTxt.bindAvatar = this;
			_nameTxt.addToLayer(Stage3DLayerManager.starlingLayer);
			_nameTxt.updateHpBar();
		}
		
		protected function initShowContainer() : void {
			
			if (!_underAttackBD) {
				return;
			}
			
			showContainer = new SpriteBind3D();
			showContainer.bindTarget = _underAttackBD;
			showContainer.bindAvatar = this;
			showContainer.view = Stage3DLayerManager.getView(0);
		}
		
		public function forcePosition(px : Number, pz : Number) : void {
			this._physic.setFrom(px, pz);
			this.x = px;
			this.y = _worldManager.queryHeightAt(px, pz) + 1;
			this.z = pz;
		}
		
		public function get radius():int {
			return _radius;
		}

		public function set radius(value:int):void {
			_radius = value;
		}
						
		public function walkToward(dir : Vector3D) : Boolean {
			_walkDirection = dir;
			if (_walkDirection == null) {
				return false;
			}
			_walkDirectionDelay = 100;
			
			if (isMainChar) {
				_worldManager.hideMouseClickEffect();
			}
			
			_walkDirection.y = 0;
			_walkDirection.normalize();
			
			if (isMainChar) {
				if (_gameManager.stateController.canMoveTo() == false) {
					return false;
				}
			}
			
			if (_pathBak.length == 0) {
				_pathBak.push(new Vector3D());
			}
			
			var targetI   : int = 0;
			var zDistance : Number   = 0;
			var targetPos : Vector3D = _pathBak[0];
			var pos3d 	  : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
			
			for (var i : int = 0; i < 5; i++) {
				zDistance = _walkDirection.z * (i + 1) * _physic.speed;
				pos3d.setTo(x + _walkDirection.x * (i + 1) * _physic.speed, 0, z + zDistance);
				if (_worldManager.district && _worldManager.district.isPointInSide(pos3d, WorldManager.instance.district.pixelToTerrainSize / 2)) {
					targetI = i + 1;
				} else {
					break;
				}
			}
			
			if (targetI == 0) {
				targetPos.setTo(x + _walkDirection.x * 0.00001, 0, z + _walkDirection.z * 0.00001);
			} else {
				targetPos.setTo(x + _walkDirection.x * targetI * _physic.speed, 0, z + _walkDirection.z * targetI * _physic.speed);
			}
			
			if (_path) {
				_path.length = 0;
			} else {
				_path = new Vector.<Vector3D>();
			}
			
			_path.push(targetPos);
			_physic.setTo(x, z, PhysicActor.MOVE);
			
			onPathSegmentComplete();
			faceToGround(x + _walkDirection.x * 100, z + _walkDirection.z * 100);
			
			if (isMainChar) {
				_gameManager.stateController.move();
			} else {
				_animationCtrl.playMove();
			}
			return true;
		}
		
		public function onPathSegmentComplete() : void {
			if (_path == null || _path.length == 0) {
				if (isMainChar) {
					if (_walkDirectionDelay <= 0) {
						_gameManager.stateController.stop();
					}
				} else {
					stopWalk();
				}
			} else {
				var nextPosition : Vector3D = _path.shift();
				_physic.moveTo(nextPosition.x, nextPosition.z, _physic.state);
				var distance : Number = distanceToPos(nextPosition.x, nextPosition.z);
				if (distance > 1) {
					faceToGround(nextPosition.x, nextPosition.z);
				}
			}
		}
		
		public function distanceToPos(x : Number, z : Number) : Number {
			Matrix3DUtils.CALCULATION_VECTOR3D.setTo(x - this.x, 0, z - this.z);
			return Matrix3DUtils.CALCULATION_VECTOR3D.length;
		}
		
		public function walkTo(pos2d : Vector3D) : Boolean {
			_walkDirectionDelay = 100;
			if (isMainChar && !_gameManager.stateController.canMoveTo()) {
				return false;
			}
			_path = null;
			
			var pathCoordList : Vector.<Number> = null;
			var pos3d : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
			pos3d.setTo(x, 0, z);;
			//寻路
			if (_worldManager.district && _worldManager.district.isPointInSide(pos3d, WorldManager.instance.district.pixelToTerrainSize / 2)) {
				pos3d.setTo(pos2d.x, 0, pos2d.z);
				pathCoordList = _worldManager.district.findPath(new Vector3D(x, 0, z), pos3d);
			}
			
			if (pathCoordList && pathCoordList.length > 1) {
				var space2dY : Number = 0;
				var coordLen : int = pathCoordList.length / 2;
				_path = new Vector.<Vector3D>();
				_path.length = coordLen / 2 - 1;
				
				for (var i : int = 0; i < coordLen; i++) {
					if (_pathBak.length - 1 < i) {
						_pathBak.length = i;
						_pathBak[i] = new Vector3D();
					}
					space2dY = pathCoordList[i * 2 + 1];
					
					_pathBak[i].setTo(pathCoordList[i * 2], 0, space2dY);
					_path[i] = _pathBak[i];
				}
				
				_physic.setTo(x, z, PhysicActor.MOVE);
				
				onPathSegmentComplete();
				
				if (isMainChar) {
					_gameManager.stateController.move();
				} else {
					_animationCtrl.playMove();
				}
				
				return true;
			}
			return false;
		}
		
		//向前移动（直接移动、而不是走动）
		public function displaceForward(len:Number):void
		{
			var direction:Vector3D = _tempVector;
			var angle:Number = Math.PI * 3/2 - _graphicDis.rotationY * MathConsts.DEGREES_TO_RADIANS;
			direction.y = 0;
			direction.z = Math.sin(angle);
			direction.x = Math.cos(angle);
			direction.scaleBy(len);
			direction.incrementBy(this.position);
			if (_worldManager.district && _worldManager.district.isPointInSide(direction, WorldManager.instance.district.pixelToTerrainSize / 2))
			{
				this.x = direction.x;
				this.y = direction.y;
				this.z = direction.z;	
			}
		}
		
		public function distanceToObject(targetId : int) : Number {
			var target : Avatar3D = _worldManager.getAvatar3D(targetId);
			if (target == null) {
				return 0;
			}
			return distanceToPos(target.x, target.z);
		}
		
		public function stopWalk(executeIdleAction : Boolean = true) : void {
			_path = null;
			_physic.setTo(x, z, PhysicActor.STAY);
			if (isMainChar) {
				_worldManager.hideMouseClickEffect();
			}
			if (isDead == false) {
				_animationCtrl.playIdle();
			}
		}
		
		public function popTextAnim(value : String, color : uint) : void {
			if (_nameTxtOc == null) {
				return;
			}
			if (value + color == _lastPopValue) {
				return;
			}
				
			_lastPopValue = value + color;
			
			var anim : BattleResultTextAnim = new BattleResultTextAnim();
			anim.bindAvatar = this;
			anim.view 		= Stage3DLayerManager.getView(0);
			anim.bindTarget = _nameTxtOc;
			anim.init(value, color);
			anim.updateTranform();
		}
		
		public function onAnimationComplete():void {
			if (isDead) {
				return;
			}
			_animationCtrl.playIdle();
		}
		
		private function updateAnimSpeed() : void {
			_animationCtrl.animSpeedScale += (_targetAnimSpeed >= _animationCtrl.animSpeedScale) ? 0.02 : (-0.02);
		}
		
		override public function run(gapTm:uint):void {
			super.run(gapTm);
			
			updateGrayScale();
			updateAnimSpeed();
			
			_lastPopTimer += gapTm;
			if (_lastPopTimer > 500) {
				_lastPopValue = null;
				_lastPopTimer = 0;
			}
			
			var posDirty : Boolean = _physic.update(getTimer(), gapTm);
			if (_physic.pathFinished) {
				onPathSegmentComplete();
			}
			if (posDirty) {
				setGroundXY(_physic.x, _physic.z);
			}
			
			if (_nameTxt) {
				_nameTxt.updateHpBar();
			}
			
			if (_nameTxt2) {
				_nameTxt2.updateHpBar();
			}
				
			_lastNotifyEnemyT += gapTm;
			if (_lastNotifyEnemyT > 500) {
				_lastNotifyEnemyT = 0;
				notifyEnemy();
			}
			
			_walkDirectionDelay -= gapTm;
			if (isDead) {
				_deadAndRecycleTime -= gapTm;
			}
			
		}
		
		public function get aiController() : MonsterAIController {
			return null;
		}
		
		protected function notifyEnemy() : void {
			
		}
		
		public function faceToTarget(targetId:uint):void {
			if (id == targetId) {
				return;
			}
			var avatar : Avatar3D = _worldManager.getAvatar3D(targetId);
			if (avatar) {
				faceToGround(avatar.x, avatar.z);
			}
		}
		
		public function notifyInterest(target:Avatar3D):void {
			
		}
				
		override public function dispose():void {
			super.dispose();
			if(_destroyed == false) {
				_destroyed = true;
			}
		}
		
		public function get deadRecycleEnable() : Boolean {
			return _deadAndRecycleTime <= 0;
		}
		
		public function onNetReborn():void {
			if(isDead) {
				isDead = false;
				if(isMainChar) {
					_gameManager.stateController.reborn();
				} else {
					_animationCtrl.playIdle();
					pickEnable = true;
				}
			}			
		}
		
		public function onNetDead():void {
			if(isDead == false) {
				isDead = true;
				if(isMainChar) {
					_gameManager.stateController.dead();
				} else {
					_animationCtrl.playDead();
					pickEnable = false;
				}
			}
		}
		
		private function updateGrayScale():void {
			var value:Number = _currentGray ? (_grayScale + GRAYSCALE_SPEED) : (_grayScale - GRAYSCALE_SPEED);
			value = MathUtil.clamp(0, 1, value);
			if(_grayScale == value) {
				return;
			}
			_grayScale = value;
		}
		
		public function set currentGray(value:Boolean):void{
			_currentGray = value;
		}
		
		public function get currentGray():Boolean{
			return _currentGray;
		}
		
	}
}
