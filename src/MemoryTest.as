package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import away3d.premium.DomainMemoryOprator;
	import away3d.premium.heap.HeapAllocator;
	import away3d.premium.heap.MemoryItem;
	
	CONFIG::FlexDebug{
		import avm2.intrinsics.memory.fake.li8;
		import avm2.intrinsics.memory.fake.si8;
	}
		
	CONFIG::FlexRelease{
		import avm2.intrinsics.memory.li8;
		import avm2.intrinsics.memory.si8;
	}
	
	public class MemoryTest extends Sprite
	{
		private var vec:Vector.<ByteArray> = new Vector.<ByteArray>(1000, true);
		private var item0:MemoryItem;
		private var item1:MemoryItem;
		private var item2:MemoryItem;
		private var item3:MemoryItem;
		private var item4:MemoryItem;
		private var item5:MemoryItem;
		private var item6:MemoryItem;
		
		private static var console : TextField;
		private static var isInit : Boolean = false;
		
		private var heapStart:int;
		
		public function MemoryTest()
		{
			init(stage);
			
			DomainMemoryOprator.mallocBuffer(1024*1024, 0);
			
			heapStart = HeapAllocator.heapStart;
			HeapAllocator.initHeap(heapStart, 1408)
			
			if(!mallocTest() || !freeTest() || !reallocTest()) 
				console.text += "Test failed!";
			else
				console.text += "Test pass!";
		}
		
		private static function init(stage:Stage) : void {
			if ( isInit ) return;
			
			console = new TextField();
			console.autoSize = TextFieldAutoSize.LEFT;
			console.wordWrap = false;
			console.multiline = true;
			
			console.defaultTextFormat = new TextFormat("_sans", 12, 0x303030);
			
			
			stage.addChild(console);
			
			isInit = true;
		}
		
		private function mallocTest():Boolean
		{
			trace("=============== malloc test start! ================");
			
			item0 = HeapAllocator.malloc(150);
			if(!item0)
			{
				trace("Memory not allocated! Item: item0");
				return false;
			}
			if(!checkItemInfo("item0", item0, false, 0, 256))
				return false;
			writeDataToItem(item0, 0);
			if(!checkItemData(item0, 0))
				return false;
			
			
			item1 = HeapAllocator.calloc(259);
			if(!item1)
			{
				trace("Memory not allocated! Item: item1");
				return false;
			}
			if(!checkItemInfo("item1", item1, false, 256, 384))
				return false;
			writeDataToItem(item1, 1);
			if(!checkItemData(item1, 1))
				return false;
			
			
			item2 = HeapAllocator.malloc(100);
			if(!item2)
			{
				trace("Memory not allocated! Item: item2");
				return false;
			}
			if(!checkItemInfo("item2", item2, false, 640, 128))
				return false;
			writeDataToItem(item2, 2);
			if(!checkItemData(item2, 2))
				return false;
			
			
			item3 = HeapAllocator.malloc(256);
			if(!item3)
			{
				trace("Memory not allocated! Item: item3");
				return false;
			}
			if(!checkItemInfo("item3", item3, false, 768, 256))
				return false;
			writeDataToItem(item3, 3);
			if(!checkItemData(item3, 3))
				return false;
			
			
			item4 = HeapAllocator.malloc(128);
			if(!item4)
			{
				trace("Memory not allocated! Item: item4");
				return false;
			}
			if(!checkItemInfo("item4", item4, false, 1024, 128))
				return false;
			writeDataToItem(item4, 4);
			if(!checkItemData(item4, 4))
				return false;
			
			
			item5 = HeapAllocator.malloc(150);
			if(!item5)
			{
				trace("Memory not allocated! Item: item5");
				return false;
			}
			if(!checkItemInfo("item5", item5, false, 1152, 256))
				return false;
			writeDataToItem(item5, 5);
			if(!checkItemData(item5, 5))
				return false;
			
			if(HeapAllocator.allocatedItemCnt != 6 || HeapAllocator.freeItemCnt != 0 || HeapAllocator.sizeAvailable != 0 || HeapAllocator.idleItemCnt != 0)
			{
				trace("HeapAllocator.allocatedItemCnt: ", HeapAllocator.allocatedItemCnt, "HeapAllocator.freeItemCnt: ", HeapAllocator.freeItemCnt, "HeapAllocator.sizeAvailable: ", HeapAllocator.sizeAvailable, "HeapAllocator.idleItemCnt: ", HeapAllocator.idleItemCnt);
				return false;
			}
			
			trace("=============== malloc test end! ================");
			
			return true;
		}
		
		private function freeTest():Boolean
		{
			trace("=============== free test start! ================");
			
			HeapAllocator.free(item2);
			if(!(checkItemInfo("item0", item0, false, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 384) &&
				checkItemInfo("item2", item2, true, 640, 128) &&
				checkItemInfo("item3", item3, false, 768, 256) &&
				checkItemInfo("item4", item4, false, 1024, 128) &&
				checkItemInfo("item5", item5, false, 1152, 256)))
				return false;
			
			
			HeapAllocator.free(item3);
			if(!(checkItemInfo("item0", item0, false, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 384) &&
				checkItemInfo("item3", item3, true, 640, 384) &&
				checkItemInfo("item4", item4, false, 1024, 128) &&
				checkItemInfo("item5", item5, false, 1152, 256)))
				return false;
			
			
			HeapAllocator.free(item0);
			if(!(checkItemInfo("item0", item0, true, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 384) &&
				checkItemInfo("item3", item3, true, 640, 384) &&
				checkItemInfo("item4", item4, false, 1024, 128) &&
				checkItemInfo("item5", item5, false, 1152, 256)))
				return false;
			
			
			HeapAllocator.free(item5);
			HeapAllocator.free(item4);
			if(!(checkItemInfo("item0", item0, true, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 384) &&
				checkItemInfo("item4", item4, true, 640, 768)))
				return false;
			
			
			if(HeapAllocator.allocatedItemCnt != 1 || HeapAllocator.freeItemCnt != 2 || HeapAllocator.sizeAvailable != 1024 || HeapAllocator.idleItemCnt != 3)
			{
				trace("HeapAllocator.allocatedItemCnt: ", HeapAllocator.allocatedItemCnt, "HeapAllocator.freeItemCnt: ", HeapAllocator.freeItemCnt, "HeapAllocator.sizeAvailable: ", HeapAllocator.sizeAvailable, "HeapAllocator.idleItemCnt: ", HeapAllocator.idleItemCnt);
				return false;
			}
			
			
			trace("=============== free test end! ================");
			return true;
		}
		
		private function reallocTest():Boolean
		{
			//this is to reorder free list
			item4 = HeapAllocator.malloc(768);
			item0 = HeapAllocator.malloc(256);
			HeapAllocator.free(item4);
			HeapAllocator.free(item0);
			
			if(!(checkItemInfo("item0", item0, true, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 384) &&
				checkItemInfo("item4", item4, true, 640, 768)))
				return false;
			
			trace("=============== realloc test start! ================");
			
			trace("realloc test 1");
			
			HeapAllocator.realloc(item1, 512);
			if(!(checkItemInfo("item0", item0, true, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 512) &&
				checkItemInfo("item4", item4, true, 768, 640)))
				return false;
			
			item0 = HeapAllocator.malloc(256);
			item2 = HeapAllocator.malloc(128);
			item3 = HeapAllocator.malloc(128);
			
			
			if(!(checkItemInfo("item0", item0, false, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 512) &&
				checkItemInfo("item2", item2, false, 768, 128) &&
				checkItemInfo("item3", item3, false, 896, 128) &&
				checkItemInfo("temp", item3.next, true, 1024, 384)))
				return false;
			
			
			writeDataToItem(item0, 0);
			writeDataToItem(item1, 1);
			writeDataToItem(item2, 2);
			writeDataToItem(item3, 3);
			
			HeapAllocator.free(item0);
			
			
			if(!(checkItemInfo("item0", item0, true, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 512) &&
				checkItemInfo("item2", item2, false, 768, 128) &&
				checkItemInfo("item3", item3, false, 896, 128) &&
				checkItemInfo("temp", item3.next, true, 1024, 384)))
				return false;
			
			
			trace("realloc test 2");
			
			HeapAllocator.realloc(item2, 384);
			
			
			if(!(checkItemInfo("item0", item0, true, 0, 256) &&
				checkItemInfo("item1", item1, false, 256, 512) &&
				checkItemInfo("temp", item1.next, true, 768, 128) &&
				checkItemInfo("item3", item3, false, 896, 128) &&
				checkItemInfo("item2", item2, false, 1024, 384)))
				return false;
			
			if(!checkItemData(item2, 2, 128) || !checkItemInfo("item2", item2, false, 1024, 384))
				return false;
			
			
			if(HeapAllocator.allocatedItemCnt != 3 || HeapAllocator.freeItemCnt != 2 || HeapAllocator.sizeAvailable != 384)
			{
				trace("HeapAllocator.allocatedItemCnt: ", HeapAllocator.allocatedItemCnt, "HeapAllocator.freeItemCnt: ", HeapAllocator.freeItemCnt, 
					"HeapAllocator.sizeAvailable: ", HeapAllocator.sizeAvailable, "HeapAllocator.idleItemCnt: ", HeapAllocator.idleItemCnt);
				return false;
			}
			
			
			writeDataToItem(item0, 0);
			writeDataToItem(item1, 1);
			writeDataToItem(item2, 2);
			writeDataToItem(item3, 3);
			
			
			//defragmentTest
			HeapAllocator.realloc(item3, 384);
			
			
			if(!(checkItemInfo("item1", item1, false, 0, 512) &&
				checkItemInfo("item2", item2, false, 512, 384) &&
				checkItemInfo("item3", item3, false, 896, 384) &&
				checkItemInfo("temp", item3.next, true, 1280, 128)))
				return false;
			
			
			if(!checkItemData(item3, 3, 128) || !checkItemInfo("item3", item3, false, 896, 384) || !checkItemData(item1, 1, 512) || !checkItemData(item2, 2, 384))
				return false;
			
			if(HeapAllocator.allocatedItemCnt != 3 || HeapAllocator.freeItemCnt != 1 || HeapAllocator.sizeAvailable != 128)
			{
				trace("HeapAllocator.allocatedItemCnt: ", HeapAllocator.allocatedItemCnt, "HeapAllocator.freeItemCnt: ", HeapAllocator.freeItemCnt, 
					"HeapAllocator.sizeAvailable: ", HeapAllocator.sizeAvailable, "HeapAllocator.idleItemCnt: ", HeapAllocator.idleItemCnt);
				return false;
			}
			
			trace("=============== realloc test end! ================");
			return true;
		}
		
		private function checkItemData(item:MemoryItem, data:int, length:int = 0):Boolean
		{
			if(length == 0)
				length = item.blockSize;
			
			for(var i:int = item.heapPtr; i < length + item.heapPtr && i < item.blockSize + item.heapPtr; ++i)
			{
				var curdata:int = li8(i);
				if(data != curdata)
				{
					trace("Check data fail! item.available:", item.available, "item.heapPtr: ", item.heapPtr - heapStart, 
						"item.blockSize: ", item.blockSize, "pos: ", i - item.heapPtr, "cur data: ", curdata, "expect: ", data);
					trace(li8(i++));
					return false;
				}
			}
			return true;
		}
		
		private function checkItemInfo(itemName:String, item:MemoryItem, expectStat:Boolean, expectPtr:int, expectSize:int):Boolean
		{
			if(item.available == expectStat && item.heapPtr == expectPtr + heapStart && item.blockSize == expectSize)
				return true;
			trace(itemName, " ",  "item.available:", item.available, "item.heapPtr: ", item.heapPtr - heapStart, "item.blockSize: ", item.blockSize); 
			return false;
		}
		
		private function writeDataToItem(item:MemoryItem, data:int):void
		{
			for(var i:int = item.heapPtr; i < item.blockSize + item.heapPtr; ++ i)
			{
				si8(data, i);
			}
		}
		
		private function writeData(start:int, end:int):void
		{
			
		}
	}
}
