#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::IdlCompiler;
use base 'uObject';

use Rpc::Web::Meta::Interface;
use Rpc::Web::Meta::Method;

sub compile {
	my $self = shift;
	my $interface = shift;

	my $out = 'var RJS_HOME = "http://localhost/test.fcgi";';
	$out .= "\n\n";
	$out .= $self->get_common_js;
	my $jsclass = $interface->{NAME} || $interface->{EXPORT_AS};

	# Output class
	$out .= "function $jsclass ()\n";
	$out .= "{\n";
	$out .= "	this.__rjsClass = '$jsclass';\n";
	$out .= "}\n";
	$out .= "\n";


	# Output methods
	for my $method ($interface->methods) {
		my $method_name = $method->{NAME};
		my $args = join ",", @{$method->{ARGUMENTS}};

		$out .= "$jsclass.$method_name = function ($args)\n";
		$out .= "{\n";
		$out .= "	WebRpc.Object.__invoke ($jsclass, '$method_name', null, arguments);\n";
		$out .= "}\n";
		$out .= "\n";
	}

	return $out;
}


sub get_common_js {
	my $self = shift;

	open my $fh, '<', '../../webrpc.js' or die "File webrpc.js not found";
	
	my @lines = <$fh>;
	close $fh;

	return join '', @lines;
}


1;
