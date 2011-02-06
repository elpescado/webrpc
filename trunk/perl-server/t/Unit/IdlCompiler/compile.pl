#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../../lib";

use Rpc::Web::Meta::Interface;
use Rpc::Web::IdlCompiler;


my $basic_math = new Rpc::Web::Meta::Interface ("BasicMath");
$basic_math->add_method ("add", "x", "y");
$basic_math->add_method ("sub", "x", "y");
$basic_math->add_method ("square", "x");

my $compiler = new Rpc::Web::IdlCompiler ();
print $compiler->compile ($basic_math);
