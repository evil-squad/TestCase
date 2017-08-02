package demo.skill
{
	import flash.utils.Dictionary;
	
	import demo.display3D.Avatar3D;
	import demo.enum.SkillDefineEnum;
	import demo.managers.ParticleManager;
	import demo.managers.SkillManager;
	import demo.managers.WorldManager;

	public class SkillBase
	{
		public var id:uint = 0;				// 技能表 id
		public var seq:uint = 0;				// 技能序号
		private var _lastTime:int = 0;		// 已存活时间
		private var _surviveTime:int = 0;	//
		private var _forEver:Boolean = false;				// 永生
		private var _isSleeping:Boolean = true;			// 处于非活动状态
		
		protected var _particleManager:ParticleManager;
		protected var _skillManager:SkillManager;
		
		protected var _caster:Avatar3D;
		protected var _receiver:Avatar3D;
		protected var _skillDetail:SkillDetailVO;
		private var _timeHandler:Dictionary;
		
		protected var _posList:Array;
		protected var _posX:Number;
		protected var _posY:Number;
		
		private var _recycleTime:int = 5000;//5秒之后会被回收。
		protected var _maxSurviveTime:int = 6000;//6秒之后会被回收。
		
		public var skillCastPosList:Array;
		public var skillCastTargetId:uint;
		public var skillCastTargetIds:Array;
		public var skillCastPosX:Number = 0;
		public var skillCastPosY:Number = 0;
		
		public var parentSkill:SkillDetailVO;//由另外一个技能导致触发该技能.
		protected var _world:WorldManager;
		
		public function get detail():SkillDetailVO { return _skillDetail; }
		public function noDead():void { _forEver = true; }
		public function get isSleeping():Boolean { return _isSleeping; }
		public function get isMoveCastSkill():Boolean { return false; }
		public function get lastTime():int {return _lastTime;}
		
		public function get isDead():Boolean
		{
			return _forEver == false && (_lastTime >= _recycleTime || _surviveTime >= _maxSurviveTime);
		}
		
		
		public function SkillBase()
		{
			_world = WorldManager.instance;
			_particleManager = ParticleManager.getInstance();
			_skillManager = SkillManager.getInstance();
			
		}
		
		protected function removeElement():void 
		{
			_forEver = false;
			_lastTime = 0;
			_surviveTime = _maxSurviveTime;
			_isSleeping = true;
		}
		
		protected function checkFaceTarget():void
		{
			if(_caster && skillCastTargetId != 0 && _caster.isDead == false)
			{
				_caster.faceToTarget(skillCastTargetId);
			}
			else if(_skillDetail.releaseType == SkillDefineEnum.TARGET_AREA || _skillDetail.releaseType == SkillDefineEnum.TARGET_DIRECTION)
			{
				_caster.faceToGround(skillCastPosX, skillCastPosY);
			}
			
		}
		
		public function reset():void
		{
			removeElement();
			_lastTime = 0;
			_surviveTime = 0;
			//reset status
			skillCastTargetId = 0;
			skillCastTargetIds = null;
			skillCastPosX = 0;
			skillCastPosY = 0;
			skillCastPosList = null;
			_casted = false;
			_timeHandler = null;
		}
		
		
		
		//我尝试使用技能。做一些预处理，比如药品栏变色，或者其他等待状态，不处理技能的逻辑.
		
		//___施法过程为
		//1-------->他人玩家tryCastSkill之后，直接进入onCastSkill
		
		//2------->玩家自己tryCastSkill之后，等待服务端反馈选择进入onCastSkill或者onCastSkillFail;
		
		//注意：onCastSkill里面执行doCastSkill的逻辑
		public function tryCastSkill(caster:Avatar3D, skillDetail:SkillDetailVO, targetId:int, targetIds:Array, posList:Array):void
		{
			_caster = caster;
			_skillDetail = skillDetail;
			_posList = posList;
			_posX = posList ? posList[0].x:0;
			_posY = posList ? posList[0].y:0;
			if(_caster == null)
				return;
			
			var aliveTime:int;
			if(skillDetail)
			{
				if(isMoveCastSkill)
				{
					aliveTime = skillDetail.skillEffectTime2 + 200;
				}
				else
				{
					aliveTime = skillDetail.skillLifeTime == -1 ? skillDetail.situationTime + 200 : skillDetail.skillLifeTime;
				}
			}
			else
			{
				aliveTime = 1100;
			}
			
			_recycleTime = aliveTime;
			_maxSurviveTime = _recycleTime + 100;
			
			checkFaceTarget();
			
			_receiver = _world.getAvatar3D(targetId);
			
//			addTimeHandlerAt(200 + int(Math.random() * 800), checkStone);
		}
		
		// 服务器通知使用该技能
		protected function castSkill():void
		{
			_receiver = _receiver || _world.getAvatar3D(skillCastTargetId);
			if(_caster == null)
				return;
			checkFaceTarget();
		}
		
		private var _casted:Boolean;
		public function checkNowCastEnable():void
		{
			if(_casted)
				return;
			var enable:Boolean = true;
			if(enable)
			{
				castSkill();
				_casted = true;
			}
			_isSleeping = false;
			
		}
		
		// 服务器通知该技能使用完毕,(某些持续施法技能需用到此函数)
		public function onCastSkillEnd(targetId:int = 0):void
		{
			if(_caster)
				_caster.skillController.onCastSkillEnd(this);//todo
			removeElement();
			
		}
		
		
		public function update(curTime:int, deltaTime:int):void
		{
			_lastTime += deltaTime;
			handlerWithCurTime();
		}
		
		private function checkStone():void
		{
			if(_caster.aiController == null)
				return;
			if(_caster.grayScaleRadom > Math.random())
			{
				_caster.aiController.stone();
			}
		}
		
		//更新这一帧的时候，刚好跨过某一个时间.
		protected function addTimeHandlerAt(time:int, fun:Function):void
		{
			_timeHandler = _timeHandler || new Dictionary();
			if(_timeHandler[time] != null)
			{
				throw new Error("registered before at " + time + " ms");
				return;
			}
			_timeHandler[time] = fun;
		}
		
		
		private function handlerWithCurTime():void
		{
			var fun:Function;
			var minTime:int = int.MAX_VALUE;
			for(var time:* in _timeHandler)
			{
				if(time < minTime)
				{
					minTime = time;
				}
			}
			
			if(lastTime > minTime)
			{
				fun = _timeHandler[minTime];
				fun();
				delete _timeHandler[minTime];
			}
		}
		
		protected function playDuration(animationName:String):void
		{
			if (_caster)
			{
				var total:uint = _caster.animationController.getSequenceDuration(animationName);
				_caster.animationController.playAnimWithDuring(animationName, total);
			}
		}
		
		public function surviveRender(curTime:int, deltaTime:int):Boolean
		{
			_surviveTime += deltaTime;
			return _surviveTime >= _maxSurviveTime;
		}
		
		// 技能操作方法
		public function get isToSelf():Boolean {return false;}
		public function get isNeedTarget():Boolean {return false;}
		public function get isCanTarget():Boolean {return false;}
		
		
	}
}