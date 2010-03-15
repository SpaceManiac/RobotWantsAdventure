<?php
session_start();

require_once '../wombat.php';
require_once 'getdbc.php';
require_once 'modpassword.php';
WombatHead('RWK:AE Mod Control Panel');

if(!isset($_SESSION['rwamod'])) {
	if(isset($_POST['password']) && $_POST['password'] == MOD_PASSWORD) {
		$_SESSION['rwamod'] = true;
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
}

$dbh = getDBC();

if (isset($_POST['update'])) {
	$id = 0; $name = ''; $author = ''; $filename = ''; $testing = 0;
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
		$id = substr($key, 5, strlen($key)-6);
		$name = $_POST['name_' . $id . '_'];
		$author = $_POST['author_' . $id . '_'];
		$filename = $_POST['filename_' . $id . '_'];
		$testing = ($_POST['testing_' . $id . '_'] == "on" ? 1 : 0);
		
		$stmt->execute();
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

$files = array();
opendir('levels/');
while(($f = readdir()) !== FALSE) {
	if($f[0] == '.') continue;
	$files[] = $f;
}
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
}

?>
<h1>RWK:AE Mod Control Panel</h1>
<form action="mod.php" method="post">
<input type="hidden" name="update" value="1" />
<table width="100%" cellspacing="0" cellpadding="1" border="1">
<tr><th width="50">ID</th><th>Name</th><th>Author</th><th>Filename</th><th width="100">In-Testing</th></tr>
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
	echo '<td><input type="checkbox" name="testing_' . $id . '_"' . $checked . ' /></td>';
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
</select></td><td><input type="checkbox" name="testing_new" checked></td></tr>
<tr><td colspan="5" align="center"><input type="submit" value="Update Database"></td></tr>
</table>
</form>
<p>Unused files: <?php echo implode($unused_files, ', '); ?></p>
<br />
<a href="/rwa/">Back to RWK:AE</a>

<?php WombatFoot(); ?>