package rahil {
	import de.polygonal.ds.Itr;
	import de.polygonal.ds.ListSet;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	/**
	 * see http://en.wikipedia.org/wiki/Connected-component_labeling
	 * @author Rahil Patel
	 * @example
	   var c:ConnectedComponentLabeling = new ConnectedComponentLabeling(FP.getBitmap(Global.GRAPHIC_LASER_GUN));
	   var a:Array = c.blobs;
	   trace(a);
	 */
	public class ConnectedComponentLabeling {
		
		private var bitmapData:BitmapData
		private var rows:int;
		private var cols:int;
		private var pixelTable:Array;
		private var labelTable:Array;
		private var label:int = 1;
		private var equivalences:Vector.<ListSet> = new Vector.<ListSet>();
		private var _connectedComponents:Vector.<ConnectedComponent> = new Vector.<ConnectedComponent>();
		private var _numberOfConnectedComponents:int;
		
		//[Embed(source = '../assets/graphics/test.png')]
		//private const GRAPHIC_TEST:Class;
		
		public function ConnectedComponentLabeling(bitmapData:BitmapData):void {
			//von Neumann neighborhood, pixel connectivity, flood fill, magic wand, Connected-component labeling 
			
			//load a bitmap
			this.bitmapData = bitmapData;
			rows = bitmapData.height;
			cols = bitmapData.width;
			
			//init
			
			//convert 1d array to 2d array to iterate easily
			pixelTable = new Array(rows);
			var row:Array;
			for (var i:int = 0; i < rows; i++){
				row = [];
				for (var j:int = 0; j < cols; j++){
					row[j] = bitmapData.getPixel32(j, i); // >> 24 & 0xFF;
				}
				pixelTable[i] = row;
			}
			
			//create a 2d array to hold the labels, init to 0
			labelTable = new Array(rows)
			//var row:Array;
			for (var i:int = 0; i < rows; i++){
				row = [];
				for (var j:int = 0; j < cols; j++){
					row[j] = 0;
				}
				labelTable[i] = row;
			}
			
			//add the 0 set id set
			equivalences[0] = new ListSet();
			
			//run the algorithm
			solve();
			
			//output the pixel groups info
			_numberOfConnectedComponents = _connectedComponents.length;
		}
		
		private function solve():void {
			/* http://en.wikipedia.org/wiki/Connected-component_labeling
			 * two pass algorithm
			   On the first pass:
			   Iterate through each element of the data by column, then by row (Raster Scanning)
			   If the element is not the background
			   Get the neighboring elements of the current element
			   If there are no neighbors, uniquely label the current element and continue
			   Otherwise, find the neighbor with the smallest label and assign it to the current element
			   Store the equivalence between neighboring labels
			   On the second pass:
			   Iterate through each element of the data by column, then by row
			   If the element is not the background
			   Relabel the element with the lowest equivalent label
			 */
			
			/*
			   algorithm TwoPass(data)
			   linked = []
			   labels = structure with dimensions of data, initialized with the value of Background
			
			   First pass
			
			   for row in data:
			   for column in row:
			   if data[row][column] is not Background
			
			   neighbors = connected elements with the current element's label
			
			   if neighbors is empty
			   linked[NextLabel] = set containing NextLabel
			   labels[row][column] = NextLabel
			   NextLabel += 1
			
			   else
			
			   Find the smallest label
			
			   L = neighbors labels
			   labels[row][column] = min(L)
			   for label in L
			   linked[label] = union(linked[label], L)
			
			   Second pass
			
			   for row in data
			   for column in row
			   if data[row][column] is not Background
			   labels[row][column] = find(labels[row][column])
			
			   return labels
			 */
			
			//begin algorithm
			//first pass
			for (var i:int = 0; i < rows; i++){
				for (var j:int = 0; j < cols; j++){
					if (pixelTable[i][j] != 0)
						setLabel(i, j);
				}
			}
			
			//debugLabelTable();
			
			//debugEquivalences();
			
			//merge equivalences?
			
			//delete the empty sets
			//equivalences.length
			//var indexesToDelete:Array = new Array();
			//for (var i:int = 0; i < equivalences.length; i++) {
			//if (equivalences[i].isEmpty)
			//indexesToDelete.push(i);
			//trace("index to delete: " + i);
			//}
			//
			//for each (var i:int in indexesToDelete) {
			//
			//}
			//
			//sort by comparing isEmpty, then splice?
			//equivalences.sort
			
			//second pass
			for (var i:int = 0; i < rows; i++){
				for (var j:int = 0; j < cols; j++){
					if (pixelTable[i][j] != 0)
						setLabel2(i, j)
				}
			}
			
			//debugLabelTable();
			
			//debugEquivalences
			
			//Get the neighboring elements of the current element
			//If there are no neighbors, uniquely label the current element and continue
			//Otherwise, find the neighbor with the smallest label and assign it to the current element
			//Store the equivalence between neighboring labels
			//On the second pass:
			//Iterate through each element of the data by column, then by row
			//If the element is not the background
			//Relabel the element with the lowest equivalent label
			
			//extract blob info
			//number of blobs, size of blob, approximate x position of blob, etc.
			for (var i:int = 0; i < rows; i++){
				for (var j:int = 0; j < cols; j++){
					if (pixelTable[i][j] != 0){
						createConnectedComponents(i, j);
					}
				}
			}
		
			//testing blob bitmaps
			//for each (var cc:ConnectedComponent in _connectedComponents) {
			//trace(cc.label);
			//Flash.debugBitmapData(cc.bitmapData);
			//}
		}
		
		private function setLabel(row:uint, col:uint):void {
			//neighbors = connected elements with the current element's label
			//
			//if neighbors is empty
			//linked[NextLabel] = set containing NextLabel                    
			//labels[row][column] = NextLabel
			//NextLabel += 1
			
			var current:int = labelTable[row][col];
			var westNeighbor:int = col - 1 < 0 ? 0 : labelTable[row][col - 1];
			var northNeighbor:int = row - 1 < 0 ? 0 : labelTable[row - 1][col];
			
			if (westNeighbor == 0 && northNeighbor == 0){
				current = label;
				label++;
				
				equivalences[current] = new ListSet();
			} else {
				//else
				//
				//Find the smallest label
				//
				//L = neighbors labels
				//labels[row][column] = min(L)
				//for label in L
				//linked[label] = union(linked[label], L)
				
				if (westNeighbor == 0) //init to 99 instead, so don't have to check here?
					current = northNeighbor;
				else if (northNeighbor == 0)
					current = westNeighbor;
				else
					current = Math.min(westNeighbor, northNeighbor);
				
				//store equivalences
				if (westNeighbor != 0)
					equivalences[current].set(westNeighbor);
				if (northNeighbor != 0)
					equivalences[current].set(northNeighbor);
			}
			
			labelTable[row][col] = current; //reference did not work? Because it's a primitive data type?
		}
		
		private function setLabel2(row:uint, col:uint):void {
			//Second pass
			//
			//for row in data
			//for column in row
			//if data[row][column] is not Background         
			//labels[row][column] = find(labels[row][column])
			
			//should be using union find, to get the lowest equivalent set
			//but instead it loops through equivalences starting from the lowest index and returns the first match
			
			var lowestLabel:int = 0;
			for each (var l:ListSet in equivalences){
				//trace(l); //same as l.toString()
				if (l.contains(labelTable[row][col])){
					lowestLabel = l.key; //key or use i of a for loop?
					break;
				}
			}
			
			//special case for a single pixel
			//if no neighbors, no equivalence would exist
			if (lowestLabel == 0)
				return;
			
			labelTable[row][col] = lowestLabel;
		}
		
		private function createConnectedComponents(row:int, col:int):void {
			
			var currentLabel:int = labelTable[row][col];
			var connectedComponent:ConnectedComponent = null; //somehow was holding the last value

			//find the blob with the current label
			for each (var cc:ConnectedComponent in _connectedComponents) {
				if (cc.label == currentLabel)
					connectedComponent = cc;
			}
			
			//create one if it does not exist
			if (!connectedComponent) {
				connectedComponent = new ConnectedComponent(currentLabel, 0, new BitmapData(bitmapData.width, bitmapData.height, true, 0))
				_connectedComponents.push(connectedComponent);
			}
			
			//increase the size
			connectedComponent.size = connectedComponent.size + 1;
				
			//draw the pixel
			connectedComponent.bitmapData.setPixel32(col, row, pixelTable[row][col])
		}
		
		private function debugLabelTable():void {
			var s:String;
			for (var i:int = 0; i < rows; i++){
				s = "";
				for (var j:int = 0; j < cols; j++){
					s = s + labelTable[i][j];
				}
				trace(s);
			}
		}
		
		private function debugEquivalences():void {
			var iter:Itr;
			for each (var l:ListSet in equivalences){
				trace(l); //same as l.toString()
				iter = l.iterator();
				while (iter.hasNext()){
					var element:* = iter.next();
					trace(element);
				}
				iter.reset();
			}
		}
		
		public function get connectedComponents():Vector.<ConnectedComponent> {
			return _connectedComponents;
		}
		
		public function get numberOfConnectedComponents():int {
			return _numberOfConnectedComponents;
		}
	}
}