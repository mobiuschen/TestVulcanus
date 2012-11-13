package
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /**
     * Test Cases: 0个点, 1个点, 2个点, 所有点都在一条直线上.
     *   
     * @author mobiuschen
     * 
     */
    public class TestMazeGenerator extends Sprite
    {
        static private const P_NUM:int = 70;
        
        static private const AREA:Rectangle = new Rectangle(0, 0, 500, 500);
        
        public function TestMazeGenerator()
        {
            super();
            
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            init();
            
            
        }
        
        
        private function init():void
        {
            var mg:MapGenerator = new MapGenerator();
            renderMap(mg.getMap(30, 50));
        }
        
        
        private function renderMap(map:Vector.<Vector.<int>>):void
        {
            var h:int = map.length;
            var w:int = map[0].length;
            var tileSize:int = 10;
            
            var colorDict:Object = {};
            colorDict[MapGenerator.WALL_INT] = 0x888888;
            colorDict[MapGenerator.ROAD_INT] = 0xFFCC66;
            var shape:Shape = new Shape();
            for(var i:int = 0; i < h; i++)
            {
                for(var j:int = 0; j < w; j++)
                {
                    shape.graphics.beginFill(colorDict[map[i][j]]);
                    shape.graphics.drawRect(j * tileSize, i * tileSize, tileSize, tileSize);
                }
            }
            shape.graphics.endFill();
            addChild(shape);
        }
        
        
        private function renderShapes(points:Vector.<Point>, lines:Vector.<Line>):void
        {
            var shape:Shape = new Shape();
            
            shape.graphics.lineStyle(1, 0x00ff00);
            for(i = 0, n = lines.length; i < n; i++)
            {
                var line:Line = lines[i];
                shape.graphics.moveTo(line.p1.x, line.p1.y);
                shape.graphics.lineTo(line.p2.x, line.p2.y);
            }
            
            for(var i:int = 0, n:int = points.length; i < n; i++)
            {
                var p:Point = points[i];
                shape.graphics.beginFill(0xff0000);
                shape.graphics.drawCircle(p.x, p.y, 5);
                shape.graphics.endFill();
            }
            
            addChild(shape);
        }
        
        
        
        /**
         * 随机生成在指定范围内, 生成固定数量的点
         *  
         * @param pointsNum
         * @param area
         * @return 
         * 
         */        
        private function generatePoints(pointsNum:int, area:Rectangle):Vector.<Point>
        {
            var result:Vector.<Point> = new Vector.<Point>(pointsNum, true);
            for(var i:int = 0; i < pointsNum; i++)
            {
                result[i] = 
                    new Point(
                        int(area.width * Math.random()) + area.x, 
                        int(area.height * Math.random()) + area.y
                    );
                //trace(_points[i]);
            }
            
            return result;
        }
        
        
    }
}


import flash.geom.Point;

class Line
{
    
    public function Line(distance:Number, p1:Point, p2:Point)
    {
        this.distance = distance;
        this.p1 = p1;
        this.p2 = p2;
    }
    
    public function toString():String
    {
        return "[p1=(" +p1.x + ", " + p1.y + "), p2=(" + p2.x + ", " + p2.y + "), distance=" + distance + "]";
    }
    
    public var distance:Number;
    public var p1:Point;
    public var p2:Point
}