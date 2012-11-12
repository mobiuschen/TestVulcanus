package
{
    import flash.geom.Point;
    
    import asunit.framework.TestCase;
    
    public class TestCase_MapGenerator extends TestCase
    {
        public function TestCase_MapGenerator(testMethod:String=null)
        {
            super(testMethod);
        }
        
        public function testCalCollections_1():void
        {
            var w:int = MapGenerator.WALL_INT;
            var r:int = MapGenerator.ROAD_INT;
            var map:Vector.<Vector.<int>>;
            
            map = new <Vector.<int>>[
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 0);
            
            map = new <Vector.<int>>[
                new <int>[r, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 1);
            
            map = new <Vector.<int>>[
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, r],
            ];
            checkMap(map, 1);
            
            map = new <Vector.<int>>[
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[r, w, w, w],
            ];
            checkMap(map, 1);
            
            map = new <Vector.<int>>[
                new <int>[r, w, w, w],
                new <int>[w, r, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 1);
            
            map = new <Vector.<int>>[
                new <int>[r, w, w, w],
                new <int>[w, r, w, w],
                new <int>[r, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 1);
            
            map = new <Vector.<int>>[
                new <int>[r, w, w, w],
                new <int>[w, r, w, w],
                new <int>[r, w, w, w],
                new <int>[w, r, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 1);
            
            map = new <Vector.<int>>[
                new <int>[r, w, r, w],
                new <int>[w, r, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 1);
            
            map = new <Vector.<int>>[
                new <int>[w, w, r, w],
                new <int>[w, r, r, r],
                new <int>[w, w, r, w],
                new <int>[w, r, r, r],
                new <int>[w, w, r, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 1);
            
            map = new <Vector.<int>>[
                new <int>[r, r, r, r],
                new <int>[r, r, r, r],
                new <int>[r, r, r, r],
                new <int>[r, r, r, r],
            ];
            checkMap(map, 1);
        }
        
        
        public function testCalCollections_2():void
        {
            var w:int = MapGenerator.WALL_INT;
            var r:int = MapGenerator.ROAD_INT;
            var map:Vector.<Vector.<int>>;
            var mg:MapGenerator = new MapGenerator();
            
            
            map = new <Vector.<int>>[
                new <int>[r, w, r, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 2);
            
            map = new <Vector.<int>>[
                new <int>[w, w, r, w],
                new <int>[w, r, r, r],
                new <int>[w, w, w, w],
                new <int>[w, r, r, r],
                new <int>[w, w, r, w],
                new <int>[w, w, w, w],
            ];
            checkMap(map, 2);
            
            map = new <Vector.<int>>[
                new <int>[w, w, r, w],
                new <int>[w, w, r, w],
                new <int>[w, w, r, w],
                new <int>[w, r, r, w],
            ];
            checkMap(map, 1);
        }
        
        
        private function checkMap(map:Vector.<Vector.<int>>, collectionNum:int):void
        {
            var mg:MapGenerator = new MapGenerator();
            var clc:Vector.<Vector.<Point>> = mg._testCalCollections(map);
            assertTrue(checkElementRepeat(clc));
            assertEquals(collectionNum, clc.length);
        }
        
        
        
        private function checkElementRepeat(result:Vector.<Vector.<Point>>):Boolean
        {
            for(var i:int = 0, n:int = result.length; i < n; i++)
            {
                for(var j:int = 0, m:int = result[i].length; j < m; j++)
                {
                    var p:Point = result[i][j];
                    for(var i1:int = 0, n1:int = result.length; i1 < n1; i1++)
                    {
                        for(var j1:int = 0, m1:int = result[i1].length; j1 < m1; j1++)
                        {
                            if(i == i1 && j == j1)
                                continue;
                            var p1:Point = result[i1][j1];
                            if(p.x == p1.x && p.y == p1.y)
                                return false;
                        }
                    }                        
                }
            }
            return true;
        }
    }
}