package com.radioclouds.visualizer.models {

  /**
   * @author matas
   */
  public class Comment {
    public var timestamp : Number;
    public var isTimedComment : Boolean;
    public var isReply : Boolean;
    public var iconUrl : String;
    public var body : String;
    public var username : String;
    public var createdAt : String;

    public function Comment(data : XML) {
			
      timestamp = Number(data.timestamp);
      isTimedComment = !Boolean(data.timestamp.@nil.toString());
      isReply = Boolean(uint(data["reply-to-id"]) > 0);
      iconUrl = data.user["avatar-url"].toString();
      body = data.body;
      username = data.user.username;
      createdAt = data["created-at"];
    }
  }
}
