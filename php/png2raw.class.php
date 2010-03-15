<?php
/*
	Png2Raw class - takes a png image and converts it to a raw file,
		ready to be added to the database, or whatever.
*/

class Png2Raw
{
	public $bitmap;
	public $lookup = array();
	public $raw = array();
	
	/// $bitmap is optional, so you can pass the bmp later if you want.
	function __construct( $bitmap = '' )
	{
		$this->bitmap = $bitmap;
		$this->raw = NULL;
	}
	
	function loadPng($filename)
	{
		$this->bitmap = imagecreatefrompng($filename);
	}
	
	function loadLookup($filename)
	{
		$data = file($filename);
		$this->lookup = array();
		foreach($data as $line)
		{
			if(strlen($line) < 2) continue;
			if($line[0] == '/' && $line[1] == '/') continue;
			$p = strpos($line, ' ');
			$tile = intval(substr($line, 0, $p));
			$color = substr($line, $p+1, 6);
			$this->lookup[hexdec($color)] = $tile;
		}
	}
	
	function convert()
	{
		$image = $this->bitmap;
		$h = imagesx($image);
		$w = imagesy($image);
		
		for ($y = 0; $y < $h; $y++)
		{
			for ($x = 0; $x < $w; $x++ )
			{
				$color = imagecolorat( $image, $x, $y );
				if(isset($this->lookup[$color]))
				{
					$this->raw .= chr($this->lookup[$color]);
				}
				else
				{
					$this->raw .= "<invalid>";
					return;
				}
			}
		}
	}
}

?>