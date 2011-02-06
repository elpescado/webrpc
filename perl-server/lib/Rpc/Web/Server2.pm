#!/usr/bin/perl

use strict;
use warnings;


package Rcp::Web::Server;


# Constructor
sub new {
	my $type = shift;
	my $self = {
		CLASSES => {}
	};

	bless ($self, $type);
	return $self;
}


sub publish {
	my $self = shift;
	my $class = shift;

	push @{ $self->{CLASSES} }, $class;	
}


sub run {
	my $self = shift;
}


sub invoke {
	my $self = shift;
}


sub export {
	my $self = shift;
}


3.14;
