#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Server::FastCGI;
use base 'Rpc::Web::Server';

use AnyEvent;
use AnyEvent::FCGI;
use CGI::Stateless;


uObject::property 'port';
uObject::property 'backend';

my $CONTENT = <<"EOF";
<html>
	<head>
		<title>Test form</title>
	</head>
	<body>
		<form method="post">
			<div>
				<label for="obj">Object</label>
				<input type="text" name="obj" id="obj" />
			</div>
			<div>
				<label for="class">Class</label>
				<input type="text" name="class" id="class" />
			</div>
			<div>
				<label for="method">Method</label>
				<input type="text" name="method" id="method" />
			</div>
			<div>
				<label for="args">Arguments</label>
				<input type="text" name="args" id="args" />
			</div>
			<input type="submit" value="Go!" />
		</form>
		<hr/>
		Result: <code>%s</code>
	</body>
</html>
EOF


sub init {
	my $self = shift;
	print "init()\n";

	my $fcgi = new AnyEvent::FCGI(
    	port => 8888,
	    on_request => sub {
			print STDERR "pn_request\n";
			my $request = shift;
	
			$self->_handle ($request);
		},
	);

	$self->{FCGI} = $fcgi;
}


sub _handle {
	my $self = shift;
	my $request = shift;

	local *STDIN; open STDIN, '<', \$request->read_stdin;
	local %ENV = %{$request->params};
	local $CGI::Q = new CGI::Stateless;

	if (CGI::url_param ("invoke")) {
		return $self->do_invoke ($request);
	} elsif (CGI::url_param ("js")) {
		return $self->do_js ($request);
	} elsif (CGI::url_param ("test")) {
		return $self->do_test ($request);
	} 

	$request->respond (
		sprintf ($CONTENT, ""),
		'X-JSON' => '',
	);
}


sub do_invoke {
	my $self = shift;
	my $request = shift;

	my $obj = CGI::param ("obj");
	my $class = CGI::param ("class");
	my $method = CGI::param ("method");
	my $args = CGI::param ("args");

	my $rv = "";
	if ($class) {

		$rv = $self->backend->invoke (
			'obj'    => $obj,
			'class'  => $class,
			'method' => $method,
			'args'   => $args,
		);
	}
	$request->respond (
		sprintf ($CONTENT, $rv),
		'X-JSON' => $rv,
	);
}


sub do_js {
	my $self = shift;
	my $request = shift;

	my $rv = $self->backend->generate_js_stubs ();

	$request->respond (
		$rv,
		"Content-Type", "application/javascript",
	);
}


sub do_test {
	my $self = shift;
	my $request = shift;

	my $rv = $self->backend->test_panel ();

	$request->respond (
		$rv,
		"Content-Type", "text/html",
	);
}


sub run {
	AnyEvent->loop;
}


sub quit {
}




