package demo.skill
{
	import flash.events.EventDispatcher;
	
	import demo.enum.SkillDefineEnum;

	public class SkillDetailVO extends EventDispatcher
	{
		public function SkillDetailVO(name:String)
		{
			skillName = name;
		}
		//0非持续施法，1，持续施法（不能移动）, 2，持续施法，可以移动
		public var castType:int = 0;
		public var skillName:String;
		public var clientId:int = 0;	// 客户端技能id
		public var skillEffectTime2:int;//旋风斩持续时间
		public var skillRange:Number = 0;		
		public var skillRadius:int = 0;
		public var singTime:int = 0;			//动作释放时间 
		public var situationTime:int = 1;		//僵持时间  
		public var skillLifeTime:int = -1;		// 技能持续时间
		public var skillAloneCd:int = 0;		// 技能的CD(ms)
		public var skillPublicCd:int = 500;
		public var damageMulti:Number = 1;
		public var damageCount:int;				//技能伤害最多数
		
		public var excuteDelay:int;			//技能伤害时间
		public var createMagicId:int;
		/**
		 *0:从施法者位置出发，到技能指定位置
		 *1:从施法者出发，圆形散开多个飞出
		 *2:从目标位置出发，到技能指定位置
		 */		
		public var createMagicType:int = SkillDefineEnum.MAGIC_0;			//特殊作用.
		public var excuteExtraCount:int;		//额外伤害次数
		public var excuteExtraDelay:int;		//额外伤害的延迟时间.(从calcDamageDelay作用之后开始算)
		//			1=选择敌人释放
		//			2＝选择友方释放
		//			3＝直接释放
		//			4＝选择区域释放
		public var releaseType:int = 0;
		
		/**
		 * 连招下一个技能id 
		 */		
		public var nextSkillId:int = 0;
		
		/**
		 * 连招base技能id 
		 */		
		public var baseSkillId:int = 0;
		
		public var holdTime:int;//触发连招时，当前动作至少要播放多长时间才开始执行连招动作
		public var comboTime:int;//技能可以接受连招输入的最后时间点
		
		
		/**
		 * 技能附加状态类型，如石化、减速之类的 
		 */		
		public var stateType:int = 0;
		
		public var cdUpdateListener:Function;
		
		// 计算用变量
		// 当前技能剩余CD时间
		private var _cdRemain:int = 0;
		public function set cdRemain(value:int):void
		{
			if(value < 0)
			{
				value = 0;
			}	
			if(_cdRemain != value)
			{
				_cdRemain = value;
				if(cdUpdateListener != null)
					cdUpdateListener();
			}
		}
		
		public function get cdRemain():int
		{
			return _cdRemain;
		}
		
	}
}

