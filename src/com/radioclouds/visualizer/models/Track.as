package com.radioclouds.visualizer.models {

  /**
   * @author matas
   */
  public class Track {
    public var title : String;
    public var uri : String;
    public var permalink : String;
    public var permalinkUrl : String;
    public var userId : String;
    public var bpm : String;
    public var duration : Number;
    public var comments : Array = new Array();
    public var loaded : Boolean;
    public var id : String;
    public var artwork : String;
    public var downloadable : Boolean;
    public var streamable : Boolean;
    public var userName : String;
    public var userPermalink : String;
    public var userPermalinkUrl : String;
    public var streamUrl : String;
    public var waveformUrl : String;
    public var playbackCount : Number;
    public var downloadCount : Number;
    public var commentCount : Number;

    public function Track(data : XML) {
			
      title = data.title;
      uri = data.uri;
      permalink = data.permalink;
      permalinkUrl = data["permalink-url"];
      userId = data["user-id"];
      duration = Number(data.duration);
      bpm = data.bpm;
      id = data.id;
      artwork = data["artwork-url"];
      downloadable = (data["downloadable"] == "true");
      streamable = (data["streamable"] == "true");
      streamUrl = data["stream-url"];
      waveformUrl = data["waveform-url"];
      userName = data.user.username;
      userPermalink = data.user.permalink;
      userPermalinkUrl = data.user["permalink-url"];
      playbackCount = Number(data["playback-count"]);
      downloadCount = Number(data["download-count"]);
      commentCount = Number(data["comment-count"]);
			
			
      // parse all comments (if there are any) into array
      var commentData : XMLList = data.comments.comment;
      if(commentData.length() > 0) {
        parseComments(commentData);	
      }
    }

    public function parseComments(commentData : XMLList) : void {
      for(var i : uint = 0, l : uint = commentData.length();i < l;i++) {
        var commentTmp : Comment = new Comment(commentData[i]);
        comments.push(commentTmp);
      }
    }

    public function toString() : String {
      return "[Track]";
    }

    private function log(msg) : void {
      var logText : String = this.toString() + msg;
      trace(logText);
    }
  }
}
