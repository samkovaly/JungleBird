package Vines {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Xiler
	 */
	public class Vine635 extends Vine {
		protected static var data:BitmapData;
		public var clip:Bitmap;
		
		public function Vine635() {
			this.offsetX = -9.05;
			this.collisionMinY = 635;
			collisionMaxY = collisionMinY + VINE_OPENING;
			
			if(!data){
				var sprite:Sprite = new Vine635a();
				data = new BitmapData(sprite.width, sprite.height, true, 0x0);
				data.draw(sprite, null, null, null, null, true);
			}
			clip = new Bitmap(data, "auto", true);
			addChild(clip);
		}
	}
}