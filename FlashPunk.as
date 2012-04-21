package rahil {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	/**
	 * My personal library for FlashPunk
	 * @author Rahil Patel
	 */
	public class FlashPunk {
		//the inheritance structure sucks, wish I could just add functions to class without inheriting it, like extension methods in C# - could use http://tobyho.com/2009/05/02/modifying-core-types-in/ but i doubt it has autocompletion
		
		/**
		 * Returns true if the point is off FP.screen
		 */
		public static function isOffScreen(x:Number, y:Number):Boolean { //could just check if point in rectangle
			if (x < 0 || x > FP.screen.width || y < 0 || y > FP.screen.height)
				return true;
			return false;
		}
		
		public static function stayOnScreen(entity:Entity):void {
			//if the origin is on the top left, stays fully on screen
			if (entity.originX == 0 && entity.originY == 0) {
				if (entity.x < 0)
					entity.x = 0;
				else if (entity.x + entity.width > FP.screen.width)
					entity.x = FP.screen.width - entity.width;
				if (entity.y < 0)
					entity.y = 0;
				else if (entity.y + entity.height > FP.screen.height)
					entity.y = FP.screen.height - entity.height;
			}
			else { //if the origin is in the center, goes half of screen
				if (entity.x < 0)
					entity.x = 0;
				else if (entity.x > FP.screen.width)
					entity.x = FP.screen.width;
				if (entity.y < 0)
					entity.y = 0;
				else if (entity.y > FP.screen.height)
					entity.y = FP.screen.height;
			}
		}
		
		public static function mouseIsOnEntity(entity:Entity):Boolean {
			return FP.distanceRectPoint(Input.mouseX, Input.mouseY, entity.x, entity.y, entity.width, entity.height) == 0;
		}
		
		public static function mousePressedOnEntity(entity:Entity):Boolean {
			return Input.mousePressed && mouseIsOnEntity(entity);
		}
		
		public static function pan(centerX:Number):Number {
			return ((centerX - FP.camera.x) / FP.width) * 2 - 1;
		}
		
	}
}