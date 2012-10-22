package net.joyfl.evermind.models
{
	import net.joyfl.evermind.node.NodeContainer;

	public class Map
	{
		[Bindable]
		public var metadata : MapMetadata;
		public var node : NodeContainer;
	}
}