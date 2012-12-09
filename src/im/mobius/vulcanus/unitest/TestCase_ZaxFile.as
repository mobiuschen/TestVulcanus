package im.mobius.vulcanus.unitest
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.JPEGEncoderOptions;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    import asunit.framework.TestCase;
    
    import im.mobius.vulcanus.zax.ZaxFile;
    import im.mobius.vulcanus.zax.ZaxFileState;
    
    public class TestCase_ZaxFile extends TestCase
    {
        [Embed(source="/1.jpeg")]
        private const JPG1:Class;
        
        [Embed(source="/terrain_tile.png")]
        private const TERRAIN_IMG:Class;
        
        public function TestCase_ZaxFile(testMethod:String=null)
        {
            super(testMethod);
            
            trace(File.applicationStorageDirectory);
        }
        
        
        public function _testCreateZaxFile():void
        {
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testCreateZaxFile.zax", false);
            assertEquals(ZaxFileState.CLOSED, zaxFile.getState());
            zaxFile.open(openCallback);
            assertEquals(ZaxFileState.OPERATING, zaxFile.getState());
            
            function openCallback(success:Boolean):void
            {
                assertEquals(ZaxFile.ZAX_VERSION, zaxFile.getVersion());
                assertEquals(0, zaxFile._testGetIndexNum());
                assertEquals(ZaxFileState.OPEN, zaxFile.getState());
            }
        }
        
        
        public function _testAppendTxt():void
        {
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testAppendTxt.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testAppendTxt.zax", false);
            zaxFile.open(openCallback);
            
            function openCallback(success:Boolean):void
            {
                var ba:ByteArray = new ByteArray();
                ba.writeUTF("一二三四五六");
                zaxFile.appendBlock([ba], ["txt"], onAppenComplete);
            }
            
            function onAppenComplete(sucess:Boolean):void
            {
                zaxFile.readByKey("txt", onReadComplete);
            }
            
            function onReadComplete(ba:ByteArray):void
            {
                trace(ba.readUTF());
            }
        }
        
        
        public function testReopen():void
        {
            //加载一张图片，保存在b.zax里；然后再取出来，加载到舞台上
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testReopen.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testReopen.zax", false);
            zaxFile.open(openCallback);
            
            function openCallback(success:Boolean):void
            {
                assertTrue(success);
                
                var ba:ByteArray = new ByteArray();
                ba.writeUTF("一二三四五六");
                zaxFile.appendBlock([ba], ["txt"], onAppendComplete);
            }
            
            
            function onAppendComplete(success:Boolean):void
            {
                assertTrue(success);
                zaxFile.close(onClose);
            }
            
            function onClose(success:Boolean):void
            {
                assertTrue(success);
                zaxFile.open(onReopen);
            }
            
            function onReopen(success:Boolean):void
            {
                assertEquals(1, zaxFile._testGetIndexNum());
                zaxFile.readByKey("txt", onReadComplete);
            }
            
            function onReadComplete(ba:ByteArray):void
            {
                assertEquals("一二三四五六", ba.readUTF());
                assertEquals(ZaxFileState.CLOSED, zaxFile.getState());
                ba.position = 0;
                trace(ba.readUTF());
            }
        }
        
        
        public function _testAppend():void
        {
            //加载一张图片，保存在b.zax里；然后再取出来，加载到舞台上
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testAppend.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testAppend.zax", false);
            zaxFile.open(openCallback);
            
            function openCallback(success:Boolean):void
            {
                var bpd:BitmapData = (new JPG1() as Bitmap).bitmapData;
                var ba:ByteArray = new ByteArray();
                ba = bpd.encode(new Rectangle(0,0,bpd.width,bpd.height), new JPEGEncoderOptions(), ba);
                zaxFile.appendBlock([ba], ["jpg1"], onAppenComplete);
            }
            
            function onAppenComplete(sucess:Boolean):void
            {
                zaxFile.readByKey("jpg1", onReadComplete);
            }
            
            function onReadComplete(ba:ByteArray):void
            {
                var ldr:Loader = new Loader();
                ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
                ldr.loadBytes(ba);
            }
            
            
            function onLoadComplete(evt:Event):void
            {
                var ldrInfo:LoaderInfo = evt.currentTarget as LoaderInfo;
                ldrInfo.addEventListener(Event.COMPLETE, onLoadComplete);
                context.addChild(ldrInfo.loader);
                zaxFile.close(onCloseComplete);
            }
            
            function onCloseComplete(success:Boolean):void
            {
                assertEquals(ZaxFileState.CLOSED, zaxFile.getState());
            }
        }
    }
}