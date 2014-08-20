import 'package:stagexl/stagexl.dart';
import 'package:actionscript2dart/dotlight_working/dotlight.dart';
import 'dart:html';

void main() {
  Element stageEl = querySelector("#stage");

  Stage.autoHiDpi = false;
  Stage stage = new Stage(stageEl, webGL: false);
  stage.scaleMode = StageScaleMode.NO_SCALE;
  stage.align = StageAlign.TOP_LEFT;

  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  DotLight light = new DotLight(new Rectangle(0, 0, 465, 465));
  stage.addChild(light);
  light.start();
   
}
