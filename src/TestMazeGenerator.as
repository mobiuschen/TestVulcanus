package
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.geom.Rectangle;
    
    import im.mobius.map.MapGenerator;
    
    /**
     * Test Cases: 0个点, 1个点, 2个点, 所有点都在一条直线上.
     *   
     * @author mobiuschen
     * 
     */
    public class TestMazeGenerator extends Sprite
    {
        static private const P_NUM:int = 70;
        
        static private const AREA:Rectangle = new Rectangle(0, 0, 50, 50);
        
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
            renderMap(mg.generateMap(AREA.width, AREA.height, 0.3));
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
    }
}