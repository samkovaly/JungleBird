package Vines {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Xiler
	 */
	public class Vine245 extends Vine {
		protected static var data:BitmapData;
		public var clip:Bitmap;
		
		public function Vine245() {
			this.offsetX = -9.10;
			this.collisionMinY = 245;
			collisionMaxY = collisionMinY + VINE_OPENING;
			
			if(!data){
				var sprite:Sprite = new Vine245a();
				data = new BitmapData(sprite.width, sprite.height, true, 0x0);
				data.draw(sprite, null, null, null, null, true);
			}
			clip = new Bitmap(data, "auto", true);
			addChild(clip);
		}
	}
}



