<?php
/*
	LevelList class - Loads level information from database,
		and outputs them as XML.
	
	LevelListItem class - Holds information about a single level.
		Should only be used by LevelList.
*/

/*
	IMPORTANT NOTE: Please add require() for the file containing the
		passwords, but don't add that file to the repo!
*/

require_once 'getdbc.php';

class LevelList
{
	public $levels = array();
	function addLevel( $level )
	{
		$this->levels[] = $level;
	}
	
	function load()
	{
		$dbh = getDBC();
		$sql = 'SELECT * FROM levels ORDER BY id ASC';
		$stmt = $dbh->prepare($sql);
		$stmt->execute();
		while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$this->addLevel(new LevelListItem( $row['id'], $row['name'], $row['author'], $row['filename']));
		}
	}
	
	function outputXML()
	{
		$xml = new SimpleXMLElement('<levels></levels>');
		
		foreach ( $this->levels as $level )
		{
			$lvl = $xml->addChild('level');
			$lvl->addAttribute('id', $level->id);
			$lvl->addChild('name', $level->name);
			$lvl->addChild('author', $level->author);
			$lvl->addChild('filename', $level->filename);
		}
		echo $xml->asXML();
	}
}

class LevelListItem
{
	public $id, $name, $author;
	
	function __construct( $id, $name, $author, $filename )
	{
		$this->id = $id;
		$this->name = $name;
		$this->author = $author;
		$this->filename = $filename;
	}
}

?>