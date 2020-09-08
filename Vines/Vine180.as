package Vines {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Xiler
	 */
	public class Vine180 extends Vine {
		protected static var data:BitmapData;
		public var clip:Bitmap;
		
		public function Vine180() {
			this.offsetX = -13
			this.collisionMinY = 180;
			collisionMaxY = collisionMinY + VINE_OPENING;
			
			if(!data){
				var sprite:Sprite = new Vine180a();
				data = new BitmapData(sprite.width, sprite.height, true, 0x0);
				data.draw(sprite, null, null, null, null, true);
			}
			clip = new Bitmap(data, "auto", true);
			addChild(clip);
		}
	}
}
