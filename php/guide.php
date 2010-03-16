<?php
require_once '../wombat.php';
WombatHead('RWK:AE - Robot Ability Guide');
?>
<h1>Robot Ability Guide</h1>
<?php include('linkbar.php'); ?>

<p>Robot can jump 2 and a half tiles upwards. This means he'll die on ouch blocks 3 tiles above him!<br />
<img src="guide_jump.png" alt="Jumping diagram" /></p>

<p>Robot can double-jump a maximum of 5 and a half tiles upwards. This means he might die on ouch blocks 6 tiles above him if he isn't careful!<br />
<img src="guide_djump.png" alt="Double-jump diagram" /></p>

<p>With careful double-jumping, Robot can navigate a tunnel like this one:<br />
<img src="guide_tunnel.png" alt="Navigating a tunnel diagram" /></p>

<p>Robot can rocket just about infinitely upwards... for now anyways! Just don't make it really extreme - 20 tiles is probably a good limit.<br />
<img src="guide_riser.png" alt="Rocket riser diagram" /></p>

<p>When Robot uses a teleporter, he goes to the nearest one of the same color, by actual distance.
If you can't tell by looking at your map which one he'll go to, you probably want to do some moving around of teleporters.<br />
</p>

<?php WombatFoot(); ?>