package rahil {
	import flash.display.BitmapData;
	
	/**
	 * A 4-connected neighborhood/blob
	 * @author Rahil Patel
	 */
	public class ConnectedComponent {
		
		public var label:int; //id
		public var size:int; //numberOfPixels
		public var bitmapData:BitmapData;
		
		public function ConnectedComponent(label:int = 0, size:int = 0, bitmapData:BitmapData = null) {
			this.label = label;
			this.size = size;
			this.bitmapData = bitmapData;
		}
	}
}