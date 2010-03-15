<?php

function getDBC() {
	$dsn = "sqlite:/f5/wombatymuus/protected/rwa.dat";
	try {
		$dbh = new PDO($dsn, $dbname, $pass);
	}
	catch(PDOException $e) {
		return NULL;
	}
	$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	return $dbh;
}

?>