WebRpc = {};

WebRpc.Object = function ()
{
}

WebRpc.Object.prototype = {
}

WebRpc.Object.__invoke = function (class, name, obj, args)
{
	var args = Array.prototype.slice.call(args);
	var callback = args.pop ();
	if (obj != null) {
		obj = Object.toJSON (obj);
	} 
	new Ajax.Request (RJS_HOME+'?invoke', {
		method: 'post',
		parameters: {
			"obj": obj,
			"class": class.name,
			"method": name,
			"args": Object.toJSON (args)
		},

		onComplete: function (transport, json) {
			var response = {
				success: true,
				result: WebRpc.Object.unserialize (json)
			};
			/*
			if (transport.responseText)
				alert ("DEBUG:\n" + transport.responseText);
			*/
			callback.call (null, response);
		}
	});
}

WebRpc.Object.unserialize = function (data)
{
	if (data != undefined && data != null) {
		var to = typeof (data);
		if (to == 'object') {
			if (data instanceof Array) {
				/* Special case: array */
				str = "Array\n";
				for (var i = 0; i < data.length; i++) {
					data[i] = WebRpc.Object.unserialize (data[i]);
				}
			} else {
				/* Generic object */
				for (var i in data) {
					/* TODO: Handle object properties */
					//data[i] = WebRpc.Object.unserialize (data[i]);
				}
				if (data.__rjsClass != undefined) {
					data.__proto__ = eval(data.__rjsClass).prototype;
				}
			}
		}
	}
	return data;
}


/*
 * rjs base exception class
 */
WebRpc.Error = function (message)
{
	this.name = "WebRpc.Error";
	this.message = message;
}
WebRpc.Error.prototype.__proto__ = Error.prototype;


/*
 * rjs PHP exception
 */
WebRpc.PhpError = function ()
{
	this.__proto__.constructor ('abab');
	this.name = "WebRpc.PhpError";
}
WebRpc.PhpError.prototype.__proto__ = WebRpc.Error.prototype;



Ajax.Responders.register({
  onException: function (req, e) {
  	alert ("Exception "+e.name+" caught:\n"+e.message);
  }
});
