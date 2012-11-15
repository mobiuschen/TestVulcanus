package
{
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import im.mobius.QuadTreeCollisionDetection;
    
    public class TestQTCollisionDetect extends Sprite
    {
        static private const BG_COLOR:uint = 0xF8E9A8;
        
        static private const BLOCK_COLOR:uint = 0x00928C;
        
        static private const CONTROL_BLOCK_COLOR:uint = 0xFF0000;
        
        private var _qtCD:QuadTreeCollisionDetection;
        
        private var _controlShape:Shape;
        
        public function TestQTCollisionDetect()
        {
            super();
            
            // support autoOrients
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        
        private function onAddedToStage(evt:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, onAddedToStage);
            
            collisionDetect();
            //runTest();
        }
        
        private function collisionDetect():void
        {
            var area:Rectangle = new Rectangle(0, 0, 700, 500);
            var minGridSize:Number = 20;
            
            var bg:Shape = getOneShape(area.x, area.y, area.width, area.height, BG_COLOR);
            addChild(bg);
            
            _controlShape = getOneShape(0, 0, 30, 30, CONTROL_BLOCK_COLOR);
            
            var shapes:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            for(var i:int = 0, n:int = 200; i < n; i++)
            {
                var shape:Shape = 
                    getOneShape(
                        0, 0, 
                        5 + Math.random() * minGridSize, 
                        5 + Math.random() * minGridSize, 
                        BLOCK_COLOR
                    );
                shape.x = Math.random() * (area.width - minGridSize -5);
                shape.y = Math.random() * (area.height - minGridSize -5);
                shapes.push(shape);
                addChild(shape);
            }
            
            _qtCD = new QuadTreeCollisionDetection();
            _qtCD.initCamps(area, minGridSize, 5, new <DisplayObject>[_controlShape], shapes);
            
            addChild(_controlShape);
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        
        private function onEnterFrame(evt:Event):void
        {
            _controlShape.x = stage.mouseX - 15;
            _controlShape.y = stage.mouseY - 15;
            
            _qtCD.detectCollision();
        }
        
        
        
        private function getOneShape(x:Number, y:Number, w:Number, h:Number, color:uint):Shape
        {
            var shape:Shape = new Shape();
            shape.graphics.beginFill(color);
            shape.graphics.drawRect(0, 0, w, h);
            shape.graphics.endFill();
            shape.x = x;
            shape.y = y;
            return shape;
        }
    }
}