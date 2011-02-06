#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::CallProxy;
use base 'uObject';

use Rpc::Web::Meta::Interface;
use Rpc::Web::Meta::Method;

sub invoke {
	my $self      = shift;
	my $interface = shift;
	my $method    = shift;
	my $object    = shift;
	my $args      = shift;

	my $ref = \&{ $interface->{NAME} . "::" . $method->{NAME} };
	my $rv;
	
	if (defined $object) {
	} else {
		$rv = $ref->( @$args );
	}

	return $rv;
}

1;
