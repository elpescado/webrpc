#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Serializer;
use base 'uObject';

use JSON::XS;

sub init {
	my $self = shift;

	$self->{JSON} = JSON::XS->new->utf8->allow_nonref;
}


sub _json {
	return shift->{JSON};
}


# Serialize an object
sub serialize {
	my $self = shift;
	my $obj  = shift;

	return $self->_json->encode ($obj);
}

# Unserialize object
sub unserialize {
	my $self = shift;
	my $json = shift;

	return $self->_json->decode ($json);
}

uObject::property "foo";


1;
