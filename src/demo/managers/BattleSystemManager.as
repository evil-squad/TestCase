package demo.managers {

	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.core.math.Matrix3DUtils;
	
	import demo.display3D.Avatar3D;
	import demo.display3D.Monster3D;
	import demo.display3D.Player3D;
	import demo.enum.SkillDefineEnum;
	import demo.helper.Scene_TaggerHelper;
	import demo.skill.SkillDetailVO;
	import demo.skill.magic.MagicBase;
	import demo.utils.CircleIntersectFan;
	import demo.utils.MathUtils;
	import demo.vo.ServerSkillVO;

	public class BattleSystemManager {

		private static var _instance : BattleSystemManager;

		public static function getInstance() : BattleSystemManager {
			_instance = _instance || new BattleSystemManager();
			return _instance;
		}
		
		private var serverSkills : Vector.<ServerSkillVO>;						// 技能集合
		private var deadAvatars  : Dictionary;									// ......
		private var magicIdx     : int = 904444;
		private var _calcVector  : Vector3D = new Vector3D();
		private var _attackIds   : Vector.<int> = new Vector.<int>();

		public function BattleSystemManager() {
			serverSkills = new Vector.<ServerSkillVO>();
			deadAvatars  = new Dictionary();
		}
		
		public function reset() : void {
			serverSkills.length = 0;
			deadAvatars = new Dictionary();
		}
		
		public function addAction(action : ServerSkillVO, skill : SkillDetailVO) : void {
			action.skillId = skill.clientId;
			action.surviveTime = 0;
			action.excuteTimeList = new Vector.<int>();
			action.excuteTimeList.push(skill.excuteDelay);
			for (var i : int = 0; i < skill.excuteExtraCount; i++) {
				action.excuteTimeList.push(skill.excuteDelay + (i + 1) * skill.excuteExtraDelay);
			}
			serverSkills.push(action);
		}
		
		public function update(curTime : int, deltaTime : int) : void {
			for (var i : int = 0; i < serverSkills.length; i++) {
				var ssvo : ServerSkillVO = serverSkills[i];
				if (ssvo.excuteTimeList.length == 0) {
					serverSkills.splice(i, 1);
					i--;
					continue;
				}
				ssvo.surviveTime += deltaTime;
				if (ssvo.excuteTimeList[0] <= ssvo.surviveTime) {
					processAction(ssvo);
					ssvo.excuteTimeList.shift();
				}
			}
			//怪物复活
			var rebornList : Vector.<Avatar3D> = new Vector.<Avatar3D>();
			for (var obj : Avatar3D in deadAvatars) {
				var during : int = deadAvatars[obj] + deltaTime;
				if (during >= 10000) {
					rebornList.push(obj);
				} else {
					deadAvatars[obj] = during;
				}
			}
			for each (var avatar : Avatar3D in rebornList) {
				avatar.onNetReborn();
				onNetBeAttacked(avatar, avatar.maxHp, 0, avatar.id, 0);
				delete deadAvatars[avatar];
			}
		}
		
		private function processAction(action : ServerSkillVO) : void {
			var world  : WorldManager = WorldManager.instance;
			var caster : Avatar3D = world.getAvatar3D(action.casterId);
			if (caster == null) {
				return;
			}
			
			var skill  : SkillDetailVO = SkillManager.getInstance().getSkillInfo(action.skillId);
			var target : Avatar3D = null;
			
			if (skill.releaseType == SkillDefineEnum.TARGET_SINGLE_ENEMY) {
				if (skill.damageCount > 0) {
					target = world.getAvatar3D(action.suffererId);
					if (target && target.isDead == false) {
						calcDamage(caster, target, skill);
					}
				}
			} else if (skill.damageCount > 0) {
				if (skill.releaseType == SkillDefineEnum.TARGET_FREE) {
					circleAttack(caster, skill.skillRadius, skill, skill.damageCount, caster.x, caster.z);
				} else if (skill.releaseType == SkillDefineEnum.TARGET_DIRECTION) {
					// 扇形检测
					var vec0 : Vector3D = Matrix3DUtils.CALCULATION_VECTOR3D;
					vec0.setTo(action.x - caster.x, 0, action.y - caster.z);
					vec0.normalize();
					vec0.scaleBy(skill.skillRadius);
					vec0.setTo(vec0.x + caster.x, 0, vec0.z + caster.z);
					sectorAttack(caster, skill.skillRadius, skill, skill.damageCount, caster.x, caster.z, vec0.x, vec0.z);
				}
			}
			
			if (skill.createMagicId > 0) {
				var i     : int = 0;
				var angle : Number = 0;
				var magic : MagicBase = null;;
				// magic对象创建时候的类型
				// 0:从施法者位置出发，到技能指定位置
				// 1:从施法者出发，圆形散开多个飞出
				// 2:从目标位置出发，到技能指定位置
				// 3:类似寒冰射手的n发子弹.
				if (skill.createMagicType == SkillDefineEnum.MAGIC_0) {
					magic = MagicBase.CreateMagic(magicIdx++, caster.id, skill.createMagicId, action.suffererId, caster.x, caster.z, action.x, action.y);
					WorldManager.instance.addOperator(magic);
				} else if (skill.createMagicType == SkillDefineEnum.MAGIC_1) {
					for (i = 0; i < 18; i++) {
						angle = i / 18 * Math.PI * 2;
						var resultX : int = 100 * Math.sin(angle) + caster.x;
						var resultY : int = 100 * Math.cos(angle) + caster.z;
						magic = MagicBase.CreateMagic(magicIdx++, caster.id, skill.createMagicId, action.suffererId, caster.x, caster.z, resultX, resultY);
						WorldManager.instance.addOperator(magic);
					}
				} else if (skill.createMagicType == SkillDefineEnum.MAGIC_2) {
					target = world.getAvatar3D(action.suffererId);
					magic = MagicBase.CreateMagic(magicIdx++, caster.id, skill.createMagicId, action.suffererId, target.x, target.z, action.x, action.y);
					WorldManager.instance.addOperator(magic);
				} else if (skill.createMagicType == SkillDefineEnum.MAGIC_3) {
					angle = -int(5 / 2) * 12;
					for (i = 0; i < 5; i++) {
						var point : Point = MathUtils.rotatePoint2D(action.x - caster.x, action.y - caster.z, angle);
						angle += 12;
						point.setTo(caster.x + point.x, caster.z + point.y);
						magic = MagicBase.CreateMagic(magicIdx++, caster.id, skill.createMagicId, action.suffererId, caster.x, caster.z, point.x, point.y);
						WorldManager.instance.addOperator(magic);
					}
				}
			}
		}
		
		public function circleAttack(caster : Avatar3D, range : int, skill : SkillDetailVO, attackCount : int, centerX : int, centerY : int, withOutIds : Vector.<int> = null) : Vector.<int> {
			_attackIds.length = 0;

			var target : Avatar3D = null;
			var world  : WorldManager = WorldManager.instance;
			var count  : int = 0;

			if (caster is Monster3D) {
				for each (target in world.players) {
					if (target.isDead) {
						continue;
					}
					if (withOutIds && withOutIds.indexOf(target.id) >= 0) {
						continue;
					}
					if (target.distanceToPos(centerX, centerY) > range + caster.radius + target.radius) {
						continue;
					}
					calcDamage(caster, target, skill);
					_attackIds.push(target.id);
					count++;
					if (count >= attackCount) {
						break;
					}
				}
			} else if (caster is Player3D) {
				for each (target in world.monsters) {
					if (target.isDead) {
						continue;
					}
					if (withOutIds && withOutIds.indexOf(target.id) >= 0) {
						continue;
					}
					if (target.distanceToPos(centerX, centerY) > range + caster.radius + target.radius) {
						continue;
					}
					calcDamage(caster, target, skill);
					count++;
					_attackIds.push(target.id);
					if (count >= attackCount) {
						break;
					}
				}
			}
			
			return _attackIds;
		}

		public function sectorAttack(caster : Avatar3D, range : int, skill : SkillDetailVO, attackCount : int, centerX : int, centerY : int, endX : int, endY : int, withOutIds : Vector.<int> = null) : Vector.<int> {
			_attackIds.length = 0;

			var theta  : Number = Math.cos(60 / 180 * Math.PI);
			var target : Avatar3D;
			var world  : WorldManager = WorldManager.instance;
			var count  : int;
			
			if (caster is Monster3D) {
				for each (target in world.players) {
					if (target.isDead) {
						continue;
					}
					if (withOutIds && withOutIds.indexOf(target.id) >= 0) {
						continue;
					}
					if (target.distanceToPos(centerX, centerY) > range + caster.radius + target.radius) {
						continue;
					}
					if (!CircleIntersectFan.IsCircleIntersectFan(target.x, target.z, target.radius, centerX, centerY, endX, endY, theta)) {
						continue;
					}
					calcDamage(caster, target, skill);
					_attackIds.push(target.id);
					count++;
					if (count >= attackCount) {
						break;
					}
				}
			} else if (caster is Player3D) {
				for each (target in world.monsters) {
					if (target.isDead) {
						continue;
					}
					if (withOutIds && withOutIds.indexOf(target.id) >= 0) {
						continue;
					}
					if (target.distanceToPos(centerX, centerY) > range + caster.radius + target.radius) {
						continue;
					}
					if (!CircleIntersectFan.IsCircleIntersectFan(target.x, target.z, target.radius, centerX, centerY, endX, endY, theta)) {
						continue;
					}
					calcDamage(caster, target, skill);
					count++;
					_attackIds.push(target.id);
					if (count >= attackCount) {
						break;
					}
				}
			}

			return _attackIds;
		}
		
		public function singleAttack(caster : Avatar3D, sufferer : Avatar3D, skill : SkillDetailVO) : void {
			calcDamage(caster, sufferer, skill);
		}

		private function calcDamage(caster : Avatar3D, sufferer : Avatar3D, skill : SkillDetailVO) : void {
			var damageMulti : Number = 1;
			var resultHp    : Number;
			var reason      : int = SkillDefineEnum.RS_NORMAL;
			//无敌
			if (sufferer.godMode) {
				reason = SkillDefineEnum.RS_MISS;
				resultHp = sufferer.hp;
			} else if (Math.random() > 0.95) {
				resultHp = sufferer.hp;
				reason = SkillDefineEnum.RS_MISS;
			} else if (Math.random() > 0.95) {
				resultHp = sufferer.hp;
				reason = SkillDefineEnum.RS_BLOCK;
			} else if (Math.random() > 0.95) {
				resultHp = sufferer.hp;
				reason = SkillDefineEnum.RS_RESIST;
			} else {
				if (Math.random() > 0.6) {
					reason = SkillDefineEnum.RS_CRITICAL;
					damageMulti = 1.5;
				}
				
				var damage : Number = 160 + Math.random() * 80;
				damage *= damageMulti * skill.damageMulti;

				if (sufferer.hp - damage > sufferer.maxHp) {
					resultHp = sufferer.maxHp;
				} else {
					resultHp = sufferer.hp - damage;
					if (resultHp <= 0) {
						resultHp = 0;
						sufferer.onNetDead();
					}
				}
			}
			if (reason != SkillDefineEnum.RS_MISS && reason != SkillDefineEnum.RS_BLOCK && reason != SkillDefineEnum.RS_RESIST) {
				addAttackEffect2(sufferer, skill);
			}
			onNetBeAttacked(sufferer, resultHp, skill.clientId, caster.id, reason);
		}
		
		/**
		 *技能效果2！
		 */

		private function addAttackEffect2(sufferer : Avatar3D, skill : SkillDetailVO) : void {
			if (sufferer == null || sufferer.aiController == null) {
				return;
			}
			if (sufferer.isDead) {
				return;
			}
			if (skill.stateType == SkillDefineEnum.SKILL_STATE_PETRIFY) {
				sufferer.aiController.stone();
			}
		}
		
		
		private function onNetBeAttacked(target : Avatar3D, Hp : Number, SkillId : uint, ModifierId : uint, reason : int) : void {
			var deltaHp : Number = Hp - target.hp;
			if (deltaHp > 0) {
				onNetBeHealth(target, deltaHp, SkillId, ModifierId, reason);
			} else if (deltaHp <= 0) {
				deltaHp = -deltaHp;
				onNetBeHurt(target, deltaHp, SkillId, ModifierId, reason);
			}
			target.hp = Hp;
		}
		
		public static const Color_YELLOW : int = 0xFFFF00;
		public static const Color_GREEN  : int = 0x00FF00;
		public static const Color_WHITE  : int = 0xFFFFFF;
		public static const Color_RED    : int = 0xFF0000;
		public static const Color_OTHER  : int = 0x00FFFF;
		public static const Color_BLUE   : int = 0x0000FF;

		private function onNetBeHurt(target : Avatar3D, deltaHp : int, skillId : uint, modifierId : uint, reason : int) : void {
			var mainPlayer : Avatar3D = GameManager.getInstance().mainRole;
			if (mainPlayer == null) {
				return;
			}
			var playHurt : Boolean = false;
			var isWithMe : Boolean = target == mainPlayer || modifierId == mainPlayer.id;
			var tweenDis : int = 0;
			var dirVec   : Vector3D = null;
			
			//未初始化,显示不出位置
			if (target.showContainer == null || mainPlayer.showContainer == null) {
				return;
			}
			
			if (reason == SkillDefineEnum.RS_NORMAL) {
				if (isWithMe) {
					// 受伤字幕(普通伤害值不为0)
					if (deltaHp != 0) {
						if (target == mainPlayer) {
							Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_shuxing_jian", -deltaHp, null, null, Scene_TaggerHelper.tweenTypeEnemyHpDecrease);
							if (target.showContainer2) {
								Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_shuxing_jian", -deltaHp, null, null, Scene_TaggerHelper.tweenTypeEnemyHpDecrease);
							}
						} else {
							tweenDis = 200 + Math.random() * 100;
							dirVec = Matrix3DUtils.CALCULATION_VECTOR3D;
							dirVec.x = target.showContainer.x - mainPlayer.showContainer.x;
							dirVec.y = target.showContainer.y - mainPlayer.showContainer.y;
							dirVec.normalize();
							dirVec.scaleBy(tweenDis);
							Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_diaoxue_df", -deltaHp, null, null, Scene_TaggerHelper.tweenTypeEnemyHpDecrease, new Point(0, -60), new Point(dirVec.x, dirVec.y - 60));
							if (target.showContainer2) {
								Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_diaoxue_df", -deltaHp, null, null, Scene_TaggerHelper.tweenTypeEnemyHpDecrease, new Point(0, -60), new Point(dirVec.x, dirVec.y - 60));
							}
						}
					}
				}
				playHurt = true;
			} else if (reason == SkillDefineEnum.RS_MISS) {
				// miss
				if (isWithMe) {
					if (target == mainPlayer) {
						Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_shanbi_zj", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						if (target.showContainer2) {
							Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_shanbi_zj", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						}
					} else {
						Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_shanbi_df", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						if (target.showContainer2) {
							Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_shanbi_df", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						}
					}
				}
			} else if (reason == SkillDefineEnum.RS_BLOCK) {
				// 格挡
				if (isWithMe) {
					if (target == mainPlayer) {
						Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_shuxing_jia_fy", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						if (target.showContainer2) {
							Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_shuxing_jia_fy", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						}
					} else {
						Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_shuxing_jian_fy", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						if (target.showContainer2) {
							Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_shuxing_jian_fy", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						}
					}
				}
			} else if (reason == SkillDefineEnum.RS_CRITICAL) {
				if (isWithMe) {
					if (deltaHp != 0) {
						// 暴击
						if (target == mainPlayer) {
							Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_baoji_zj", -deltaHp, "af_num_baoji_zj_bj", null, Scene_TaggerHelper.tweenTypeEnemyHpDecrease);
							if (target.showContainer2) {
								Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_baoji_zj", -deltaHp, "af_num_baoji_zj_bj", null, Scene_TaggerHelper.tweenTypeEnemyHpDecrease);
							}
						} else {
							tweenDis = 200 + Math.random() * 100;
							dirVec = Matrix3DUtils.CALCULATION_VECTOR3D;
							dirVec.x = target.showContainer.x - mainPlayer.showContainer.x;
							dirVec.y = target.showContainer.y - mainPlayer.showContainer.y;
							dirVec.normalize();
							dirVec.scaleBy(tweenDis);
							Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_baoji_df", -deltaHp, "af_num_baoji_df_bj", new Point(-200, 20), Scene_TaggerHelper.tweenTypeEnemyHpDecrease, new Point(0, -60), new Point(dirVec.x, dirVec.y - 60));
							if (target.showContainer2) {
								Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_baoji_df", -deltaHp, "af_num_baoji_df_bj", new Point(-200, 20), Scene_TaggerHelper.tweenTypeEnemyHpDecrease, new Point(0, -60), new Point(dirVec.x, dirVec.y - 60));
							}
						}
					}
				}
				playHurt = true;
			} else if (reason == SkillDefineEnum.RS_RESIST) {
				// 抵抗
				if (isWithMe) {
					if (target == mainPlayer) {
						Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_mianyi_zj", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						if (target.showContainer2) {
							Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_mianyi_zj", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						}
					} else {
						Scene_TaggerHelper.showAttackFace(target.showContainer, "af_num_mianyi_df", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						if (target.showContainer2) {
							Scene_TaggerHelper.showAttackFace(target.showContainer2, "af_num_mianyi_df", 0, null, null, Scene_TaggerHelper.tweenTypeBlink);
						}
					}
				}
			}
			// 受伤特效
			if (playHurt) {
				SkillManager.getInstance().onHit(target, skillId, modifierId, reason);
			}
		}

		private function onNetBeHealth(target : Avatar3D, deltaHp : int, SkillId : uint, ModifierId : uint, reason : int) : void {
			if (reason == SkillDefineEnum.RS_NULL) {
				return;
			}
			SkillManager.getInstance().onHeal(target, SkillId);
		}
		
		public function searchEnemyCount(caster : Avatar3D, radius : int, centerX : int, centerY : int) : int {
			
			var target : Avatar3D = null;
			var world  : WorldManager = WorldManager.instance;
			var count  : int = 0;
			
			if (caster is Monster3D) {
				for each (target in world.players) {
					if (target.isDead) {
						continue;
					}
					if (target.distanceToPos(centerX, centerY) > radius + target.radius) {
						continue;
					}
					count++;
				}
			} else if (caster is Player3D) {
				for each (target in world.monsters) {
					if (target.isDead) {
						continue;
					}
					if (target.distanceToPos(centerX, centerY) > radius + target.radius) {
						continue;
					}
					count++;
				}
			}
			return count;
		}

		private function showTip(target : Avatar3D, value : String, color : int, reason : int) : void {
			target.popTextAnim(value, color);
		}
		
	}
}
