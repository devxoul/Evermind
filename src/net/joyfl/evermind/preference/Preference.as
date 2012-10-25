package net.joyfl.evermind.preference
{
	import flash.net.SharedObject;

	public class Preference
	{
		static private var _sharedObj : SharedObject;
		
		public function Preference()
		{
			throw new Error( "" );
		}
		
		static private function get sharedObj() : SharedObject
		{
			if( !_sharedObj )
				_sharedObj = SharedObject.getLocal( "net.joyfl.Evermind" );
			
			return _sharedObj;
		}
		
		static public function getValue( key : String ) : Object
		{
			return sharedObj.data[key];
		}
		
		static public function setValue( key : String, value : Object, flush : Boolean = false ) : Object
		{
			sharedObj.data[key] = value;
			if( flush ) sharedObj.flush();
			return value;
		}
		
		static public function flush() : void
		{
			sharedObj.flush();
		}
		
		static public function clear() : void
		{
			sharedObj.clear();
		}
	}
}