package com.radioclouds.visualizer {
	import flash.net.SharedObject;	
	
	import com.radioclouds.visualizer.PlayerEvent;	
	
	import flash.events.Event;	
	import flash.events.MouseEvent;	
	
	import com.radioclouds.visualizer.gui.RoundedBox;	
	
	import flash.display.Sprite;
	
	/**
	 * @author matas
	 */
	public class VolumeSlider extends Sprite {
		private var _volume : Number = .8;
		private var _background : RoundedBox;
		private var _containerWidth : Number = 80;
		private var _containerHeight : Number = 8;
		private var _slider : RoundedBox;
		private var _userSettings : SharedObject;
		private var _volumeIcon : Sprite;

		public function VolumeSlider() {
			
			_background = new RoundedBox({width: _containerWidth, height: _containerHeight, color: 0xB6B6B6, radius: 0});
			_background.mouseEnabled = true;
			_background.buttonMode = true;
			_background.useHandCursor = true;
			addChild(_background);
			
			_slider = new RoundedBox({width: _containerWidth, height: _containerHeight, color: 0x333333, radius: 0, alpha: .7});
			_slider.mouseEnabled = false;
			addChild(_slider);	
			
			_userSettings = SharedObject.getLocal( "radioCloudsSettings" );
			
			_volumeIcon = new Sprite();
			_volumeIcon.graphics.lineStyle();
			_volumeIcon.graphics.beginFill(0x888888);
			_volumeIcon.graphics.lineTo(20, -8);
			_volumeIcon.graphics.lineTo(20, 0);
			_volumeIcon.graphics.lineTo(0, 0);
			_volumeIcon.graphics.endFill();
			_volumeIcon.y = 7;
			addChild(_volumeIcon);
			
			addEventListener(MouseEvent.MOUSE_DOWN, startDraging);	
					
			changeVolume(_userSettings.data.volume || _volume);	
		}

		private function startDraging(event : MouseEvent) : void {
			addEventListener(Event.ENTER_FRAME, readVolumeSlider);	
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraging);			
		}
		
		private function stopDraging(event : MouseEvent) : void {
			removeEventListener(Event.ENTER_FRAME, readVolumeSlider);
		}		
		
		private function readVolumeSlider(event : Event) : void {
			var newVolume : Number = Math.min(this.mouseX / _background.width, 1);
			if(newVolume != _volume){
				changeVolume(newVolume);
			}
		}		
		
		private function changeVolume(newVolume : Number) : void {
			_volume = newVolume;
			_userSettings.data.volume = _volume;
			dispatchEvent(new PlayerEvent(PlayerEvent.VOLUME_CHANGED));
			redraw();
		}	
		
		
		private function redraw() : void {
			_background.width = _containerWidth;
			_slider.width = _containerWidth * _volume;
			_volumeIcon.x = _containerWidth + 10;
		}

		public function get volume() : Number {
			return _volume;
		}
		
		public function set volume(newVolume : Number) : void {
			changeVolume(newVolume);
		}
		
		public override function set width(newWidth : Number): void {
			_containerWidth = newWidth;
			redraw();
		}
		
		public override function set height(newHeight : Number): void {
			_background.height = newHeight;
			_slider.height = newHeight;
		}
	}
}
