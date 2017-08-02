package demo.state {

	/**
	 * 玩家状态机接口
	 * @author chenbo
	 *
	 */
	public interface IPlayerState {
		function move() : Boolean;
		function stop() : Boolean;
		function cast(isCritical : Boolean = false) : Boolean;
		function dodge() : Boolean;
		function loot() : Boolean;
		function stun() : Boolean;
		function hurt() : Boolean;
		function die() : Boolean;
		function castEnable(isCritical : Boolean = false) : Boolean
	}
}
