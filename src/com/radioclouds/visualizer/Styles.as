package com.radioclouds.visualizer {
	import flash.text.StyleSheet;		import flash.text.Font;
	import flash.text.TextFormat;
	import com.radioclouds.visualizer.fonts.*;			/* embed Fonts */
	// [Embed(systemFont="Helvetica", fontName="_Helvetica", mimeType="application/x-font-truetype", unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
	
	/**
	 * @author matas
	 */
	public class Styles {
		
		private static var _instance:Styles = new Styles();
		
		
		public var MAIN_FONT : Font = new HelveticaRegular();
		public var MAIN_FONT_BOLD : Font = new HelveticaBold();
		
		public static const STAGE_WIDTH : Number = 990;
		public static const STAGE_HEIGHT : Number = 660;
		public static const MARGIN_STANDARD : int = 10;
		public static const COLOR_TEXT : uint = 0xFFFFFF;
		public static const COLOR_TEXT_HOVER : uint = 0xff6600;
		public static const COLOR_TEXT_BLUE : uint = 0x69c1F3;
		public static const COLOR_TEXT_GREY : uint = 0xB1B1B1;
		public static var HEADLINE : TextFormat;
		public static var SUBHEADLINE : TextFormat;
		public static var COPY : TextFormat;
		public static var SMALL : TextFormat;
		public static var CSS : StyleSheet;


		
		public function Styles(){
			
			HEADLINE = new TextFormat();
			HEADLINE.bold = true;
			HEADLINE.size = 18;
			HEADLINE.color = COLOR_TEXT;
			HEADLINE.font = MAIN_FONT_BOLD.fontName;
			
			SUBHEADLINE = new TextFormat();
			SUBHEADLINE.bold = true;
			SUBHEADLINE.size = 14;
			SUBHEADLINE.color = COLOR_TEXT;
			SUBHEADLINE.font = MAIN_FONT_BOLD.fontName;
			
			
			COPY = new TextFormat();
			COPY.size = 11;
			COPY.color = 0xEEEEEE;
			COPY.font = MAIN_FONT.fontName;
			
			SMALL = new TextFormat();
			SMALL.size = 9;
			SMALL.color = 0x777777;
			SMALL.font = MAIN_FONT.fontName;
			
			refreshCss();
		}
		
		private static function refreshCss() : void {
			CSS = new StyleSheet();
			CSS.parseCSS("a {color: #ff6600; font-weight: bold; text-decoration: underline;} a:hover{color: #ffffff} strong{font-weight: bold} em{color: #BBBBBB}");
			
		}
	}
}
