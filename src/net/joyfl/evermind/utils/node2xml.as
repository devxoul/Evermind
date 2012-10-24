package net.joyfl.evermind.utils
{
	import net.joyfl.evermind.node.NodeContainer;

	public function node2xml( node : NodeContainer ) : XML
	{
		var xml : XML = new XML( <node label={node.title} color={node.color} /> );
		addChildXMLFromNode( xml, node );
			
		function addChildXMLFromNode( parentXML : XML, parentNode : NodeContainer ) : void
		{
			for each( var childNode : NodeContainer in parentNode.children )
			{
				var childNodeXML : XML = new XML( <node label={childNode.title} x={childNode.x} y={childNode.y} color={"0x" + childNode.color.toString( 16 ).toUpperCase()} /> );
				
				if( childNode.children.length > 0 )
					addChildXMLFromNode( childNodeXML, childNode );
				
				parentXML.appendChild( childNodeXML );
			}
		}
		
		return xml;
	}
}