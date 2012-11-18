package net.joyfl.evermind.node
{
	import net.joyfl.evermind.utils.node2xml;
	import net.joyfl.evermind.utils.xml2node;

	public class NodeHistory extends Object
	{
		
		private var currentSlot:int;
		private var slotNum:int;
		private var container:NodeContainer;
		private var xmls:Vector.<XML>;
		
		public function NodeHistory ( container:NodeContainer, slotNum:int = 30 ) :void
		{
			super();
		
			this.slotNum = slotNum;
			this.container = container;
			xmls = new Vector.<XML>;
			currentSlot = 0;
			xmls.push( node2xml( container ) );
		}
		
		public function update () :void
		{
			if( canRedo ) xmls.splice( currentSlot + 1, Number.MAX_VALUE );
			++ currentSlot;
			xmls.push( node2xml( container ) );
			if( xmls.length > slotNum )
			{
				xmls.splice( 0, 1 );
				-- currentSlot;
			}
		}
		
		public function get currentContainer () :NodeContainer
		{
			return xml2node( xmls[ xmls.length - 1 ] );
		}
		
		public function undo () :NodeContainer
		{
			if( !canUndo )
			{
				trace( 'Error : currentSlot < 0' );
				return null;
			}
			-- currentSlot;
			return xml2node( xmls[ currentSlot ] );
		}
		
		public function redo () :NodeContainer
		{
			if( !canRedo )
			{
				trace( 'Error : currentSlot == slotNum - 1' );
				return null;
			}
			++ currentSlot;
			return xml2node( xmls[ currentSlot ] );
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