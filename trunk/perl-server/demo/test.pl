#!/usr/bin/perl

use strict;
use warnings;

package Foobar;

sub test {
	my $arg = shift;
	print STDERR "dupa ($arg)\n";
	return "test, $arg";
}

package main;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use Rpc::Web::ServerFactory;
use Rpc::Web::Meta::Interface;
use Rpc::Web::Meta::Method;

use Data::Dumper;


my $f = new Rpc::Web::ServerFactory;
my $server = $f->create_instance ();

my $foobar_iface = new Rpc::Web::Meta::Interface ("Foobar");
my $dupa = $foobar_iface->add_method ("dupa", "arg");

$server->backend->runtime->add_interface ($foobar_iface);

$server->run ();

