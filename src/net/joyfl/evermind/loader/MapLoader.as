package net.joyfl.evermind.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import net.joyfl.evermind.events.EvermindEvent;
	import net.joyfl.evermind.models.Map;
	import net.joyfl.evermind.models.MapMetadata;
	import net.joyfl.evermind.preference.Preference;
	import net.joyfl.evermind.preference.PreferenceKey;
	import net.joyfl.evermind.utils.Base64;
	import net.joyfl.evermind.utils.xml2node;
	
	public class MapLoader extends EventDispatcher
	{
		private const API_BASE_URL : String = "http://ec2.jagur.kr/api.php";
		
		private var _loader : URLLoader = new URLLoader();
		
		public function MapLoader()
		{
			_loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
		}
		
		private function onIOError( e : IOErrorEvent ) : void
		{
			trace( e );
		}
		
		public function auth( email : String, password : String ) : void
		{
			_loader.addEventListener( Event.COMPLETE, onAuth );
			var url : String = API_BASE_URL + "?url=auth&email=" + email + "&password=" + password;
			var req : URLRequest = new URLRequest( url );
			_loader.load( req );
		}
		
		private function api( command : String, method : String, params : Object = null ) : void
		{
			var url : String = API_BASE_URL + "?url=" + command + "&access_token=" + Preference.getValue( PreferenceKey.ACCESS_TOKEN );
			trace( url );
			var vars : URLVariables = params ? new URLVariables() : null;
			for( var key : String in params )
			{
				vars[key] = params[key];
			}
			
			var req : URLRequest = new URLRequest( url );
			req.data = vars;
			req.method = method;
			
			_loader.load( req );
		}
		
		public function listMaps() : void
		{
			_loader.addEventListener( Event.COMPLETE, onListMap );
			api( "list", URLRequestMethod.GET );
		}
		
		public function getMap( mapId : String ) : void
		{
			_loader.addEventListener( Event.COMPLETE, onGetMap );
			api( "map/" + mapId, URLRequestMethod.GET );
		}
		
		public function createMap() : void
		{
			_loader.addEventListener( Event.COMPLETE, onCreateMap );
			onCreateMap( null ); // temp
		}
		
		public function setMap( map : Map ) : void
		{
			_loader.addEventListener( Event.COMPLETE, onSetMap );
			onSetMap( null ); // temp
		}
		
		
		
		private function onAuth( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onAuth );
			
			var json : Object = JSON.parse( e.target.data );
			if( json.status.code != 0 )
			{
				trace( "[MapLoader.onAuth()] Error" );
			}
			
			dispatchEvermindEvent( EvermindEvent.AUTH, json.data );
		}
		
		private function onListMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onListMap );
			
			var json : Object = JSON.parse( e.target.data );
			
			if( json.status.code != 0 )
			{
				trace( "[MapLoader.onListMap()] Error" );
			}
			
			var maps: Array = [];
			for each( var map : Object in json.data.maps )
			{
				var metadata : MapMetadata = new MapMetadata();
				metadata.mapId = map.map_id;
				metadata.title = map.map_name;
				metadata.created = map.created_time;
				metadata.modified = map.modified_time;
				metadata.loadThumbnail( map.base_url + map.thumbnail );
				
				maps.push( metadata );
			}
			
			dispatchEvermindEvent( EvermindEvent.LIST_MAPS, maps );
		}
		
		private function onGetMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onGetMap );
			
			var json : Object = JSON.parse( e.target.data );
			
			if( json.status.code != 0 )
			{
				trace( "[MapLoader.onGetMap()] Error" );
			}
			
			var xml : XML = new XML( Base64.decode( json.data.map_data.split( " " ).join( "+" ) ) );
			
			var metadata : MapMetadata = new MapMetadata();
			metadata.mapId = json.data.map_id;
			metadata.title = json.data.map_name;
			metadata.created = json.data.created_time;
			metadata.modified = json.data.modified_time;
			
			var map : Map = new Map();
			map.metadata = metadata;
			map.node = xml2node( xml );
			
			dispatchEvermindEvent( EvermindEvent.GET_MAP, map );
		}
		
		private function onCreateMap( e : EvermindEvent ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onCreateMap );
			
			var xml : XML = new XML(
				<result>
					<status>
						<code>0</code>
						<message></message>
					</status>
					<data>
						<map id="ID1" created="Created1" />
					</data>
				</result>
			);
			
			if( xml.status.code != 0 )
			{
				trace( "[MapLoader.onCreateMap()] Error" );
			}
			
			var metadata : MapMetadata = new MapMetadata();
			metadata.mapId = xml..map.@id;
			metadata.created = xml..map.@created;
			
			dispatchEvermindEvent( EvermindEvent.CREATE_MAP, metadata );
		}
		
		private function onSetMap( e : EvermindEvent ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onSetMap );
			
			var xml : XML = new XML(
				<result>
					<status>
						<code>0</code>
						<message></message>
					</status>
				</result>
			);
			
			if( xml.status.code != 0 )
			{
				trace( "[MapLoader.onSetMap()] Error" );
			}
			
			dispatchEvermindEvent( EvermindEvent.SET_MAP, true );
		}
		
		private function dispatchEvermindEvent( type : String, data : Object ) : void
		{
			dispatchEvent( new EvermindEvent( type, data ) );
		}
	}
}