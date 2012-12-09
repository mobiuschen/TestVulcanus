package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.OutputProgressEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.setTimeout;
    
    public class TestFileStream extends Sprite
    {
        private var _fs:FileStream;
        private var _fs2:FileStream;
        private var _file:File;
        
        public function TestFileStream()
        {
            super();
            updateModeCanBeAppend();
        }
        
        
        private function updateModeCanBeAppend():void
        {
            var fs:FileStream = new FileStream();
            var file:File = new File(File.applicationStorageDirectory.nativePath + "/updateModeCantBeAppend.zax");
            if(file.exists)
                file.deleteFile();
            fs.open(file, FileMode.UPDATE);
            trace(fs.bytesAvailable);
            fs.writeInt(10);
            fs.writeInt(9);
            fs.writeInt(8);
            fs.close();
            trace(file.size == 12);
        }
        
        
        private function testFileStream():void
        {
            trace(File.applicationStorageDirectory.nativePath);
            _fs = new FileStream();
            _fs2 = new FileStream();
            _file = new File(File.applicationStorageDirectory.nativePath + "/testFileSteam.zax");
            _fs.addEventListener(Event.COMPLETE, onEvent);
            _fs.addEventListener(ProgressEvent.PROGRESS, onEvent);
            _fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onEvent);
            _fs.addEventListener(Event.CLOSE, onEvent);
            
            _fs.addEventListener(Event.COMPLETE, onComplete);
            trace("open");
            //_fs.openAsync(_file, FileMode.UPDATE);
            _fs.openAsync(_file, FileMode.UPDATE);
            
            setTimeout(write1, 1000);
            setTimeout(traceAll, 3000);
        }
        
        
        private function write1():void
        {
            _fs.writeInt(10);
            _fs.writeInt(9);
            _fs.writeInt(8);
            _fs.writeInt(7);
            _fs.writeInt(6);
            _fs.writeInt(5);
            _fs.writeInt(4);
        }
        
        private function write2():void
        {
            _fs2.open(_file, FileMode.UPDATE);
            _fs2.position = 0;
            _fs2.writeInt(11);
            _fs2.writeInt(12);
            _fs2.writeInt(13);
            /*_fs2.writeInt(14);
            _fs2.writeInt(15);
            _fs2.writeInt(16);
            _fs2.writeInt(17);*/
        }
        
        private function traceAll():void
        {
            _fs2.close();
            _fs.close();
            
            var fs:FileStream = new FileStream();
            fs.open(_file, FileMode.READ);
            trace("---------");
            while(fs.bytesAvailable > 0)
            {
                trace(fs.readInt());
            }
        }
        
        private function onComplete(evt:Event):void
        {
            _fs.removeEventListener(Event.COMPLETE, onComplete);
            trace("read");
            _fs.readFloat();
            
            trace("write")
            _fs.writeInt(10);
            
            trace("setPosition");
            //_fs.position = 0;
            
            trace("close");
            _fs.close();
        }
        
        
        private function onEvent(evt:Event):void
        {
            trace(evt);
        }
    }
}