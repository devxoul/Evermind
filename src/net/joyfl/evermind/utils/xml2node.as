package net.joyfl.evermind.utils
{
	import net.joyfl.evermind.node.NodeContainer;
	import net.joyfl.evermind.node.NodeData;

	public function xml2node( xml : XMLList ) : NodeContainer
	{
		var node : NodeContainer = new NodeContainer( 0, 0, xml..node[0].@label, xml..node[0].@color );
		addChildNodesFromXML( node, xml..node[0].node );
		
		function addChildNodesFromXML( parentNode : NodeContainer, parentNodeXML : XMLList ) : void
		{
			for each( var childNodeXML : XML in parentNodeXML )
			{
				var childNode : NodeData = new NodeData( childNodeXML.@x, childNodeXML.@y, childNodeXML.@label );
				
				if( childNodeXML.node )
					addChildNodesFromXML( childNode, childNodeXML.node );
				
				parentNode.addNode( childNode );
			}
		}
		
		return node;
	}
}