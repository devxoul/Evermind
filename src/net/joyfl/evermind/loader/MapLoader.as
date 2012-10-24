package net.joyfl.evermind.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.joyfl.evermind.events.EvermindEvent;
	import net.joyfl.evermind.models.Map;
	import net.joyfl.evermind.models.MapMetadata;
	import net.joyfl.evermind.utils.xml2node;
	
	public class MapLoader extends EventDispatcher
	{
		private const API_BASE_URL : String = "";
		
		private var _loader : Loader = new Loader();
		
		public function MapLoader()
		{
			
		}
		
		public function listMaps() : void
		{
			_loader.addEventListener( Event.COMPLETE, onListMap );
			onListMap( null ); // temp
		}
		
		public function getMap( mapId : String ) : void
		{
			_loader.addEventListener( Event.COMPLETE, onGetMap );
			onGetMap( null ); // temp
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
		
		
		private function onListMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onListMap );
			
			var xml : XML = new XML(
				<result>
					<status>
						<code>0</code>
						<message></message>
					</status>
					<data>
						<maps>
							<map id="ID1" title="Title1" created="Created1" modified="Modified1" />
							<map id="ID2" title="Title2" created="Created2" modified="Modified2" />
							<map id="ID3" title="Title3" created="Created3" modified="Modified3" />
							<map id="ID4" title="Title4" created="Created4" modified="Modified4" />
							<map id="ID5" title="Title5" created="Created5" modified="Modified5" />
						</maps>
					</data>
				</result>
			);
			
			if( xml.status.code != 0 )
			{
				trace( "[MapLoader.onListMap()] Error" );
			}
			
			var maps : Array = [];
			for each( var mapXML : XML in xml..map )
			{
				var map : MapMetadata = new MapMetadata();
				map.mapId = mapXML.@id;
				map.title = mapXML.@title;
				map.created = mapXML.@created;
				map.modified = mapXML.@modified;
				map.loadThumbnail();
				
				maps.push( map );
			}
			
			dispatchEvermindEvent( EvermindEvent.LIST_MAPS, maps );
		}
		
		private function onGetMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onGetMap );
			
			var xml : XML = new XML(
				<result>
					<status>
						<code>0</code>
						<message></message>
					</status>
					<data>
						<map id="devxoul_0" title="Evermind PPT" created="created" modified="modified">
							<node label="Introducing Evermind" color="0x42A79F">
								<node label="Features" x="125" y="-30" color="0x42A79F">
									<node label="Good design" x="238" y="-106" color="0x42A79F" />
									<node label="Easy to use" x="240" y="-65" color="0x42A79F" />
									<node label="Smooth sync" x="238" y="27" color="0x42A79F" />
								</node>
								<node label="Team" x="130" y="100" color="0x42A79F">
									<node label="전수열" x="240" y="82" color="0x42A79F" />
									<node label="길형진" x="240" y="136" color="0x42A79F" />
									<node label="천성혁" x="240" y="188" color="0x42A79F" />
									<node label="진재규" x="240" y="246" color="0x42A79F" />
								</node>
								<node media="http://example.com/evermind.png" x="-60" y="0" color="0x42A79F" />
							</node>
						</map>
					</data>
				</result>
			);
			
			if( xml.status.code != 0 )
			{
				trace( "[MapLoader.onGetMap()] Error" );
			}
			
			var metadata : MapMetadata = new MapMetadata();
			metadata.mapId = xml..map.@id;
			metadata.title = xml..map.@title;
			metadata.created = xml..map.@created;
			metadata.modified = xml..map.@modified;
			
			var map : Map = new Map();
			map.metadata = metadata;
			map.node = xml2node( xml..map );
			
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