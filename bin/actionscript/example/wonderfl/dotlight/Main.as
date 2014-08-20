// forked from ProjectNya's DotLight
// http://wonderfl.net/c/3lDU
////////////////////////////////////////////////////////////////////////////////
// [AS3.0] ドットの光 (6)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=1095
////////////////////////////////////////////////////////////////////////////////

package example.wonderfl.dotlight {

    import flash.display.Sprite;
    import flash.geom.Rectangle;

    //[SWF(backgroundColor="#000000", width="465", height="465", frameRate="30")]

	public class Main extends Sprite {
		private var light : DotLight;

        public function Main() {
           // Wonderfl.capture_delay(60);
            init();
        }

        private function init():void {
            graphics.beginFill(0x000000);
            graphics.drawRect(0, 0, 465, 465);
            graphics.endFill();
            light = new DotLight(new Rectangle(0, 0, 465, 465));
            addChild(light);
            light.start();
        }

    }

}

