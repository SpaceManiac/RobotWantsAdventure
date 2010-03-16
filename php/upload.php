<?php
/*
	Let the user upload a file, PNG only, 256x256.
	If it's a valid level, add it to the database,
	otherwise tell the user.
*/

function makeTiny($str) {
	return str_replace(" ", "", strtolower($str));
}

require_once '../wombat.php';
require_once 'getdbc.php';
require_once 'png2raw.class.php';
WombatHead('RWK:AE - Upload a level');

//Only do the upload stuff if a file has been uploaded.
$error = '';
if (isset($_FILES['userfile']))
{
	//Check file uploaded.
	if ( is_uploaded_file($_FILES['userfile']['tmp_name']))
	{
		$filename = $_FILES['userfile']['name'];
		$filename = basename($filename, '.png') . '.png';
		$authorname = stripslashes($_POST['authorname']);
		$levelname = stripslashes($_POST['levelname']);
		
		if($authorname == '') $authorname = "Anonymous";
		if($levelname == '') $levelname = "Untitled " . mt_rand(10, 99);
		
		$filename = makeTiny($levelname) . '_' . makeTiny($authorname) . '.png';
		
		$newlocation = '/f5/wombatymuus/public/rwa/levels/' . $filename;
		$i = 1;
		while(file_exists($newlocation)) {
			$name = basename($filename, '.png');
			$newlocation = '/f5/wombatymuus/public/rwa/levels/' . $name . '_v' . ++$i . '.png';
		}
		move_uploaded_file($_FILES['userfile']['tmp_name'], $newlocation);
		
		$rawfile = substr($newlocation, 0, strlen($newlocation) - 4) . '.raw';
		$rawfile2 = basename($rawfile);
		
		$p2r = new Png2Raw;
		$p2r->loadLookup('rwk.txt');
		$p2r->png = $newlocation;
		if($p2r->convert()) {
			file_put_contents($rawfile, $p2r->raw);
		
			$dbh = getDBC();
			$sql = 'INSERT INTO levels (name, author, filename, testing) VALUES (:name, :author, :filename, :testing)';
			$stmt = $dbh->prepare($sql);
			$testing = 1;
			$stmt->bindParam(':name', $levelname);
			$stmt->bindParam(':author', $authorname);
			$stmt->bindParam(':filename', $rawfile2);
			$stmt->bindParam(':testing', $testing);
			$stmt->execute();
			
			$error = '<font color="green">Upload successful!</font>';
		} else {
			unlink($newlocation);
			$error = '<font color="red">Error: ' . $p2r->error . '</font>';
		}
	}
}
?>
<h1>Upload a level</h1>
<?php include('linkbar.php'); ?>

<p>Want to make a level for Robot Wants Kitty: Adventure Edition? Here's how!</p>

<h2>1. Get the tools</h2>
First of all, you'll need an image editor such as MS Paint or Paint.NET - anything with an eyedropper tool and ability to save as PNG should work.<br />
Secondly, download the template image: it contains all the colors you'll need to build your level in your image editor.<br />
<a href="template.png"><img src="template.png" alt="Template" border="1" /></a>

<h2>2. Build your level</h2>
Eyedropper and pencil tool away - it's level building time! Here's the expanded names of the template items:<br />
<code>
<b>&nbsp;WALL</b> - solid wall<br />
<b>SPACE</b> - empty space<br />
<b>ROBOT</b> - the robot!<br />
<b>KITTY</b> - robot wants<br />
<b>L DEC</b> - left decoration thing, attach to the left side of platforms to make them look nice<br />
<b>R DEC</b> - right decoration thing, attach to the right side of platforms to make them look nice<br />
<b>RED A</b> - the red (ground) alien<br />
<b>BLU A</b> - the blue (flying) alien<br />
<b>&nbsp;JUMP</b> - the jump jet powerup<br />
<b>LASER</b> - the blaster powerup<br />
<b>&nbsp;OUCH</b> - classic OUCH OUCH block<br />
<b>D-JMP</b> - double-jump powerup<br />
<b>RISER</b> - rocket riser powerup<br />
<b>&nbsp;DASH</b> - dash rocket powerup<br />
<b>L SPD</b> - laser rapid-fire/speed powerup<br />
<b><i>X</i> KEY</b> - red, green, & blue keys<br />
<b>&nbsp;BOSS</b> - the boss monster <br />
<b><i>X</i> GAT</b> - red, green, & blue gates (doors) <br />
<b><i>X</i> TEL</b> - red, green, & blue teleporters (implemented!)
</code>

<h2><a name="submit">3. Submit your level</a></h2>

<?php echo $error; ?>
<form action="upload.php#submit" method="post" enctype="multipart/form-data">
	<p>Select a level to upload. Levels must be in PNG format, 256x256. Once you upload it, a mod will test it and make it public.</p>
	<table cellspacing="1" cellpadding="1" border="0">
		<tr><td colspan="2" align="center"><input type="file" name="userfile" /></td></tr>
		<tr><td align="right"><b>Level name:</b></td><td><input type="text" name="levelname" /></td></tr>
		<tr><td align="right"><b>Author:</b></td><td><input type="text" name="authorname" /></td></tr>
		<tr><td colspan="2" align="center"><input type="submit" value="Submit level for testing" /></td></tr>
	</table>
</form>

<?php WombatFoot(); ?>
