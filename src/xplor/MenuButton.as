package xplor 
{
	import org.flixel.*;
	
	public class MenuButton extends FlxButton
	{
		[Embed(source="../../data/BtnOnImage.png")]
		protected var BtnOnImage:Class;
		[Embed(source="../../data/BtnOffImage.png")]
		protected var BtnOffImage:Class;
		
		private var txt:FlxText;
		
		public function MenuButton(X:int, Y:int, callback:Function, label:String = "", label2:String = null) 
		{
			var on:FlxSprite = new FlxSprite(0, 0, BtnOnImage);
			var off:FlxSprite = new FlxSprite(0, 0, BtnOffImage);
			var txt:FlxText = new FlxText(0, 5, on.width, label).setFormat(null, 8, 0xff000000, "center");
			var txt2:FlxText;
			
			if (label2 != null) {
				txt2 = new FlxText(0, 5, on.width, label2).setFormat(null, 8, 0xff000000, "center");
			} else {
				txt2 = txt;
			}
			
			super(X - (on.width / 2), Y, callback);
			loadGraphic(off, on).loadText(txt, txt2);
		}
	}
}