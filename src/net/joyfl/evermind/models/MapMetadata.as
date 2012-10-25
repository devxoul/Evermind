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
		public var mapId : String;
		public var title : String;
		public var thumbnail : BitmapData;
		public var created : String;
		public var modified : String;
		
		public function loadThumbnail( url : String ) : void
		{
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