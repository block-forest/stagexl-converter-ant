package example.wonderfl.xmas{
import flash.display.Shape;

class StarUnit extends Shape {
    private var radius:uint = 10;
    private var color:uint = 0xFFFFFF;
    
    public function StarUnit(r:uint = 10, c:uint = 0xFFFFFF, forceStar:Boolean=false){
        cacheAsBitmap = true;
        radius = r;
        color = c;
        
        graphics.lineStyle(0, color);
        graphics.beginFill(color);
        
        if (Math.random() > 0.2 || forceStar){
            drawStar();
        } else {
            radius *= 3;
            drawSnowFlower();
        }
    }
    
    private function drawStar():void {
        graphics.moveTo(radius, 0);
        for (var i:int = 1; i < 11; i++){
            var radius2:Number = radius;
            if (i % 2 > 0){
                radius2 = radius / 2;
            }
            var angle:Number = Math.PI * 2 / 10 * i;
            graphics.lineTo(Math.cos(angle) * radius2, Math.sin(angle) * radius2);
        }
    }
    
    private function drawSnowFlower():void {
        graphics.moveTo(radius/10, 0);
        for (var i:int = 0; i < 24; i++){
            var radius2:Number = radius;
            var mod:int = i % 4;
            if (mod == 1){
                radius2 = radius;
            } else if (mod == 3){
                radius2 = radius / 2;
            } else {
                radius2 = radius / 10;
            }
            var angle:Number = Math.PI * 2 / 24 * i;
            graphics.lineTo(Math.cos(angle) * radius2, Math.sin(angle) * radius2);
        }
    }
}
}
