/**
 * 弓箭手250的弹道
 */	
package demo.skill.magic
{
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Matrix3DUtils;
	
	import demo.controller.PlayerAnimationController;
	import demo.display3D.Avatar3D;
	import demo.display3D.Particle3D;
	import demo.enum.PathEnum;
	import demo.enum.SkillDefineEnum;
	import demo.managers.BattleSystemManager;
	import demo.managers.SkillManager;
	import demo.skill.SkillDetailVO;
	
	public class MagicObject_250 extends MagicBase
	{
		private var _ballEffect:Particle3D;
		private var _explodeEffect:Particle3D;
		
		private var _orgX:Number;
		private var _orgY:Number;
		
		private var _vX:Number = 0;
		private var _vY:Number = 0;
		private var _sufferer:Avatar3D;
		private var _ownerPlayer:Avatar3D;
		
		private static const BallSpeed:Number = 80;
		
		//自动追踪最多5个目标
		private var _suffererList:Vector.<Avatar3D>;
		private static const MAX_COUNT:int = 5;
		public function MagicObject_250(Id:uint, OwnerId:uint, X:int, Y:int)
		{
			super(Id, OwnerId, X, Y);
		}
		
		override public function initMagicData(Id:uint, OwnerId:uint, ConfigId:int, TargetId:uint, X:int, Y:int, Arg1:Number = 0, Arg2:Number = 0):void
		{
			super.initMagicData(Id, OwnerId, ConfigId, TargetId, X, Y, Arg1, Arg2);
			_sufferer = _world.getAvatar3D(suffererId);
			_ownerPlayer = creater as Avatar3D;
			_vX = _sufferer.x - _ownerPlayer.x;
			_vY = _sufferer.z - _ownerPlayer.z;
			_orgX = _ownerPlayer.x;
			_orgY = _ownerPlayer.z;
			var vector:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
			vector.setTo(_vX, 0, _vY);
			vector.normalize();
			vector.scaleBy(BallSpeed);
			
			_vX = vector.x;
			_vY = vector.z;
			setGroundXY(_orgX, _orgY);
			y = y + 150;
			var effectPath:String = SkillManager.getInstance().getSkillPath(PlayerAnimationController.SEQ_ATTACK_250);
			_ballEffect = _particleManager.getParticle(effectPath, null);
			if(_ballEffect)
			{
				graphicDis.addChild(_ballEffect);
				ObjFaceTo3DSpace(graphicDis, _sufferer.x, _sufferer.z, getSufferHeight());
			}
			addTimeHandlerAt(3600, on3600Ms);
			
			collectMonsters();
		}
		
		private function collectMonsters():void
		{
			_suffererList = new Vector.<Avatar3D>();
			var m:Avatar3D;
			
			var fillCount:int = MAX_COUNT * 4;//先多选一些出来用于比较
			for each(m in _world.monsters)
			{
				if(m.isDead || m.godMode || m == _sufferer)
					continue;
				if(creater.distanceToPos(m.x, m.z) < 3000)
				{
					_suffererList.push(m);
					if(_suffererList.length >= fillCount)
						break;
				}
			}
			
			//排序
			var newList:Vector.<Avatar3D> = new Vector.<Avatar3D>();
			
			var last:Avatar3D = _sufferer;
			var distance:int;
			var target:Avatar3D;
			while(last)
			{
				if(last != _sufferer)
				{
					newList.push(last);
					if(newList.length >= MAX_COUNT)
						break;
				}
				distance = 1500;//闪电链之间的最大距离，超过这个就断掉了！
				target = null;
				for each(m in _suffererList)
				{
					var d:int = last.distanceToPos(m.x, m.z);
					if(d < distance)
					{
						distance = d;
						target = m;
					}
				}
				
				if(target)
				{
					_suffererList.splice(_suffererList.indexOf(target), 1);
					last = target;
				}
				else
				{
					last = null;
				}
			}
			_suffererList = newList;
			
		}
		
		
		private function on3600Ms():void
		{
			onNetActive(0);
			recycleEnable = true;
		}
		
		override protected function updatePosition():void
		{
		}
		
		override public function onNetActive(Value:uint):void
		{
			var explode:Particle3D = _particleManager.getParticle(PathEnum.SKILL_PATH + "tx_suit_arch1_001/tx_suit_arch1_400.awd", null, null, 1000);
			_world.addObject(explode);
			explode.position = graphicDis.scenePosition;
		}
		
		override public function run(deltaTime:uint):void
		{
			super.update(deltaTime);
			
			var lastHeight:Number = y;
			setGroundXY(x + _vX * deltaTime / 17, z + _vY * deltaTime / 17);
			var distance:Number = _sufferer.distanceToPos(x, z);
			var ratio:Number = (BallSpeed / distance) * (deltaTime / 17);
			y = ratio * (getSufferHeight() - lastHeight) + lastHeight;
			
			ObjFaceTo3DSpace(graphicDis, _sufferer.x, _sufferer.z, getSufferHeight());
			
			_vX = _sufferer.x - x;
			_vY = _sufferer.z - z;
			var tempVector:Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
			tempVector.setTo(_vX, 0, _vY);
			tempVector.normalize();
			tempVector.scaleBy(BallSpeed);
			
			_vX = tempVector.x;
			_vY = tempVector.z;
			
			checkAttack();
		}
		
		private function getSufferHeight():Number
		{
			var tag:ObjectContainer3D = _sufferer.underAttackContainer;
			if(tag)
			{
				return tag.scenePosition.y;
			}
			return _sufferer.y + 150;
		}
		
		private function checkAttack():void
		{
			if(_sufferer.distanceToPos(x, z) < (100 + _sufferer.radius))
			{
				onNetActive(1);
				var skill:SkillDetailVO = SkillManager.getInstance().getSkillInfo(SkillDefineEnum.PLAYER_SHOOT_ATTACK);
				BattleSystemManager.getInstance().singleAttack(_ownerPlayer, _sufferer, skill);
				
				_sufferer = _suffererList.shift();
				if(_sufferer == null)
				{
					recycleEnable = true;
				}
			}
		}
		
		override public function resetMagic(Id:int=0, Name:String=null):void
		{
			if(_ballEffect)
			{
				_particleManager.recycleParticle(_ballEffect);
				_ballEffect = null;  
			}
			
			setGroundXY(0, 0);
			super.resetMagic(Id, Name);
		}
	}
}

