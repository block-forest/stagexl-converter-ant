package example.wonderfl.dotlight {
	import flash.display.BitmapData;
	/**
	 * @author nilsdoehring
	 */
	public class Bresenham {

    private var canvas:BitmapData;

    public function Bresenham(c:BitmapData) {
        canvas = c;
    }

    public function draw(x0:int, y0:int, x1:int, y1:int, color:uint, alpha:Number):void {
        var steep:Boolean = Math.abs(y1 - y0) > Math.abs(x1 - x0);
        var t:int;
        if (steep) {
            t = x0;
            x0 = y0;
            y0 = t;
            t = x1;
            x1 = y1;
            y1 = t;
        }
        if (x0 > x1) {
            t = x0;
            x0 = x1;
            x1 = t;
            t = y0;
            y0 = y1;
            y1 = t;
        }
        var dx:int = x1 - x0;
        var dy:int = Math.abs(y1 - y0);
        var e:int = dx*0.5;
        var ys:int = (y0 < y1) ? 1 : -1;
        var y:int = y0;
        for (var x:int = x0; x <= x1; x++) {
            if (steep) {
                plot(y, x, color, alpha);
            } else {
                plot(x, y, color, alpha);
            }
            e = e - dy;
            if (e < 0) {
                y = y + ys;
                e = e + dx;
            }
        }
    }
    private function plot(x:int, y:int, c:uint, a:Number):void {
        canvas.setPixel32(x, y, c | ((a*0xFF) << 24));
    }

}
}
