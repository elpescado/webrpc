#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../../lib";
use lib "$Bin/../../lib";

use Rpc::Web::Serializer;

use Test::More tests => 7;


my $s = new Rpc::Web::Serializer;


sub f {
	return $s->serialize (@_);
}

# Simple scalar
diag ("Scalars");
is (f (undef),    "null",     "undef=>null");
is (f (5),        "5",        "Digit");
is (f (42),       "42",       "Number");
is (f ("String"), '"String"', "String");

# Arrays
diag ("Arrayrefs");
is (f ([1,2,3]), "[1,2,3]",  "Array of numbers");
is (f ([0]),     "[0]",      "Array of one number");

# Hashes
diag ("Hashrefs");
is (f ({a=>'b', c=>'d'}), '{"c":"d","a":"b"}', "Hash");
