package
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    import asunit.framework.Assert;
    
    /**
     * Test Cases: 0个点, 1个点, 2个点, 所有点都在一条直线上.
     *   
     * @author mobiuschen
     * 
     */
    public class TestMazeGenerator extends Sprite
    {
        static private const P_NUM:int = 70;
        
        static private const AREA:Rectangle = new Rectangle(0, 0, 700, 700);
        
        public function TestMazeGenerator()
        {
            super();
            
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            init();
        }
        
        
        private function init():void
        {
            graphics.beginFill(0x555555);
            graphics.drawRect(AREA.x, AREA.y, AREA.width, AREA.height);
            graphics.endFill();
            
            var points:Vector.<Point> = generatePoints(P_NUM, AREA); 
            stage.addEventListener(MouseEvent.CLICK, onClickStage);
            
            
            
            function onClickStage(evt:MouseEvent):void
            {
                var lines:Vector.<Line> = joint(points);
                renderShapes(points, lines);
            }
                
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
         * 根据给定的点, 连接成地图 
         * @param allPoints
         * 
         */        
        private function joint(allPoints:Vector.<Point>):Vector.<Line>
        {
            var allLines:Vector.<Line> = getAllLines(allPoints);
            var collections:Vector.<Vector.<Point>> = initCollections(allPoints);
            
            var result:Vector.<Line> = new Vector.<Line>();
            
            while(allPoints.length > 0)
            {
                if(collections.length == 1)
                    break;
                //寻找最短的边
                //var selectedLine:Line = allLines.shift();
                
                //不一定寻找最短的线段, 而是在前几名中随机选一条线段.
                var idx:int = int(Math.random() * Math.min(allLines.length, 10));
                var selectedLine:Line = allLines.splice(idx, 1)[0];
                
                if(!checkCrossPoint(selectedLine.p1, selectedLine.p2, allPoints) &&
                   !checkCrossLine(selectedLine.p1, selectedLine.p2, result))
                {
                    joint2Point(selectedLine, collections, result);
                }
            }
            
            Assert.assertTrue(collections.length == 1);
            
            return result;
        }
        
        
        /**
         * 连接两个点
         *  
         * @param selectedLine
         * @param collections
         * @param lines
         * @return 
         * 
         */        
        private function joint2Point(selectedLine:Line, 
                                     collections:Vector.<Vector.<Point>>, 
                                     lines:Vector.<Line>):Boolean
        {
            var p1:Point = selectedLine.p1;
            var p2:Point = selectedLine.p2;
            
            if(p1 == p2)
                return false;
            var vec1:Vector.<Point>;
            var vec2:Vector.<Point>;
            for each(var vec:Vector.<Point> in collections)
            {
                if(vec.indexOf(p1) >= 0)
                    vec1 = vec;
                if(vec.indexOf(p2) >= 0)
                    vec2 = vec;
            }//for 
            
            Assert.assertTrue(vec1 != null && vec2 != null);
            
            //两个点在同一个集合内, 不允许连接.
            if(vec1 == vec2)
                return false;
            
            //连接两个集合
            collections.push(vec1.concat(vec2));
            collections.splice(collections.indexOf(vec1), 1);
            collections.splice(collections.indexOf(vec2), 1);
            
            lines.push(selectedLine);
            return true;
            
        }//function joint2Point
        
        
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
        
        
        /**
         * 根据所有点, 生成所有距离. 
         * @param points
         * @return 
         * 
         */        
        private function getAllLines(points:Vector.<Point>):Vector.<Line>
        {
            var dis:Number;
            var p1:Point;
            var p2:Point;
            var result:Vector.<Line> = new Vector.<Line>();
            for each(p1 in points)
            {
                for each(p2 in points)
                {
                    if(p1 == p2)
                        continue;
                    var dx:Number = p1.x - p2.x;
                    var dy:Number = p1.y - p2.y;
                    dis = Math.sqrt(dx * dx + dy * dy);
                    result.push(new Line(dis, p1, p2));
                }
            }
            Assert.assertEquals(result.length, (points.length * points.length - points.length));
            result.sort(sortByDis);
            return result;
            
            function sortByDis(a:Line, b:Line):int
            {
                if(a.distance < b.distance)
                    return -1;
                else if(a.distance > b.distance)
                    return 1;
                return 0;
            }
        }//function
        
        
        /**
         * 初始化集合 
         * @param points
         * @return 
         * 
         */        
        private function initCollections(points:Vector.<Point>):Vector.<Vector.<Point>>
        {
            var result:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
            for each(var p:Point in points)
                result.push(new <Point>[p]);
                
            return result;
        }
        
        
        /**
         * 检查新的线段是否会和其他线段相交
         * 
         * @param p1
         * @param p2
         * @param crtLines
         * @return 
         * 
         */        
        private function checkCrossLine(p1:Point, p2:Point, allLines:Vector.<Line>):Boolean
        {
            //算法
            //http://hi.baidu.com/qi_hao/item/ed3e47de22d180fccb0c3999
            
            //由两个点组成的矩形
            var rect1:Rectangle =
                new Rectangle(
                    Math.min(p1.x, p2.x), Math.min(p1.y, p2.y), 
                    Math.abs(p1.x - p2.x), Math.abs(p1.y - p2.y)
                );
            for each(var line:Line in allLines)
            {
                var rect2:Rectangle = 
                    new Rectangle(
                        Math.min(line.p1.x, line.p2.x), Math.min(line.p1.y, line.p2.y), 
                        Math.abs(line.p1.x - line.p2.x), Math.abs(line.p1.y - line.p2.y)
                    );
                
                if(!rect1.intersects(rect2))//快速排斥实验
                    continue;
                
                //跨立实验
                //(( P1 - Q1 ) × ( Q2 - Q1 )) * (( Q2 - Q1 ) × ( P2 - Q1 )) >= 0
                var v1:Vector3D = new Vector3D(p1.x - line.p1.x, p1.y - line.p1.y);
                var v2:Vector3D = new Vector3D(line.p2.x - line.p1.x, line.p2.y - line.p1.y);
                var v3:Vector3D = new Vector3D(p2.x - line.p1.x, p2.y - line.p2.y);
                var v4:Vector3D = v1.crossProduct(v2);
                var v5:Vector3D = v2.crossProduct(v3);
                if(v4.dotProduct(v5) >= 0)
                    return true;
            }
            return false;
        }//function
        

        
        /**
         * 检查p1, p2组成的线段, 是否会和其他点相交. 
         * 
         * @param p1
         * @param p2
         * @param allPoints
         * @return 
         * 
         */        
        private function checkCrossPoint(p1:Point, p2:Point, allPoints:Vector.<Point>):Boolean
        {
            var v1:Vector3D = new Vector3D(p1.x - p2.x, p1.y - p2.y);
            v1.normalize();
            //trace(v1.length);
            
            for each(var p3:Point in allPoints)
            {
                var v2:Vector3D = new Vector3D(p3.x - p2.x, p3.y - p2.y);
                v2.normalize();
                if(!v1.equals(v2))
                    continue;
                
                v2.x = p3.x - p1.x;
                v2.y = p3.y - p1.y;
                v2.negate();
                if(v1.equals(v2))
                    return true;
            }
            return false;
        }
    }
}