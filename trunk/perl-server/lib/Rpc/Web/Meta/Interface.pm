#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Meta::Interface;
use base 'uObject';

sub init {
	my $self = shift;
	my $name = shift;

	$self->{NAME} = $name;
	$self->{EXPORT_AS} = undef;
	$self->{METHODS} = [];
}


sub name {
	return shift->{NAME};
}


sub methods {
	my $self = shift;

	return wantarray
		? @{ $self->{METHODS} }
		: $self->{METHODS};
}


sub add_method {
	my $self = shift;
	my $name = shift;
	
	my $method = new Rpc::Web::Meta::Method ($name, @_);
	push @{ $self->{METHODS} }, $method;

	return $method;
}


sub get_method {
	my $self = shift;
	my $name = shift;

	for my $m ( @{$self->{METHODS}} ) {
		if ($m->name eq $name) {
			return $m;
		}
	}

	return;
}


1;
