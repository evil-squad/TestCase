package demo.enum {

	/**
	 * ID生成器 
	 * @author chenbo
	 * 
	 */	
	public class IDEnum {
		
		static private var _id : int = 100000;
		
		static public function get nextID() : int {
			return _id++;
		}
	}
}
