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
		
		private var fading:Boolean = false;
		
        override public function TitleState():void
        {
			FlxG.log("TitleState opened");
			var b:ByteArray = new BuildNum();
			var s:String = b.readUTFBytes(b.length);
			
			this.add(new Background());
            this.add(new FlxText(0, 20, FlxG.width, "Robot Wants Kitty:", 0xffffffff, null, 16, "center")) as FlxText;
            this.add(new FlxText(0, 36, FlxG.width, "Adventure Edition EDITOR", 0xffffffff, null, 16, "center")) as FlxText;
			this.add(new MenuButton(FlxG.width / 2, 70, edit, "Open Editor (Z)"));
			this.add(new MenuButton(FlxG.width / 2, 110, loadDisk, "Load From Disk (X)"));
			this.add(new FlxText(0, 220, FlxG.width + 1, "Build " + s, 0xffffffff, null, 8, "center"));
			
			this.add(new Cursor());
        }
		
        override public function update():void
        {
            if (FlxG.keys.Z) {
                edit();
			} else if (FlxG.keys.X) {
				loadDisk();
			}
            super.update();
        }
		
		private function loadDisk():void
		{
			if (!fading) {
				fading = true;
                FlxG.flash(0xffffffff, 0.75);
                FlxG.fade(0xff000000, 0.5, onFadeLoadDisk);
				FlxG.play(hitSnd);
			}
		}
		
		private function edit():void
		{
			if (!fading) {
				fading = true;
                FlxG.flash(0xffffffff, 0.75);
                FlxG.fade(0xff000000, 0.5, onFadeEdit);
				FlxG.play(hitSnd);
			}
		}
		
        private function onFadeLoadDisk():void
        {
            //FlxG.switchState(LoadDiskState);
            FlxG.switchState(TitleState);
        }
        private function onFadeEdit():void
        {
            //FlxG.switchState(EditState);
            FlxG.switchState(PlayState);
        }
    }
}