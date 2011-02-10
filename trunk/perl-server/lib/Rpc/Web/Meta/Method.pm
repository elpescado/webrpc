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


sub arguments {
	my $self = shift;
	return wantarray
		? @{$self->{ARGUMENTS}}
		:   $self->{ARGUMNETS};
}


sub name {
	return shift->{NAME};
}

1;
