package Vines {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Xiler
	 */
	public class Vine50 extends Vine {
		protected static var data:BitmapData;
		public var clip:Bitmap;
		
		public function Vine50() {
			this.offsetX = -10.55;
			this.collisionMinY = 50;
			collisionMaxY = collisionMinY + VINE_OPENING;
			
			if(!data){
				var sprite:Sprite = new Vine50a();
				data = new BitmapData(sprite.width, sprite.height, true, 0x0);
				data.draw(sprite, null, null, null, null, true);
			}
			clip = new Bitmap(data, "auto", true);
			addChild(clip);
		}
	}
}