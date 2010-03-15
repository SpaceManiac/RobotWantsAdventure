<?php

require_once 'levellist.class.php';

$testing = false;
if(isset($_GET['testing']) && $_GET['testing'] == 1) {
	$testing = true;
}

header('Content-type: text/xml');
$levellist = new LevelList();
$levellist->load($testing);
$levellist->outputXML();

?>