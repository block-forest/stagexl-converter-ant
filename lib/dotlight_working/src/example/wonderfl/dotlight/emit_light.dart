part of dotlight;
/**
	 * @author nilsdoehring
	 */
class EmitLight {
  BitmapData canvas;
  Rectangle rect;
  int scale;
  int cx;
  int cy;
  int radius;
  static num yScale = 0.25;
  List dots;
  static num acceleration = 0.01;
  static num gravity = 0.03;
  static num deceleration = 0.008;
  ColorHSV color;
  static num length = 2;
  Bresenham manager;
  EmitLight(BitmapData c, int s) {
    canvas = c;
    rect = canvas.rectangle;
    scale = s;
    cx = (rect.width * 0.5).toInt();
    cy = (rect.height * 0.85).toInt();
    radius = (rect.width * 0.4).toInt();
    init();
  }

  void init() {
    dots = new List();
    color = new ColorHSV(0, 0.4);
    manager = new Bresenham(canvas);
  }
  void create(int max) {
    for (int n = 0; n < max; n++) {
      num angle = (new Random().nextDouble()) * 360;
      num power = new Random().nextDouble() + 0.5;
      Dot dot = new Dot(cx, cy, angle, power);
      dot.x = cx + cos(angle * PI / 180) * radius;
      dot.y = cy + sin(angle * PI / 180) * radius * yScale;
      dot.px = dot.x;
      dot.py = dot.y;
      color.h = 180;
      dot.rgb = color.value;
      dots.add(dot);
    }
  }
  void emit(List list) {
    for (int n = 0; n < dots.length; n++) {
      Dot dot = dots[n];
      
      int c = list[(dot.x ~/ scale).abs()][(dot.y ~/ scale).abs()].toInt();
      
      dot.cx += ((((c >> 16) & 0xFF) - 0x80) / 0x80) * 5;
      dot.vy += gravity * dot.power;
      dot.vy *= 0.99;
      dot.vx += acceleration;
      dot.angle += dot.vx;
      dot.cy -= dot.vy;
      num px = cos(dot.angle * PI / 180) * radius;
      num py = sin(dot.angle * PI / 180) * radius * yScale;
      dot.x = dot.cx + px * (dot.energy * 0.4 + 0.2);
      dot.y = dot.cy + py * (dot.energy * 0.4 + 0.2);
      dot.energy -= deceleration;
      int x0 = dot.x.round();
      int y0 = dot.y.round();
      int x1 = (dot.x - (dot.x - dot.px) * length).round();
      int y1 = (dot.y - (dot.y - dot.py) * length).round();
      color.h = 180 + 50 * dot.energy * 0.5;
      dot.rgb = color.value;
      manager.draw(x0, y0, x1, y1, dot.rgb, dot.energy * 0.5);
      dot.px = dot.x;
      dot.py = dot.y;
      if (dot.energy < 0) {
        dots.removeRange(n, n+1);
        dot = null;
      }
    }
  }

}
