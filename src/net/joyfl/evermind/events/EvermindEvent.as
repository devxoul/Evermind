package net.joyfl.evermind.events
{
	import flash.events.Event;
	
	public class EvermindEvent extends Event
	{
		static public const LIST_MAPS : String = "EvermindEvent_ListMaps";
		static public const GET_MAP : String = "EvermindEvent_GetMap";
		
		public var data : Object;
		
		public function EvermindEvent( type : String, data : Object = null )
		{
			super( type, false, false );
			
			this.data = data;
		}
	}
}