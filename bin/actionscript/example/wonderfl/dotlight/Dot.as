package example.wonderfl.dotlight {
	/**
	 * @author nilsdoehring
	 */
	public class Dot {

    public var x:Number = 0;
    public var y:Number = 0;
    public var vx:Number = 0;
    public var vy:Number = 0;
    public var cx:Number = 0;
    public var cy:Number = 0;
    public var px:Number = 0;
    public var py:Number = 0;
    public var angle:Number = 0;
    public var power:Number = 1;
    public var energy:Number = 2;
    public var rgb:uint = 0xFFFFFF;

    public function Dot(_x:Number, _y:Number, a:Number, p:Number) {
        cx = _x;
        cy = _y;
        angle =a;
        power = p;
    }

}
}
