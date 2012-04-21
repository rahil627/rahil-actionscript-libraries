package rahil {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.utils.ByteArray;
	
	/**
	 * My personal library for Flash
	 * @author Rahil Patel
	 */
	public class Flash {
		
		public static const RADIAN:Number = Math.PI / 180; //FP.RAD uses /-180
		public static const DEGREE:Number = 180 / Math.PI;
		
		/*
		 * Removes all of the children of the object
		 */
		public static function removeAllChildren(object:DisplayObjectContainer):void { //not really needed, unless you want to remove everything from the topmost object
			while (object.numChildren > 0)
				object.removeChildAt(0);
		}
		
		/*
		 * Removes all of the children of the object and itself
		 */
		public static function removeAllChildrenAndSelf(object:DisplayObjectContainer):void {
			removeAllChildren(object);
			object.parent.removeChild(object);
		}
		
		/**
		 * Converts degrees into radians
		 */
		public static function convertToRadians(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
		
		public static function degreesToRadians(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
		
		/**
		 * Converts radians into degrees
		 */
		public static function convertToDegrees(radians:Number):Number {
			return radians * 180 / Math.PI;
		}
		
		public static function radiansToDegrees(radians:Number):Number {
			return radians * 180 / Math.PI;
		}
		
		/**
		 * Returns a random whole number within the range provided
		 */
		public static function randomNumber(low:Number = 0, high:Number = 1):Number {
			return Math.floor(Math.random() * (1 + high - low)) + low;
		}
		
		/**
		 * Returns true if successful
		 * @param	chance - chance of success, range of 0-1
		 */
		public static function chance(chance:Number):Boolean {
			return (Math.random() < chance);
		}
		
		/**
		 * Returns the number of pixels within the bitmap that do not have a uint value of 0
		 */
		public static function numberOfPixelsInBitmapData(bitmapData:BitmapData):uint {
			var pixelVector:Vector.<uint> = bitmapData.getVector(bitmapData.rect);
			return numberOfPixelsInVector(pixelVector);
		}
		
		/**
		 * Returns the number of pixels within the pixel vector of a bitmap that do not have a uint value of 0
		 */
		public static function numberOfPixelsInVector(pixelVector:Vector.<uint>):uint {
			var numberOfPixels:uint;
			for each (var pixel:uint in pixelVector) {
				if (pixel != 0)
					numberOfPixels++;
			}
			return numberOfPixels;
		}
		
		/**
		 * Returns a 2d map of pixel colors (uint)
		 */
		public static function getPixelArray2d(bitmapData:BitmapData):Array {
			var rows:int = bitmapData.height;
			var cols:int = bitmapData.width;
			
			var pixelArray2d:Array = new Array(rows);
			var row:Array;
			for (var i:int = 0; i < rows; i++) {
				row = [];
				for (var j:int = 0; j < cols; j++) {
					row[j] = bitmapData.getPixel32(j, i); // >> 24 & 0xFF;
				}
				pixelArray2d[i] = row;
			}
			
			return pixelArray2d;
		}
		
		/**
		 * Traces out a 2d pixel map
		 */
		public static function debugPixelArray2d(pixelArray2d:Array):void {
			var cols:int = pixelArray2d.length
			var rows:int = (pixelArray2d[0] as Array).length;
			
			var s:String;
			for (var i:int = 0; i < rows; i++) {
				s = "";
				for (var j:int = 0; j < cols; j++) {
					s = s + (pixelArray2d[i][j] == 0 ? 0 : 1); //0s and 1s
				}
				trace(s);
			}
		}
		
		/**
		 * Traces out a 2D pixel map
		 */
		public static function debugBitmapData(bitmapData:BitmapData):void {
			var pixelTable:Array = getPixelArray2d(bitmapData);
			debugPixelArray2d(pixelTable);
		}
		
		/**
		 * Returns -1 or 1
		 */
		public static function sign(n:Number):int {
			return n < 0 ? -1 : 1;
		}
		
		//by senocular, should check out his utilities!
		/**
		 * Returns a deep copy of an object
		 * Warning: it returns an Object, so remember to cast it back yourself
		 * Also, it seems to only work for Arrays and Dictionaries, not any object
		 */
		public static function deepCopy(source:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return (copier.readObject());
		}
		
		/**
		 * Returns a shallow copy of an object
		 * Warning: it returns an Object, so remember to cast it back yourself
		 */
		public static function shallowCopy(sourceObj:Object):Object {
			//var cls:Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
			//var copyObject:Object = new cls(); //create an instance of the same class as objectA
			var copyObject:Object = new Object();
			
			for (var property:String in sourceObj) //loop through the properties of the object
				copyObject[property] = sourceObj[property];
			
			return copyObject;
		}
		
		public static function uintToHex(n:uint):String {
			return n.toString(16);
		
			//apparently the above implementation fails with zero spacing on some occasions
		/*
		   var digits:String = "0123456789ABCDEF";
		   var hex:String = '';
		
		   while (dec > 0){
		   var next:uint = dec & 0xF;
		   dec >>= 4;
		   hex = digits.charAt(next) + hex;
		   }
		
		   if (hex.length == 0)
		   hex = '0'
		
		   return hex;
		 */
		}
		
		public static function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean = false):void {
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration) {
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				//s.parent.addChild(mark);
				s.addChild(mark);
			}
		}
		
		/**
		 * display.tranform matrix by a registration point
		 */
		public static function setDisplayMatrix(display:DisplayObject, tx:Number = 0, ty:Number = 0, reg:Point = null, ang:Number = 0, scalex:Number = 1, scaley:Number = 1, skew:Number = 0, axis:String = "x"):void {
			
			reg = reg || new Point();
			var curM:Matrix = new Matrix();
			var skewM:Matrix = new Matrix();
			var rotM:Matrix = new Matrix();
			var scaleM:Matrix = new Matrix();
			var rp:Point;
			var r:Number = ang * Math.PI / 180;
			
			if (axis == "y") {
				skewM.c = Math.tan(skew);
			} else {
				skewM.b = Math.tan(skew);
			}
			
			scaleM.scale(scalex, scaley);
			rotM.rotate(r);
			
			curM.concat(scaleM);
			curM.concat(skewM);
			curM.concat(rotM);
			
			rp = curM.transformPoint(reg);
			
			curM.tx = -rp.x;
			curM.ty = -rp.y;
			curM.tx += tx;
			curM.ty += ty;
			
			display.transform.matrix = curM;
		}
		
		/**
		 * Traces out if any embedded fonts were found or not
		 */
		public static function debugEmbeddedFonts():void {
			var a:Array = Font.enumerateFonts(false);
			
			if (a.length > 0)
				trace("embedded font found: " + a[0]["fontName"]);
			else
				trace("no embedded fonts");
		}
		
		public static function getRandomPointWithinRectangle(rectangle:Rectangle):Point {
			var randomX:int = randomNumber(rectangle.left, rectangle.right);
			var randomY:int = randomNumber(rectangle.top, rectangle.bottom);
			return new Point(randomX, randomY);
		}
		
		/**
		 * Searches spirally outward from the inputted location
		 * The function is not meant to be used, it's just here for keepsake
		 * @param X max width of the search
		 * @param Y max height of the search
		 */
		public static function spiralSearch(X:int, Y:int):void {
			var cx:int = 0;
			var cy:int = 0;
			var dx:int = 0;
			var dy:int = -1;
			
			for (var i:int = 0; i < Math.pow(Math.max(X, Y), 2); i++) {
				if ((-X / 2 < cx <= X / 2) && (-Y / 2 < cy <= Y / 2))
					trace(cx, cy); //do stuff
				
				if (cx == cy || (cx < 0 && cx == -cy) || (cx > 0 && cx == 1 - cy)) {
					var dxTemp:int = dx;
					var dyTemp:int = dy;
					dx = -dyTemp;
					dy = dxTemp;
				}
				
				cx = cx + dx;
				cy = cy + dy;
			}
		}
		/*
		public static function openURL(url:String):void {
			navigateToURL(new URLRequest(url));
		}
		*/
	}
}