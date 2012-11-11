package
{
    import flash.geom.Point;

    public class Line
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
}