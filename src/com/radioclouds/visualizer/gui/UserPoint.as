package com.radioclouds.visualizer.gui {
	import flash.events.IOErrorEvent;	
	import flash.system.LoaderContext;	
	import flash.display.Loader;
	
	import caurina.transitions.Tweener;
	
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	import com.radioclouds.visualizer.Styles;

	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	/**
	 * @author matas
	 */
	public class UserPoint extends Sprite {

		private var _userName : String;
		private var _userPicUrl : String;
		private var _anchorClip : Sprite;
		private var _labelTf : TextFieldSpecial;
		private var _bg : Sprite;
		private var _imageLoader : Loader;
		private var _active : Boolean;
		private var _permalink : String;
		private var _id : String;
		private var _stayVisible : Boolean;
		private var _lineContainer : Sprite;


		public function UserPoint(settings : Object, anchorObject : Sprite = null) {

			_userName = settings.userName;
			_permalink = settings.permalink;
			_id = settings.id;
			_userPicUrl = settings.userPicUrl;
			_anchorClip = null || anchorObject;
			_lineContainer = new Sprite();
			addChild(_lineContainer);


			x = settings.x || 0;
			y = settings.y || 0;
			
			useHandCursor = true;
			
			
			init();
		}
		
		private function init():void {
			
			
			_labelTf = new TextFieldSpecial({htmlText:_userName, format: Styles.SUBHEADLINE, background: true});
			_labelTf.color = 0xEEEEEE;
			_labelTf.y = 36;
			
			
			var labelContainer : Sprite = new Sprite();
			labelContainer.buttonMode = labelContainer.useHandCursor = true;
			labelContainer.addChild(_labelTf);
			
			labelContainer.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			labelContainer.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			
			_bg = new Circle({radius:20, color: Math.random()*0xFFFFFF});
			_bg.alpha = .4;
			Tweener.addTween(_bg, {
				scaleX: .1,
				scaleY: .1,
				time: .7,
				transition:"easeoutback"
			});
			
			// TODO draw the line to anchor object
			
			if(_anchorClip){
				drawLineTo(_anchorClip);
			}
			
			addChild(_bg);
			addChild(labelContainer);
			
			
			// load user image	
			if(_userPicUrl){
				var imageUrl : String = _userPicUrl;
				var loadingContext : LoaderContext = new LoaderContext();
				loadingContext.checkPolicyFile = true;
				_imageLoader = new Loader();
				_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				_imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);


				_imageLoader.load(new URLRequest(imageUrl), loadingContext); 
			}
		}
		
		private function onImageLoaded(evt : Event) : void {
			removeChild(_bg);
			
			// get the bitmap data from laoder
			
			var myBitmap:BitmapData = new BitmapData(_imageLoader.width, _imageLoader.height, false);
			myBitmap.draw(_imageLoader, new Matrix());
			
			// create matrix for image manipulation
			var myMatrix:Matrix = new Matrix();
			// scale image to the third of its size
			myMatrix.scale(.3, .3);
			
			// fill the rectangle with loaded image
			_bg = new Rectangle({width:36, height: 36, x: -18, y:-18, bitmap:myBitmap, matrix:myMatrix});
			_bg.alpha = 0;
			_bg.scaleX = _bg.scaleY = (_active) ? 2 : 1;
			addChildAt(_bg, 0);
			
			_bg.useHandCursor = true;
			_bg.buttonMode = true;
			
			Tweener.addTween(_bg, {
				alpha: 1,
				time: .7,
				transition:"easeoutback"
			});
			

			
			_bg.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_bg.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
		}

		function ioErrorHandler(event:IOErrorEvent):void {
			log("ioErrorHandler: " + event);
		}
		
		
		private function onMouseOver(evt : MouseEvent) : void {
			this.active = true;
			dispatchEvent(new Event(Event.INIT));
		}

		private function onMouseOut(evt : MouseEvent) : void {
			if(!_stayVisible){
				this.active = false;
			}
		}
		
		private function redraw() : void {
			if(_active) {
				_labelTf.color = 0xFFFFFF;
				_labelTf.backgroundColor = Styles.COLOR_TEXT_HOVER;
				Tweener.addTween(_bg,{scaleX:2, scaleY:2, time:.5, transition:"easeoutback"});
				Tweener.addTween(_labelTf, {scaleX:2, scaleY:2, y: 72, time:.5, transition:"easeoutback"});
			}else {
				_labelTf.color = 0xEEEEEE;
				_labelTf.backgroundColor = 0x000000;
				Tweener.addTween(_bg,{scaleX:1, scaleY:1, time:.5, transition:"easeoutback"});
				Tweener.addTween(_labelTf, {scaleX:1, scaleY:1, y:36, time:.5, transition:"easeoutback"});
			}
		}

		
		
		public function set active(status : Boolean):void {
			_active = status;
			redraw();			
		}
		
		public function set stayVisible(status : Boolean):void {
			_stayVisible = _active = status;
			redraw();
		}
		

		public function drawLineTo(target : Sprite) : void {
			
			_lineContainer.graphics.lineStyle(1,0x000000,0.5);
			_lineContainer.graphics.moveTo(0, 0);
			_lineContainer.graphics.lineTo(0-(this.x-target.x), 0-(this.y-target.y));
		}

		public function get userName() : String {
			return _userName;
		}
		
		public function set userName(userName : String) : void {
			_userName = userName;
		}
		
		public function get permalink() : String {
			return _permalink;
		}
		
		public function get id() : String {
			return _id;
		}
		
		private function log(msg : String) : void {
			var logText : String = this.toString()+msg;
			trace(logText);
		}
	}
}
