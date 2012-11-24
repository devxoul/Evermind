package net.joyfl.evermind.node
{
	import net.joyfl.evermind.utils.node2xml;
	import net.joyfl.evermind.utils.xml2node;

	public class NodeHistory extends Object
	{
		
		private var currentSlot:int;
		private var container:NodeContainer;
		private var data:Vector.<NodeContainer>;
		
		public function NodeHistory ( container:NodeContainer, slotNum:int = 30 ) :void
		{
			super();
			this.container = container;
			data = new Vector.<NodeContainer>;
			currentSlot = 0;
			data.push( container.clone() );
		}
		
		public function get slotNum () :int
		{
			return data.length;
		}
		
		public function update () :void
		{
			if( canRedo ) data.splice( currentSlot + 1, Number.MAX_VALUE );
			++ currentSlot;
			data.push( container.clone() );
			trace( 'update', currentSlot, data.length );
			if( data.length > slotNum )
			{
				data.splice( 0, 1 );
				-- currentSlot;
			}
		}
		
		public function get currentContainer () :NodeContainer
		{
			return data[ data.length - 1 ].clone();
		}
		
		public function undo () :NodeContainer
		{
			if( !canUndo )
			{
				trace( 'Error : currentSlot < 0' );
				return null;
			}
			-- currentSlot;
			trace( currentSlot, data.length );
			container = data[ currentSlot ].clone();
			return container;
		}
		
		public function redo () :NodeContainer
		{
			if( !canRedo )
			{
				trace( 'Error : currentSlot == slotNum - 1' );
				return null;
			}
			++ currentSlot;
			trace( currentSlot, data.length );
			container = data[ currentSlot ].clone();
			return container;
		}
		
		public function get canUndo () :Boolean
		{
			if( currentSlot == 0 ) return false;
			return true;
		}
	
		public function get canRedo () :Boolean
		{
			if( currentSlot == slotNum - 1 ) return false;
			return true;
		}
		
	}
}