package {
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class GridSizeSelection extends MovieClip {
		
		private var _inited:Boolean = false;
		
		//movieclips
		private var _bg:MovieClip;
		private var _small:MovieClip;
		private var _medium:MovieClip;
		private var _large:MovieClip;
		
		private var _addedEL:Boolean = false;
		
		private var _gridSize:String = "small";
		
		private var _textSize:int = 20;
		private var _titleTextSize:int = 30;
		
		public function GridSizeSelection() {
			drawGridSelection();
		}
		
		private function drawGridSelection():void {
			trace("drawGridSelection() called");
			_inited = true;
			
			this.graphics.beginFill( 0xA3A3A3 );
			this.graphics.drawRect(0, 0, 680, 480);
			this.graphics.endFill();
			
			
			var _textFormat:TextFormat = new TextFormat();
			_textFormat.size = _textSize;
			
			_small = new MovieClip();
			_small.graphics.beginFill( 0x66FF33 );
			_small.graphics.drawRect( -100, -100, 200, 200 );
			_small.graphics.endFill();
			
			var _smallText:TextField = new TextField();
			_smallText.width = 100;
			_smallText.text = "Small\n9x9 grid\n10 mines";
			_smallText.x = -(_smallText.width/2);
			_smallText.y = -(_smallText.height / 2);
			_smallText.setTextFormat( _textFormat );
			_smallText.selectable = false;
			
			_small.addChild( _smallText );
			
			
			_medium = new MovieClip();
			_medium.graphics.beginFill( 0x3399FF );
			_medium.graphics.drawRect( -100, -100, 200, 200 );
			_medium.graphics.endFill();
			
			var _mediumText:TextField = new TextField();
			_mediumText.text = "Medium\n16x16 grid\n40 mines";
			_mediumText.x = -(_mediumText.width/2);
			_mediumText.y = -(_mediumText.height / 2);
			_mediumText.setTextFormat( _textFormat );
			_mediumText.selectable = false;
			
			_medium.addChild( _mediumText );
			
			
			_large = new MovieClip();
			_large.graphics.beginFill( 0xFFFF00 );
			_large.graphics.drawRect( -100, -100, 200, 200 );
			_large.graphics.endFill();
			
			var _largeText:TextField = new TextField();
			_largeText.text = "Large\n15x30\n99mines";
			_largeText.x = -(_largeText.width/2);
			_largeText.y = -(_largeText.height / 2);
			_largeText.setTextFormat( _textFormat );
			_largeText.selectable = false;
			
			_large.addChild( _largeText );
					
			
			var _gameTitle:TextField = new TextField();
			_gameTitle.text = "MineSweeper. Please select grid size.";
			_gameTitle.width = 680;
			_textFormat.size = _titleTextSize;
			_gameTitle.setTextFormat(_textFormat);
			_gameTitle.x = 340 -(_gameTitle.width/2);
			_gameTitle.y = 50;
			_gameTitle.selectable = false;
			
			_small.x = 120;
			_small.y = 315;
			
			_medium.x = 340;
			_medium.y = 315;
			
			_large.x = 560;
			_large.y = 315;
			
			_smallText.mouseEnabled = false;
			_mediumText.mouseEnabled = false;
			_largeText.mouseEnabled = false;			
			
			this.addChild( _gameTitle );
			this.addChild( _small );
			this.addChild( _medium );
			this.addChild( _large );
					
		}
		
		
		
		public function init():void {
			
			addEL();
		}
			

		private function addEL():void {
			if ( _inited && !_addedEL ) {
				_small.addEventListener( MouseEvent.CLICK, onSmall);
				_medium.addEventListener( MouseEvent.CLICK, onMedium );
				_large.addEventListener( MouseEvent.CLICK, onLarge );
				_small.buttonMode = true;
				_medium.buttonMode = true;
				_large.buttonMode = true;
				_addedEL = true;
			}
		}
		
		private function removeEL():void {
			if ( _inited && _addedEL ) {
				_small.removeEventListener( MouseEvent.CLICK, onSmall);
				_medium.removeEventListener( MouseEvent.CLICK, onMedium );
				_large.removeEventListener( MouseEvent.CLICK, onLarge );
				_small.buttonMode = false;
				_medium.buttonMode = false;
				_large.buttonMode = false;
				_addedEL = false;
			}
		}
		
		private function onSmall($e:MouseEvent):void {
			trace("[MW] small selected");
			_gridSize = "small";
			var e:DataEvent = new DataEvent("SizeSelected");
			e.data = _gridSize;
			dispatchEvent( e );
			removeEL();
		}
		
		private function onMedium($e:MouseEvent):void {
			trace("[MW] medium selected");
			_gridSize = "medium";
			var e:DataEvent = new DataEvent("SizeSelected");
			e.data = _gridSize;
			dispatchEvent( e );
			removeEL();
		}
		
		private function onLarge($e:MouseEvent):void {
			trace("[MW] large selected");
			_gridSize = "large";
			var e:DataEvent = new DataEvent("SizeSelected");
			e.data = _gridSize;
			dispatchEvent( e );	
			removeEL();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function cleanUp():void {
			removeEL();
		}
	}
}