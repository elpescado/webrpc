#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../../lib";

package CtorTestObject;
use base 'uObject';


sub init {
	my $self = shift;
	my $arg = shift;

	$self->{INITIALIZED} = 1;
	$self->{ARG} = $arg;
}

package main;

use Test::More tests => 3;

my $o = new CtorTestObject (7);

isa_ok ($o, 'CtorTestObject',   'Object created');
ok ($o->{INITIALIZED},          'Constuctor was run');
is ($o->{ARG}, 7,               'Parameters passed to constructor');

