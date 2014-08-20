package example.wonderfl.xmas {
    import com.greensock.*;
    import com.greensock.easing.Bounce;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.filters.BlurFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    
    public class Main extends Sprite {
        private var rect:Rectangle;
        private static var point:Point = new Point();
        private var container:Sprite;
        private var gallery:Sprite;
        private var helix:Sprite;
        private var initColor:Number = 0xfefe84;
        private static var blur:BlurFilter;
        private var bitmapData:BitmapData;
        private var bitmap:Bitmap;
        private var startCount:int = 100;
        private var cx:int = 0;
        private var timer:Timer;
        private var galItems:Vector.<StarUnit>;
        private var canSpin:Boolean = false;
        private var dir:int = -1;
        private var bigStar:StarUnit;
        private static var radian:Number = Math.PI / 180;
        
        public function Main(){
            init();
        }
        
        private function init():void {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            graphics.beginFill(0x5f0e17);
            graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            graphics.endFill();
            
            rect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            
            bitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
            bitmap = new Bitmap(bitmapData);
            addChild(bitmap);
            
            blur = new BlurFilter(50, 50, 1);
            
            container = new Sprite();
            gallery = new Sprite();
            helix = new Sprite();
            gallery.addChild(helix);
            container.addChild(gallery);
            addChild(container);
            
            gallery.x = stage.stageWidth / 2;
            gallery.y = 0; //stage.stageHeight / 2;
            gallery.z = 800;
            
            galItems = new Vector.<StarUnit>();
            
            for (var i:int = 0; i < startCount; i++){
                galItems[i] = new StarUnit(20, initColor);
            }
            startCount--;
            
            gallery.rotationX = -90;
            timer = new Timer(40);
            timer.addEventListener(TimerEvent.TIMER, create, false, 0, true);
            timer.start();
            
            addEventListener(Event.ENTER_FRAME, loop);
        }
        
        private function create(evt:TimerEvent):void {
            var star:StarUnit;
            if (dir<0) {
                star = galItems[startCount];
            } else {
                star = new StarUnit(20, initColor);
                galItems.push(star);
            }
            var rad:int = (startCount * 6) + 20;

            star.blendMode = BlendMode.ADD;
            star.x = Math.sin(rad) * rad;
            star.y = Math.cos(rad) * rad;
            star.z = (startCount - 10) * 10;
            star.rotationX = Math.random()*360;
            star.rotationY = 90;
            
            star.rotationX = (rad / (Math.PI / 180)) + 90;
            helix.addChild(star);

            startCount += dir;
    
            if (startCount < 0) {
                canSpin = true;
                bigStar = new StarUnit(60, initColor, true);
                bigStar.rotationY = 90;
                bigStar.blendMode = BlendMode.ADD;
                bigStar.z = -bigStar.height*3;
                TweenLite.to(bigStar, 1, {z:-bigStar.height*1.5, ease:Bounce.easeOut});
                helix.addChild(bigStar);
                timer.stop();
            }
        }
        
        private function loop(evt:Event):void {
            if (canSpin){
                cx -= 2;
            }
            var len:int = galItems.length;
            for (var i:int = 0; i < len; i++) {
                galItems[i].rotationZ += 10;
            }
            TweenLite.to(helix, 2, {rotation: (cx - (stage.stageWidth / 2)) * 1.6});

            bitmapData.lock();
            bitmapData.draw(container, null, null, BlendMode.SCREEN, null, true);
            bitmapData.applyFilter(bitmapData, rect, point, blur);
            bitmapData.unlock();
        }
    }

}

