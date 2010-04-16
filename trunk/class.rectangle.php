<?php

class Rectangle
{
	public $w = 1;
	public $h = 1;
	
	public function area ()
	{
		return $this->w * $this->h;
	}
	
	public function __construct ($w, $h)
	{
		$this->w = $w;
		$this->h = $h;
	}
	
	
	public static function intersect ($r1, $r2)
	{
		$res = new Rectangle ();
		$res->w = min ($r1->w, $r2->w);
		$res->h = min ($r1->h, $r2->h);
		return $res;
	}
	
	public static function create ($w, $h)
	{
		return new Rectangle ($w, $h);
	}
}
