package net.joyfl.evermind.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.joyfl.evermind.events.EvermindEvent;
	import net.joyfl.evermind.models.Map;
	import net.joyfl.evermind.models.MapMetadata;
	
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
		
		public function getMap() : void
		{
			_loader.addEventListener( Event.COMPLETE, onGetMap );
			onGetMap( null ); // temp
		}
		
		private function onListMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onListMap );
			
			var xml : XML = new XML(
				<data>
					<status>
						<code>0</code>
						<message></message>
					</status>
					<maps>
						<map id="ID1" title="Title1" created="Created1" modified="Modified1" />
						<map id="ID2" title="Title2" created="Created2" modified="Modified2" />
						<map id="ID3" title="Title3" created="Created3" modified="Modified3" />
						<map id="ID4" title="Title4" created="Created4" modified="Modified4" />
						<map id="ID5" title="Title5" created="Created5" modified="Modified5" />
					</maps>
				</data>
			);
			
			if( xml.status.code != 0 )
			{
				trace( "[MapLoader.onListMap()] Error" );
			}
			
			var maps : Array = [];
			for each( var mapXML : XML in xml..map )
			{
				var map : MapMetadata = new MapMetadata();
				map.title = mapXML.@title;
				map.created = mapXML.@created;
				map.modified = mapXML.@modified;
				
				maps.push( map );
			}
			
			dispatchEvermindEvent( EvermindEvent.LIST_MAPS, maps );
		}
		
		private function onGetMap( e : Event ) : void
		{
			_loader.removeEventListener( Event.COMPLETE, onGetMap );
		}
		
		private function dispatchEvermindEvent( type : String, data : Object ) : void
		{
			dispatchEvent( new EvermindEvent( type, data ) );
		}
	}
}