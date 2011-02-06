#!/usr/bin/perl

use strict;
use warnings;

package BasicMath;

sub add {
	my $x = shift;
	my $y = shift;
	return $x + $y;
}

sub square {
	my $x = shift;
	return $x * $x;
}

777;
