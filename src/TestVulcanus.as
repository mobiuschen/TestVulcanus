package
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.profiler.profile;
    import flash.profiler.showRedrawRegions;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import asunit.framework.Test;
    import asunit.textui.TestRunner;
    
    import im.mobius.view.RawComponent;
    import im.mobius.vulcanus.unitest.TestCase_MapGenerator;
    
    public class TestVulcanus extends Sprite
    {
        private var _dict:Object = 
            {
                "ShowStackTrace": testShowStackTrace,
                "Profile": testProfile,
                "ShowRedrawRegions": testShowRedrawRegions
            };
        
        
        private var _txtPanel:Sprite;
        
        private var _logTF:TextField;
        
        public function TestVulcanus()
        {
            super();
            
            trace(File.applicationStorageDirectory.nativePath);
            
            // support autoOrients
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            var runner:TestRunner = new TestRunner();
            addChild(runner);
            
            //var test:Test = new TestCase_LogBatch();
            //runner.doRun(test, true);
            
            var test:Test = new TestCase_MapGenerator();
            runner.doRun(test, true);
            
            //runner.start(TestCase_LogBatch, "testSaveLog", true);
            //runner.start(TestCase_LogBatch, null, true);
            //initUI();
        }
        
        
        
        private function initUI():void
        {
            _txtPanel = new Sprite();
            var pW:Number = 500;
            var pH:Number = 500;
            var shape:Shape = new Shape();
            shape.graphics.beginFill(0, 0.3);
            shape.graphics.drawRect(0, 0, pW, pH);
            shape.graphics.endFill();
            
            _logTF = new TextField();
            _logTF.width = pW; 
            _logTF.height = pH;
            _logTF.y = 0;
            _logTF.x = 300;
            _logTF.defaultTextFormat = new TextFormat(null, 14, 0x00ff00);
            _logTF.background = true;
            _logTF.backgroundColor = 0x99000000;
            _logTF.text = "Log:\n";
            _logTF.multiline = true;
            addChild(_logTF);
            
            
            var i:int = 0;
            for(var k:String in _dict)
            {
                var btn:Sprite = RawComponent.createBtn(k);
                btn.x = 10;
                btn.y = 10 + 50 * i;
                btn.name = k;
                btn.addEventListener(MouseEvent.CLICK, onClickBtn);
                addChild(btn);
                i++;
            }
        }
        
        
        private function onClickBtn(evt:MouseEvent):void
        {
            var f:Function = _dict[evt.currentTarget.name];
            if(f != null)
                f();
        }
        
        
        private function log(msg:String):void
        {
            _logTF.appendText(msg + "\n");
        }
        
        
        private function testShowStackTrace():void
        {
            trace("testShowStackTrace");
            
            try
            {
                throw new Error("Test Error.");
            }
            catch(err:Error)
            {
                log(err.getStackTrace());
            }
        }
        
        
        private function testProfile():void
        {
            trace("testProfile");
        
            profile(true);
        }
        
        
        private function testShowRedrawRegions():void
        {
            trace("testShowRedrawRegions");
            showRedrawRegions(true);
        }
    }
}