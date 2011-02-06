#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../../lib";

package PropertiesTestObject;
use base 'uObject';


uObject::property 'foo';
uObject::property 'bar';


package main;

use Test::More tests => 9;

my $o = new PropertiesTestObject;

isa_ok ($o, 'PropertiesTestObject', 'Object created');

ok ($o->can('foo'), '"foo" property defined');
is ($o->foo (42), 42, "Setter returns value");
is ($o->{_FOO},   42, "Setter works");
is ($o->foo,      42, "Getter works");
is ($o->{_FOO},   42, "Getter does not change property value");

# unsetting property
is ($o->foo (undef), undef, "Unsetting value");
is ($o->{_FOO},      undef, "Setter can set value to undef");
is ($o->foo,         undef, "Getter works");

