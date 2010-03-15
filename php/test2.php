<?php
/*
	This is a file for testing the bmp2raw class.
*/
// Turn off all error reporting
error_reporting(0);
require('bmp2raw.class.php');
$b2r = new Bmp2Raw;
$b2r->loadBmp('http://hamupload.nfshost.com/image.php?i=336');
$b2r->convert();
?>