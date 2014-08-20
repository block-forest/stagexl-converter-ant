 part of dotlight;
	/**
	 * @author nilsdoehring
	 */
	 class DotLight extends Sprite {
     Rectangle rect;
     BitmapData canvas;
     BitmapData sparkle;
     
     BitmapData afterglow;
     Bitmap aBitmap;
     
     static int scale = 4;
     Matrix aMatrix;
     ColorTransform colorTrans;
     BlurFilter blur;
     Matrix sMatrix;
     List offsets;
		 int seed;
		 EmitLight light;
	 DotLight(Rectangle r) {
        rect = r;
        init();
    }

      void init() {
        afterglow = new BitmapData(rect.width*2~/scale, rect.height*2~/scale, false, 0xFF000000);
        
        aBitmap = new Bitmap(afterglow/*, PixelSnapping.AUTO, true*/);
        aBitmap.scaleX = aBitmap.scaleY = scale/2;
        addChild(aBitmap);
        
        canvas = new BitmapData(rect.width, rect.height, true, 0x00000000);
        Bitmap cBitmap = new Bitmap(canvas);
        cBitmap.blendMode = BlendMode.ADD;
        addChild(cBitmap);
        
        offsets = [new Point(0,0), new Point(0,0)];
        seed = (new Random().nextDouble()*1000).floor();
        OptimizedPerlin.iOctaves = 2;
        OptimizedPerlin.seed = seed;
                
        sparkle = new BitmapData(rect.width~/scale, rect.height~/scale, true, 0x00000000);
        Bitmap sBitmap = new Bitmap(sparkle);
        //sBitmap.smoothing = true;
        sBitmap.blendMode = BlendMode.ADD;
        sBitmap.scaleX = sBitmap.scaleY = scale;
        addChild(sBitmap);
        
        aMatrix = new Matrix(2/scale, 0, 0, 2/scale, 0, 0);
        colorTrans = new ColorTransform(0.1, 0.1, 0.1);
        blur = new BlurFilter(2, 2/*, 1*/);
        sMatrix = new Matrix(1/scale, 0, 0, 1/scale, 0, 0);
        light = new EmitLight(canvas, scale);
    }
      void start() {
        addEventListener(Event.ENTER_FRAME, draw, useCapture:false, priority:0/*, true*/);
    }
      void stop() {
        removeEventListener(Event.ENTER_FRAME, draw);
    }
      void draw(Event evt) {
        num offset = /*getTimer()*/ stage.juggler.elapsedTime*1000*0.05;
        offsets[0].x = offsets[1].y = offset;
                
        OptimizedPerlin.iXoffset = offsets[0].x;
        OptimizedPerlin.iYoffset = offsets[1].y;
        List list = OptimizedPerlin.fillList(new Point(rect.width~/scale, rect.height~/scale), rect.width~/scale, rect.height~/scale);

        light.create(10);
        
        //canvas.lock();
        canvas.fillRect(canvas.rectangle, 0xff000000);
        light.emit(list);
       // canvas.unlock();
        
        //sparkle.lock();
        sparkle.draw(canvas, sMatrix);
        //sparkle.fillRect(sparkle.rectangle, 0xff000000); //does nothing?
       // sparkle.unlock();
        
       // afterglow.lock();
        
        /* Original from as3
        afterglow.draw(canvas, aMatrix, colorTrans, BlendMode.ADD);
        afterglow.applyFilter(afterglow, afterglow.rect, new Point(0,0), blur);
        */        
        
        afterglow.colorTransform(rect, colorTrans);
        
        //XXX BitmapData.draw in StageXL does not feature BlendModes
        afterglow.draw(canvas, aMatrix/*, colorTrans, BlendMode.ADD*/);
        
        /*XXX BitmapData.drawPixels in StageXL does feature BlendModes, but no Matrix
         * (We want to scale down by factor 4)
         */
        //afterglow.drawPixels(canvas, canvas.rectangle, new Point(0,0), BlendMode.ADD);
        
        afterglow.applyFilter(blur, afterglow.rectangle/*, new Point(), blur*/);

        // afterglow.unlock();
    }
      

}

