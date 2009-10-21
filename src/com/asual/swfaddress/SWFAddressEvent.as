/**
 * SWFAddress 2.1: Deep linking for Flash and Ajax - http://www.asual.com/swfaddress/
 * 
 * SWFAddress is (c) 2006-2007 Rostislav Hristov and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

package com.asual.swfaddress {

    import flash.events.Event;
    import com.asual.swfaddress.SWFAddress;

    /**
     * Event class for SWFAddress.
     */
    public class SWFAddressEvent extends Event {
        
        /**
         * Init event.
         */
        public static const INIT:String = 'init';

        /**
         * Change event.
         */
        public static const CHANGE:String = 'change';
        
        private var _value:String;
        private var _path:String;
        private var _pathNames:Array;
        private var _parameters:Object;
        private var _parametersNames:Array;
        
        /**
         * Creates a new SWFAddress event.
         * @param type Type of the event.
         * @constructor
         */
        public function SWFAddressEvent(type:String) {
            super(type, false, false);
            _value = SWFAddress.getValue();
            _path = SWFAddress.getPath();
            _pathNames = SWFAddress.getPathNames();
            _parameters = new Object();
            _parametersNames = SWFAddress.getParameterNames();
            for (var i:int = 0; i < _parametersNames.length; i++) {
                _parameters[_parametersNames[i]] = SWFAddress.getParameter(_parametersNames[i]);
            }
        }

        /**
         * The target of this event.
         */
        public override function get type():String {
            return super.type;
        }

        /**
         * The target of this event.
         */
        public override function get target():Object {
            return SWFAddress;
        }

        /**
         * The value of this event.
         */
        public function get value():String {
            return _value;
        }

        /**
         * The path of this event.
         */
        public function get path():String {
            return _path;
        }
        
        /**
         * The folders in the deep linking path of this event.
         */         
        public function get pathNames():Array {
            return _pathNames;
        }
        
        /**
         * The parameters of this event.
         */
        public function get parameters():Object {
            return _parameters;
        }
        
        /**
         * The parameters names of this event.
         */    
        public function get parametersNames():Array {
            return _parametersNames;
        }
    
        /**
         * Clones this event.
         */
        public override function clone():Event {
            return new SWFAddressEvent(type);
        }
    }
}
