#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Runtime;
use base 'uObject';

uObject::property 'proxy';
uObject::property 'serializer';

sub init {
	my $self = shift;
	
	$self->{_INTERFACES} = {};
}

sub _interfaces {
	my $self = shift;
	return $self->{_INTERFACES};
}


sub invoke {
	my $self = shift;
	my %p = @_;

	my $obj = $p{obj};
	my $class_name = $p{class};
	my $method_name= $p{method};
	my $args = $p{args};

	my $interface = $self->lookup_interface ($class_name);
	my $method    = $self->lookup_method ($interface, $method_name);
	my $instance  = $self->serializer->unserialize ($obj);
	my $args_v    = $self->serializer->unserialize ($args);

	my $rv = $self->proxy->invoke ($interface,
	                               $method, 
								   $instance,
								   $args_v);
	return $self->serializer->serialize ($rv);								
}


sub lookup_interface {
	my $self = shift;
	my $interface_name = shift;

	return $self->{_INTERFACES}->{$interface_name};
}


sub add_interface {
	my $self      = shift;
	my $interface = shift;

	$self->{_INTERFACES}->{$interface->name} = $interface;
}


sub lookup_method {
	my $self        = shift;
	my $interface   = shift;
	my $method_name = shift;

	return $interface->get_method ($method_name);
}


4;
