package xplor
{
    import org.flixel.*;
	
    public class WinState extends FlxState
    {
		[Embed(source="../../data/win.mp3")] 
		protected var winSnd:Class;
		[Embed(source="../../data/win.png")] 
		protected var winPic:Class;
		
		protected var pic:FlxSprite;
		
		public static var time:String = "";
		
        override public function create():void
        {
            pic = this.add(new FlxSprite(0, 0, winPic)) as FlxSprite;
			this.add(new FlxText(0, FlxG.height  -24, FlxG.width/2, "Press Z to quit").setFormat(null, 8, 0xffffffff, "center"));
			this.add(new FlxText(FlxG.width/2, 2, FlxG.width/2, time).setFormat(null, 8, 0xffffffff, "center"));
			FlxG.play(winSnd);
        }
		
        override public function update():void
        {
            if (FlxG.keys.Z)
            {
                FlxG.flash.start(0xffffffff, 0.75);
                FlxG.fade.start(0xff000000, 0.5, onFade);
            }
            super.update();
        }
		
        private function onFade():void
        {
            FlxG.state = new TitleState;
        }
    }
}