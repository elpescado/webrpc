#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Server::FastCGI;
use base 'Rpc::Web::Server';

use AnyEvent;
use AnyEvent::FCGI;
use CGI::Stateless;


uObject::property 'port';


sub init {
	my $self = shift;

	my $fcgi = new AnyEvent::FCGI(
    	port => 8888,
	    on_request => sub {
			my $request = shift;
	
			$self->_handle ($request);
		},
	);
}


sub _handle {
	my $self = shift;
	my $request = shift;

	local *STDIN; open STDIN, '<', \$request->read_stdin;
	local %ENV = %{$request->params};
	local $CGI::Q = new CGI::Stateless;

	my $obj = CGI::param ("obj");
	my $class = CGI::param ("class");
	my $method = CGI::param ("method");
	my $args = CGI::param ("args");

	my $rv = undef;

	$request->respond (
		"",
		'X-JSON' => $rv,
	);
}


sub run {
	AnyEvent->loop;
}


sub quit {
}



