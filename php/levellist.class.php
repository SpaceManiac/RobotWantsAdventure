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

class LevelList
{
	public $levels = array();
	function addLevel( $level )
	{
		$this->levels[] = $level;
	}
	
	function load()
	{
		//This would load the levels from the database, except the database
		//doesn't exist yet so I don't know what to write. :P
	}
	
	function outputXML()
	{
		$xml = new SimpleXMLElement('<levels>');
		
		foreach ( $this->levels as $level )
		{
			$lvl = $xml->addChild('level');
			$lvl->addAttribute('id', $level->id);
			$lvl->addChild('name', $level->name);
			$lvl->addChild('author', $level->author);
		}
		echo $xml->asXML();
	}
}

class LevelListItem
{
	public $id, $name, $author;
	
	function __construct( $id, $name, $author )
	{
		$this->id = $id;
		$this->name = $name;
		$this->author = $author;
	}
}

?>