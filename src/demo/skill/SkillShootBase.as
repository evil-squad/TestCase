package demo.skill
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.SkeletonBone;
	
	import demo.display3D.Particle3D;
	import demo.enum.BoneNameEnum;
	import demo.managers.WorldManager;

	public class SkillShootBase extends SkillBase
	{
		private var _ballNode : ObjectContainer3D;
		
		private var _castEff : Particle3D;			// 起手特效
		private var _ballEff : Particle3D;			// 飞射效果
		private var _bombEff : Particle3D;			// 爆炸效果
		
		private var step : int;	// 0:起手 1:飞射 2:爆炸 3:结束
		
		protected var _castTime : int = 200;			// 起手时间(子类配置)
		protected var _ballSpeed : Number = 750;		// 法球飞行速度(子类配置)
		protected var _isCastTwoHand : Boolean = true;	// 双手施法
		protected var _isCastRightHand : Boolean = true;
		protected var _isCastNoHand : Boolean = false;
		
		private var _ballFlyTime : int;		
		private var _bombTime : int;
		
		private var _startPos : Vector3D = new Vector3D;
		private var _curPos : Vector3D = new Vector3D;
		
		protected var _defaultBoneTag:String = BoneNameEnum.RIGHT_HAND;
		
		public function SkillShootBase()
		{
			super();
			
			_ballNode = new ObjectContainer3D;
		}
		
		protected function createCastEffect() : Particle3D	 {return null;}		// 创建起手特效
		protected function createBallEffect() : Particle3D {return null;}		// 创建飞射特效
		protected function createBombEffect() : Particle3D {return null;}		// 创建爆炸特效
		
		
		
		
		override protected function castSkill():void
		{
			super.castSkill();
//			step = -1;
//			_receiver = _world.getAvatar3D(skillCastTargetId);
//			if(!_receiver)
//			{
//				removeElement();
//				return;
//			}
//			
//			step = 0;
//			_ballNode.x = _ballNode.y = _ballNode.z = 0;
//			// 起手效果
//			_castEff = createCastEffect();
//			if(_castEff)
//			{
//				if(_isCastNoHand)
//					_caster.graphicDis.addChild(_castEff);
//				else
//				{
//					if(_isCastRightHand)
//					{
//						_caster.mesh.addChildAtBone(_defaultBoneTag, _castEff);
//					}
//					else
//					{
//						_caster.mesh.addChildAtBone(BoneNameEnum.LEFT_HAND, _castEff);
//					}
//				}
//			}
//			
//			
//			// 飞射效果
//			_caster.mesh.addChildAtBone(_defaultBoneTag, _ballNode);
//			
//			_ballEff = createBallEffect();
//			if(_ballEff)
//			{
////				_ballEff.noLifeTime();
//				_ballNode.addChild(_ballEff);
//			}
//			
//			
//			// 计算法球飞行时间
//			var length:Number = _receiver.distanceToPos(_caster.x, _caster.y);
//			_ballFlyTime = length / _ballSpeed * 1000 - _castTime;
//			_ballFlyTime = _ballFlyTime < 0 ? 10 : _ballFlyTime;
		}
		
		override public function reset():void
		{
			step = -1;
			removeElement();
			super.reset();
		}
		
		
		override protected function removeElement():void
		{
			super.removeElement();
			step = -1;
			if(_castEff)
			{
//				_castEff.dead = true;
				_castEff = null;
			}
			if(_ballEff)
			{
//				_ballEff.dead = true;
				_ballEff = null;
			}
			if(_bombEff)
			{
//				_bombEff.dead = true;
				_bombEff = null;
			}
			
			if(_ballNode && _ballNode.parent)
			{
				_ballNode.parent.removeChild(_ballNode);
			}
		}
		
		override public function update(curTime:int, deltaTime:int):void
		{
			super.update(curTime, deltaTime);
			
			var dir : Vector3D;
			var up : Vector3D;
			var right : Vector3D;
			var rotMat : Matrix3D;
			
			if(step == 0)
			{	
				if(lastTime > _castTime)
				{	// 法球出手
					if(_caster)
					{  
						if(_caster.mesh.getBoneByName(_defaultBoneTag))
							_startPos.copyFrom( _caster.mesh.getBoneByName(_defaultBoneTag).scenePosition );
						else
							_startPos.copyFrom(_caster.graphicDis.scenePosition);
					}
					WorldManager.instance.gameScene3D.addChild(_ballNode);
					// 位置
					_ballNode.position = _startPos;
					// 方向
					if(_receiver.mesh.getBoneByName(BoneNameEnum.CHEST))
					    right = _receiver.mesh.getBoneByName(BoneNameEnum.CHEST).scenePosition.subtract(_startPos);
					else
						right = _receiver.graphicDis.scenePosition.subtract(_startPos);
					
					right.normalize();
					up = Vector3D.Y_AXIS;
					dir = right.crossProduct(up);
					up = dir.crossProduct(right);
					
					rotMat = new Matrix3D;
					
					rotMat.copyColumnFrom(0, right);
					rotMat.copyColumnFrom(1, up);
					rotMat.copyColumnFrom(2, dir);
					rotMat.copyColumnFrom(3, _ballNode.position);
					
					_ballNode.transform = rotMat;
					
					step = 1;
				}
			}
			else if(step == 1)
			{
				if(_castEff)
				{
//					_castEff.dead = true;
					_castEff = null;
				}
				// 法球飞行
				var w:Number = (lastTime - _castTime) / _ballFlyTime;
				if(_receiver.mesh.getBoneByName(BoneNameEnum.CHEST))
				    _curPos.copyFrom( _receiver.mesh.getBoneByName(BoneNameEnum.CHEST).scenePosition );
				else
					_curPos.copyFrom(_receiver.graphicDis.scenePosition);
				
				_curPos = _curPos.subtract(_startPos);
				_curPos.scaleBy( w );
				_curPos = _curPos.add(_startPos);
				
				// 位置
				_ballNode.position = _curPos;
				// 方向
				if(_receiver.mesh.getBoneByName(BoneNameEnum.CHEST))
				{
					right = _receiver.mesh.getBoneByName(BoneNameEnum.CHEST).scenePosition.subtract(_curPos);
				}
				else
				{
					right = _receiver.graphicDis.scenePosition.subtract(_curPos);
				}
				right.normalize();
				up = Vector3D.Y_AXIS;
				dir = right.crossProduct(up);
				up = dir.crossProduct(right);
				
				rotMat = new Matrix3D;
				
				rotMat.copyColumnFrom(0, right);
				rotMat.copyColumnFrom(1, up);
				rotMat.copyColumnFrom(2, dir);
				rotMat.copyColumnFrom(3, _ballNode.position);
				
				_ballNode.transform = rotMat;
				
				
				if( lastTime > (_ballFlyTime + _castTime) )
				{
					step = 2;
					if(_ballEff)
					{
//						_ballEff.dead = true;
						_ballEff = null;
					}
					
					if(_ballNode && _ballNode.parent)
					{
						_ballNode.parent.removeChild(_ballNode);
					}
					// 爆炸
					var bombEffect : Particle3D = createBombEffect();
					if(bombEffect)
					{
						_bombTime = 1000;//bombEffect.lifeTime;
						
						var tag:SkeletonBone = _receiver.mesh.getBoneByName(BoneNameEnum.CHEST)
						if(tag)
						  _curPos.copyFrom( tag.scenePosition );
						else
						  _curPos.copyFrom(_receiver.graphicDis.scenePosition)
						_curPos = _curPos.subtract(_startPos);
						_curPos.scaleBy(0.95);
						_curPos = _curPos.add(_startPos);
						
						bombEffect.position = _curPos;
						WorldManager.instance.gameScene3D.addChild(bombEffect);
					}
					else
						_bombTime = 0;
				}
				
			}
			else if(step == 2)
			{
				if(_castEff)
				{
//					_castEff.dead = true;
					_castEff = null;
				}
				if( lastTime > (_castTime + _ballFlyTime + _bombTime) )		// 爆炸持续
				{
					step = 3;
				}
			}
			else if(step == 3)
			{				
				removeElement();		// 技能效果结束
			}
		}
	}
}