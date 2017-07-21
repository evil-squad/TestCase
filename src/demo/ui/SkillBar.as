package demo.ui {

	import demo.skill.SkillDetailVO;
	
	import starling.display.Sprite;

	public class SkillBar extends Sprite {
		
		private var skillCdFaces : Vector.<SkillDetailVO> = new Vector.<SkillDetailVO>();

		public function SkillBar() {
			super();
		}

		/**
		 * 获取技能槽index处的skill
		 * @return
		 *
		 */
		public function getSkillAtIndex(index : int) : SkillDetailVO {
			if (skillCdFaces.length <= index) {
				return null;
			}
			return skillCdFaces[index];
		}

		/**
		 *
		 * @param skillVO
		 * @param key 快捷键
		 *
		 */
		public function addSkillCdIcon(skillVO : SkillDetailVO, key : String = "") : void {
			var cdFace : IconCDFace = new IconCDFace(40);
			cdFace.skillVO = skillVO;

			if (key) {
				cdFace.showShortCutTip(key);
			}
			
			this.addChild(cdFace);
			this.skillCdFaces.push(skillVO);
			this.updateLayout();
		}
		
		/**
		 * 清理，为下一次切换场景做准备
		 */
		public function clear() : void {
			var index : int = 0;
			while (numChildren > 0) {
				var child : IconCDFace = getChildAt(0) as IconCDFace;
				child.destroy();
				removeChild(child, true);
			}
			skillCdFaces.length = 0;
		}
		
		public function updatePos() : void {
			if(!stage)return;
			this.x = (stage.stageWidth - 220) / 2;
			this.y = stage.stageHeight - 46;
		}
		
		private function updateLayout() : void {
			var index : int = 0;
			for (var i : int = 0; i < numChildren; i++) {
				var child : IconCDFace = getChildAt(i) as IconCDFace;
				if (child) {
					child.x = index * (child.iconSize + 8);
					index++;
				}
			}
			updatePos();
		}
		
		public function get skillCount():int
		{
			return skillCdFaces.length;
		}
	}
}
