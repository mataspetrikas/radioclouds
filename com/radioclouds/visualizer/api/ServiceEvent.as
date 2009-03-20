package com.radioclouds.visualizer.api {
	import flash.events.Event;
	
	/**
	 * @author matas
	 */
	public class ServiceEvent extends Event {
		
		public static const USERDATA_LOADED: String = "onUserDataLoad";
		public static const CONTACTS_LOADED: String = "onContactsLoad";
		public static const TRACKS_LOADED: String = "onTracksLoad";
		public static const NOT_FOUND : String = "onNotFound";
		
		private var _data : Object;
		private var _caller : String;

		public function ServiceEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false, data:Object = null, caller : String  = "") {
			super(type, bubbles, cancelable);
			
			_data  = data;
			_caller = caller;
		}
		
		public function get data() : Object{
			return _data;
		}
		
		public function get caller() : String {
			return _caller;
		}
	}
}
