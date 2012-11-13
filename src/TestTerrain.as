package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class TestTerrain extends Sprite
    {
        [Embed(source="../assets/terrain_tile.png")]
        private const TERRAIN_IMG:Class;
        
        /*** 地块尺寸 */        
        static private const TILE_SIZE:Number = 64;
        
        /*** 地图长宽的tile的数量 */        
        static private const MAP_BORDER_TILE_NUM:int = 8;
        
        private var _bpdVector:Vector.<BitmapData>;
        
        private var _canvas:Bitmap;
        
        private var _mapDatas:Vector.<Vector.<int>>;
        
        private var _mapContainer:Sprite;
        
        public function TestTerrain()
        {
            super();
            
            // support autoOrients
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            init();
        }
        
        
        private function init():void
        {
            initMapContainer();
            initImg();
            
            _mapContainer.addEventListener(MouseEvent.CLICK, onClickMap);
        }
        
        
        private function initMapContainer():void
        {
            _mapContainer = new Sprite();
            //打底
            _mapContainer.graphics.beginFill(0x999999);
            var borderSize:int = MAP_BORDER_TILE_NUM * TILE_SIZE;
            _mapContainer.graphics.drawRect(0, 0, borderSize, borderSize);
            _mapContainer.graphics.endFill();
            
            //画线
            _mapContainer.graphics.lineStyle(1, 0x00ff00);
            for(var i:int = 0; i < MAP_BORDER_TILE_NUM; i++)
            {
                _mapContainer.graphics.moveTo(0, i * TILE_SIZE);
                _mapContainer.graphics.lineTo(borderSize, i * TILE_SIZE);
                _mapContainer.graphics.moveTo(i * TILE_SIZE, 0);
                _mapContainer.graphics.lineTo(i * TILE_SIZE, borderSize);
            }
            
            var bpd:BitmapData = new BitmapData(borderSize, borderSize, true, 0);
            _canvas = new Bitmap(bpd);
            _mapContainer.addChild(_canvas);
            
            addChild(_mapContainer);
            
            //地图描述数据
            var n:int = MAP_BORDER_TILE_NUM * MAP_BORDER_TILE_NUM;
            _mapDatas = new Vector.<Vector.<int>>(n, true);
            for(i = 0; i < n; i++)
                _mapDatas[i] = new <int>[0, 0, 0, 0];
        }
        
        private function initImg():void
        {
            var oriBpd:BitmapData = (new TERRAIN_IMG() as Bitmap).bitmapData;
            var bpd:BitmapData;
            
            var srcRect:Rectangle;
            var desP:Point = new Point();
            var bmp:Bitmap;
            _bpdVector = new Vector.<BitmapData>();
            for(var i:int = 0, n:int = 16; i < n; i++)
            {
                bpd = new BitmapData(TILE_SIZE, TILE_SIZE);
                //先竖后横
                srcRect = new Rectangle(
                    int(i / 4) * TILE_SIZE,
                    (i % 4) * TILE_SIZE, 
                    TILE_SIZE, TILE_SIZE
                );
                bpd.copyPixels(oriBpd, srcRect, desP);
                _bpdVector.push(bpd);
                
                /*
                trace(srcRect);
                bmp = new Bitmap(bpd);
                bmp.x = (i % MAP_BORDER_TILE_NUM) * TILE_SIZE;
                bmp.y = int(i / MAP_BORDER_TILE_NUM) * TILE_SIZE;
                trace(bmp.x, bmp.y);
                addChild(bmp);
                */
            }
            oriBpd.dispose();
        }
        
        
        private function onClickMap(evt:MouseEvent):void
        {
            var idx:int = int(evt.localY / TILE_SIZE) * MAP_BORDER_TILE_NUM + int(evt.localX / TILE_SIZE);
            /*
            0,1
            2,3
            0 是点击点
            */
            var rightOutOfBorder:Boolean = (idx % MAP_BORDER_TILE_NUM + 1) >= MAP_BORDER_TILE_NUM;
            var aroundIdxes:Vector.<int> = new <int>[
                idx,
                rightOutOfBorder ? -1 : (idx + 1),
                idx + MAP_BORDER_TILE_NUM,
                rightOutOfBorder ? -1 : (idx + MAP_BORDER_TILE_NUM + 1) 
            ];
            handlMap(aroundIdxes);
            //trace(aroundIdxes);
        }
        
        
        private function handlMap(aroundIdxes:Vector.<int>):void
        {
            trace(aroundIdxes);
            
            var l:int = _mapDatas.length;
            var idx:int;
            
            //点击点
            idx = aroundIdxes[0];
            if(idx >= 0 && idx < l && _mapDatas[idx][3] != 4)
                _mapDatas[idx][3] = 4;
            
            //右
            idx = aroundIdxes[1];
            if(idx >= 0 && idx < l && _mapDatas[idx][1] != 8)
                _mapDatas[idx][1] = 8;
            
            //下
            idx = aroundIdxes[2];
            if(idx >= 0 && idx < l && _mapDatas[idx][2] != 1)
                _mapDatas[idx][2] = 1;
            
            //右下
            idx = aroundIdxes[3];
            if(idx >= 0 && idx < l && _mapDatas[idx][0] != 2)
                _mapDatas[idx][0] = 2;
            
            updateTile(aroundIdxes[0]);
            updateTile(aroundIdxes[1]);
            updateTile(aroundIdxes[2]);
            updateTile(aroundIdxes[3]);
        }
        
        
        private function updateTile(idx:int):void
        {
            if(idx < 0 || idx >= _mapDatas.length)
                return;
            
            var weight:int = 0;
            for each(var w:int in _mapDatas[idx])
                weight += w;
                
            var srcBpd:BitmapData = _bpdVector[weight];
            var desP:Point = 
                new Point(
                    (idx % MAP_BORDER_TILE_NUM) * TILE_SIZE,
                    int(idx / MAP_BORDER_TILE_NUM) * TILE_SIZE
                );
            var srcRect:Rectangle = new Rectangle(0, 0, TILE_SIZE, TILE_SIZE);
            var bpd:BitmapData = _canvas.bitmapData;
            bpd.copyPixels(srcBpd, srcRect, desP);
        }
    }
}