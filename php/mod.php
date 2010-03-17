<?php
require_once '../wombat.php';
require_once 'getdbc.php';
require_once 'modpassword.php';
WombatHead('RWK:AE - Mod Control Panel');

if(!isset($_SESSION['rwamod'])) {
	if(isset($_POST['password']) && $_POST['password'] == MOD_PASSWORD) {
		$_SESSION['rwamod'] = MOD_PASSWORD;
	} else {
?>
<form action="mod.php" method="post">
Enter password:<br />
<input type="password" name="password" /><br />
<input type="submit" value="Log in" />
</form>
<?php
		WombatFoot();
		die;
	}
} else {
	if($_SESSION['rwamod'] !== MOD_PASSWORD) {
		unset($_SESSION['rwamod']);
		die;
	}
}

$dbh = getDBC();
if (isset($_POST['update'])) {
	$id = 0; $name = ''; $author = ''; $filename = ''; $testing = '';

	$sql_d = 'DELETE FROM levels WHERE id=:id';
	$stmt_d = $dbh->prepare($sql);
	$stmt_d->bindParam(':id', $id);
	
	$sql = 'UPDATE levels SET name=:name, author=:author, filename=:filename, testing=:testing WHERE id=:id';
	$stmt = $dbh->prepare($sql);
	$stmt->bindParam(':id', $id);
	$stmt->bindParam(':name', $name);
	$stmt->bindParam(':author', $author);
	$stmt->bindParam(':filename', $filename);
	$stmt->bindParam(':testing', $testing);
			
	foreach(array_keys($_POST) as $key) {
		if(substr($key, 0, 4) != 'name') continue;
		if($key == 'name_new') continue;
		$id = (int)(substr($key, 5, strlen($key)-6));
		$name = $_POST['name_' . $id . '_'];
		$author = $_POST['author_' . $id . '_'];
		$filename = $_POST['filename_' . $id . '_'];
		$testing = ($_POST['testing_' . $id . '_'] == "on" ? 1 : 0);
		
		if(isset($_POST['delete_' . $id . '_'])) {
			echo 'deleting';
			$stmt_d->execute();
		} else {
			$stmt->execute();
		}
	}
	if($_POST['name_new'] !== '') {
		$sql = 'INSERT INTO levels (name, author, filename, testing) VALUES (:name, :author, :filename, :testing)';
		$stmt = $dbh->prepare($sql);
		$testingn = ($_POST['testing_new'] == "on" ? 1 : 0);
		$stmt->bindParam(':name', $_POST['name_new']);
		$stmt->bindParam(':author', $_POST['author_new']);
		$stmt->bindParam(':filename', $_POST['filename_new']);
		$stmt->bindParam(':testing', $_POST['testing_new']);
		$stmt->execute();
	}
}

$sql = 'DELETE FROM levels WHERE name=""';
$stmt = $dbh->prepare($sql);
$stmt->execute();

$files = array();
$unused_png = array();
opendir('levels/');
while(($f = readdir()) !== FALSE) {
	if($f[0] == '.' ) {
		continue;
	}
	$ext = substr($f, strlen($f)-4, 4);
	if($ext == '.raw') {
		$files[] = $f;
	} else if($ext == '.png') {
		$unused_png[] = $f;
	}
}
sort($files, SORT_STRING);
$unused_files = $files;
$sql = 'SELECT * FROM levels ORDER BY id ASC';
$stmt = $dbh->prepare($sql);
$stmt->execute();

$levels = array();
while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
	$levels[] = $row;
	$index = array_search($row['filename'], $unused_files);
	if($index !== FALSE) {
		array_splice($unused_files, $index, 1);
	}
	$png = substr($row['filename'], 0, strlen($row['filename'])-4) . '.png';
	$index = array_search($png, $unused_png);
	if($index !== FALSE) {
		array_splice($unused_png, $index, 1);
	}
}

if(isset($_POST['deleteunused'])) {
	foreach($unused_files as $f) {
		@unlink('./levels/' . $f);
	}
	foreach($unused_png as $f) {
		@unlink('./levels/' . $f);
	}
	$unused_files = array();
	$unused_png = array();
}

?>
<h1>RWK:AE Mod Control Panel</h1>
<?php include('linkbar.php'); ?>

<form action="mod.php" method="post" onsubmit="return confirm('Are you sure you want to update the database?');">
<input type="hidden" name="update" value="1" />
<table width="100%" cellspacing="0" cellpadding="1" border="1">
<tr><th width="50">ID</th><th>Name</th><th>Author</th><th>Filename</th><th>&nbsp;</th></tr>
<?php

foreach($levels as $lvl) {
	$id = (int)($lvl['id']);
	$name = $lvl['name'];
	$author = $lvl['author'];
	$filename = $lvl['filename'];
	$testing = (bool)($lvl['testing']);
	
	echo '<tr>';
	echo '<td>' . $id . '</td>';
	echo '<td><input type="text" name="name_' . $id . '_" value="' . $name . '" /></td>';
	echo '<td><input type="text" name="author_' . $id . '_" value="' . $author . '" /></td>';
	echo '<td><select name="filename_' . $id . '_" value="' . $name . '">';
	foreach($files as $file) {
		$selected = '';
		if($filename == $file) {
			$selected = ' selected="selected"';
		}
		echo '<option' . $selected . '>' . $file . '</option>';
	}
	echo '</select></td>';
	$checked = '';
	if($testing) {
		$checked = ' checked="checked"';
	}
	echo '<td><img src="test.png" alt="in-testing" /><input type="checkbox" name="testing_' . $id . '_"' . $checked . ' />';
	echo ' <img src="delete.png" alt="delete" /><input type="checkbox" name="delete_' . $id . '_" />';
	$pngname = './levels/' . substr($filename, 0, strlen($filename)-4) . '.png';
	if(file_exists($pngname)) {
		echo ' <a href="' . $pngname . '"><img src="map.png" alt="view map" border="0" /></a>';
	}
	echo '</td>';
	echo "</tr>\n";
}

?>
<tr><td>New</td><td><input type="text" name="name_new" /></td><td><input type="text" name="author_new" /></td><td><select name="filename_new">
<?php
foreach($files as $file) {
	$selected = '';
	echo '<option>' . $file . '</option>';
}
?>
</select></td><td><img src="test.png" alt="in-testing" /><input type="checkbox" name="testing_new" checked></td></tr>
<tr><td colspan="5" align="center"><input type="submit" value="Update Database"></td></tr>
</table>
</form>
<p>Unused files: <?php echo implode($unused_files, ', '); ?></p>
<p>Unreferenced png files: <?php echo implode($unused_png, ', '); ?></p>
<form action="mod.php" method="post" onsubmit="return confirm('Are you sure you want to clear all unused files?');">
<input type="hidden" name="deleteunused" value="1" />
<p><input type="submit" value="Delete all unused files" /><br />In general, don't use this. SpaceManaic'll take care of it if it gets too big.</p>
</form>
<p>Yay for <a href="http://www.famfamfam.com/lab/icons/silk/">Silk</a> set!</p>

<?php WombatFoot(); ?>