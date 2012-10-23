package net.joyfl.evermind.node {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	/**
	 * NodeContainer
	 * @langversion Action Script 3.0
	 * @playerversion Flash 11
	 * @author 천성혁 ( Seong-Hyeok Cheon ), cjstjdgur123@naver.com, http://blog.shipnk.com/
	 */
	
	public class NodeContainer extends Object {
		
		
		/**
		 * 포함하고 있는 노드들을 배열로 담는다.
		 */
		public var children:Vector.<NodeData>;
		
		/**
		 * 노드의 x 값을 나타낸다. ( 하위 노드에 영향을 주지 않음. )
		 */
		public var x:Number;
		
		
		/**
		 *  노드의 y 값을 나타낸다. ( 하위 노드에 영향을 주지 않음. )
		 */
		public var y:Number;
		
		
		/**
		 * 노드의 Title
		 */
		public var title:String;
		
		
		/**
		 * 노드의 색상 ( 0x000000 ~ 0xFFFFFF )
		 */
		public var color:uint;
		
		
		/**
		 * 노드가 담고 있는 미디어 객체.
		 */
		public var media:BitmapData;
		
		
		/**
		 * 노드가 담고 있는 자식들의 수를 int 형으로 반환
		 */
		public function get numChildren () :int
		{
			return children.length;
		}
		
		
		/**
		 * 노드의 인덱스 값을 받아 NodeData를 반환
		 * @return 해당 위치의 NodeData
		 */
		public function getNodeByIndex ( idx:int ) :NodeData
		{
			return children[ idx ];
		}
		
		private var _isEditMode:Boolean;
		private var _textField:TextField;
		private var _bitmap:Bitmap;
		private var _bitmapContainer:Sprite;
		private var _leftPoint:Point;
		private var _rightPoint:Point;
		private var _code:uint;
		
		/**
		*/
		public function get isEditMode ():Boolean
		{
			return _isEditMode;
		}
		
		internal function get code ( ):uint
		{
			return _code;
		}
		
		internal function set code ( value:uint ):void
		{
			_code = value;
		}
		
		internal function get textField ():TextField
		{
			return _textField;
		}
		
		internal function get bitmap ():Bitmap
		{
			return _bitmap;
		}
		
		internal function get leftPoint ():Point
		{
			return _leftPoint;
		}
		
		internal function get rightPoint ():Point
		{
			return _rightPoint;
		}
		
		/**
		 * NodeContainer를 생성
		 * @param	x		노드의 x 값
		 * @param	y		노드의 y 값
		 * @param	title	노드의 title
		 * @param	color	노드의 색상
		 * @param	media	노드에 들어갈 미디어 객체
		 */
		public function NodeContainer ( x:Number, y:Number, title:String, color:uint, media:BitmapData = null ) {
			_textField = new TextField;
			_bitmap = new Bitmap;
			_bitmapContainer = new Sprite;
			_bitmapContainer.addChild( bitmap );
			_leftPoint = new Point;
			_rightPoint = new Point;
			_isEditMode = false;
			this.x = x;
			this.y = y;
			this.title = title;
			this.color = color;
			this.media = media;
			_code = 0xFFFFFFFF * Math.random();
			children = new Vector.<NodeData>;
		}
		
		
		/**
		 * 하위 노드를 생성한다.
		 * @param	x		노드의 x 값
		 * @param	y		노드의 y 값
		 * @param	title	노드의 title
		 * @param	color	노드의 색상
		 * @param	media	노드에 들어갈 미디어 객체
		 */
		public function createNode ( x:Number, y:Number, title:String, media:BitmapData = null ) :NodeData
		{
			var node:NodeData = new NodeData( x, y, title, media );
			node.setParent( this );
			children.push( node );
			return node;
		}
		
		/**
		 * 하위 노드를 추가한다.
		 * @param	node	추가할 노드.
		 */
		public function addNode ( node:NodeData ) :void
		{
			if( children.indexOf( node ) != -1 )
			{
				trace( '이미 존재하는 노드' );
				return;
			}
			if( node.parent != null )
			{
				trace( "이미 다른 부모를 가진 노드" );
				return;
			}
			node.setParent( this );
			children.push( node );
		}
		
		/**
		*/
		public function removeNode ( node:NodeData ):void
		{
			var idx:int = children.indexOf( node );
			if( idx == -1 )
			{
				trace( "Evermind Error :: NodeContainer.removeNode" );
				return;
			}
			children.splice( idx, 1 );
		}
		
		/**
		*/
		public function getNodeByCode ( code:uint ):NodeContainer
		{
			for each ( var n:NodeContainer in getAllNode() )
			{
				if( n.code == code ) return n;
			}
			return null;
		}
		
		public function getAllNode ():Vector.<NodeContainer>
		{
			var vector:Vector.<NodeContainer> = new Vector.<NodeContainer>;
			vector.push( this );
			for each ( var n:NodeData in children )
			{
				if( vector.indexOf( n ) == -1 ) vector.push( n );
				for each ( var n2:NodeData in n.getAllNode() )
				{
					if( vector.indexOf( n2 ) == -1 ) vector.push( n2 );
				}
			}
			return vector;
		}
		
		// 내부 처리 부분
		
		/**
		*/
		public function setEditMode ( bool:Boolean ) :void
		{
			if( media != null )
			{
				// 사진일때 취할 행동
				return;
			}
			_isEditMode = bool;
			if( bool )
			{
				_textField.selectable = true;
				_textField.type = TextFieldType.INPUT;
				_textField.border = true;
				_textField.borderColor = this.color;
				_textField.setSelection( 0, _textField.length );
			}
			else
			{
				if( _textField.text.length != 0 ) this.title = _textField.text;
				_textField.type = TextFieldType.DYNAMIC;
				_textField.selectable = false;
				_textField.border = false;
				_textField.setSelection( 0, 0 );
			}
		}
		
		/**
		*/
		public function pop ():void
		{
			_bitmapContainer.scaleX = _bitmapContainer.scaleY = _textField.scaleX = _textField.scaleY = 2;
		}
		
		public function update ():void
		{
			if( _textField.scaleX > 1 ) _bitmapContainer.scaleX = _bitmapContainer.scaleY = _textField.scaleX = _textField.scaleY *= 0.9;
			if( _textField.scaleX < 1 ) _bitmapContainer.scaleX = _bitmapContainer.scaleY = _textField.scaleX = _textField.scaleY = 1
		}
		
		internal function calculate ():void
		{
			if( media == null )
			{
				if( !_isEditMode )
				{
					_textField.text = this.title;
					_textField.selectable = false;
				}
				_textField.name = this.code + '';
				_textField.autoSize = TextFieldAutoSize.CENTER;
				_textField.x = this.x - _textField.width / 2;
				_textField.y = this.y - _textField.height / 2;
				_leftPoint.x = this.x - _textField.width / 2;
				_rightPoint.y = leftPoint.y = this.y + _textField.height / 2;
				_rightPoint.x = this.x + _textField.width / 2;
			}
			else
			{				
				_bitmap.bitmapData = this.media;
				_bitmapContainer.name = this.code + '';
				if( _bitmapContainer.width > 150 ) _bitmapContainer.scaleX = _bitmapContainer.scaleY = 150 / _bitmapContainer.width;
				_bitmapContainer.x = this.x - _bitmapContainer.width / 2;
				_bitmapContainer.y = this.y - _bitmapContainer.height / 2;
				
				_leftPoint.x = this.x - _bitmapContainer.width / 2;
				_rightPoint.y = leftPoint.y = this.y + _bitmapContainer.height / 2;
				_rightPoint.x = this.x + _bitmapContainer.width / 2;
			}
			_leftPoint.y = _rightPoint.y += 4;
			
		}
		
		internal function drawLine ( view:NodeView, shape:Shape, level:Number = 5, color:uint = 16777216 ):void
		{
			if( color == 16777216 ) 
			{
				this.calculate();
				color = this.color;
			}
			
			if( media != null )
			{
				drawPicture( view, shape, level, color );
				return;
			}
			
			view.addChild( textField );
			shape.graphics.lineStyle( level, color );
			shape.graphics.moveTo( _leftPoint.x, _leftPoint.y );
			shape.graphics.lineTo( _rightPoint.x, _rightPoint.y );
			
			var num:Number = 0.8;
			var a1:Point = new Point;
			var a2:Point = new Point;
			var node:NodeData;
			for( var i:int = 0; i < children.length; ++ i )
			{
				node = children[ i ];
				node.calculate();
				node.drawLine( view, shape, level * 0.85, color ); // drawLine
				shape.graphics.lineStyle( level, color );
				
				if( this.x < node.x )
				{
					a1 = _rightPoint;
					a2 = node.leftPoint;
				}
				else
				{
					a1 = _leftPoint;
					a2 = node.rightPoint;
				}
				
				shape.graphics.moveTo( a1.x, a1.y );
				shape.graphics.cubicCurveTo( (a2.x-a1.x) * num + a1.x, a1.y,
											a2.x - (a2.x-a1.x) * num, a2.y,
											a2.x, a2.y );
			}
		}
		
		private function drawPicture ( view:NodeView, shape:Shape, level:Number = 5, color:uint = 16777216 ):void
		{
			if( color == 16777216 ) color = this.color;
			
			view.addChild( _bitmapContainer );
			shape.graphics.lineStyle( level, color );
			shape.graphics.moveTo( _leftPoint.x, _leftPoint.y );
			shape.graphics.lineTo( _rightPoint.x, _rightPoint.y );
			
			
			var num:Number = 0.8;
			var a1:Point = new Point;
			var a2:Point = new Point;
			var node:NodeData;
			for( var i:int = 0; i < children.length; ++ i )
			{
				node = children[ i ];
				node.calculate();
				node.drawLine( view, shape, level * 0.85, color ); // drawLine
				shape.graphics.lineStyle( level, color );
				
				if( this.x < node.x )
				{
					a1 = _rightPoint;
					a2 = node.leftPoint;
				}
				else
				{
					a1 = _leftPoint;
					a2 = node.rightPoint;
				}
				
				shape.graphics.moveTo( a1.x, a1.y );
				shape.graphics.cubicCurveTo( (a2.x-a1.x) * num + a1.x, a1.y,
											a2.x - (a2.x-a1.x) * num, a2.y,
											a2.x, a2.y );
			}
		}
		
		public function clone () :NodeContainer
		{
			var data:NodeContainer = new NodeContainer( this.x, this.y, this.title, this.color, this.media );
			for each ( var nd:NodeData in this.children )
			{
				data.addNode( nd.clone() as NodeData );
			}
			return data;
		}
		
	}
	
}
