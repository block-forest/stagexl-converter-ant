 part of dotlight;
	/**
	 * @author nilsdoehring
	 */
	 class Bresenham {

     BitmapData canvas;
	 Bresenham(BitmapData c) {
        canvas = c;
    }

      void draw(int x0,int y0,int x1,int y1,int color,num alpha) {
        bool steep = (y1 - y0).abs() > (x1 - x0).abs();
        int t;
        if( steep != null) {
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
        int dx = x1 - x0;
        int dy = (y1 - y0).abs();
        int e = (dx*0.5).toInt();
        int ys = (y0 < y1) ? 1 : -1;
        int y = y0;
        for (int x = x0; x <= x1; x++) {
            if( steep != null) {
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
      void plot(int x,int y,int c,num a) {
        canvas.setPixel32(x, y, c | ((a*0xFF).toInt() << 24));
    }

}

