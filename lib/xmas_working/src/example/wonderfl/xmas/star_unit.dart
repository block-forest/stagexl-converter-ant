 part of xmas;

 //http://wonderfl.net/c/bSES
class StarUnit extends Shape {
     int radius = 10;
     int color = 0xFFFFFFFF;
	 StarUnit([int r=10, int c=0xFFFFFFFF, bool forceStar=false]){
        /*cacheAsBitmap = true;*/
        radius = r;
        color = c;
        
        /*
        graphics.lineStyle(0, color);
        graphics.beginFill(color);
        */
        
        if (new Random().nextDouble() > 0.2 || forceStar){
            drawStar();
        } else {
            radius *= 3;
            drawSnowFlower();
        }
        
        graphics.fillColor(color);
    }
    
      void drawStar() {
        graphics.moveTo(radius, 0);
        for (int i = 1; i < 11; i++){
            num radius2 = radius;
            if (i % 2 > 0){
                radius2 = radius / 2;
            }
            num angle = PI * 2 / 10 * i;
            graphics.lineTo(cos(angle) * radius2, sin(angle) * radius2);
        }
    }
    
      void drawSnowFlower() {
        graphics.moveTo(radius/10, 0);
        for (int i = 0; i < 24; i++){
            num radius2 = radius;
            int mod = i % 4;
            if (mod == 1){
                radius2 = radius;
            } else if (mod == 3){
                radius2 = radius / 2;
            } else {
                radius2 = radius / 10;
            }
            num angle = PI * 2 / 24 * i;
            graphics.lineTo(cos(angle) * radius2, sin(angle) * radius2);
        }
    }
}

