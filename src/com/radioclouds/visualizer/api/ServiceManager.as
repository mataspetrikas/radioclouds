package com.radioclouds.visualizer.api {
  import flash.events.IOErrorEvent;
  import flash.events.Event;
  import flash.net.*;
  import flash.events.EventDispatcher;

  /**
   * @author matas
   */
  public class ServiceManager extends EventDispatcher {
    public static const DATA_LOADED : String = "DataLoaded";
    private static const _instance : ServiceManager = new ServiceManager(SingletonLock);
    private static const API_KEY : String = "ivTTQUWit07TrzyHeIg21w";
    private static const _API_URL_HOST : String = "http://api.soundcloud.com/"; //"http://api.soundcloud.com/"
    private static const _API_URL_USERS : String = _API_URL_HOST + "users/";
    private static const _API_CONTACTS_QUERY : String = "/contacts?track_count[from]=1";
    private static const _API_TRACKS_QUERY : String = "/tracks?order=hotness&filter=streamable";

    public static function get instance() : ServiceManager {
      return _instance;
    }

    public function ServiceManager( lock : Class ) {
      super();
      // Verify that the lock is the correct class reference.
      if ( lock != SingletonLock ) {
        throw new Error("Invalid Singleton access.  Use ServiceManager.instance.");
      }
    }

    public function getUserData(userId : String) : void {

      var url : String = _API_URL_USERS + userId;
      log("getUserData(" + userId + ") " + url);
      makeServiceCall(url, userId, ServiceEvent.USERDATA_LOADED);
    }

    public function getUserContacts(userId : String) : void {
      var url : String = _API_URL_USERS + userId + _API_CONTACTS_QUERY;
      log("getUserContacts(" + userId + ") " + url);
      makeServiceCall(url, userId, ServiceEvent.CONTACTS_LOADED);
    }

    public function getUserTracks(userId : String) : void {
			
      var url : String = _API_URL_USERS + userId + _API_TRACKS_QUERY;
      log("getUserTracks(" + userId + ")");
      makeServiceCall(url, userId, ServiceEvent.TRACKS_LOADED);
    }

    private function makeServiceCall(url : String, userId : String, eventType : String) : void {
      log("makeServiceCall(" + userId + ")");
      var loader : URLLoaderSpecial = new URLLoaderSpecial();
      loader.caller = userId;
      loader.eventType = eventType;
      loader.dataFormat = URLLoaderDataFormat.TEXT;
      loader.addEventListener(Event.COMPLETE, handleLoadedData);
      loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
      loader.load(new URLRequest(tokenizeUrl(url)));
    }

    private function handleLoadedData(evt : Event) : void {
      try {
        var loadedXml : XML = new XML(URLLoaderSpecial(evt.target).data);
        var caller : String = URLLoaderSpecial(evt.target).caller;
        var eventType : String = URLLoaderSpecial(evt.target).eventType;
        //trace(loadedXml);
        dispatchEvent(new ServiceEvent(eventType, false, false, loadedXml, caller));
      }catch (e : TypeError) {
        log("Could not parse text into XML");
        log(e.message);
      }
    }

    private function onLoadError(event : IOErrorEvent) : void {
      log('track not loaded');
      dispatchEvent(new ServiceEvent(ServiceEvent.NOT_FOUND));
    }

    public function get HOST_URL() : String {
      return _API_URL_HOST;
    }

    public function tokenizeUrl(url : String) : String {
      return url + (/\?/.test(url) ? "&" : "?") + "oauth_consumer_key=" + API_KEY;
    }

    public override function toString() : String {
      return "[ServiceManager]";
    }

    private function log(msg : String) : void {
      var logText : String = this.toString() + msg;
      trace(logText);
    }
  }
}

/**
 * This is a private class declared outside of the package
 * that is only accessible to classes inside of the ServiceManager.as
 * file.  Because of that, no outside code is able to get a
 * reference to this class to pass to the constructor, which
 * enables us to prevent outside instantiation.
 */
class SingletonLock {
}