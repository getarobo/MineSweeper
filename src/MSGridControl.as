package {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;

	public class MSGridControl extends MovieClip {
		
		private var _sGrid:MSGrid;
		private var _mGrid:MSGrid;
		private var _lGrid:MSGrid;
		
		private var _gridSize:String = "small";
		
		private var _addedEL:Boolean = false;
		
		private var _timeText:TextField;
		private var _timer:Timer;
		private var _time:int = 0;
		
		private var _replayButton:MovieClip;
		
		private var _resultText:TextField;
		
		
		public function MSGridControl() {
			this.graphics.beginFill(0xccccff);
			this.graphics.drawRect(0, 0, 680, 480);
			this.graphics.endFill();
			
			_replayButton = new MovieClip();
			_replayButton.graphics.beginFill(0xf2f2f2);
			_replayButton.graphics.drawRect(0, 0, 150, 75);
			_replayButton.graphics.endFill;
			
			
			
			
			var _text:TextField = new TextField();
			_text.text = "REPLAY";
			_text.x = 40;
			_text.y = 20;
			_text.selectable = false;
			_text.mouseEnabled = false;
			
			_replayButton.addChild(_text);
			_replayButton.buttonMode = true;
			_replayButton.visible = false;
			_replayButton.x = 500;
			_replayButton.y = 5;
			
			_resultText = new TextField();
			_resultText.text = "";
			var _textFormat:TextFormat = new TextFormat();
			_textFormat.size = 30;
			_resultText.setTextFormat(_textFormat);
			
			_resultText.x = 200;
			_resultText.y = 5;
			
			this.addChild( _resultText);
			
			
			this.addChild( _replayButton);
		}
		
		public function init():void {
			
			_timeText = new TextField();
			_timeText.text = "0 sec";
			_timer = new Timer(1000, 0);
			
			_timeText.x = 340 - _timeText.width;
			_timeText.y = 50;
			
			this.addChild( _timeText );
			
			
			_sGrid = new MSGrid(9, 9, 10);
			_sGrid.x = 340 - _sGrid.width / 2;
			_sGrid.y = 240 - _sGrid.height / 2;
						
			_mGrid = new MSGrid(16, 16, 40);
			_mGrid.x = 340 - _mGrid.width / 2;
			_mGrid.y = 240 - _mGrid.height / 2;
				
			_lGrid = new MSGrid(16, 30, 99);
			_lGrid.x = 340 - _lGrid.width / 2;
			_lGrid.y = 240 - _lGrid.height / 2;
			
			addEL();
		}
				
		private function addEL():void {
			if( !_addedEL ){
				_sGrid.addEventListener("GameClear", onGameClear);
				_sGrid.addEventListener("GameOver", onGameOver);
				
				_mGrid.addEventListener("GameClear", onGameClear);
				_mGrid.addEventListener("GameOver", onGameOver);
				
				_lGrid.addEventListener("GameClear", onGameClear);
				_lGrid.addEventListener("GameOver", onGameOver);
				
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
				
				_replayButton.addEventListener(MouseEvent.CLICK, onReplay);
				
				_addedEL = true;
			}
		}
		private function removeEL():void {
			if( _addedEL ){
				_sGrid.removeEventListener("GameClear", onGameClear);
				_sGrid.removeEventListener("GameOver", onGameOver);
				
				_mGrid.removeEventListener("GameClear", onGameClear);
				_mGrid.removeEventListener("GameOver", onGameOver);
				
				_lGrid.removeEventListener("GameClear", onGameClear);
				_lGrid.removeEventListener("GameOver", onGameOver);
				
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				
				_replayButton.removeEventListener(MouseEvent.CLICK, onReplay);

				_addedEL = false;
			}
		}
		
		
		public function reset($size:String):void {
			_gridSize = $size;
			if ( $size == "small") {
				_sGrid.reset();				
			}else if ( $size == "medium" ) {
				_mGrid.reset();
			}else {
				_lGrid.reset();
			}
			_timeText.text = "0 sec";
		}
		
		public function startGame():void {
			startTimer();
			if ( _gridSize == "small") {	
				this.addChild(_sGrid);
				_sGrid.startGame();

			}else if ( _gridSize == "medium" ) {
				this.addChild(_mGrid);
				_mGrid.startGame();
			}else {
				this.addChild(_lGrid);
				_lGrid.startGame();
			}
		}
		
		public function gameOver():void {
			if ( _gridSize == "small") {		
				this.removeChild(_sGrid);
			}else if ( _gridSize == "medium" ) {
				this.removeChild(_mGrid);
			}else {
				this.removeChild(_lGrid);
			}
		}
		
		private function startTimer():void {
			_time = 0;
			_timeText.text = "" + _time + " sec";
			_timer.stop();
			_timer.reset();
			_timer.start();
		}
		
		private function onTimer($e:TimerEvent):void{
			_time++;
			_timeText.text = "" + _time + " sec";
			
		}
		
		private function stopTimer():void {
			_timer.stop();
			_timer.reset();
		}
		
		private function onGameClear($e:Event):void {
			stopTimer();
			_replayButton.visible = true;
			_resultText.text = "GAME CLEAR";
		}
		private function onGameOver($e:Event):void {
			stopTimer();
			_replayButton.visible = true;
			_resultText.text = "GAME OVER";
		}
		
		private function onReplay($e:MouseEvent):void {
			trace("REPLAY REPLAY");
			gameOver();
			dispatchEvent(new Event("REPLAY") );
			_replayButton.visible = false;
		}
		

	
	}
}
		