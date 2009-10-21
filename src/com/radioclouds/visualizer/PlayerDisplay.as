package com.radioclouds.visualizer {
	import com.radioclouds.visualizer.ButtonPause;
	import com.radioclouds.visualizer.PlayerEvent;
	import com.radioclouds.visualizer.VolumeSlider;
	
	import caurina.transitions.Tweener;

	import flash.events.MouseEvent;


	import com.radioclouds.visualizer.gui.TextFieldSpecial;
	
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import com.radioclouds.visualizer.models.Track;
	
	import flash.display.Loader;
	
	import com.radioclouds.visualizer.gui.RoundedBox;
	
	import flash.display.Sprite;
	
	/**
	 * @author matas
	 */
	public class PlayerDisplay extends Sprite {
		private var _background : Sprite;
		private var _containerWidth : Number = 350;
		private var _waveformLoader : Loader;
		private var _trackTitle : TextFieldSpecial;
		private var _progressBar : RoundedBox;
		private var _playHead : RoundedBox;
		private var _soundPosition : Number = 0;
		private var _trackTimecode : TextFieldSpecial;
		private var _trackDuration : Number;
		private var _bufferBar : RoundedBox;
		private var _loadPosition : Number;
		private var _trackArtist : TextFieldSpecial;
		private var _seekPosition : Number = 0;
		private var _DEFAULT_HEIGHT : Number = 65;
		private var _volumeSlider : VolumeSlider;
		private var _currentVolume : Number;
		private var _pauseButton : ButtonPause;
		private var _playButton : ButtonPlay;
		private var _paused : Boolean = false;		private var _fullScreenButton : Sprite;
		public function PlayerDisplay() {
			
			
			
			_background = new RoundedBox({height: _DEFAULT_HEIGHT, color: 0x333333, radius: 0});
			addChild(_background);			
			
			
			_bufferBar = new RoundedBox({width: 0, height: _DEFAULT_HEIGHT, color: 0x111111, radius: 0});
			_bufferBar.mouseEnabled = true;
			addChild(_bufferBar);	
			
			
			_progressBar = new RoundedBox({width: 0, height: _DEFAULT_HEIGHT, color:Styles.COLOR_TEXT_HOVER, radius: 0});
			_progressBar.mouseEnabled = false;
			addChild(_progressBar);
			
			_playHead = new RoundedBox({width: 1, height: _DEFAULT_HEIGHT, color: 0xFF0000, radius: 0});
			_playHead.alpha = 0.8;
			addChild(_playHead);
			
			
			
			_waveformLoader = new Loader();
			_waveformLoader.visible = false;
			_waveformLoader.mouseEnabled = false;
			addChild(_waveformLoader);
			
			_volumeSlider = new VolumeSlider();
			_volumeSlider.x = _containerWidth + 10;
			_volumeSlider.y = _DEFAULT_HEIGHT - _volumeSlider.height - 5;
			addChild(_volumeSlider);
			_volumeSlider.addEventListener(PlayerEvent.VOLUME_CHANGED, onVolumeChange);
			
			_trackTitle = new TextFieldSpecial({
				text: " ",
				x: _containerWidth + 22,
				y: 5,
				format: Styles.HEADLINE
			});
			addChild(_trackTitle);
			
			_trackArtist = new TextFieldSpecial({
				text: " ",
				x: _containerWidth + 8,
				y: 25,
				format: Styles.HEADLINE
			});
			addChild(_trackArtist);
			
			_trackTimecode = new TextFieldSpecial({
				text: " ",
				format: Styles.HEADLINE,
				y: _trackTitle.y
			});
			_trackTimecode.visible = false;
			_trackTimecode.alpha = 0.8;
			addChild(_trackTimecode);
			
			_pauseButton = new ButtonPause();
			addChild(_pauseButton);
			
			_playButton = new ButtonPlay();
			addChild(_playButton);
			
			_pauseButton.x = _playButton.x = _containerWidth + 12;
			_pauseButton.y = _playButton.y = _trackTimecode.y + 5;
			
			_playButton.addEventListener(MouseEvent.CLICK, onPlayClicked);
			_pauseButton.addEventListener(MouseEvent.CLICK, onPauseClicked);
			
			_fullScreenButton = new ButtonPlay();
			_fullScreenButton.rotation = -90;
			_fullScreenButton.y = _background.height - 20;
			_fullScreenButton.addEventListener(MouseEvent.CLICK, onFullScreenClick);
			addChild(_fullScreenButton);
			
			
			_bufferBar.addEventListener(MouseEvent.MOUSE_DOWN, seekTrackStart);
			
			
			redraw();
		}
		
		private function onFullScreenClick(event : MouseEvent) : void {
			dispatchEvent(new PlayerEvent(PlayerEvent.FULL_SCREEN_TOGGLE));
		}

		private function seekTrackStop(event : MouseEvent) : void {
			removeEventListener(Event.ENTER_FRAME, seekTrack);
			stage.removeEventListener(MouseEvent.MOUSE_UP, seekTrackStop);
		}

		private function seekTrackStart(event : MouseEvent) : void {
			addEventListener(Event.ENTER_FRAME, seekTrack);
			stage.addEventListener(MouseEvent.MOUSE_UP, seekTrackStop);
		}

		private function onPlayClicked(event : MouseEvent) : void {
			_paused = false;
			dispatchEvent(new PlayerEvent(PlayerEvent.PLAY));
			redraw();			
		}

		private function onPauseClicked(event : MouseEvent) : void {
			_paused = true;
			_seekPosition = _trackDuration * (_playHead.x / _containerWidth);
			dispatchEvent(new PlayerEvent(PlayerEvent.PAUSE));
			redraw();
			
		}

		private function onVolumeChange(event : Event) : void {
			log("on volume changed:" + _volumeSlider.volume);
			_currentVolume = _volumeSlider.volume;
			dispatchEvent(new PlayerEvent(PlayerEvent.VOLUME_CHANGED));
		}

		
		public function displayTrackData(trackData : Track) : void {
			
			reset();
			
			_background.width = stage.stageWidth;

			
			_waveformLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onWaveformLoaded);
			_waveformLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onWaveformLoaded);
			_waveformLoader.load(new URLRequest(trackData.waveformUrl)); 	
			
			log(trackData.userName + " - " +	trackData.title);
			_trackTitle.text = trackData.title;
			_trackArtist.text = "by " + trackData.userName;
			
			_trackArtist.alpha = _trackTitle.alpha = 0;
			
			_trackTimecode.x = _trackTitle.x + _trackTitle.width + 5;
			
			Tweener.addTween(_trackTitle,{
				alpha: .5,
				time:.5, 
				transition:"easeoutback"
			});
			
			Tweener.addTween(_trackArtist,{
				alpha: 0.3,
				time:.5, 
				delay: .5,
				transition:"easeoutback"
			});
			
			_trackDuration = trackData.duration;
			
			
			
//			for(var i:uint = 0, l:uint = trackData.comments.length; i<l; i++){
//				var tmpComment : Comment = trackData.comments[i];
//			}
		}

		private function onWaveformLoaded(event : Event) : void {
			_waveformLoader.width = _containerWidth;
			_waveformLoader.height = _background.height;
			_waveformLoader.alpha = 0;
			_waveformLoader.visible = true;
			Tweener.addTween(_waveformLoader,{
				alpha: 0.4,
				time:.6, 
				transition:"easeoutback"
			});
		}

		
		private function seekTrack(evt : Event) : void {
			_paused = false;
			_seekPosition = _trackDuration * (Math.min(mouseX, _bufferBar.width) / _containerWidth);
			dispatchEvent(new Event(Event.CHANGE));
		}


		
		private function redraw() : void{
			
			_progressBar.width = (_trackDuration > 0) ? _containerWidth * (_soundPosition / _trackDuration) : 0;
			_bufferBar.width = (_trackDuration > 0) ? _containerWidth * _loadPosition : 0;
			_playHead.x = _progressBar.width;
			_playHead.visible = (_playHead.x > 0);
			
			_trackTimecode.visible = (_soundPosition > 0);
			_trackTimecode.text = milisecondsToMinutes(_soundPosition) + " / " + milisecondsToMinutes(_trackDuration);
			
			_pauseButton.visible = !_paused;
			_playButton.visible = _paused;
		}

		private static function milisecondsToMinutes(ms : Number) : String{
			var seconds : Number = ms / 1000;
			var m : Number = Math.floor(seconds/60);
			var s : Number = Math.round(seconds - (m * 60));
			
			// Add leading zeros to second numbers.
			return m + "." + ((s < 10) ? "0" : "") + s;
			
		}
		
		public function set playProgress(progress : Number): void {
			if(progress != _soundPosition){
				_soundPosition = progress;
				redraw();
			}
		}
		
		public function set loadProgress(progress : Number): void {
			if(progress != _loadPosition) {
				_loadPosition = progress;
				redraw();
			}
		}
		
		public function reset() : void {
			_trackDuration = _soundPosition = _seekPosition = _loadPosition = 0;
			_waveformLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onWaveformLoaded);
			_waveformLoader.visible = false;
			_trackArtist.text = _trackTitle.text = _trackTimecode.text = "";
			_progressBar.width = _bufferBar.width = 0;
			_playHead.visible = false;
		}

		public override function set width(newWidth : Number): void {
			_background.width = newWidth;
			_fullScreenButton.x = _background.width - _fullScreenButton.width - 10;
			redraw();
		}

		public function get seekPosition() : Number {
			return _seekPosition;
		}
		
		public function set volume(newVolume : Number) : void {
			_volumeSlider.volume = newVolume;
		}
		
		public function get volume() : Number {
			return _volumeSlider.volume;
		}

		public override function toString():String
		{
			return "[PlayerDisplay]";
		}
		
		private function log(msg):void{
			var logText : String = this.toString()+msg;
			trace(logText);
		}
		
		public function get paused() : Boolean {
			return _paused;
		}
		
		public function set paused(status : Boolean) : void {
			_paused = status;
			redraw();
		}
	}
}
