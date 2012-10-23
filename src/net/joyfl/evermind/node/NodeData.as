package  net.joyfl.evermind.node {
	import flash.display.BitmapData;
	
	/**
	 * NodeData
	 * @langversion Action Script 3.0
	 * @playerversion Flash 11
	 * @author 천성혁 ( Seong-Hyeok Cheon ), cjstjdgur123@naver.com, http://blog.shipnk.com/
	 */
	
	public class NodeData extends NodeContainer {
		
		internal var _parent:NodeContainer;
		
		internal function setParent ( parent:NodeContainer ):void
		{
			_parent = parent;
			this.color = _parent.color;
		}
		
		/**
		 */
		override public function clone () :NodeContainer
		{
			var data:NodeData = new NodeData( this.x, this.y, this.title, this.media );
			for each ( var nd:NodeData in this.children )
			{
				data.addNode( nd.clone() as NodeData );
			}
			return data;
		}
		
		/**
		*/
		public function removeThis ( ) :void
		{
			_parent.removeNode( this );
		}
		
		/**
		 * 상위 노드를 담는다.
		 */
		public function get parent ( ):NodeContainer
		{
			return _parent;
		}
		
		/**
		 * 새로운 노드 데이터를 만든다.
		 * @param	x		노드의 x 값
		 * @param	y		노드의 y 값
		 * @param	title	노드의 title
		 * @param	color	노드의 색상
		 * @param	media	노드에 들어갈 미디어 객체
		 */
		public function NodeData ( x:Number, y:Number, title:String, media:BitmapData = null ) {
			super( x, y, title, 0, media );
		}

	}
	
}
