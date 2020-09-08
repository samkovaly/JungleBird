package Vines {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Xiler
	 */
	public class Vine extends Sprite {
		
		protected var offsetX:Number;
		public var collisionMinY:Number;
		public var collisionMaxY:Number;
		public static const VINE_WIDTH:int = 120; // graphical constants
		public static const VINE_OPENING:int = 275;
		
		private static var theParent:Sprite;
		
		private static var spawnMultiples:int = 2;
		private static var vineArray:Array = new Array();
		private static var vinesInUse:Array = new Array();
		
		
		public function Vine() {
			
		}
		public function get getOffsetX():Number {
			return this.offsetX;
		}
		public function spawn(basePositionX:int):void {
			this.x = basePositionX + offsetX;
			this.y=0
		}
		public function unSpawn():void {
			this.x = -VINE_WIDTH;
			this.y = -this.height;
		}
		
		public static function setParent(parent:Sprite):void {
			theParent = parent;
		}
		public static function spawnVines():void {
			vineArray = new Array();
			for (var i:int = 0; i < spawnMultiples; i++) {
				vineArray.push(new Vine50());
				vineArray.push(new Vine115());
				
				vineArray.push(new Vine180());
				vineArray.push(new Vine245());
				vineArray.push(new Vine310());
				vineArray.push(new Vine375());
				vineArray.push(new Vine440());
				vineArray.push(new Vine505());
				vineArray.push(new Vine570());
				vineArray.push(new Vine635());
				vineArray.push(new Vine700());
				
			}
			for (var j in vineArray) {
				theParent.addChild(Vine(vineArray[j]));
				vineArray[j].x - VINE_WIDTH;
				vineArray[j].y = -vineArray[j].height;
			}
		}
		public static function getRandomVine():Vine {
			var selectedVine:Vine = vineArray[Math.floor(Math.random() * vineArray.length)];
			vineArray.splice(vineArray.indexOf(selectedVine), 1);
			
			vinesInUse.push(selectedVine);
			
			
			return selectedVine;
		}
		public static function addBackVine(returningVine:Vine):void {
			vineArray.push(returningVine);
			vinesInUse.splice(vinesInUse.indexOf(returningVine), 1);
		}		
	}
}