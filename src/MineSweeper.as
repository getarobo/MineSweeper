package {
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	
	
	[SWF(backgroundColor="#000000", width="680", height="480", frameRate="60")]
	public class MineSweeper extends MovieClip
	{
		//game
		private var _started:Boolean = false;
		
		//grid size selction panel
		private var _gssEL:Boolean = false;
		private var _gss:GridSizeSelection;
		
		//grid control
		private var _gridSize:String = "small";
		private var _gridControl:MSGridControl;
		private var _gridEL:Boolean = false;
	
		public function MineSweeper() {
			_gridControl = new MSGridControl();
			_gridControl.init();
						
			loadGridSizeSelection();
			
			this.addChildAt(_gridControl,0);
		}
		
		//create grid size selection panel and add events
		private function loadGridSizeSelection():void {
			_gss = new GridSizeSelection();
			_gss.init();
			_gss.x = 0;
			_gss.y = 0;
			addEL_gss();
			this.addChild( _gss );
		}

		private function addEL_gss():void {
			if( _gss && !_gssEL ){
				_gss.addEventListener( "SizeSelected", onSizeSelected );
				_gssEL = true;
			}
		}
		private function removeEL_gss():void {
			if( _gss && _gssEL ){
				_gss.removeEventListener( "SizeSelected", onSizeSelected );
				_gssEL = false;
			}
		}
		private function onSizeSelected($e:DataEvent):void {
			_gridSize = $e.data;
			trace("[MW] - gridSize:", _gridSize);
			this.removeChild(_gss);
			initAndStart();
		}
			
		// initial grid build up
		private function initAndStart():void {
			_gridControl.reset(_gridSize);
			addEL_grid();
			startGame();
		}
		
		private function addEL_grid():void {
			if ( _gridControl && !_gridEL) {
				_gridControl.addEventListener( "REPLAY", onReplay);
				_gridEL = true;
			}
		}
		private function removeEL_grid():void {
			if (  _gridControl && _gridEL ) {
				_gridControl.removeEventListener( "REPLAY", onReplay);
				_gridEL = false;
			}
		}
		
		private function startGame():void {
			_gridControl.startGame();
		}
		
		private function onReplay($e:Event):void {
			removeEL_grid();
			_gss.init();
			addEL_gss();
			addChild(_gss);
		}
		
		
		
		
		
		
		//cleanup
		
		public function cleanUp():void {
			removeEL_grid();
			removeEL_gss();
			
			if ( _gridControl ) {
			//	_gridControl.cleanUp();
			}
			if ( _gss ) {
			//	_gridControl.cleanUp();
			}
			
			while ( this.numChildren ) {
				this.removeChildAt(0);
			}
		}
		
			
		
	}
	
	
	
}