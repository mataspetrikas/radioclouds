package com.radioclouds.visualizer.gui {
  import flash.text.TextFormat;
  import flash.display.Sprite;

  import com.radioclouds.visualizer.Styles;	

  /**
   * @author matas
   */
  public class TextButton extends Sprite {
    private var _labelText : String;
    private var _btnLabel : TextFieldSpecial;

    public function TextButton(settings : Object) {
      super();
			
      _labelText = settings.label;
      x = settings.x || 0;
      y = settings.y || 0;
			
      useHandCursor = true;
      buttonMode = true;
			
      var format : TextFormat = TextFormat(settings.format) || Styles.COPY;
			
      _btnLabel = new TextFieldSpecial({htmlText:_labelText, format: format});
      addChild(_btnLabel);
    }
  }
}
