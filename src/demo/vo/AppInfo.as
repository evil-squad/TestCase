package demo.vo
{
	/**
	 * 外部加载模块信息 
	 * @author fly.liuyang
	 * 
	 */	
	public class AppInfo
	{
		/** APP名字 **/
		public var appName:String;
		/** APP类名,用于类反射 **/
		public var className:String;
		/** 加载的标题 **/
		public var loadingTitle:String;
		/** 资源名字 **/
		public var resName:String;
		/** 按钮名字， 这个不懂搞什么的 **/
		public var btnName:String;
		/** 是不是关闭全部面板时进行排除 **/
		public var isSpecialInCloseAll:Boolean;
		/** 显示的方位 九宫格  参考：PanelPosType **/
		public var posType:uint = 0;
		/** 显示的方位上的相对坐标 x**/
		public var pX:int = 0;
		/** 显示的方位上的相对坐标 y**/
		public var pY:int = 0;
		
	}
}