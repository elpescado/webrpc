#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../../lib";
use lib "$Bin/../../lib";


use Rpc::Web::Meta::Interface;
use Rpc::Web::CallProxy;

use BasicMath;

use Test::More tests => 3;

my $basic_math = new Rpc::Web::Meta::Interface ("BasicMath");
my $add = $basic_math->add_method ("add", "x", "y");
my $square = $basic_math->add_method ("square", "x");

my $proxy = new Rpc::Web::CallProxy ();

is ($proxy->invoke ($basic_math, $add, undef, [1, 1]), 2, "1 + 1 = 2");
is ($proxy->invoke ($basic_math, $add, undef, [2, 3]), 5, "2 + 3 = 5");

is ($proxy->invoke ($basic_math, $square, undef, [4]), 16, "4 ^ 2 = 16");

