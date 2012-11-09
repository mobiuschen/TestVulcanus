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
    
    public class TestTerrain2 extends Sprite
    {
        [Embed(source="../assets/terrain_tile.png")]
        private const TERRAIN_IMG:Class;
        
        private var config:Array = [
            [0,4,8,12],
            [1,5,9,13],
            [2,6,10,14],
            [3,7,11,15],
        ];
        
        
        private var arr:Array = new Array();
        
        private var resBD:BitmapData;
        
        
        private var py:uint;
        private var px:uint;
        
        private var lib:Array = new Array();
        
        public function TestTerrain2()
        {
            super();
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            
            var bitmap:BitmapData;
            var bd:BitmapData = (new TERRAIN_IMG()).bitmapData;
            
            //var py:uint;
            //var px:uint;
            for(py = 0;py<config.length;py++)
            {
                var line:Array = config[py];
                for(px = 0;px < line.length;px++)
                {
                    bitmap = new BitmapData(64,64,true,0);
                    bitmap.copyPixels(bd,new Rectangle(px*64,py*64,64,64),new Point(),null,null,true);
                    lib[line[px]] = bitmap;
                }
            }
            
            for(py=0;py<10;py++)
            {
                var data:Array = new Array();
                for(px=0;px<10;px++)
                {
                    data.push([0,0,0,0]);
                }
                arr.push(data);
            }
            
            stage.addEventListener(MouseEvent.CLICK,onClick);
            
            resBD = new BitmapData(640,640,true,0xff000000);
            addChild(new Bitmap(resBD));
            
        }
        
        
        
        private function onClick(e:MouseEvent):void
        {
            var _mx:uint = int(e.stageX/64);
            var _my:uint = int(e.stageY/64);
            
            if(arr[_my][_mx][3]!=4) 
                arr[_my][_mx][3]+=4;
            
            if(arr[_my][_mx+1][1]!=8) 
                arr[_my][_mx+1][1]+=8;
            
            if(arr[_my+1][_mx][2]!=1)
                arr[_my+1][_mx][2]+=1;
            
            if(arr[_my+1][_mx+1][0]!=2)
                arr[_my+1][_mx+1][0]+=2;
            
            reDraw();
        }
        
        
        private function reDraw():void
        {
            resBD.fillRect(resBD.rect,0);
            for(py=0;py<10;py++)
            {
                for(px=0;px<10;px++)
                {
                    var b:uint=arr[py][px][0]+arr[py][px][1]+arr[py][px][2]+arr[py][px][3];
                    
                    if(b==0) continue;
                    if(b>15) b=15;
                    resBD.copyPixels(lib[b],lib[b].rect,new Point(px*64,py*64),null,null,true);
                }
            }
        }
        
    }
}