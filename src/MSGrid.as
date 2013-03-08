package {
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;

	public class MSGrid extends MovieClip {
		
		private var _grid:Array;
		private var _col:int = 0;
		private var _row:int = 0;
		private var _mine:int = 0;
		private var _spacePressed:Boolean = false;
		private var _selected:Array;
		private var _first:Boolean = true;
		
		private var _minePlacedCount:int = 0;
		private var _checkedCount:int = 0;
		
		private var _playing:Boolean = false;
		private var _addedEL:Boolean = false;
		
		
		public function MSGrid($row:int, $col:int, $mine:int) {
			_col = $col;
			_row = $row;
			_mine = $mine;

			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, 20 * _col, 20 * _row);
			this.graphics.endFill();
			
			init();
		}
		
		public function init():void {
			
			_selected = new Array();
			for (var k:int = 0 ; k < _col * _row -1; k++) {
				if ( k < _mine ) {
					_selected.push(1);
				}else {
					_selected.push(0);
				}
			}
			
			_grid = new Array();
			var block:Block;
			var count:int = 0;
			for ( var j:int = 0; j < _row  ; j++) {
				for ( var i:int = 0 ; i < _col ; i++) {
					block = new Block();
					block.x = 20 * i;
					block.y = 20 * (_row - j -1);
					block.xx = i;
					block.yy = j;
					_grid.push(block);
					this.addChild(block);
					count++;
				}
			}
		}
		
		public function reset():void {
			for each( var b:Block in _grid ) {
				b.reset();
			}
			_spacePressed = false;
			_minePlacedCount = 0;
			_checkedCount = 0;
			_first = true;
			
		}
		
		public function startGame():void {
			_playing = true;
			addEL();
		}
		
		private function addEL():void {
			if( !_addedEL ){
				for ( var i:int = 0 ; i < _grid.length ; i++) {
					_grid[i].addEventListener( "CLICKED", onClick );
				}
				this.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
				this.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
				_addedEL = true;
			}
		}
		
		private function removeEL():void {
			if( _addedEL ){
				for ( var i:int = 0 ; i < _grid.length ; i++) {
					_grid[i].removeEventListener( "CLICKED", onClick );
				}
				this.stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
				this.stage.removeEventListener( KeyboardEvent.KEY_UP, onKeyUp );
				_addedEL = true;
			}
		}
		
		private function onClick($e:DataEvent):void {
			if ( !_playing ) return;
			var block:Block = $e.currentTarget as Block;
			processClick( block );			
		}
		
		private function onKeyDown($e:KeyboardEvent):void {
			if ( $e.keyCode == 32 ) {//space
				_spacePressed = true;
			}
		}
		private function onKeyUp($e:KeyboardEvent):void {
			_spacePressed = false;
		}
		
		
		private function processClick( $b:Block):void {
			if ($b.checked ) return;
			if ( _spacePressed ) {
				MarkAsBomb( $b );
			}else{
				if ( _first ) {
					plantMinds($b.xx, $b.yy);
					markBlocks();
					_first = false;
				}
				if ( $b.isMine ) {
					trace("GAME OVER GAME OVER");
					$b.graphics.beginFill(0x333333);
					$b.graphics.drawRect(0, 0, 20, 20);
					$b.graphics.endFill();
					$b.graphics.beginFill(0xFF0000);
					$b.graphics.drawRect(1, 1, 18, 18);
					$b.graphics.endFill();
					gameOver();
					return;
				}
				floodCheck($b);
			}
		}
		private function MarkAsBomb( $b:Block):void {
			if( $b.flagged ){
				$b.flagged = false;
				_minePlacedCount--;
				trace("MINED:", _minePlacedCount);
			}else{
				$b.flagged = true;
				_minePlacedCount++;
				trace("MINED:", _minePlacedCount);
			}
			checkWin();
		}
		
		private function checkWin():void {
			if ( _minePlacedCount == _mine && (_minePlacedCount+_checkedCount) == _col*_row ) {
				var win:Boolean = true;
				for each( var b:Block in _grid ) {
					if ( b.flagged != b.isMine ) {
						win = false;
						break;
					}
				}
				if ( win ) {
					trace("WIN WIN WIN WIN");
					gameClear();
				}
			}

		}
		
		private function plantMinds($xx:int, $yy:int):void {
			_selected.sort(randomPick);
			for ( var i:int = 0 ; i < _col * _row-1; i++) {
				if ( _selected[i] == 1 ) {
					if( i < $xx + $yy*_col )
						_grid[i].isMine = true;
					else
						_grid[i+1].isMine = true;
				}else {
					if( i < $xx + $yy*_col )
						_grid[i].isMine = false;
					else
						_grid[i+1].isMine = false;
				}
			}
		}
		private function randomPick( a:int, b:int):Number {
			if ( Math.random() < 0.5 ) return -1;
			return 1;
		}
		
		private function markBlocks():void {
			for ( var i:int = 0 ; i < _grid.length ; i++) {
				markBlock(_grid[i] );
			}
		}
		
		private function markBlock($b:Block):void {
			if ( $b.isMine ) { 
				$b.mineCount = -1;
				return;
			}
			var mineCount:int = 0;
			
			if ( $b.xx > 0 && _grid[ IX($b.xx-1,$b.yy)].isMine ) {
				mineCount++;
			}
			if ( $b.xx < _col - 1 && _grid[ IX( $b.xx + 1, $b.yy)].isMine ) {
				mineCount++;
			}
			if ( $b.yy > 0 && _grid[ IX($b.xx, $b.yy -1)].isMine ) {
				mineCount++;
			}
			if ( $b.yy < _row - 1 && _grid[ IX($b.xx, $b.yy +1)].isMine ) {
				mineCount++;
			}
			
			if ( $b.xx > 0 && $b.yy > 0 && _grid[ IX( $b.xx - 1, $b.yy - 1) ].isMine) {
				mineCount ++;
			}
			if ( $b.xx > 0 && $b.yy < _row -1 && _grid[ IX( $b.xx - 1, $b.yy + 1) ].isMine) {
				mineCount ++;
			}
			if ( $b.xx < _col - 1 && $b.yy > 0 && _grid[ IX( $b.xx + 1, $b.yy - 1) ].isMine) {
				mineCount ++;
			}
			if ( $b.xx < _col -1 && $b.yy < _row -1 && _grid[ IX( $b.xx + 1, $b.yy + 1) ].isMine) {
				mineCount ++;
			}
			$b.mineCount = mineCount;
		}
		
		private function IX($x:int, $y:int):int {
			return $x + $y * _col;
		}
		
		private function floodCheck($b:Block):void {
			if ( !$b) return;
			if ( $b.isMine ) return;
			if ( $b.mineCount > 0) {
				_checkedCount++
				trace("CHECKED:", _checkedCount);
				$b.checked = true;
				checkWin();
				return;
			}else {
				_checkedCount++;				
				checkWin();
				trace("CHECKED:", _checkedCount);

				$b.checked = true;
				if ( $b.xx > 0 && !_grid[ IX($b.xx - 1, $b.yy )].checked ) {
					floodCheck( _grid[IX($b.xx - 1, $b.yy)] );
				}
				if ( $b.xx < _col -1 && !_grid[ IX($b.xx+1, $b.yy )].checked ){
					floodCheck( _grid[IX($b.xx + 1, $b.yy)] );
				}
				if ( $b.yy > 0 && !_grid[ IX($b.xx, $b.yy-1)].checked ){
					floodCheck( _grid[IX($b.xx, $b.yy-1)] );
				}
				if ( $b.yy < _row -1 && !_grid[ IX($b.xx, $b.yy+1 )].checked ){
					floodCheck( _grid[IX($b.xx, $b.yy+1)] );
				}
				
				if ( $b.xx > 0 && $b.yy > 0 && !_grid[ IX($b.xx-1, $b.yy-1 )].checked ){
					floodCheck( _grid[IX($b.xx - 1, $b.yy-1)] );
				}
				if ( $b.xx < _col -1 && $b.yy > 0 &&  !_grid[ IX($b.xx+1, $b.yy-1 )].checked ){
					floodCheck( _grid[IX($b.xx + 1, $b.yy-1)] );
				}
				if ( $b.xx < _col -1 && $b.yy < _row -1 && !_grid[ IX($b.xx+1, $b.yy+1)].checked ){
					floodCheck( _grid[IX($b.xx+1, $b.yy+1)] );
				}
				if ( $b.xx > 0 && $b.yy < _row -1 && !_grid[ IX($b.xx-1, $b.yy+1 )].checked ){
					floodCheck( _grid[IX($b.xx-1, $b.yy+1)] );
				}				
			}
		}
		
		private function gameClear():void {
			_playing = false;
			dispatchEvent( new Event("GameClear") );
		}
		
		private function gameOver():void {
			_playing = false;
			dispatchEvent( new Event("GameOver") );
		}

	
	}
}
		