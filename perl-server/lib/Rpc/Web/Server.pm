#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Server;
use base 'uObject';


sub run {
}


sub quit {
}


sub runtime {
	my $self = shift;
	$self->{RUNTIME} = $_[0] if $_[0];
	return $self->{RUNTIME};
}
