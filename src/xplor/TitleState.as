package xplor
{
    import org.flixel.*;
	import org.flixel.data.FlxAnim;
	import flash.utils.ByteArray;
	
    public class TitleState extends FlxState
    {
		[Embed(source="../../data/powerup.mp3")] 
		protected var hitSnd:Class;
		
		[Embed(source = "../../data/build.txt", mimeType = "application/octet-stream")]
		private var BuildNum:Class;
		
		public static var Adventure:String = "Classic Adventure by Hamumu";
		
		private var fading:Boolean = false;
		
        override public function TitleState():void
        {
			FlxG.log("TitleState opened");
			var b:ByteArray = new BuildNum();
			var s:String = b.readUTFBytes(b.length);
			
			this.add(new Background());
            this.add(new FlxText(0, 20, FlxG.width, "Robot Wants Kitty:", 0xffffffff, null, 16, "center")) as FlxText;
            this.add(new FlxText(0, 36, FlxG.width, "Adventure Edition", 0xffffffff, null, 16, "center")) as FlxText;
			this.add(new FlxText(0, 90, FlxG.width + 1, "Build " + s, 0xffffffff, null, 8, "center"));
			this.add(new FlxText(0, 110, FlxG.width, "Selected:", 0xffffffff, null, 8, "center")); 
			this.add(new FlxText(0, 120, FlxG.width, Adventure, 0xffffffff, null, 8, "center")); 
            this.add(new FlxText(0, FlxG.height - 28, FlxG.width, "Press Z to start", 0xffffffff, null, 8, "center"));
            this.add(new FlxText(0, FlxG.height - 20, FlxG.width, "Press X to configure", 0xffffffff, null, 8, "center"));
			this.add(new FlxText(0, FlxG.height - 12, FlxG.width, "Press Q while playing to quit", 0xffffffff, null, 8, "center"));
        }
		
        override public function update():void
        {
            if (FlxG.keys.Z && !fading) {
                FlxG.flash(0xffffffff, 0.75);
                FlxG.fade(0xff000000, 0.5, onFadePlay);
				FlxG.play(hitSnd);
				fading = true;
            } else if (FlxG.keys.X && !fading) {
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 0.5, onFadeConfig);
				FlxG.play(hitSnd);
				fading = true;
			} else if (FlxG.keys.F12 && !ConfigState.testing) {
				FlxG.log("Testing mode enabled");
				ConfigState.testing = 1;
			}
            super.update();
        }
		
        private function onFadePlay():void
        {
            FlxG.switchState(PlayState);
        }
        private function onFadeConfig():void
        {
            FlxG.switchState(ConfigState);
        }
    }
}