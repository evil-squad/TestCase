package demo.display2D {

	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	import demo.display3D.Avatar3D;

	public interface IBind3D {
		function get bindTarget() : ObjectContainer3D;
		function set bindTarget(value : ObjectContainer3D) : void;
		function get bindAvatar() : Avatar3D;
		function set bindAvatar(value : Avatar3D) : void;
		function set bindOffset(value : Vector3D) : void;
		function get bindOffset() : Vector3D;
		function updateTranform() : void;
	}
}
