#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../../lib";
use lib "$Bin/../../lib";

use Rpc::Web::Serializer;

use Test::More tests => 3;


my $s = new Rpc::Web::Serializer;


