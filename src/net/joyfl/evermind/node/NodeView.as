package net.joyfl.evermind.node {
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * NodeView
	 * @langversion Action Script 3.0
	 * @playerversion Flash 11
	 * @author 천성혁 ( Seong-Hyeok Cheon ), cjstjdgur123@naver.com, http://blog.shipnk.com/
	 */
	
	public class NodeView extends Sprite {
		
		/**
		 * 그릴 NodeContainer를 담는다.
		 */
		public var container:NodeContainer;
		private var lineShape:Shape;
		
		/**
		 * NodeView 객체를 생성.
		 * @param	container	그릴 NodeContainer를 받는다.
		 */
		public function NodeView ( container:NodeContainer ) {
			this.container = container;
			lineShape = new Shape;
			this.addChild( lineShape );
		}
		
		
		/**
		 * 받은 NodeContainer로 렌더링한다.
		 */
		public function render ():void
		{
			this.removeChildren();
			this.addChild( lineShape );
			lineShape.graphics.clear();
			container.drawLine( this, lineShape );
			
		}
		
		/**
		 */
		public function getSnapshot ():BitmapData
		{
			var matrix:Matrix = new Matrix;
			var bitmap:BitmapData = new BitmapData( 900, 400, false, 0xFFFFFF );
			matrix.scale( 0.8, 0.8 );
			matrix.translate( 900 / 2, 400 / 2 );
			bitmap.draw( this, matrix );
			return bitmap;
		}
		
	}
	
}
