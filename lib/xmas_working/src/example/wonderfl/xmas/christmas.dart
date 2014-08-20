part of xmas;

class Main extends Sprite {
  Rectangle rect;
  static Point point = new Point(0, 0);
  Sprite container;
  Sprite gallery;
  Sprite helix;
  num initColor = 0xfffefe84;
  static BlurFilter blur;
  BitmapData bitmapData;
  Bitmap bitmap;
  int startCount = 100;
  int cx = 0;
  Timer timer;
  List<StarUnit> galItems;
  bool canSpin = false;
  int dir = -1;
  StarUnit bigStar;
  static num radian = PI / 180;
  Main() {
    //init();
  }

  void init() {
    stage.align = StageAlign.TOP_LEFT;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    graphics.rect(0, 0, stage.stageWidth, stage.stageHeight);
    graphics.fillColor(0xff5f0e17);

    rect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

    bitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0xff000000);
    bitmap = new Bitmap(bitmapData);
    bitmap.blendMode = BlendMode.SCREEN;
    addChild(bitmap);

    blur = new BlurFilter(50, 50);

    container = new Sprite();
    gallery = new Sprite();
    helix = new Sprite();
    gallery.addChild(helix);
    container.addChild(gallery);
    addChild(container);

    gallery.x = stage.stageWidth / 2;
    gallery.y = 0; //stage.stageHeight / 2;
    //gallery.z = 800;

    galItems = new List<StarUnit>();

    for (int i = 0; i < startCount; i++) {
      galItems.add(new StarUnit(20, initColor));
    }
    startCount--;

    gallery.rotation /*X*/ = -90;
    timer = new Timer.periodic(new Duration(milliseconds: 40), (Timer t) => create());

    addEventListener(Event.ENTER_FRAME, loop);
  }

  void create(/*TimerEvent evt*/) {
    StarUnit star;
    if (dir < 0) {
      star = galItems[startCount];
    } else {
      star = new StarUnit(20, initColor);
      galItems.add(star);
    }
    int rad = (startCount * 6) + 20;

    star.blendMode = BlendMode.ADD;
    star.x = sin(rad) * rad;
    star.y = cos(rad) * rad;
    //star.z = (startCount - 10) * 10;
    //star.rotationY = 90;
    star.rotation /*X*/ = (rad / (PI / 180)) + 90;
    helix.addChild(star);

    startCount += dir;

    if (startCount < 0) {
      canSpin = true;
      bigStar = new StarUnit(60, initColor, true);
      //bigStar.rotationY = 90;
      bigStar.blendMode = BlendMode.ADD;
      //bigStar.z = -bigStar.height*3;
      /* TweenLite.to(bigStar, 1, {z:-bigStar.height*1.5, ease:Bounce.easeOut}); */
      //stage.juggler.tween(bigStar, 1, TransitionFunction.easeOutBounce).animate.z.to(-bigStar.height*1.5);
      helix.addChild(bigStar);
      timer.cancel();
    }
  }

  void loop(Event evt) {
    if (canSpin != null) {
      cx -= 2;
    }
    int len = galItems.length;
    for (int i = 0; i < len; i++) {
      //galItems[i].rotationZ += 10;
    }
    /*TweenLite.to(helix, 2, {rotation: (cx - (stage.stageWidth / 2)) * 1.6});*/
    stage.juggler.removeTweens(helix);
    stage.juggler.tween(helix, 2).animate.rotation.to((cx - (stage.stageWidth / 2)) * 1.6);
    //bitmapData.lock();
    bitmapData.draw(container/*, null, null, BlendMode.SCREEN, null, true*/);
    /*bitmapData.applyFilter(bitmapData, rect, point, blur);*/
    bitmapData.applyFilter(blur, rect);
    //bitmapData.unlock();
  }
}

