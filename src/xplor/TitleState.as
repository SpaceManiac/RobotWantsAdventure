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
		
        override public function create():void
        {
			FlxG.log("TitleState opened");
			var b:ByteArray = new BuildNum();
			var s:String = b.readUTFBytes(b.length);
			
			this.add(new Background());
            this.add(new FlxText(0, 20, FlxG.width, "Robot Wants Kitty:").setFormat(null, 16, 0xffffffff, "center")) as FlxText;
            this.add(new FlxText(0, 36, FlxG.width, "Adventure Edition").setFormat(null, 16, 0xffffffff, "center")) as FlxText;
			this.add(new FlxText(0, 220, FlxG.width + 1, "Build " + s).setFormat(null, 8, 0xffffffff, "center"));
			//this.add(new FlxText(0, 110, FlxG.width, "Selected:", 0xffffffff, null, 8, "center")); 
			//this.add(new FlxText(0, 120, FlxG.width, Adventure, 0xffffffff, null, 8, "center")); 
			this.add(new MenuButton(FlxG.width / 2, 70, play, "Play!"));
			this.add(new MenuButton(FlxG.width / 2, 110, adv, "Select Adventure"));
			this.add(new FlxText(0, 134, FlxG.width, Adventure).setFormat(null, 8, 0xffffffff, "center")); 
			this.add(new MenuButton(FlxG.width / 2, 150, config, "Game Options"));
            //this.add(new FlxText(0, FlxG.height - 28, FlxG.width, "Press Z to start", 0xffffffff, null, 8, "center"));
            //this.add(new FlxText(0, FlxG.height - 20, FlxG.width, "Press X to configure", 0xffffffff, null, 8, "center"));
			//this.add(new FlxText(0, FlxG.height - 12, FlxG.width, "Press Q while playing to quit", 0xffffffff, null, 8, "center"));
			
			this.add(new Cursor());
        }
		
        override public function update():void
        {
            if (FlxG.keys.Z) {
                play();
            } else if (FlxG.keys.X) {
				config();
			} else if (FlxG.keys.A) {
				adv();
			} else if (FlxG.keys.justPressed("F12")) {
				if (ConfigState.testing) {
					FlxG.log("Testing mode disabled");
					ConfigState.testing = 0;
				} else {
					FlxG.log("Testing mode enabled");
					ConfigState.testing = 1;
				}
			}
            super.update();
        }
		
		private function adv():void
		{
			if (!fading) {
				fading = true;
                FlxG.flash.start(0xffffffff, 0.75);
                FlxG.fade.start(0xff000000, 0.5, onFadeAdv);
				FlxG.play(hitSnd);
			}
		}
		
		private function play():void
		{
			if (!fading) {
				fading = true;
                FlxG.flash.start(0xffffffff, 0.75);
                FlxG.fade.start(0xff000000, 0.5, onFadePlay);
				FlxG.play(hitSnd);
			}
		}
		
		private function config():void
		{
			if (!fading) {
				fading = true;
                FlxG.flash.start(0xffffffff, 0.75);
                FlxG.fade.start(0xff000000, 0.5, onFadeConfig);
				FlxG.play(hitSnd);
			}
		}
		
        private function onFadePlay():void
        {
            FlxG.state = new PlayState;
        }
        private function onFadeAdv():void
        {
            FlxG.state = new AdvSelectState;
        }
        private function onFadeConfig():void
        {
            FlxG.state = new ConfigState;
        }
    }
}