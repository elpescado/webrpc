#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Runtime;
use base 'uObject';

sub init {
	my $self = shift;

	$self->{
}

sub invoke {
	my $self = shift;
	my %p = @_;

	my $obj = $p{obj};
	my $class_name = $p{class};
	my $method_name= $p{method};
	my $args = $p{args};
}

4;
