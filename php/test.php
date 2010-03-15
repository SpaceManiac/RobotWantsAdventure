<?php
require('levellist.class.php');
header ("content-type: text/xml");

$list = new LevelList();
$list->addLevel( new LevelListItem(1,'Level 1', 'Steve') );
$list->addLevel( new LevelListItem(2,'Level 2', 'Steve') );
$list->addLevel( new LevelListItem(3,'Level 3', 'Steve') );
$list->addLevel( new LevelListItem(4,'Level 4', 'Steve') );
$list->outputXML();

?>