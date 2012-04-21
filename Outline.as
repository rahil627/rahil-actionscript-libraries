package rahil {
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * Returns the points of each pixel that has a neighboring transparent pixel
	 * Also it is worth noting that this code treats out-of-bound pixels as being non-transparent.
	 * @author moagrius, http://upshots.org/actionscript-3/get-outline-from-bitmapdata
	 */
	public class Outline {
		
		private static const SPOTS:Array = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]];
		
		private var bitmapData:BitmapData;
		private var pixelTable:Array;
		private var rows:uint;
		private var cols:uint;
		
		public var points:Array;
		
		private var _outlineBitmapData:BitmapData;
		
		public function Outline(bmd:BitmapData):void {
			
			points = [];
			bitmapData = bmd;
			
			initialize();
		}
		
		private function initialize():void {
			
			rows = bitmapData.height;
			cols = bitmapData.width;
			
			pixelTable = new Array(rows);
			
			var row:Array;
			
			for (var i:int = 0; i < rows; i++){
				row = [];
				for (var j:int = 0; j < cols; j++){
					row[j] = bitmapData.getPixel32(j, i) >> 24 & 0xFF;
				}
				pixelTable[i] = row;
			}
			
			populate();
			
			//TODO: added by me
			setOutlineBitmapData();
		}
		
		public function hasTransparentNeighbor(rowIndex:uint, cellIndex:uint):Boolean {
			
			var spot:Array;
			var rowNum:int;
			var cellNum:int;
			var row:Array;
			
			for (var i:int = 0; i < 8; i++){
				spot = SPOTS[i];
				rowNum = rowIndex + spot[0];
				if (rowNum > -1){
					if (rowNum < rows){
						cellNum = cellIndex + spot[1];
						if (cellNum > -1){
							row = pixelTable[rowNum];
							if (cellNum < cols){
								if (!row[cellNum]){
									return true;
								}
							}
						}
					}
				}
			}
			return false;
		}
		
		private function populate():void {
			for (var i:int = 0; i < rows; i++){
				for (var j:int = 0; j < cols; j++){
					if (pixelTable[i][j]){
						if (hasTransparentNeighbor(i, j)){
							points.push(new Point(j, i));
						}
					}
				}
			}
		}
		
		//added by Rahil
		private function setOutlineBitmapData():void {			
			_outlineBitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0);
			for (var i:int = 0; i < points.length; i++) {
				_outlineBitmapData.setPixel32((points[i] as Point).x, (points[i] as Point).y, 0xFF0000FF);
			}
		}
		
		/**
		 * Returns a bitmap with a blue outline
		 * added by Rahil
		 */
		public function get outlineBitmapData():BitmapData {
			return _outlineBitmapData;
		}
	}
}