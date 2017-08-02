package demo.ui
{
	
	import away3d.events.Event;
	
	import demo.managers.GameManager;
	import demo.skill.SkillDetailVO;
	import demo.ui.cd.CDFace;
	
	import feathers.controls.Label;
	import feathers.controls.UIAsset;
	import feathers.utils.filter.NativeFilterPool;
	
	import org.client.mainCore.manager.EventManager;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.styles.ColorMatrixMeshStyle;

	public class IconCDFace extends Sprite
	{
		private var _cdFace:CDFace;
		
		private var _needCD:Boolean = true;
		
		/** 显示快捷键 */
		private var _shortcutKeyLab:Label;
		
		private var _iconSize:int;
		
		private var _skillVO:SkillDetailVO;
		
		private var _iconImage:UIAsset;
		private var _bgImage:UIAsset;
		
		public var isCircleCD:Boolean = false;
		
		public function IconCDFace($iconSize:int=40)
		{
			_iconSize = $iconSize;
			
			initIconBg();
			updateIcon();
		}
		
		private function initIconBg():void
		{
			_bgImage ||= new UIAsset();
			_bgImage.styleName = "ui/mainui/shortcut/jnd.png";
			this.addChildAt(_bgImage, 0);
		}
		
		/**----------------------------------------------------------------------------------*/
		public function get skillVO():SkillDetailVO
		{
			return _skillVO;
		}
		
		public function set skillVO(value:SkillDetailVO):void
		{
			if(_skillVO)
				_skillVO.cdUpdateListener = null;
			
			_skillVO = value;
			
			updateIcon();
			
			_skillVO.cdUpdateListener = onCdUpdate;
		}
		
		private function updateIcon():void
		{
			if(_iconImage == null)
			{
				_iconImage = new UIAsset();
				_iconImage.imageScaleMode = UIAsset.IMAGE_SCALE_MODE_AUTO;
				_iconImage.width = _iconImage.height = _iconSize;
				_iconImage.x = _iconImage.y = 2;
				this.addChild(_iconImage);
				_iconImage.addEventListener(TouchEvent.TOUCH, onTouch);
				_iconImage.addEventListener(Event.COMPLETE, onIconImageLoad);
			}
			if(_skillVO)_iconImage.styleName = "ui/icon/skill/" + _skillVO.clientId + ".png";
		}
		
		private function onIconImageLoad(ev:Event):void
		{
			EventManager.dispatchEvent("SkillIconLoad");
		}
		
		private function onTouch(e:TouchEvent):void
		{
			e.stopPropagation();

			var touch:Touch = e.getTouch(_iconImage,TouchPhase.ENDED);
			if(touch)
			{
				GameManager.getInstance().playerController.onSkillOpearate(_skillVO.clientId);
				return;
			}
			
			var meshStyle:ColorMatrixMeshStyle = _iconImage.style as ColorMatrixMeshStyle;
			touch = e.getTouch(_iconImage,TouchPhase.HOVER);
			if(touch)
			{
				meshStyle ||= new ColorMatrixMeshStyle();
				meshStyle.adjustBrightness(0.01);
				_iconImage.style = meshStyle;
			}else  if(meshStyle){
				meshStyle.reset();
			}
		}
		
		private function onCdUpdate():void
		{
			if(!_cdFace || !_cdFace.parent)
			{
				addCdFace();
			}
			if(_skillVO.cdRemain == 0)
				removeCDFace();
			else
				_cdFace.update(_skillVO.skillAloneCd - _skillVO.cdRemain,_skillVO.skillAloneCd);
		}
		
		private function removeCDFace():void
		{
			if(_cdFace)
			{
				CDFace.recyle(_cdFace);
				if (_cdFace.parent)
					_cdFace.parent.removeChild(_cdFace);
				//DisplayUtil.removeForParent(_cdFace);
				_cdFace = null;
				this.touchable = true;
			}
		}

		private function addCdFace():void
		{
			if(!_cdFace)
			{
				_cdFace = CDFace.create(_iconSize+4,_iconSize+4,null,isCircleCD);
			}
			setIsShowCdTm(_isShwoTm);
			this.addChild(_cdFace);
			this.touchable = false;
		}
		
		/**显示快捷栏提示*/
		public function showShortCutTip(value:String):void
		{
			if(_shortcutKeyLab == null)
			{
				_shortcutKeyLab = new Label();
				_shortcutKeyLab.color = 0xFFFF00;
				_shortcutKeyLab.nativeFilters = NativeFilterPool.onePixelBlackDropDownFilters;
				_shortcutKeyLab.fontSize = 10;
				_shortcutKeyLab.registerBitmapFonts("0.123456789");
			}
			_shortcutKeyLab.text = value;
			_shortcutKeyLab.touchable = false;
			addChild(_shortcutKeyLab);
		}
		
		private var _isShwoTm:Boolean = false; 
		
		public function setIsShowCdTm(isShow:Boolean):void
		{
			if(_cdFace == null)return;
			
			_isShwoTm = isShow;
			if(isShow)
			{
				_cdFace.showTmTxt();
			}
			else
			{
				_cdFace.hideTmTxt();
			}
		}

		public function get iconSize():int
		{
			return _iconSize;
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function destroy():void
		{
			if(_cdFace)
			{
				_cdFace.dispose();
				_cdFace = null;
			}
			if(_iconImage)
			{
				_iconImage.removeEventListeners(TouchEvent.TOUCH);
				_iconImage = null;
			}
			_skillVO.cdUpdateListener = null;
			_skillVO = null;
		}
		
		/** 清空 只是把显示数据清除 并不全部销毁 * */
		public function clear():void
		{
			removeCDFace();
			_skillVO.cdUpdateListener = null;
			_skillVO = null;
		}
	}
}