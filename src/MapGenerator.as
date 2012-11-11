package
{
    import flash.geom.Point;
    

    public class MapGenerator
    {
        static public const WALL_INT:int = 1;
        
        static public const ROAD_INT:int = 0;
        
        /**
         * 地砖密度 
         */        
        static private const ROAD_DENSITY:Number = 0.4;
        
        private var _map:Vector.<int>;
        
        public function MapGenerator()
        {
        }
        
        
        public function getMap(w:int, h:int):Vector.<Vector.<int>>
        {
            var map:Vector.<Vector.<int>> = initMap(w, h);
            traverseHandle(map);
            var collection:Vector.<Vector.<Point>> = calCollections(map);
            trace("collection.length:", collection.length);
            
            return map;
        }
        
        
        private function initMap(w:int, h:int):Vector.<Vector.<int>>
        {
            var result:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(h, true);
            //填充数据
            for(var i:int = 0, n:int = result.length; i < n; i++)
            {
                var row:Vector.<int> = new Vector.<int>(w, true); 
                for(var j:int = 0, m:int = row.length; j < m; j++)
                    row[j] = Math.random() > ROAD_DENSITY ? WALL_INT : ROAD_INT;
                
                result[i] = row;
            }
            
            return result;
        }
        
        
        
        private function traverseHandle(map:Vector.<Vector.<int>>):void
        {
            var rN:int = 0;
            var wN:int = 0;
            //填充数据
            for(var i:int = 0, n:int = map.length; i < n; i++)
            {
                var row:Vector.<int> = map[i];
                for(var j:int = 0, m:int = row.length; j < m; j++)
                {
                    //m是列数, n是行数
                    var weight:int = 0;
                    if(j > 0)
                    {
                        if(i <= 0 || map[i - 1][j - 1] == WALL_INT) weight++;
                        if(map[i][j - 1] == WALL_INT) weight++;
                        if(i >= n - 1 || map[i + 1][j - 1] == WALL_INT) weight++;
                    }
                    else
                    {
                        weight += 3;
                    }
                    
                    if(i <= 0 || map[i - 1][j] == WALL_INT) weight++;
                    if(i >= n - 1 || map[i + 1][j] == WALL_INT) weight++;
                    
                    if(j < m - 1)
                    {
                        if(i <= 0 || map[i - 1][j + 1] == WALL_INT) weight++;
                        if(map[i][j + 1] == WALL_INT) weight++;
                        if(i >= 0 || map[i + 1][j + 1] == WALL_INT) weight++;   
                    }
                    else
                    {
                        weight += 3;
                    }
                    
                    
                    if(weight < 4)
                    {
                        rN++;
                        map[i][j] = ROAD_INT;
                    }
                    else if(weight > 5)
                    {
                        wN++;
                        map[i][j] = WALL_INT;
                    }
                }//for
            }//for
            //trace(rN, wN);
        }
        
        
        static public function calCollections(map:Vector.<Vector.<int>>):Vector.<Vector.<Point>>
        {
            var result:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
            
            //填充数据
            for(var i:int = 0, n:int = map.length; i < n; i++)
            {
                var row:Vector.<int> = map[i];
                for(var j:int = 0, m:int = row.length; j < m; j++)
                {
                    if(row[j] == WALL_INT)
                        continue;
                    
                    //m是列数, n是行数
                    var flg:Boolean = false;
                    
                    
                    flg ||= d(j - 1, i - 1, j, i);
                    trace(j, i, result.length);
                    flg ||= d(j - 1, i, j, i);
                    trace(j, i, result.length);
                    flg ||= d(j - 1, i + 1, j, i);//左下
                    trace(j, i, result.length);
                    flg ||= d(j, i - 1, j, i);
                    trace(j, i, result.length);
                    flg ||= d(j, i + 1, j, i);//下
                    trace(j, i, result.length);
                    flg ||= d(j + 1, i - 1, j, i);
                    trace(j, i, result.length);
                    flg ||= d(j + 1, i, j, i);//右
                    trace(j, i, result.length);
                    flg ||= d(j + 1, i + 1, j, i);//右下
                    trace(j, i, result.length);
                    trace("----------");
                    
                    //其实只要计算右边和下面的邻接点就可以了
                    /*flg ||= d(j - 1, i + 1, j, i);//左下
                    trace(j, i, result.length);
                    flg ||= d(j, i + 1, j, i);//下
                    trace(j, i, result.length);
                    flg ||= d(j + 1, i, j, i);//右
                    trace(j, i, result.length);
                    flg ||= d(j + 1, i + 1, j, i);//右下
                    trace(j, i, result.length);
                    trace("----------");*/
                    
                    if(!flg)
                    {
                        //周围都是墙的情况
                        trace("Solo Point");
                        result.push(new <Point>[new Point(j, i)]);
                    }
                }//for
            }//for
            
            trace("check", check());
            
            return result;
            
            
            function check():Boolean
            {
                for(var i:int = 0, n:int = result.length; i < n; i++)
                {
                    trace("result length at", i, result[i].length);
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
            }//function check
            
            function d(x1:int, y1:int, x2:int, y2:int):Boolean
            {
                if(x1 < 0 || x1 >= m || y1 < 0 || y1 >= n || map[y1][x1] == WALL_INT)
                    return false;
                if(x2 < 0 || x2 >= m || y2 < 0 || y2 >= n || map[y2][x2] == WALL_INT)
                    return false;
                
                var vec1:Vector.<Point>;
                var vec2:Vector.<Point>;
                for each(var vec:Vector.<Point> in result)
                {
                    for each(var p:Point in vec)
                    {
                        if(x1 == p.x && y1 == p.y)
                            vec1 = vec;
                        if(x2 == p.x && y2 == p.y)
                            vec2 = vec;
                        if(vec1 != null && vec2 != null)
                            break;
                    }
                }
                
                if(vec1 == null && vec2 == null)
                    result.push(new <Point>[new Point(x1, y1), new Point(x2, y2)]);
                else if(vec1 == null)
                    vec2.push(new Point(x1, y1));
                else if(vec2 == null)
                    vec1.push(new Point(x2, y2));
                else if(vec1 != vec2)
                {
                    result.push(vec1.concat(vec2));
                    result.splice(result.indexOf(vec1), 1);
                    result.splice(result.indexOf(vec2), 1);
                }
                
                return true;
            }
        }
    }
}