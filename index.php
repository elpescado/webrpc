<?php

include ("class.calc.php");
include ("class.test.php");
include ("class.counter.php");
include ("class.functions.php");
include ("class.rectangle.php");
include ("class.file.php");
include ("webrpc.php");

$rpc = new WebRpcServer ();

$rpc->publish ('Calc');
$rpc->publish ('Functions');
$rpc->publish ('Counter', 'ref');
$rpc->publish ('Rectangle');
$rpc->publish ('Test');
$rpc->publish ('File');

$rpc->run ();

?>
