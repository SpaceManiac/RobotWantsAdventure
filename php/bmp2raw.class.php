<?php
/*
	Bmp2Raw class - takes a bitmap and converts it to a raw file,
		ready to be added to the database, or whatever.
*/

require('imagefrombmp.php');

class Bmp2Raw
{
	public $bitmap;
	public $raw = array();
	
	/// $bitmap is optional, so you can pass the bmp later if you want.
	function __construct( $bitmap = '' )
	{
		$this->bitmap = $bitmap;
		$this->raw = NULL;
	}
	
	function loadBmp($filename)
	{
		$this->bitmap = fopen($filename,"rb");
	}
	
	function convert()
	{
		$image = ImageCreateFromBMP( $this->bitmap );
		$h = imagesx($image);
		$w = imagesy($image);
		
		for ($y = 0; $y < $h; $y++)
		{
			$line = array();
			for ($x = 0; $x < $w; $x++ )
			{
				$line[] = imagecolorat( $image, $x, $y );
			}
			$this->raw[] = $line;
		}
		
		print_r( $this->raw );
	}
}

?>