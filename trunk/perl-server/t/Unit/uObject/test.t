#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../../lib";

package TestObject;
use base 'uObject';

sub init {
	print "init";
}

uObject::property 'foo';
uObject::property 'bar';
