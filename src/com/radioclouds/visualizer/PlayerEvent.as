package com.radioclouds.visualizer {
	import flash.events.Event;	

	/**
	 * @author matas
	 */
	public class PlayerEvent extends Event {
		
		public static const PLAY : String = "onPlay";
		public static const PAUSE : String = "onPause";
		public static const SEEK : String = "onSeek";
		public static const VOLUME_CHANGED : String = "onVolumeChanged";
		public static var NO_STREAM : String = "onTrackHasNoStream";
		public static var FULL_SCREEN_TOGGLE : String = "onFullScreenToggle";

		public function PlayerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false){
			super(type, bubbles, cancelable);	
		}
		
	}
}
