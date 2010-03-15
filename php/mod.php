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

$files = array();
opendir('levels/');
while(($f = readdir()) !== FALSE) {
	$files[] = $f;
}
$unused_files = $files;

$dbh = getDBC();
$sql = 'SELECT * FROM levels ORDER BY id ASC';
$stmt = $dbh->prepare($sql);
$stmt->execute();

$levels = array();
while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
	$levels[] = $row;
}

?>
<h1>RWK:AE Mod Control Panel</h1>
<form action="mod.php" method="post">
<input type="hidden" name="update" value="1" />
<table width="100%" cellspacing="0" cellpadding="1" border="1">
<tr><th width="50">ID</th><th>Name</th><th>Author</th><th>Filename</th><th width="100">In-Testing</th></tr>
<?php



?>
<tr><td colspan="5" align="center"><input type="submit" value="Update Database"></td></tr>
</table>
</form>
<br />
<a href="/rwa/">Back to RWK:AE</a>

<?php WombatFoot(); ?>