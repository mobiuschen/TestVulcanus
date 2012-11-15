package im.mobius
{
    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;

    public class QuadTreeCollisionDetection
    {
        private var _quadTree1:QuadTree;
        private var _quadTree2:QuadTree;
        
        private var _camp1:Vector.<DisplayObject>;
        private var _camp2:Vector.<DisplayObject>;
        
        private var _collisionFilter:GlowFilter;
        
        private var _dectetedFilter:GlowFilter;
        
        public function QuadTreeCollisionDetection()
        {
            init();
        }
        
        
        private function init():void
        {
            _collisionFilter = new GlowFilter(0x0000ff);
            _dectetedFilter = new GlowFilter(0xBF5841);
        }
        
        
        public function initCamps(area:Rectangle, minGirdSize:Number, maxLevel:int, 
                                  camp1:Vector.<DisplayObject>, camp2:Vector.<DisplayObject>):void
        {
            if(_quadTree1 != null)
                _quadTree1.clear();
            
            if(_quadTree2 != null)
                _quadTree2.clear();
            
            _quadTree1 = new QuadTree(area, minGirdSize, maxLevel);
            _quadTree2 = new QuadTree(area, minGirdSize, maxLevel);
            
            _camp1 = camp1;
            _camp2 = camp2;
        }
        
        
        public function detectCollision():void
        {
            _quadTree1.reset(_camp1);
            _quadTree2.reset(_camp2);
            
            
            for each(var obj2:DisplayObject in _camp2)
                obj2.filters = [];
            
            for each(var obj1:DisplayObject in _camp1)
            {
                var bounds:Rectangle = new Rectangle(obj1.x, obj1.y, obj1.width, obj1.height);
                
                var collisions:Vector.<DisplayObject> = _quadTree2.retriveByRect(bounds);
                for each(obj2 in collisions)
                {
                    
                    obj2.filters = [obj1.hitTestObject(obj2) ? _collisionFilter : _dectetedFilter];
                }
            }
        }
        
    }
}