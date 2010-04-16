<?php

class Functions
{
	static function sayHello ($name)
	{
		return "Hello, $name!";
	}

	static function getDate ()
	{
		return date ("r");
	}

	static function range ($from, $to)
	{
		for ($i = $from; $i <= $to; $i++)
			$numbers[] = $i;
		return $numbers;
	}
	
	static function getStore ()
	{
		session_start ();
		return $_SESSION['rjs'];
	}
	static function printStore ()
	{
		session_start ();
		return print_r ($_SESSION['rjs']);
	}
}
