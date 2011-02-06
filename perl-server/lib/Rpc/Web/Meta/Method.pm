#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Meta::Method;
use base 'uObject';

sub init {
	my $self = shift;
	my $name = shift;

	$self->{NAME} = $name;
	$self->{ARGUMENTS} = [@_];
}

sub static {
	my $self = shift;
	return 1;
}

1;
