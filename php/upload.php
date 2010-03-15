<?php
/*
	Let the user upload a file, PNG only, 256x256.
	If it's a valid level, add it to the database,
	otherwise tell the user.
*/

session_start();

//First, check the user is an admin. I'm assuming only admins can upload.
//Otherwise, simply remove this section.
if(!isset($_SESSION['rwamod'])) {
	header('Location: http://wombat.platymuus.com/rwa/mod.php');
	die;
}

require_once '../wombat.php';
require_once 'getdbc.php';
require_once('png2raw.class.php');
WombatHead('RWK:AE - Upload a level');

//Only do the upload stuff if a file has been uploaded.
if (isset($_FILES['userfile']))
{
	//Check file uploaded.
	if ( is_uploaded_file($_FILES['userfile']['tmp_name']))
	{
		$filename = $_FILES['userfile']['name'];
		$authorname = stripslashes($_POST['authorname']);
		$levelname = stripslashes($_POST['levelname']);
		
		$p2r = new Png2Raw;
		$p2r->loadLookup('rwk.txt');
		//$p2r->loadPng('http://hamupload.nfshost.com/image.php?i=340');
		$p2r->png = $_FILES['userfile']['tmp_name'];
		$p2r->convert();

		//header('Content-type: application/octet-stream');
		echo $b2r->raw;
	}
}
?>
<h1>Upload a level</h1>
<form action="upload.php" method="POST" enctype="multipart/form-data">
	<p>Select a level to upload. Levels must be in PNG format, 256x256.</p>
	<input type="file" name="userfile" /> <br />
	<b>Level name:</b> <input type="text" name="levelname" /> <br />
	<b>Author:</b> <input type="text" name="authorname" /> <br />
</form>

<?php WombatFoot(); ?>
