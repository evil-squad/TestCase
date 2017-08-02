package demo.ui
{
	import com.game.engine3D.manager.Stage3DLayerManager;
	
	import demo.enum.LayerEnum;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	
	import org.mokylin.skin.app.alert.AlertSkin;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 游戏弹窗提示
	 * @author wewell
	 * @modifier L.L.M.Sunny
	 * 修改时间：2015-10-10 下午3:05:12
	 */
	public class GameAlert extends Sprite
	{
		private static var _ins : GameAlert;

		public var skin : AlertSkin;
		private var okFCallBack : Function;
		private var cancelCallBack : Function;
		private var closeCallBack : Function;

		public function GameAlert()
		{
			skin = new AlertSkin();
			skin.lbTip.wordWrap = true;
			
			skin.toSprite(this);
			
			
			this.addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
		}
		
		/**
		 *当面板被点击时
		 */		
		protected function onTouch(e:TouchEvent):void
		{
			var t:Touch = e.getTouch(this, TouchPhase.ENDED);
			if(t != null && t.target != null)
			{
				onTouchTarget(t.target);
			}
		}

		protected function onTouchTarget(target : DisplayObject) : void
		{
			switch (target)
			{
				case skin.btnOk:
					if (okFCallBack != null)
						okFCallBack();
					hide();
					break;
				case skin.btnClose:
					if (closeCallBack != null)
						closeCallBack();
					hide();
					break;
				case skin.btnCancel:
					if (cancelCallBack != null)
						cancelCallBack();
					hide();
					break;
			}
		}

		public static function show(msg : String, title : String = "提示", onOk : Function = null, onCancel : Function = null) : GameAlert
		{
			if (!_ins)
				_ins = new GameAlert;
			_ins.skin.lbTip.text = msg;
			_ins.okFCallBack = onOk;
			_ins.cancelCallBack = onCancel;
			_ins.skin.title.htmlText = title;
			Stage3DLayerManager.starlingLayer.getLayer(LayerEnum.LAYER_ALERT).addChild(_ins);
			_ins.x = int((_ins.stage.stageWidth - _ins.width) / 2);
			_ins.y = int((_ins.stage.stageHeight - _ins.height) / 2);
			return _ins;
		}
		private function get btnOk():Button
		{
			return skin.hasOwnProperty("btnOk")?skin["btnOk"]:null;
		}
		
		private function get btnClose():Button
		{
			return skin.hasOwnProperty("btnClose")?skin["btnClose"]:null;
		}
		
		private function get btnCancel():Button
		{
			return skin.hasOwnProperty("btnCancel")?skin["btnCancel"]:null;
		}
		
		public function get isCheckSelected():Boolean
		{
			return skin["cboxTip"] && skin["cboxTip"].isSelected;
		}
		
		private function get cboxTip():Check
		{
			return skin.hasOwnProperty("cboxTip")?skin["cboxTip"]:null;
		}
		
		private function get lbTip():Label
		{
			return skin.hasOwnProperty("lbTip")?skin["lbTip"]:null;
		}
		
		private function get title():Label
		{
			return skin.hasOwnProperty("title")?skin["title"]:null;
		}
		public static function hide() : void
		{
			if (_ins)
				_ins.removeFromParent();
		}
	}
}
