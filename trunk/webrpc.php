<?php


/**
 * Exported class information
 **/
class WebRpcClassInfo
{
	public $class;
	public $options;
	
	public function __construct ($class, $options = null)
	{
		$this->class = $class;
		$this->options = $options;
	}
	
	public function isReference ()
	{
		return $this->options == 'ref';
	}
}


/**
 * Main WebRpc object
 **/
class WebRpcServer
{
	/** Class information */
	private $classes = array ();

	/** Persistent data storage */
	private $store;
	
	/**
	 * Constructor
	 **/
	public function __construct ()
	{
		$this->here = $_SERVER['PHP_SELF'];
		$this->store = new WebRpcStore ($this);
	}
	
	
	/**
	 * Publish a class so that its methods can be accessed
	 **/
	public function publish ($class, $options=null)
	{
		$this->classes[] = new WebRpcClassInfo ($class, $options);
	}
	
	
	/**
	 * Run server
	 **/
	public function run ()
	{
		if (isset ($_GET['js'])) {
			header ("Content-Type: application/x-javascript");
			echo "RJS_HOME = '{$this->here}';\n\n";

			foreach ($this->classes as $item)
				$this->export ($item);
		} else if (isset ($_GET['invoke'])) {
			$this->invoke ();
		} else if (isset ($_GET['test'])) {
			$this->htmlBegin ("test panel");
			$this->testPanel ();
			$this->htmlEnd ();
		}
	}
	
	
	/**
	 * Process request and invoke method
	 **/
	private function invoke ()
	{
		/* Get parameters */
		$obj = $_POST ['obj'];
		$className = $_POST ['class'];
		$methodName = $_POST ['method'];
		$args = $_POST ['args'];
		if (get_magic_quotes_gpc ()) {
			$obj = stripslashes ($obj);
			$args = stripslashes ($args);
		}

		/* Unserialize object and arguments */
		$obj = $this->rjsUnserialize ($obj);
		$args = $this->rjsUnserialize ($args);

		/* Invoke method */
		$class = new ReflectionClass ($className);
		$method = $class->getMethod ($methodName);
		$response = $method->invokeArgs ($obj, $args);

		/* Send response */
		$responseText = $this->rjsSerialize ($response);
		header ("X-JSON: ".$responseText);
		//echo $responseText;
		exit ();
	}
	
	
	/**
	 * Unserialize object
	 **/
	private function rjsUnserialize ($data_str)
	{
		$data = json_decode ($data_str);
		$data = $this->__unserialize ($data);		
		return $data;
	}
	
	private function __unserialize (&$obj)
	{
		if (is_array ($obj)) {
			
			foreach ($obj as $k=>$v) {
				$obj[$k] = $this->__unserialize ($v);
			}
			return $obj;
			
		} else if (is_object ($obj)) {
			
			if (isset ($obj->__rjsClass)) {
				$className = $obj->__rjsClass;
				$info = $this->getClassInfo ($className);
				if ($info->isReference ()) {
					$ref = $obj->__rjsRef;
					$obj = $this->store->retrieve ($ref);
				} else {
					$class = new ReflectionClass ($className);
					$uobj = $class->newInstance ();
					$properties = $class->getProperties ();
					foreach ($properties as $prop) {
						if ($prop->isPublic ()) {
							$pname = $prop->getName ();
							if (isset ($obj->$pname)) {
								$prop->setValue ($uobj, $this->__unserialize ($obj->$pname));
							}
						}
					}
					$obj = $uobj;
				}
			}
			return $obj;				
			
		} else {
			return $obj;
		}		
	}
	
	
	private function __serialize (&$data)
	{
		if (is_array ($data)) {
			
			foreach ($data as $k=>$v) {
				$obj[$k] = $this->__serialize ($v);
			}
			return $data;
			
		} else if (is_object ($data)) {
			
			$class = new ReflectionClass ($data);
			$info = $this->getClassInfo ($class->getName ());
			if ($info == null) {
				echo "Class ".$class->getName ()." not found\n";
				return $data;
			}
			
			if ($info->isReference ()) {
				$id = $this->store->store ($data);
				$data = new WebRpcReference ($class->getName (), $id);
			} else {
				//$data->__rjsClass = get_class ($class->getName ());
				$data->__rjsClass = $class->getName ();

				/*
				$properties = $class->getProperties ();
				$vars = get_class_vars ($class->getName ());
				foreach ($properties as $prop) {
					$name = $prop->getName ();
					$data->$name = 
				}
				*/
			}
			return $data;
			
		}
		return $data;
	}
	
	
	/**
	 * Serialize object
	 **/
	private function rjsSerialize (&$data)
	{
		$data = $this->__serialize ($data);
		return json_encode ($data);
	}
	

	/**
	 * Get class info for object
	 **/
	private function getClassInfo ($className)
	{
		foreach ($this->classes as $item) {
			if ($item->class == $className)
				return $item;
		}
		return null;
	}
	
	
	/**
	 * Export JavaScript stub
	 **/
	private function export ($classInfo)
	{
		$class = new ReflectionClass ($classInfo->class);
		$jsclass = $class->getName ();
		global $tests;

		/* Echo object constructor */		
		echo "function $jsclass ()\n";
		echo "{\n";
		echo "	this.__rjsClass = '$jsclass';\n";
		echo "	if (typeof (this.__proto__.init) == 'function') {\n";
		echo "		this.__proto__.init.apply (this, arguments);\n";
		echo "	}\n";
//		echo "	alert ('instantiate new $jsclass');\n";
		echo "}\n\n";
		
		/* Echo object prototype */
		echo "$jsclass.prototype = {\n";
		$properties = $class->getProperties ();
		$vars = get_class_vars ($class->getName ());
		foreach ($properties as $prop) {
			$name = $prop->getName ();
			echo "	$name: ", (isset($vars[$name])) ? json_encode ($vars[$name]) : "null", ",\n";
		}
		echo "}\n";
		
		/* Echo class constants */
		/*
		$constants = $class->getConstants ();
		foreach ($constants as $const=>$val) {
			echo "const $jsclass.$const = ", json_encode ($val), ";\n";
		}
		echo "\n";
		*/

		/* Echo class methods */
		$methods = $class->getMethods ();
		foreach ($methods as $method) {
			if ($method->isConstructor () || $method->isDestructor ())
				continue;

			$jsmethod = $method->getName ();
			if ($method->isPublic ()) {
				echo $jsclass, $method->isStatic () ? "." : ".prototype.";
				echo $method->getName (), " = function (";
				$parameters = $method->getParameters ();
				foreach ($parameters as $param) {
					echo $param->getName ();
					echo ", ";
				}
				$obj = $method->isStatic () ? 'null' : 'this';
				echo "response)\n";
				echo "{\n";
				echo "	WebRpc.Object.__invoke ($jsclass, '", $method->getName (), "', $obj, arguments);\n";
				echo "}\n";
				echo "\n";
			}
		}
	}
	
	
	/**
	 * Run test panel
	 **/
	private function testPanel ()
	{
		echo "<h1>Tests</h1>";
		foreach ($this->classes as $item) {
			$class = new ReflectionClass ($item->class);
			echo "<h2>", $class->getName (), "</h2>";
			echo '<table>';

			$methods = $class->getMethods ();
			$formid = 1;
			foreach ($methods as $method) {
				if (! $method->isStatic ())
					continue;

				echo '<tr>';
				echo '<th>', $method->getName (), ':</th>';
				echo "</tr>\n";
				echo '<tr class="test"><td>';
				printf ('<form id="form%d" onsubmit="return false">', $formid);
				$parameters = $method->getParameters ();
				$args = array ();
				foreach ($parameters as $param) {
					echo $param->getName (), ": ";
					$inputid = sprintf ('form%d_%s', $formid, $param->getName ());
					printf ('<input type="text" id="%s" size="4" />',
							$inputid);
					echo "\n&nbsp;\n";
					$args[] = sprintf ("$('%s').value", $inputid);
				}
				if (empty ($parameters))
					echo '<em>No arguments</em>';
				printf ('</form>');
				echo '</td><td>';
				
				$testname = sprintf ('test_%s_%s', $class->getName (), $method->getName ());
				printf ('<button onclick="%s (); ">Test!</button>',
						$testname);

				echo '</td></tr>';

				echo '<script>';
				printf ("function %s ()\n", $testname);
				echo "{\n";
				printf ("	%s.%s (%s%sfunction (response) {\n",
						$class->getName (), $method->getName (),
						implode (', ', $args), empty($args)?"":", ");
				echo "		alert ('Response:\\n'+response.result);";
				echo "	});\n";
				echo "}\n";
				echo '</script>';

				$formid++;
			}
			echo '</table>';
			echo "<hr/>";
		}
	}
	
	private function htmlBegin ($title=null)
	{
		echo '<?xml version="1.0" encoding="utf-8"?>';
		echo "\n";
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<title>WebRpc<?php if ($title != null) echo " :: $title"; ?></title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<script src="prototype.js"></script>
		<script src="webrpc.js"></script>
		<script src="<?php echo $this->here; ?>?js"></script>
		<style>
		body {
			font-size: 8pt;
		}
		table {
			border-collapse: collapse;
		}
		th {
			text-align: left;
		}
		tr.test td {
			background-color: #eee;
			border-bottom: 1px solid #ccc;
			padding: 4px;
		}
		</style>
	</head>

	<body>
	<?php	
	}
	
	private function htmlEnd ()
	{ ?>
	</body>
</html>
	<?php
	}		
}


class WebRpcStore 
{
	/** Parent rjs object */
	private $rjs;
	private $id = 1;
	
	public function __construct ($rjs)
	{
		$this->rjs = $rjs;
		session_start ();
	}
	
	
	public function store ($obj)
	{
		if (isset ($obj->__rjsRef)) {
			$id = $obj->__rjsRef;
		} else {
			$id = $this->getId ();
			$obj->__rjsRef = $id;
		}
			
		$_SESSION['rjs'][$id] = $obj;
		
		return $id;
	}
	
	
	public function retrieve ($key)
	{
		return $_SESSION['rjs'][$key];
	}
	
	
	private function getId ()
	{
		return sha1 (sprintf ("rjs_ref%d-%s", $id++, microtime ()));
	}
}


/**
 * WebRpc reference class
 **/
class WebRpcReference
{
	public $__rjsClass;
	public $__rjsRef;
	
	public function __construct ($class, $ref)
	{
		$this->__rjsClass = $class;
		$this->__rjsRef = $ref;
	}
}
