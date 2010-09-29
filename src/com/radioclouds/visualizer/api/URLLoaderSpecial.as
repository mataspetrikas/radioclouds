package com.radioclouds.visualizer.api {
  import flash.net.URLLoader;
  import flash.net.URLRequest;	

  /**
   * @author matas
   */
  public class URLLoaderSpecial extends URLLoader {
    private var _caller : String;
    private var _eventType : String;

    public function URLLoaderSpecial(request : URLRequest = null, callerId : String = undefined) {
      super(request);
      _caller = callerId;
    }

    public function set caller(callerId : String) : void {
      _caller = callerId;
    }

    public function get caller() : String {
      return _caller;
    }

    public function get eventType() : String {
      return _eventType;
    }

    public function set eventType(eventType : String) : void {
      _eventType = eventType;
    }
  }
}
