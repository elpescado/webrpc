#!/usr/bin/perl

use strict;
use warnings;

package uObject;

sub new {
	my $class = shift;
	my $self = {};

	bless $self, $class;
	$self->init (@_) if $self->can ('init');

	return $self;
}


sub property {
	my $name = shift;
	my $value = shift;

	my ($package, $filename, $line) = caller;

	my $fqn = $package . '::' . $name;
	my $pn = '_' . uc($name);

	no strict 'refs';
	*$fqn = sub {
		my $self = shift;
		if (scalar @_) {
			$self->{$pn} = shift;
		}
		return $self->{$pn};
	}
}


1;
