package com.radioclouds.visualizer {
  import com.radioclouds.visualizer.gui.RoundedBox;	

  import flash.display.Sprite;

  /**
   * @author matas
   */
  public class ButtonPause extends Sprite {
    public function ButtonPause() {
      graphics.lineStyle();
      graphics.beginFill(0x999999);
      graphics.drawRect(0, 0, 3, 9);
      graphics.endFill();
			
      graphics.lineStyle();
      graphics.beginFill(0x999999);
      graphics.drawRect(5, 0, 3, 9);
      graphics.endFill();
			
      buttonMode = true;
      useHandCursor = true;
			
      var hitClip : RoundedBox = new RoundedBox({width: 10, height: 10, radius: 0});
      hitClip.visible = false;
      addChild(hitClip);			
      hitArea = hitClip;
    }
  }
}
