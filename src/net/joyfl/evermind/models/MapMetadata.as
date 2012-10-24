package net.joyfl.evermind.models
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	[Bindable]
	public class MapMetadata
	{
		static private const THUMBNAIL_BASE_URL : String = "http://xoul.woobi.co.kr/evermind/thumb/";
		
		public var mapId : String;
		public var title : String;
		public var thumbnail : BitmapData;
		public var created : String;
		public var modified : String;
		
		public function loadThumbnail() : void
		{
			var url : String = THUMBNAIL_BASE_URL + mapId + ".png";
			trace( url );
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete  );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.load( new URLRequest( url ) );
		}
		
		private function onLoadComplete( e : Event ) : void
		{
			thumbnail = e.target.content.bitmapData;
		}
		
		private function onIOError( e : IOErrorEvent ) : void
		{
			trace( "ioError :", mapId );
		}
	}
}