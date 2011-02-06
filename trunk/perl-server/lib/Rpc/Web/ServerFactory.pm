#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::ServerFactory;
use base 'uObject';

use Rpc::Web::Backend;
use Rpc::Web::CallProxy;
use Rpc::Web::IdlCompiler;
use Rpc::Web::Runtime;
use Rpc::Web::Serializer;
use Rpc::Web::Server::FastCGI;



sub create_instance {
	my $self = shift;
	my %p = @_;

	my $backend = new Rpc::Web::Backend ();
	my $call_proxy = new Rpc::Web::CallProxy ();
	my $idl_compiler = new Rpc::Web::IdlCompiler ();
	my $runtime = new Rpc::Web::Runtime ();
	my $serializer = new Rpc::Web::Serializer ();
	my $server = new Rpc::Web::Server::FastCGI ();

	$runtime->proxy ($call_proxy);
	$runtime->serializer ($serializer);
	$backend->runtime ($runtime);
	$backend->idl_compiler ($idl_compiler);
	$server->backend ($backend);

	return $server;
}

5;
