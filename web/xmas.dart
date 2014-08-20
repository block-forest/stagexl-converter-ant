import 'package:stagexl/stagexl.dart';
import 'package:actionscript2dart/xmas_working/xmas.dart';
import 'dart:html';

void main() {
  Element stageEl = querySelector("#stage");

  Stage stage = new Stage(stageEl, webGL: false);
  stage.scaleMode = StageScaleMode.NO_SCALE;
  stage.align = StageAlign.TOP_LEFT;

  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  Main main = new Main();
  stage.addChild(main);
  main.init();
   
}
