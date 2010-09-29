package com.radioclouds.visualizer {
  import com.radioclouds.visualizer.gui.RoundedBox;	

  import flash.display.Sprite;

  /**
   * @author matas
   */
  public class ButtonPlay extends Sprite {
    public function ButtonPlay() {
      graphics.lineStyle();
      graphics.beginFill(0x999999);
      graphics.lineTo(8, 5);
      graphics.lineTo(0, 9);
      graphics.lineTo(0, 0);	
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
