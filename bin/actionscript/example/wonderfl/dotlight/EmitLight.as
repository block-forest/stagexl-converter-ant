package example.wonderfl.dotlight {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	/**
	 * @author nilsdoehring
	 */
	public class EmitLight {
    private var canvas:BitmapData;
    private var map:BitmapData;
    private var rect:Rectangle;
    private var scale:uint;
    private var cx:uint;
    private var cy:uint;
    private var radius:uint;
    private static var yScale:Number = 0.25;
    private var dots:Array;
    private static var acceleration:Number = 0.01;
    private static var gravity:Number = 0.03;
		private static var deceleration : Number = 0.008;
		private var color : ColorHSV;
		private static var length : Number = 2;
		private var manager : Bresenham;

    public function EmitLight(c:BitmapData, m:BitmapData, s:uint) {
        canvas = c;
        map = m;
        rect = canvas.rect;
        scale = s;
        cx = rect.width*0.5;
        cy = rect.height*0.85;
        radius = rect.width*0.4;
        init();
    }

    private function init():void {
        dots = new Array();
        color = new ColorHSV(0, 0.4);
        manager = new Bresenham(canvas);
    }
    public function create(max:uint):void {
        for (var n:uint = 0; n < max; n++) {
            var angle:Number = Math.random()*360;
				var power : Number = Math.random() + 0.5;
				var dot : Dot = new Dot(cx, cy, angle, power);
            dot.x = cx + Math.cos(angle*Math.PI/180)*radius;
            dot.y = cy + Math.sin(angle*Math.PI/180)*radius*yScale;
            dot.px = dot.x;
            dot.py = dot.y;
            color.h = 180;
            dot.rgb = color.value;
            dots.push(dot);
        }
    }
    public function emit():void {
        for (var n:uint = 0; n < dots.length; n++) {
            var dot:Dot = dots[n];
            var c:uint = map.getPixel(dot.x/scale, dot.y/scale);
            dot.cx += ((((c >> 16) & 0xFF) - 0x80) / 0x80)*5;
            dot.vy += gravity*dot.power;
            dot.vy *= 0.99;
            dot.vx += acceleration;
            dot.angle += dot.vx;
            dot.cy -= dot.vy;
            var px:Number = Math.cos(dot.angle*Math.PI/180)*radius;
            var py:Number = Math.sin(dot.angle*Math.PI/180)*radius*yScale;
            dot.x = dot.cx + px*(dot.energy*0.4 + 0.2);
            dot.y = dot.cy + py*(dot.energy*0.4 + 0.2);
            dot.energy -= deceleration;
            var x0:int = dot.x;
            var y0:int = dot.y;
            var x1:int = dot.x - (dot.x - dot.px)*length;
            var y1:int = dot.y - (dot.y - dot.py)*length;
            color.h = 180 + 50*dot.energy*0.5;
            dot.rgb = color.value;
            manager.draw(x0, y0, x1, y1, dot.rgb, dot.energy*0.5);
            dot.px = dot.x;
            dot.py = dot.y;
            if (dot.energy < 0) {
                dots.splice(n, 1);
                dot = null;
            }
        }
    }

}
}
