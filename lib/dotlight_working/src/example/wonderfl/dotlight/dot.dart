 part of dotlight;
	/**
	 * @author nilsdoehring
	 */
	 class Dot {

     num x = 0;
     num y = 0;
     num vx = 0;
     num vy = 0;
     num cx = 0;
     num cy = 0;
     num px = 0;
     num py = 0;
     num angle = 0;
     num power = 1;
     num energy = 2;
     int rgb = 0xFFFFFF;
	 Dot(num _x,num _y,num a,num p) {
        cx = _x;
        cy = _y;
        angle =a;
        power = p;
    }

}

