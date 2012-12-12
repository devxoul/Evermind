package net.joyfl.evermind.events
{
	import flash.events.Event;
	
	public class EvermindEvent extends Event
	{
		static public const AUTH : String = "EvermindEvent_auth";
		static public const SIGN_UP : String = "EvermindEvent_signUp";
		static public const LIST_MAPS : String = "EvermindEvent_listMaps";
		static public const GET_MAP : String = "EvermindEvent_getMap";
		static public const CREATE_MAP : String = "EvermindEvent_createMap";
		static public const SET_MAP : String = "EvermindEvent_setMap";
		static public const DELETE_MAP : String = "EvermindEvent_deleteMap";
		
		static public const ERROR : String = "EvermindEvent_error";
		
		public var data : Object;
		
		public function EvermindEvent( type : String, data : Object = null )
		{
			super( type, false, false );
			
			this.data = data;
		}
	}
}