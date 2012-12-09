package im.mobius.vulcanus.unitest
{
    import flash.display.Shape;
    import flash.geom.Rectangle;
    
    import asunit.framework.TestCase;
    
    import im.mobius.vulcanus.QuadTree;
    
    public class TestCase_QuadTree extends TestCase
    {
        private var _quadTree:QuadTree;
        
        private var _area:Rectangle = new Rectangle(0, 0, 500, 500);
        
        private var _minGridSize:Number = 50;
        
        public function TestCase_QuadTree(testMethod:String=null)
        {
            super(testMethod);
        }
        
        
        
        public function test1():void
        {
            _area = new Rectangle(0, 0, 100, 100);
            _minGridSize = 50;
            trace("Area:" + _area, ", minGridSzie=" + _minGridSize);
            _quadTree = new QuadTree(_area, _minGridSize, 5);
            checkPosQueue(_quadTree.insert(getOneShape(-50, -50, 25, 25)), 0);
            checkPosQueue(_quadTree.insert(getOneShape(0, 0, 25, 25)), 1, ["[1,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(25, 25, 25, 25)), 1, ["[1,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(60, 25, 25, 25)), 1, ["[2,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(26, 25, 25, 25)), 2, ["[1,0,]", "[2,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(26, 26, 25, 25)), 4, ["[1,0,]", "[2,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(0, 0, 100, 100)), 1, ["[0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(-1, -1, 100, 100)),4, ["[1,0,]", "[2,0,]", "[3,0,]", "[4,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(100, 100, 250, 25)), 0);
            
            var shape:Shape = new Shape();
            _quadTree.drawIt(shape);
            context.addChild(shape);
        }
        
        
        
        public function test2():void
        {
            _area = new Rectangle(0, 0, 150, 150);
            _minGridSize = 50;
            trace("Area:" + _area, ", minGridSzie=" + _minGridSize);
            _quadTree = new QuadTree(_area, _minGridSize, 5);
            checkPosQueue(_quadTree.insert(getOneShape(-50, -50, 25, 25)), 0);
            checkPosQueue(_quadTree.insert(getOneShape(0, 0, 75, 75)), 1, ["[1,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(30, 36, 45, 45)), 2, ["[3,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(30, 30, 130, 30)), 2, ["[1,0,]", "[2,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(75, 76, 75, 75)), 1, ["[4,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(0, 0, 100, 100)), 4);
            
            
            var shape:Shape = new Shape();
            _quadTree.drawIt(shape);
            context.addChild(shape);
        }
        
        
        public function test3():void
        {
            _area = new Rectangle(0, 0, 50, 50);
            _minGridSize = 50;
            trace("Area:" + _area, ", minGridSzie=" + _minGridSize);
            _quadTree = new QuadTree(_area, _minGridSize, 5);
            
            checkPosQueue(_quadTree.insert(getOneShape(-10, -10, 30, 30)), 1);
            checkPosQueue(_quadTree.insert(getOneShape(30, -10, 30, 30)), 1);
            checkPosQueue(_quadTree.insert(getOneShape(-10, 30, 30, 30)), 1);
            checkPosQueue(_quadTree.insert(getOneShape(0, 0, 30, 30)), 1);
            checkPosQueue(_quadTree.insert(getOneShape(30, 30, 30, 30)), 1);
            checkPosQueue(_quadTree.insert(getOneShape(10, 20, 30, 30)), 1);
            checkPosQueue(_quadTree.insert(getOneShape(10, 10, 30, 30)), 1);
            
            
            var shape:Shape = new Shape();
            _quadTree.drawIt(shape);
            context.addChild(shape);
        }
        
        
        public function test4():void
        {
            _area = new Rectangle(0, 0, 120, 120);
            _minGridSize = 30;
            trace("Area:" + _area, ", minGridSzie=" + _minGridSize);
            _quadTree = new QuadTree(_area, _minGridSize, 5);
            
            checkPosQueue(_quadTree.insert(getOneShape(45, 10, 40, 10)), 2, ["[1,2,0,]", "[2,1,0,]",]);
            checkPosQueue(_quadTree.insert(getOneShape(105, 10, 100, 10)), 1, ["[2,2,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(45, 45, 30, 30)), 4, ["[1,4,0,]", "[2,3,0,]", "[3,2,0,]", "[4,1,0,]",]);
            checkPosQueue(_quadTree.insert(getOneShape(75, 75, 10, 50)), 2, ["[4,1,0,]", "[4,3,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(-15, 55, 90, 90)), 6, ["[3,0,]", "[1,3,0,]", "[1,4,0,]", "[4,1,0,]", "[4,3,0,]", "[2,3,0,]"]);
            checkPosQueue(_quadTree.insert(getOneShape(121, 121, 10, 10)), 0);
            
            var shape:Shape = new Shape();
            _quadTree.drawIt(shape, true);
            context.addChild(shape);
        }
        
        
        public function test5():void
        {
            _area = new Rectangle(0, 0, 120, 120);
            _minGridSize = 10;
            trace("Area:" + _area, ", minGridSzie=" + _minGridSize);
            _quadTree = new QuadTree(_area, _minGridSize, 2);
            
            var shape:Shape = new Shape();
            _quadTree.drawIt(shape);
            context.addChild(shape);
        }
        
        
        private function checkPosQueue(posQueue:Vector.<Vector.<int>>, 
                                       expectedLen:int, 
                                       expectStrs:Array = null):void
        {
            
            var str:String = "-----";
            for(var i:int = 0, n:int = posQueue.length; i < n; i++)
            {
                str += "\n["
                for(var j:int = 0, m:int = posQueue[i].length; j < m; j++)
                {
                    str += posQueue[i][j] + ",";
                }
                str += "]";
            }
            trace(str);
            
            assertEquals(expectedLen, posQueue.length);
            if(expectStrs != null)
            {
                for each(var subStr:String in expectStrs)
                    assertTrue(str.indexOf(subStr) >= 0);
            }
        }
        
        private function getOneShape(x:Number, y:Number, w:Number, h:Number):Shape
        {
            var shape:Shape = new Shape();
            shape.graphics.beginFill(0x00ff00);
            shape.graphics.drawRect(0, 0, w, h);
            shape.graphics.endFill();
            shape.x = x;
            shape.y = y;
            return shape;
        }
    }
}