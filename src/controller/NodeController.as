﻿package evermind.controller {
	import flash.display.Stage;
	import evermind.node.NodeContainer;
	import flash.events.MouseEvent;
	import evermind.node.NodeView;
	import evermind.node.NodeData;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.BitmapData;
	
	public class NodeController extends Object {
		
		private const SLEEP_TIME:int = 10;
		private const SLIDE_BREAK:Number = 0.9;
		private const MOUSE_DELAY:int = 15;
		
		private var _finalEditingNode:NodeContainer;
		private var editingNode:NodeContainer;
		private var selectedNode:NodeContainer;
		private var isMouseDown:Boolean;
		private var isNewNode:Boolean;
		private var mouseDownPoint:Point;
		private var mouseDownCount:int;
		private var isMouseMoveMode:Boolean;
		
		private var renderingSleepTime:int;
		private var slideSpeed:Point;
		
		private var stage:Stage;
		private var container:NodeContainer;
		private var view:NodeView;
		
		/**
		*/
		public function get finalEditingNode ( ):NodeContainer
		{
			return _finalEditingNode;
		}
		
		/**
		*/
		public function NodeController ( stage:Stage, container:NodeContainer, view:NodeView ) {
			this.stage = stage;
			this.view = view;
			this.container = container;
			
			slideSpeed = new Point;
			renderingSleepTime = SLEEP_TIME;
			isMouseDown = false;
			isNewNode = false;
			mouseDownCount = 0;
			mouseDownPoint = new Point;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownEvent );
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpEvent );
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveEvent );
			stage.addEventListener(Event.ENTER_FRAME, enterFrameEvent );
			stage.addEventListener(Event.ENTER_FRAME, renderingEvent );
		}
		
		/**
		*/
		public function removeSelectedNode ():void
		{
			if( _finalEditingNode == null ) return;
			if( !(_finalEditingNode is NodeData) ) return;
			NodeData( _finalEditingNode ).removeThis();
			_finalEditingNode = null;
			view.render();
		}
		
		/**
		*/
		public function attachImageFile( node:NodeContainer, bitmap:BitmapData ):void
		{
			node.media = bitmap;
			view.render();
		}
		
		/**
		*/
		public function cancelMouseDown ():void
		{
			isNewNode = false;
			isMouseDown = false;
			selectedNode = null;
		}
		
		private function mouseDownEvent ( e:MouseEvent ) :void
		{
			selectedNode = container.getNodeByCode( e.target.name );
			isMouseDown = true;
			slideSpeed.x = slideSpeed.y = 0;
			mouseDownPoint.x = view.mouseX;
			mouseDownPoint.y = view.mouseY;
			if( _finalEditingNode != null ) _finalEditingNode = null;
			if( editingNode != selectedNode && editingNode != null )
			{
				editingNode.setEditMode( false );
				_finalEditingNode = editingNode;
				editingNode = null;
				view.render();
			}
			if( selectedNode == null )
			{
				return;
			}
			if( !selectedNode.isEditMode ) selectedNode.pop();
			isMouseMoveMode = false;
			mouseDownCount = MOUSE_DELAY;
			renderingSleepTime = SLEEP_TIME;
		}
		
		private function mouseUpEvent ( e:MouseEvent ) :void
		{
			if( (selectedNode != null && !isMouseMoveMode) || isNewNode )
			{
				selectedNode.setEditMode( true );
				editingNode = selectedNode;
			}
			//
			isNewNode = false;
			isMouseDown = false;
			selectedNode = null;
		}
		
		private function mouseMoveEvent ( e:MouseEvent ) :void
		{
			var p:Point;
			if( isMouseDown )
			{
				if( selectedNode == null )
				{
					p = new Point( (view.mouseX - mouseDownPoint.x), (view.mouseY - mouseDownPoint.y) );
					view.x += p.x * 1.5;
					view.y += p.y * 1.5;
					slideSpeed = p;
					mouseDownPoint.x = view.mouseX;
					mouseDownPoint.y = view.mouseY;
					return;
				}
			}
		}
		
		private function enterFrameEvent ( e:Event ) :void
		{
			if( isMouseDown && selectedNode != null )
			{
				if( selectedNode.isEditMode ) return;
				if( !isMouseMoveMode )
				{
					if( mouseDownCount == 0 && selectedNode is NodeData )
					{
						selectedNode.pop();
						isMouseMoveMode = true;
					}
					else
					{
						--mouseDownCount;
					}
					if( Point.distance( new Point( view.mouseX, view.mouseY ), mouseDownPoint ) > 40 )
					{
						isMouseMoveMode = true;
						selectedNode.pop();
						selectedNode = selectedNode.createNode( view.mouseX, view.mouseY - 10, "New Node", null );
						mouseDownPoint.x = view.mouseX;
						mouseDownPoint.y = view.mouseY;
						isNewNode = true;
						selectedNode.pop();
					}
					return;
				}
				
				for each ( var n:NodeContainer in selectedNode.getAllNode() )
				{
					n.x += view.mouseX - mouseDownPoint.x;
					n.y += view.mouseY - mouseDownPoint.y;
				}
				mouseDownPoint.x = view.mouseX;
				mouseDownPoint.y = view.mouseY;
			}
			else
			{
				view.x += slideSpeed.x;
				view.y += slideSpeed.y;
				slideSpeed.x *= SLIDE_BREAK;
				slideSpeed.y *= SLIDE_BREAK;
				if( renderingSleepTime > 0 ) --renderingSleepTime;
			}
		}
		
		function renderingEvent ( e:Event ):void
		{
			for each ( var n2:NodeContainer in container.getAllNode() )
			{
				n2.update();
			}
			if( renderingSleepTime > 0 ) view.render();
		}
	}
	
}
