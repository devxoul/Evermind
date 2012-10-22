package net.joyfl.evermind.models
{
	import flash.display.BitmapData;

	[Bindable]
	public class MapMetadata
	{
		public var mapId : String;
		public var title : String;
		public var thumbnail : BitmapData;
		public var created : String;
		public var modified : String;
	}
}