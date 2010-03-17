<?php
/*
	Png2Raw class - takes a png image and converts it to a raw file,
		ready to be added to the database, or whatever.
*/

class Png2Raw
{
	public $png;
	public $lookup = array();
	public $raw = array();
	public $error;
	
	/// $png is optional, so you can pass the bmp later if you want.
	function __construct( $png = '' )
	{
		$this->error = '';
		$this->png = $png;
		$this->raw = NULL;
	}
	
	function loadPng($filename)
	{
		$this->png = $filename;
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
		$image = @imagecreatefrompng($this->png);
		if($image == false) {
			$this->error = "Could not read PNG image";
			return false;
		}
		$h = imagesx($image);
		$w = imagesy($image);
		
		$hasrobot = false;
		$haskitty = false;
		
		if($h != 256 || $w != 256) {
			$this->error = "Invalid dimensions $w*$h, must be 256*256";
			return false;
		}
		
		for ($y = 0; $y < $h; $y++)
		{
			for ($x = 0; $x < $w; $x++ )
			{
				$color = imagecolorat( $image, $x, $y );
				if(isset($this->lookup[$color]))
				{
					$this->raw .= chr($this->lookup[$color]);
					
					if($this->lookup[$color] == 254) {
						if($haskitty) {
							$this->error = "Level contains multiple kitties";
							return false;
						} else {
							$haskitty = true;
						}
					} else if($this->lookup[$color] == 255) {
						if($hasrobot) {
							$this->error = "Level contains multiple robots";
							return false;
						} else {
							$hasrobot = true;
						}
					}
				}
				else
				{
					$this->raw = "";
					$this->error = "Invalid pixel at ($x, $y)";
					return false;
				}
			}
		}
		
		if(!$haskitty) {
			$this->error = "Level doesn't contain a kitty";
			return false;
		}
		if(!$hasrobot) {
			$this->error = "Level doesn't contain a robot";
			return false;
		}
		
		return true;
	}
}

?>