package example.wonderfl.dotlight {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	/**
	 * @author nilsdoehring
	 */
	public class DotLight extends Sprite {
    private var rect:Rectangle;
    private var canvas:BitmapData;
    private var map:BitmapData;
    private var sparkle:BitmapData;
    private var afterglow:BitmapData;
    private static var scale:uint = 4;
    private var aMatrix:Matrix;
    private var colorTrans:ColorTransform;
    private var blur:BlurFilter;
    private var sMatrix:Matrix;
    private var offsets:Array;
		private var seed : uint;
		private var light : EmitLight;

    public function DotLight(r:Rectangle) {
        rect = r;
        init();
    }

    private function init():void {
        afterglow = new BitmapData(rect.width*2/scale, rect.height*2/scale, false, 0xFF000000);
        var aBitmap:Bitmap = new Bitmap(afterglow, PixelSnapping.AUTO, true);
        aBitmap.scaleX = aBitmap.scaleY = scale/2;
        addChild(aBitmap);
        canvas = new BitmapData(rect.width, rect.height, true, 0x00000000);
        var cBitmap:Bitmap = new Bitmap(canvas);
        cBitmap.blendMode = BlendMode.ADD;
        addChild(cBitmap);
        map = new BitmapData(rect.width/scale, rect.height/scale, false, 0xFF000000);
        offsets = [new Point(), new Point()];
        seed = Math.floor(Math.random()*1000);
        sparkle = new BitmapData(rect.width/scale, rect.height/scale, true, 0x00000000);
        var sBitmap:Bitmap = new Bitmap(sparkle);
        sBitmap.smoothing = true;
        sBitmap.blendMode = BlendMode.ADD;
        sBitmap.scaleX = sBitmap.scaleY = scale;
        addChild(sBitmap);
        aMatrix = new Matrix(2/scale, 0, 0, 2/scale, 0, 0);
        colorTrans = new ColorTransform(0.1, 0.1, 0.1);
        blur = new BlurFilter(2, 2, 1);
        sMatrix = new Matrix(1/scale, 0, 0, 1/scale, 0, 0);
        light = new EmitLight(canvas, map, scale);
    }
    public function start():void {
        addEventListener(Event.ENTER_FRAME, draw, false, 0, true);
    }
    public function stop():void {
        removeEventListener(Event.ENTER_FRAME, draw);
    }
    private function draw(evt:Event):void {
        var offset:Number = getTimer()*0.05;
        offsets[0].x = offsets[1].y = offset;
        map.perlinNoise(rect.width/scale, rect.height/scale, 2, seed, true, true, 1, false, offsets);
        light.create(10);
        canvas.lock();
        canvas.fillRect(canvas.rect, 0x00000000);
        light.emit();
        canvas.unlock();
        sparkle.lock();
        sparkle.fillRect(sparkle.rect, 0x00000000);
        sparkle.draw(canvas, sMatrix);
        sparkle.unlock();
        afterglow.lock();
        afterglow.draw(canvas, aMatrix, colorTrans, BlendMode.ADD);
        afterglow.applyFilter(afterglow, afterglow.rect, new Point(), blur);
        afterglow.unlock();
    }

}
}
