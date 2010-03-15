<?php
/*
	This is a file for testing the bmp2raw class.
*/
// Turn off all error reporting
require('png2raw.class.php');

$p2r = new Png2Raw;
$p2r->loadLookup('rwk.txt');
$p2r->loadPng('http://hamupload.nfshost.com/image.php?i=340');
$p2r->convert();

//header('Content-type: application/octet-stream');
echo $b2r->raw;
?>