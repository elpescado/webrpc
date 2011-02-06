#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Backend;
use base 'uObject';

uObject::property 'runtime';
uObject::property 'idl_compiler';


sub invoke {
	my $self = shift;
	my $runtime = $self->runtime;

	return $runtime->invoke (@_);
}

42;
