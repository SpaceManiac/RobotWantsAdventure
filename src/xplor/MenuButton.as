﻿package xplor 
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
			var on:FlxSprite = new FlxSprite(BtnOnImage);
			var off:FlxSprite = new FlxSprite(BtnOffImage);
			var txt:FlxText = new FlxText(0, 5, on.width, label, 0xff000000, null, 8, "center");
			var txt2:FlxText;
			
			if (label2 != null) {
				txt2 = new FlxText(0, 5, on.width, label2, 0xff000000, null, 8, "center");
			} else {
				txt2 = txt;
			}
			
			super(X - (on.width / 2), Y, off, callback, on, txt, txt2);
		}
	}
}