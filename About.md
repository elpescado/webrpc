# Introduction #

WebRpc is a simple inter-process communication framework to communicate between server and web browser client. It allows PHP methods on server to be called directly from JavaScript running in browser.


# Example #

Say you have got a Rectangle class written in PHP, representing a rectangle. It's a simple class, consisting of two properties (width and height), one instance method and one static method.

```
class Rectangle
{
	public $w = 1;
	public $h = 1;
	
	
	public function __construct ($w, $h)
	{
		$this->w = $w;
		$this->h = $h;
	}
	
	
	public function area ()
	{
		return $this->w * $this->h;
	}


	public static function intersect ($r1, $r2)
	{
		$res = new Rectangle ();
		$res->w = min ($r1->w, $r2->w);
		$res->h = min ($r1->h, $r2->h);
		return $res;
	}
}
```

Using a little bit of WebRpc glue code:

```
$rpc = new WebRpcServer ();
$rpc->publish ('Rectangle');
$rpc->run ();
```

Rectangle class can be used as ordinary JavaScript Class:

```
var r = new Rectangle ();
r.w = 7;
r.h = 8;
r.area (function (response) {
		alert (response.result);
});
```

Note that, as remote method invocations are done asynchronously, return value cannot be passed as method return value. Instead, callback function is passed as last method argument. Callback function takes one argument, response. Return value is stored in response.result property.


```
Rectangle.prototype.init = function (w, h)
{
	this.w = w;
	this.h = h;
}


var r1 = new Rectangle (2, 7);
var r2 = new Rectangle (7, 3);
Rectangle.intersect (r1, r2, function (response) {
		var intersect = response.result;
		alert (intersect.w + " x " + intersect.h);
});

```

Example above shows how can you declare your own constructors and how to call static methods. As you can see, not only primitive types but also objects can be passed both as arguments and return values.