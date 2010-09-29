package com.radioclouds.visualizer {
	import com.radioclouds.visualizer.api.ServiceEvent;	
	import com.radioclouds.visualizer.api.ServiceManager;	
	import com.asual.swfaddress.SWFAddressEvent;	
	import com.asual.swfaddress.SWFAddress;	
	
	import flash.events.IOErrorEvent;	
	import flash.media.SoundLoaderContext;	
	
	import caurina.transitions.properties.SoundShortcuts;	
	
	import flash.net.SharedObject;	
	import flash.display.StageDisplayState;	
	
	import com.radioclouds.visualizer.ErrorPanel;	
	import com.radioclouds.visualizer.InfoPanel;	
	
	import flash.media.SoundTransform;	
	
	import com.radioclouds.visualizer.PlayerEvent;	
	import com.radioclouds.visualizer.gui.RoundedBox;	
	
	import flash.display.DisplayObject;	
	import flash.display.Bitmap;	
	import flash.display.BitmapData;	
	import flash.display.IBitmapDrawable;	

	import com.radioclouds.visualizer.gui.TextFieldSpecial;	

	import flash.net.URLRequest;	
	import flash.media.SoundChannel;	
	import flash.media.Sound;	
	
	import caurina.transitions.Tweener;	
	
	import flash.display.StageAlign;	
	import flash.display.StageScaleMode;	
	import flash.events.KeyboardEvent;	
	import flash.events.MouseEvent;	

	import com.radioclouds.visualizer.gui.UserPoint;	

	
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	import com.radioclouds.visualizer.models.Track;	

	/**
	 * @author matas
	 */
	public class Main extends Sprite {
		private var _allContacts : Array = new Array();
		private var _userContainer : Sprite;
		private var _sound : Sound;
		private var _soundChannel : SoundChannel;
		private var _serviceManager : ServiceManager;
		private var _playerDisplay : PlayerDisplay;
		private var _soundDuration : Number;
		private var _isPaused : Boolean;
		private var _map : Sprite;
		private var _allTracksByUser : Array;
		private var _currentTrackId : Number;
		private var _graphContainer : Sprite;
		// all initial users, but me myself more often :)
		private var _initUsers : Array = ["matas", "forss", "buzzinflychriswoodward", "nanojazz", "rewir3d", "compost", "pavit", "progcitydeeptrax", "the-subliminal-kid", "mr-suitcase", "markusenochson", "littlejinder", "leon-somov", "dmitryfyodorov", "vidis", "flakeandsun", "howieb","global-fire"];
		//private var _initUsers : Array = ["matas", "forss", "howieb"];
		private var _infoPanel : InfoPanel;
		private var _errorMessage : ErrorPanel = new ErrorPanel("");
		private var _defaultVolume : Number = .8;
		private var _userSettings : SharedObject;
		private var _seekPosition : Number;
		private var _firstUserId : String;
		private var _currentUserId : String;

		public function Main() {
			
			init();
		}
		
		public function init():void{
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			SoundShortcuts.init();
			
			_userSettings = SharedObject.getLocal( "radioCloudsSettings");
			_defaultVolume  = _userSettings.data.volume || _defaultVolume;
			
			var flashVars : Object = this.root.loaderInfo.parameters;
			var startUser:String = (flashVars.user) ? flashVars.user : _initUsers[Math.round(Math.random()*(_initUsers.length-1))];
					
			
				
			_graphContainer = new Sprite();			
			
			var graphBackground : Sprite = new RoundedBox({width: 30000, height: 30000, x: -15000, y: -15000, radius: 0, color: 0x000fff});
			graphBackground.alpha = 0;
			_graphContainer.addChild(graphBackground);
			
			// add container for user icons
			_userContainer = new Sprite();
			_graphContainer.addChild(_userContainer);
			
			// container for player display
			_playerDisplay = new PlayerDisplay();
			_playerDisplay.visible = false;
			_playerDisplay.volume = _defaultVolume;	
			_playerDisplay.y = stage.stageHeight - _playerDisplay.height;
			
			// create map
			_map = new Sprite();
			
		
			_infoPanel = new InfoPanel();
			
			addChild(_graphContainer);
			addChild(_playerDisplay);
			addChild(_infoPanel);




			_graphContainer.addEventListener(MouseEvent.MOUSE_DOWN, startDragStage);
			_playerDisplay.addEventListener(PlayerEvent.VOLUME_CHANGED, onVolumeChanged);
			_playerDisplay.addEventListener(PlayerEvent.PAUSE, onSoundPause);
			_playerDisplay.addEventListener(PlayerEvent.PLAY, onWaveformClick);
			_playerDisplay.addEventListener(PlayerEvent.FULL_SCREEN_TOGGLE, toggleFullScreen);
			// initaiate moving of user container with keyboard
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
			_infoPanel.addEventListener(InfoPanel.SUBMIT, onUserQuery);
			stage.addEventListener(Event.RESIZE, onResize);
			

			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSwfAddressChange);
			SWFAddress.addEventListener(SWFAddressEvent.INIT, onSwfAddressChange);
			
			// init actions
			_allContacts = new Array();
			_serviceManager = ServiceManager.instance;
			loadFirstUser(startUser);
			// init width updates
			onResize(new Event(Event.RESIZE));
		}
		
		private function onSwfAddressChange(event : SWFAddressEvent) : void {
			
			var userId : String = (SWFAddress.getValue() == "/") ? _firstUserId : SWFAddress.getParameter("user");
			
			if(userId != _currentUserId && userId){
				if(_allContacts[userId]){
					_allContacts[userId].dispatchEvent(new MouseEvent(MouseEvent.CLICK));	
				}else{
					loadFirstUser(userId);	
				}
			}
		}

		private function onSoundPause(event : PlayerEvent) : void {
			stopSound();
		}
		
		private function onUserQuery(event : Event) : void {
			
			loadFirstUser(_infoPanel.userQuery);
		}

		private function reset():void{
			stopSound();
			removeEventListener(Event.ENTER_FRAME, onUpdate);
			_serviceManager.removeEventListener(ServiceEvent.TRACKS_LOADED, onTracksLoaded);
			_serviceManager.removeEventListener(ServiceEvent.CONTACTS_LOADED, onContactLoaded);
			
			_playerDisplay.reset();
			// remove all existing users
			while(_userContainer.numChildren){
			    _userContainer.removeChildAt(0);
			}
			// reset all contact array
			_allContacts = new Array();
			// remove error messages
			if(contains(_errorMessage)){
				removeChild(_errorMessage);
			}
		}
		
		private function startDragStage(event : MouseEvent) : void {
			_graphContainer.startDrag();
			addEventListener(MouseEvent.MOUSE_UP, function() : void {
				_graphContainer.stopDrag();
			});
		}

		
		public function onKeyboardEvent(event:KeyboardEvent):void { 
			
			trace("event.keyCode:" + event.keyCode);
			var moveDistance : Number  = 5;			
			
			switch(event.keyCode) { 
				case Keyboard.UP : 
					_graphContainer.y -= moveDistance;
					break;
				case Keyboard.RIGHT : 
					_graphContainer.x += moveDistance;
					break;
				case Keyboard.DOWN : 
					_graphContainer.y += moveDistance;
					break;
				case Keyboard.LEFT : 
					_graphContainer.x -= moveDistance;
					break;
				case Keyboard.SPACE :
					toggleSound();
					break;
				default: 
					break; 
			} 
		}
		
		private function toggleFullScreen(evt : PlayerEvent) : void {
			if(stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}else{
				stage.displayState = StageDisplayState.NORMAL;
			}
		} 

		private function loadFirstUser(userId : String) : void{
			
			log('loadFirstUser('+userId+')');
			reset();
			
			_isPaused = false;
			
			_firstUserId = userId;
			_currentUserId = userId;			
			
			_serviceManager.addEventListener(ServiceEvent.USERDATA_LOADED, onLoadFirstUser);
			_serviceManager.addEventListener(ServiceEvent.NOT_FOUND, onUserNotFound);
			_serviceManager.getUserData(userId);
		}
		
		private function onUserNotFound(event : PlayerEvent) : void {
			_errorMessage = new ErrorPanel("no data found for this user!");
			_errorMessage.x = (stage.stageWidth - _errorMessage.width) / 2;
			_errorMessage.y = (stage.stageHeight - _errorMessage.height) / 2;
			addChild(_errorMessage);
			Tweener.addTween(_errorMessage, {
				scaleX: 1.2,
				scaleY: 1.2,
				time: 2,
				transition:"easeoutelastic"
			});
		}

		
		private function onLoadFirstUser(evt : ServiceEvent) : void {

			_serviceManager.removeEventListener(ServiceEvent.USERDATA_LOADED, onLoadFirstUser);
			
			var loadedData : XML  = XML(evt.data);
			
			var userPermalink : String = loadedData.permalink;
			var userId : String = loadedData.id;
			var userName : String = loadedData.username;
			var userPicUrl : String = loadedData["avatar-url"];
			
			SWFAddress.setTitle("RadioCloud: " + userName);
			
			
			var centerUser : UserPoint = new UserPoint({
				userName: userName, 
				permalink: userPermalink,
				id: userId,
				userPicUrl: userPicUrl, 
				x: stage.stageWidth/2, 
				y: stage.stageHeight/2
			});
			
			centerUser.stayVisible = true;
			centerUser.addEventListener(MouseEvent.CLICK, onPointClicked);
			centerUser.addEventListener(Event.INIT, onUserPointOver);
			_allContacts[userId] = _userContainer.addChild(centerUser);;
			
			loadUserTracks(userId);
			loadUserContacts(userId);
			
		}
		
		private function onPointClicked(evt : MouseEvent) : void {
			// reset active buttons
			SWFAddress.setTitle("point clicked: ");
			for (var i : String in _allContacts) {
				_allContacts[i].stayVisible = false;
			}
			var clickPoint : UserPoint = UserPoint(evt.currentTarget);
			clickPoint.stayVisible = true;
			var permalink : String = clickPoint.permalink;
			log("onPointClicked("+permalink+") id:" + clickPoint.id);
			_currentUserId = clickPoint.id;
			SWFAddress.setTitle("RadioCloud: " + clickPoint.userName);
			SWFAddress.setValue("?user=" + _currentUserId);
			loadUserTracks(_currentUserId);
			loadUserContacts(_currentUserId);
		}
		

		private function loadUserTracks(userId : String) : void {
			log('loadUserTracks('+userId+')');
			_serviceManager.addEventListener(ServiceEvent.TRACKS_LOADED, onTracksLoaded);
			_serviceManager.getUserTracks(userId);
		}
		
		private function loadUserContacts(userId : String) : void {
			log('loadUserContacts('+userId+')');
			_serviceManager.addEventListener(ServiceEvent.CONTACTS_LOADED, onContactLoaded);
			_serviceManager.getUserContacts(userId);
		}
		

		private function onTracksLoaded(evt : ServiceEvent) : void {
			log('onTracksLoaded()');
			_serviceManager.removeEventListener(ServiceEvent.TRACKS_LOADED, onTracksLoaded);
			var loadedData : XML  = XML(evt.data);
			var callerUserName : String  = evt.caller;
			var userTracks : XMLList = loadedData.track;
			
			log('callerUserName:'+callerUserName + " user has " + userTracks.length() + "tracks");
			if(userTracks.length() > 0){
				_allTracksByUser = new Array();
				for(var i:Number = 0, l:Number = userTracks.length(); i < l; i++){
					var tmpTrack : Track = new Track(userTracks[i]);
					_allTracksByUser.push(tmpTrack);
				}
				// play first track by default
				playTrackByNumber(0);
			}else{
				// íf the user has no streamble tracks
				jumpToRandomUser();
			}
		}
		
		private function onContactLoaded(evt : ServiceEvent) : void {
			log('onContactLoaded()');
			_serviceManager.removeEventListener(ServiceEvent.CONTACTS_LOADED, onContactLoaded);
			var loadedData : XML  = XML(evt.data);
			var callerUserName : String  = evt.caller;
			var userContacts : XMLList = loadedData.user;
			
			log('callerUserName:'+callerUserName);
			
			// get the caller point
			var centerUserPoint : UserPoint = _allContacts[callerUserName];
			
			log("centerUserPoint:" + centerUserPoint);
			
			// center on stage on the caller point
			Tweener.addTween(_graphContainer, {
				x: stage.stageWidth/2 - centerUserPoint.x, 
				y:stage.stageHeight / 2 - centerUserPoint.y, 
				time:.6, 
				transition:"easeoutback"
			});
			
			// itterate through contacts
			for(var i:Number = 0, l = userContacts.length();i<l;i++){
				
				var tmpItem : XML = userContacts[i];
				var userName : String = tmpItem.username;
				var permalink : String = tmpItem.permalink;
				var userId : String = tmpItem.id;
				var userPicUrl : String = tmpItem["avatar-url"];
				
				if(_allContacts[userId]){ // if the user is already on stage, draw a line from ti to caller point
					
					_allContacts[userId].drawLineTo(centerUserPoint);
				}else{
					
					var distance : Number = 120 + (Math.random() * 200);
				
					var xPos : Number = centerUserPoint.x + (distance * Math.sin(((Math.PI * 2)/l)*i));
					var yPos : Number = centerUserPoint.y + (distance * Math.cos(((Math.PI * 2)/l)*i));
					
					var userPoint : UserPoint = new UserPoint({
						userName:userName, 
						permalink: permalink,
						id: userId,
						userPicUrl: userPicUrl, 
						x: xPos, 
						y: yPos
					}, centerUserPoint);
					
					userPoint.addEventListener(MouseEvent.CLICK, onPointClicked);
					userPoint.addEventListener(Event.INIT, onUserPointOver);		
					_allContacts[userId] = _userContainer.addChild(userPoint);					
				}
				
				
			}
			
			// bring center user to front
			bringToFront(centerUserPoint);
			
			
		}



		private function onVolumeChanged(event : PlayerEvent) : void {
			_defaultVolume = event.target.volume;
			changeSoundVolume(event.target.volume);
		}
		
		private function changeSoundVolume(newVolume : Number) : void {
			var transform:SoundTransform = new SoundTransform();
			transform.volume = newVolume;
			_soundChannel.soundTransform = transform;
		}

		private function onUserPointOver(event : Event) : void {
			bringToFront(Sprite(event.currentTarget));
		}

		private function bringToFront(target : Sprite) : void {
			target.parent.setChildIndex(target, target.parent.numChildren- 1);
		}

		private function playTrackByNumber(trackNumber : Number) : void {
			log("playTrackByNumber:" + _allTracksByUser.length);
			_currentTrackId = trackNumber;
			playTrack(_allTracksByUser[_currentTrackId]);
		}

		private function playTrack(track : Track) : void {
			log("playTrack: " + track.streamUrl);
			var url : String = track.streamUrl;
			
			// load track waveform
			_playerDisplay.visible = true;
			_playerDisplay.displayTrackData(track);
			
			// if some sound is already active, stop it
			fadeSound();
			// get track duration from xml
			_soundDuration = track.duration;
			
			_seekPosition = 0;
			
			// load the track
			_sound = new Sound();
			_sound.load(new URLRequest(_serviceManager.tokenizeUrl(url)));
			_sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_soundChannel = _sound.play(_seekPosition);
						
			if(_isPaused){
				stopSound();
			}
			
			
			
			//changeSoundVolume(_defaultVolume);
			fadeSound(_defaultVolume);
			
			// take care what happens after the track finished playing
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
			// display track info on special layer
			removeEventListener(Event.ENTER_FRAME, onUpdate);
			addEventListener(Event.ENTER_FRAME, onUpdate);
			
			_playerDisplay.paused = _isPaused;
			_playerDisplay.addEventListener(Event.CHANGE, onWaveformClick);
		}
		
		private function onLoadError(event : IOErrorEvent) : void {
			log("error loadin uri!");
		}

		public function toggleSound():void {
			if(_isPaused){
				resumeSound();
			}else{
				stopSound();	
			}
		}

		public function stopSound():void {
			if(_soundChannel) {
				_seekPosition = _soundChannel.position;
				_soundChannel.stop();
			}else {
				_seekPosition = 0;	
			}
			_isPaused = true;
			_playerDisplay.paused = _isPaused;
		}

		public function resumeSound():void {
			if(_soundChannel) {
				
				_soundChannel.stop();
				_soundChannel = _sound.play(_seekPosition);	
				changeSoundVolume(_defaultVolume);
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			_isPaused = false;
			_playerDisplay.paused = _isPaused;
		}
		
		private function fadeSound(targetVolume : Number = 0, fadeTime : Number  = 5) : void {
			if(_soundChannel){
				 //_soundChannel.stop();
				 Tweener.addTween(_soundChannel, {_sound_volume:targetVolume, time:fadeTime, onComplete: function(){
				 	if(targetVolume == 0){
				 			this.stop();
				 	};
				 }
				 });
			}
		} 
		private function onSoundComplete(event : Event) : void {
			log("sound completed");
			jumpToRandomUser();
		}
		
		private function jumpToRandomUser() : void {
			var randomPointer : Number = Math.round(Math.random() * _userContainer.numChildren - 1);
			UserPoint(_userContainer.getChildAt(randomPointer)).dispatchEvent(new MouseEvent(MouseEvent.CLICK));

			
		}
		
		

		private function onWaveformClick(event : Event) : void {
			_seekPosition = _playerDisplay.seekPosition;
			resumeSound();
		}

		private function onUpdate(event : Event) : void {
			if(_sound.bytesLoaded > 0){
				_playerDisplay.loadProgress = _sound.bytesLoaded / _sound.bytesTotal;
			}
			_playerDisplay.playProgress = _soundChannel.position;
		}



		// what happens, when the user resizes player
		private function onResize(evt : Event) : void {
			_playerDisplay.width = stage.stageWidth;
			_infoPanel.width = stage.stageWidth;
			_playerDisplay.y = stage.stageHeight - _playerDisplay.height;
		}
		

		
		
		public override function toString():String
		{
			return "[Main]";
		}
		
		private function log(msg):void{
			var logText : String = this.toString()+msg;
			trace(logText);
		}
	}
}
