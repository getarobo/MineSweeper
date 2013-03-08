package 
{
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	

	public class Block extends MovieClip
	{
		private var _xx:int = -1;
		private var _yy:int = -1;
		
		private var _isMine:Boolean = false;
		private var _checked:Boolean = false;
		private var _mineCount:int = 0;
		private var _flagged:Boolean = false;
		private var _text:TextField;
		
		public function getText():String {
			return _text.text;
		}
			
		public function Block() {

			this.graphics.beginFill(0x333333);
			this.graphics.drawRect(0, 0, 20, 20);
			this.graphics.endFill();
			this.graphics.beginFill(0x666666);
			this.graphics.drawRect(2, 2, 16, 16);
			this.graphics.endFill();
			_text = new TextField();
			_text.x = 2;
			_text.y = 2;
			_text.width = 16;
			_text.height = 16;
			_text.selectable = false;
			_text.mouseEnabled = false;
			_text.visible = false;
			this.addChild(_text);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick($MouseEvent):void {
			var $e:DataEvent = new DataEvent("CLICKED");
			$e.data = _text.text;
			dispatchEvent($e);
		}
		
		public function reset():void {
			_isMine = false;
			_checked = false;
			_mineCount = 0;
			_flagged = false;
			_text.text = "";
			_text.visible = false;
			
			this.graphics.clear();
			this.graphics.beginFill(0x333333);
			this.graphics.drawRect(0, 0, 20, 20);
			this.graphics.endFill();
			this.graphics.beginFill(0x666666);
			this.graphics.drawRect(2, 2, 16, 16);
			this.graphics.endFill();
			
		}
		
		public function set xx($xx:int):void {
			_xx = $xx;

		}
		public function get xx():int {
			return _xx;
		}
		
		public function set yy($yy:int):void {
			_yy = $yy;
		}
		public function get yy():int {
			return _yy;
		}
		
		public function set flagged($f:Boolean):void {
			_flagged = $f;
			if( _flagged ){
				this.graphics.clear();
				this.graphics.beginFill(0x333333);
				this.graphics.drawRect(0, 0, 20, 20);
				this.graphics.endFill();
				this.graphics.beginFill(0xfff000);
				this.graphics.drawCircle(10,10,8);
				this.graphics.endFill();
			}else {
				this.graphics.clear();
				this.graphics.beginFill(0x333333);
				this.graphics.drawRect(0, 0, 20, 20);
				this.graphics.endFill();
				this.graphics.beginFill(0x666666);
				this.graphics.drawRect(2, 2, 16, 16);
				this.graphics.endFill();	
			}
		}
		public function get flagged():Boolean {
			return _flagged;
		}
		
		
		public function set isMine($m:Boolean):void {
			_isMine = $m;
			/*
			if( _isMine ){
				this.graphics.beginFill(0x333333);
				this.graphics.drawRect(0, 0, 20, 20);
				this.graphics.endFill();
				this.graphics.beginFill(0xfff000);
				this.graphics.drawRect(2, 2, 16, 16);
				this.graphics.endFill();
			}else {
				this.graphics.beginFill(0x333333);
				this.graphics.drawRect(0, 0, 20, 20);
				this.graphics.endFill();
				this.graphics.beginFill(0xfffDDD);
				this.graphics.drawRect(2, 2, 16, 16);
				this.graphics.endFill();
			}
			if ( _flagged ) {
				this.graphics.beginFill(0xfff000);
				this.graphics.drawCircle(10,10,8);
				this.graphics.endFill();	
			}*/
		}
		public function get isMine():Boolean {
			
			return _isMine;
		}
		
		public function set mineCount($mc:int):void {
			_mineCount = $mc;
			if ( $mc < 0 )
				_text.text = "M";
			else if( $mc != 0 )
				_text.text = ""+ $mc;
			
		}
		
		public function get mineCount():int {
			return _mineCount;
		}
		
		public function set checked($c:Boolean):void {
			_checked = $c;
			this.graphics.clear();
			if ( _checked )
				_text.visible = true;
			if ( _isMine ) {
				this.graphics.beginFill(0x333333);
				this.graphics.drawRect(0, 0, 20, 20);
				this.graphics.endFill();
				this.graphics.beginFill(0xffffff);
				this.graphics.drawRect(2, 2, 16, 16);
				this.graphics.endFill();
			}else if ( _mineCount >= 0 ) {
				this.graphics.beginFill(0x333333);
				this.graphics.drawRect(0, 0, 20, 20);
				this.graphics.endFill();
				this.graphics.beginFill(0xb2b2b2);
				this.graphics.drawRect(2, 2, 16, 16);
				this.graphics.endFill();
				
			}
		}
		public function get checked():Boolean {
			return _checked;
		}
		
	}
	
}