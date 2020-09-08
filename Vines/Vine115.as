package Vines {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Xiler
	 */
	public class Vine115 extends Vine {
		protected static var data:BitmapData;
		public var clip:Bitmap;
		
		public function Vine115() {
			this.offsetX = -7.45
			this.collisionMinY = 115;
			collisionMaxY = collisionMinY + VINE_OPENING;
			
			if(!data){
				var sprite:Sprite = new Vine115a();
				//var m:Matrix = new Matrix();
				//m.translate(offsetX, 0);
				data = new BitmapData(sprite.width, sprite.height, true,0x0);
				data.draw(sprite, null, null, null, null, true);
			}
			clip = new Bitmap(data, "auto", true);
			addChild(clip);
		}
	}
}
