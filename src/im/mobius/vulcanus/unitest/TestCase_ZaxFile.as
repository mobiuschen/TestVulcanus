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
            
            trace(File.applicationStorageDirectory.nativePath);
        }
        
        
        public function testCreateZaxFile():void
        {
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testCreateZaxFile.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testCreateZaxFile.zax", false);
            assertEquals(ZaxFileState.CLOSED, zaxFile.getState());
            zaxFile.open(addAsync(openCallback));
            assertEquals(ZaxFileState.OPERATING, zaxFile.getState());
            
            function openCallback(success:Boolean):void
            {
                assertEquals(ZaxFile.ZAX_VERSION, zaxFile.getVersion());
                assertEquals(0, zaxFile._testGetIndexNum());
                assertEquals(ZaxFileState.OPEN, zaxFile.getState());
            }
        }
        
        
        public function testAppendTxt():void
        {
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testAppendTxt.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testAppendTxt.zax", false);
            zaxFile.open(addAsync(openCallback));
            
            function openCallback(success:Boolean):void
            {
                var ba:ByteArray = new ByteArray();
                ba.writeUTF("一二三四五六");
                zaxFile.appendBlock([ba], ["txt"], addAsync(onAppenComplete));
            }
            
            function onAppenComplete(sucess:Boolean):void
            {
                zaxFile.readByKey("txt", addAsync(onReadComplete));
            }
            
            function onReadComplete(key:String, ba:ByteArray):void
            {
                assertEquals("txt", key);
                assertEquals("一二三四五六", ba.readUTF());
            }
        }
        
        
        public function testReopen():void
        {
            //加载一张图片，保存在b.zax里；然后再取出来，加载到舞台上
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testReopen.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testReopen.zax", false);
            zaxFile.open(addAsync(openCallback));
            
            function openCallback(success:Boolean):void
            {
                assertTrue(success);
                
                var ba:ByteArray = new ByteArray();
                ba.writeUTF("一二三四五六");
                zaxFile.appendBlock([ba], ["txt"], addAsync(onAppendComplete));
            }
            
            
            function onAppendComplete(success:Boolean):void
            {
                assertTrue(success);
                zaxFile.close(addAsync(onClose));
            }
            
            function onClose(success:Boolean):void
            {
                assertTrue(success);
                zaxFile.open(addAsync(onReopen));
            }
            
            function onReopen(success:Boolean):void
            {
                assertEquals(1, zaxFile._testGetIndexNum());
                zaxFile.readByKey("txt", addAsync(onReadComplete));
                assertEquals(ZaxFileState.OPERATING, zaxFile.getState());
            }
            
            function onReadComplete(key:String, ba:ByteArray):void
            {
                assertEquals("txt", key);
                assertEquals("一二三四五六", ba.readUTF());
                zaxFile.close(addAsync(onReclose));
            }
            
            function onReclose(success:Boolean):void
            {
                assertEquals(true, success);
                assertEquals(ZaxFileState.CLOSED, zaxFile.getState());
            }
        }
        
        
        
        public function testAppend():void
        {
            //加载一张图片，保存在b.zax里；然后再取出来，加载到舞台上
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testAppend.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testAppend.zax", false);
            zaxFile.open(addAsync(openCallback));
            
            function openCallback(success:Boolean):void
            {
                var bpd:BitmapData = (new JPG1() as Bitmap).bitmapData;
                var ba:ByteArray = new ByteArray();
                ba = bpd.encode(new Rectangle(0,0,bpd.width,bpd.height), new JPEGEncoderOptions(), ba);
                zaxFile.appendBlock([ba], ["jpg1"], addAsync(onAppenComplete));
            }
            
            function onAppenComplete(sucess:Boolean):void
            {
                zaxFile.readByKey("jpg1", addAsync(onReadComplete));
            }
            
            function onReadComplete(key:String, ba:ByteArray):void
            {
                assertEquals("jpg1", key);
                var ldr:Loader = new Loader();
                ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, addAsync(onLoadComplete));
                ldr.loadBytes(ba);
            }
            
            function onLoadComplete(evt:Event):void
            {
                var ldrInfo:LoaderInfo = evt.currentTarget as LoaderInfo;
                //ldrInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
                context.addChild(ldrInfo.loader);
                zaxFile.close(addAsync(onCloseComplete));
            }
            
            function onCloseComplete(success:Boolean):void
            {
                assertEquals(ZaxFileState.CLOSED, zaxFile.getState());
            }
        }
        
        
        /**
         * 测试一次性Append多个Block 
         * 
         */        
        public function testMultiAppend():void
        {
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testMultiAppend.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testMultiAppend.zax", false);
            zaxFile.open(addAsync(openCallback));
            
            function openCallback(success:Boolean):void
            {
                var ba1:ByteArray = new ByteArray();
                var ba2:ByteArray = new ByteArray();
                ba1.writeUTF("第一段文字");
                ba2.writeUTF("第二段文字");
                assertEquals(ZaxFileState.OPEN, zaxFile.getState());
                zaxFile.appendBlock([ba1, ba2], ["1stTxt", "2ndTxt"], addAsync(onAppendCallback));
                assertEquals(ZaxFileState.OPERATING, zaxFile.getState());
            }
            
            
            function onAppendCallback(success:Boolean):void
            {
                assertTrue(success);
                assertEquals(ZaxFileState.OPEN, zaxFile.getState());
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
            }
            
            function onReadComplete(key:String, ba:ByteArray):void
            {
                assertEquals("2ndTxt", key);
                assertEquals("第二段文字", ba.readUTF());
                zaxFile.close(addAsync(onClose));
            }
            
            function onClose(success:Boolean):void
            {
                assertTrue(success);
            }
        }
        
        
        /**
         * 测试同时读取相同、不同Block 
         * 
         */        
        public function testSyncRead():void
        {
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testSyncRead.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testSyncRead.zax", false);
            zaxFile.open(addAsync(openCallback));
            
            var readCount:int = 0;
            
            function openCallback(success:Boolean):void
            {
                var ba1:ByteArray = new ByteArray();
                var ba2:ByteArray = new ByteArray();
                ba1.writeUTF("第一段文字");
                ba2.writeUTF("第二段文字");
                assertEquals(17, ba1.length);
                assertEquals(ZaxFileState.OPEN, zaxFile.getState());
                zaxFile.appendBlock([ba1, ba2], ["1stTxt", "2ndTxt"], addAsync(onAppendCallback));
                assertEquals(ZaxFileState.OPERATING, zaxFile.getState());
            }
            
            
            function onAppendCallback(success:Boolean):void
            {
                assertTrue(success);
                assertEquals(ZaxFileState.OPEN, zaxFile.getState());
                
                readCount = 12;
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
            }
            
            
            function onReadComplete(key:String, ba:ByteArray):void
            {
                var str:String = ba.readUTF();
                if(key == "1stTxt")
                    assertEquals("第一段文字", str);
                else if(key == "2ndTxt")
                    assertEquals("第二段文字", str);
                
                if(--readCount == 0)
                    zaxFile.close(addAsync(onClose));
            }
            
            function onClose(success:Boolean):void
            {
                assertTrue(success);
            }
        }
        

        /**
         * 测试在读操作未完成时，关闭ZaxFile 
         * 
         */        
        public function testInterruptClose():void
        {
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/testInterruptClose.zax");
            if(file.exists)
                file.deleteFile();
            var zaxFile:ZaxFile = new ZaxFile(File.applicationStorageDirectory.nativePath + "/testInterruptClose.zax", false);
            zaxFile.open(addAsync(openCallback));
            
            var readCount:int = 0;
            
            function openCallback(success:Boolean):void
            {
                var ba1:ByteArray = new ByteArray();
                var ba2:ByteArray = new ByteArray();
                ba1.writeUTF("第一段文字");
                ba2.writeUTF("第二段文字");
                assertEquals(17, ba1.length);
                assertEquals(ZaxFileState.OPEN, zaxFile.getState());
                zaxFile.appendBlock([ba1, ba2], ["1stTxt", "2ndTxt"], addAsync(onAppendCallback));
                assertEquals(ZaxFileState.OPERATING, zaxFile.getState());
            }
            
            
            function onAppendCallback(success:Boolean):void
            {
                assertTrue(success);
                assertEquals(ZaxFileState.OPEN, zaxFile.getState());
                
                readCount = 12;
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                zaxFile.readByKey("1stTxt", addAsync(onReadComplete));
                
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                zaxFile.readByKey("2ndTxt", addAsync(onReadComplete));
                
                zaxFile.close(addAsync(onClose));
            }
            
            
            function onReadComplete(key:String, ba:ByteArray):void
            {
                trace("onReadComplete:", key);
                var str:String = ba.readUTF();
                if(key == "1stTxt")
                    assertEquals("第一段文字", str);
                else if(key == "2ndTxt")
                    assertEquals("第二段文字", str);
            }
            
            function onClose(success:Boolean):void
            {
                trace("onClose");
                assertTrue(success);
            }
        }
    }
}