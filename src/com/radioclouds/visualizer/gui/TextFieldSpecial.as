package com.radioclouds.visualizer.gui {
	import flash.text.AntiAliasType;	
	import flash.text.TextFieldType;		import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import com.radioclouds.visualizer.Styles;	
	
	/**
	 * @author matas
	 */
	public class TextFieldSpecial extends TextField {
		
		public function TextFieldSpecial(args : Object) {
			super();
			
			
			defaultTextFormat = args.format || Styles.COPY;
			textColor = args.color ||  uint(defaultTextFormat.color);
			// if portions of text need particular formating, use class selectors in Styles.CSS
			styleSheet = Styles.CSS;
			
			x = args.x || 0;
			y = args.y || 0;
			
			width = args.width || width;
			height = args.height || height;
			mouseEnabled = args.mouseEnabled || false;
			embedFonts = args.embedFonts || false;
			multiline = args.multiline || false;
			selectable = args.selectable || false;
			border = args.border || false;
			wordWrap = args.wordWrap || false;
			autoSize = args.autoSize || TextFieldAutoSize.LEFT;
			type = args.type || TextFieldType.DYNAMIC;
			antiAliasType = args.antiAliasType || AntiAliasType.ADVANCED;
			background = args.background || false;
			backgroundColor = args.backgroundColor || 0x000000;
			
			if(args.text){
				text = args.text;
			}else if(args.htmlText){
				htmlText = args.htmlText;
			}

			
		}

		public function set color(newColor : uint) : void {
			textColor = newColor;
		}
		
		public override function set text(txt : String) : void {
			super.text = txt;
		}
		
		public override function set htmlText(txt : String) : void {
			super.htmlText = txt;
		}
	}
}
