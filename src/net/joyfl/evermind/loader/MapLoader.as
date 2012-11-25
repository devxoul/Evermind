package net.joyfl.evermind.loader
{
	import com.adobe.crypto.SHA1;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.formatters.DateFormatter;
	import mx.graphics.codec.JPEGEncoder;
	
	import net.joyfl.evermind.events.EvermindEvent;
	import net.joyfl.evermind.models.Map;
	import net.joyfl.evermind.models.MapMetadata;
	import net.joyfl.evermind.preference.Preference;
	import net.joyfl.evermind.preference.PreferenceKey;
	import net.joyfl.evermind.utils.Base64;
	import net.joyfl.evermind.utils.node2xml;
	import net.joyfl.evermind.utils.xml2node;
	
	public class MapLoader extends EventDispatcher
	{
		static private const API_BASE_URL : String = "http://ec2.jagur.kr/api.php";
		
		private var _loader : URLLoader = new URLLoader();
		private var _expiredArguments : Array;
		
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
			var expireDates : Array = Preference.getValue( PreferenceKey.EXPIRE_TIME ).split( " " );
			var dateString : String = expireDates[0]; 
			var timeString : String  = expireDates[1];
			
			var dates : Array = dateString.split( "-" );
			var times : Array = timeString.split( ":" );
			var expireDate : Date = new Date( dates[0], dates[1] - 1, dates[2], times[0], times[1], times[2] );
			
			if( expireDate.time <= new Date().time )
			{
				_expiredArguments = arguments;
				auth( Preference.getValue( PreferenceKey.EMAIL ) as String, Preference.getValue( PreferenceKey.PASSWORD ) as String );
				return;
			}
			
			var url : String = API_BASE_URL + "?url=" + command + "&access_token=" + Preference.getValue( PreferenceKey.ACCESS_TOKEN );// + "&rand=" + Math.random();
			
			if( method == URLRequestMethod.POST )
			{
				postAPI( url, params );
				return;
			}
			
			var vars : URLVariables;
			if( params )
			{
				if( method == URLRequestMethod.GET )
				{
					for( var key : String in params )
					{
						url += "&" + key + "=" + params[key];
					}
				}
				else
				{
					vars = new URLVariables();
					for( key in params )
					{
						vars[key] = params[key];
					}
				}
			}
			
			trace( url );
			
			var req : URLRequest = new URLRequest( url );
			req.data = vars;
			req.method = method;
			
			_loader.load( req );
		}
		
		private function postAPI( url : String, params : Object ) : void
		{
			var req : URLRequest = new URLRequest( url );
			req.method = URLRequestMethod.POST;
			
			var boundary : String = "---------------------------14737809831466499882746641449";
			
			req.contentType = "multipart/form-data; boundary=" + boundary;
			
			var body : ByteArray = new ByteArray();
			body.endian = Endian.BIG_ENDIAN;
			
			if( params ) for( var key : String in params )
			{
				body.writeUTFBytes( "--" + boundary + "\r\n" );
				
				var value : Object = params[key];
				
				if( value is String )
				{
					body.writeUTFBytes( "Content-Disposition: form-data; name=\"" + key + "\"\r\n\r\n" );
					body.writeUTFBytes( value as String );
				}
				else if( value is BitmapData )
				{
					body.writeUTFBytes( "Content-Disposition: form-data; name=\"" + key + "\"; filename=\"" + key + "\"\r\n" );
					body.writeUTFBytes( "Content-Type: image/jpeg\r\n\r\n" );
					var img : ByteArray = new JPEGEncoder( 100 ).encode( BitmapData( value ) );
					body.writeBytes( img, 0, img.bytesAvailable );
				}
				else
				{
					trace( "other" );
				}
				
				body.writeUTFBytes( "\r\n" );
			}
			
			body.writeUTFBytes( "--" + boundary + "--\r\n" );
			
			req.data = body;
			
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
			api( "map", URLRequestMethod.POST );
		}
		
		public function setMap( map : Map ) : void
		{
			_loader.addEventListener( Event.COMPLETE, onSetMap );
			
			var xml : XML = new XML( <map /> );
			xml.appendChild( node2xml( map.node ) );
			
			var ba : ByteArray = new ByteArray();
			ba.writeUTFBytes( xml );
			
			api( "map/" + map.metadata.mapId + "/modify", URLRequestMethod.POST, {
				title: map.metadata.title,
				thumbnail: map.metadata.thumbnail,
				map: Base64.encode( ba )
			} );
		}
		
		
		
		private function onAuth( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onAuth );
			
			var json : Object = JSON.parse( e.target.data );
			if( json.status.code != 0 )
			{
				trace( "[MapLoader.onAuth()] Error" );
				return;
			}
			
			Preference.setValue( PreferenceKey.ACCESS_TOKEN, json.data.access_token );
			Preference.setValue( PreferenceKey.EXPIRE_TIME, json.data.expire_time );
			
			if( !_expiredArguments )
			{
				dispatchEvermindEvent( EvermindEvent.AUTH, json.data );
			}
			else
			{
				api.apply( api, _expiredArguments );
				_expiredArguments = null;
			}
		}
		
		private function onListMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onListMap );
			trace( e.target.data );
			var json : Object = JSON.parse( e.target.data );
			
			if( json.status.code != 0 )
			{
				trace( "[MapLoader.onListMap()] Error" );
				return;
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
			trace( e.target.data );
			var json : Object = JSON.parse( e.target.data );
			
			if( json.status.code != 0 )
			{
				trace( "[MapLoader.onGetMap()] Error" );
				return;
			}
			
			var metadata : MapMetadata = new MapMetadata();
			metadata.mapId = json.data.map_id;
			metadata.title = json.data.map_name;
			metadata.created = json.data.created_time;
			metadata.modified = json.data.modified_time;
			
			var map : Map = new Map();
			map.metadata = metadata;
			map.node = xml2node( new XML( Base64.decode( json.data.map_data.split( " " ).join( "+" ) ) ) );
			
			dispatchEvermindEvent( EvermindEvent.GET_MAP, map );
		}
		
		private function onCreateMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onCreateMap );
			trace( "create :", e.target.data );
			var json : Object = JSON.parse( e.target.data );
			
			if( json.status.code != 0 )
			{
				trace( "[MapLoader.onCreateMap()] Error" );
				return;
			}
			
			var metadata : MapMetadata = new MapMetadata();
			metadata.mapId = json.data.id;
			
			dispatchEvermindEvent( EvermindEvent.CREATE_MAP, metadata );
		}
		
		private function onSetMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onSetMap );
			trace( "set :", e.target.data );
			var json : Object = JSON.parse( e.target.data );
			
			if( json.status.code != 0 )
			{
				trace( "[MapLoader.onSetMap()] Error" );
				return;
			}
			
			dispatchEvermindEvent( EvermindEvent.SET_MAP, true );
		}
		
		private function dispatchEvermindEvent( type : String, data : Object ) : void
		{
			dispatchEvent( new EvermindEvent( type, data ) );
		}
	}
}