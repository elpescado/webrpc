#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::Backend;
use base 'uObject';

uObject::property 'runtime';
uObject::property 'idl_compiler';

use Rpc::Web::TestPanel;

sub invoke {
	my $self = shift;
	my $runtime = $self->runtime;

	return $runtime->invoke (@_);
}


sub generate_js_stubs {
	my $self = shift;

	my $js = "";

	for my $interface ( values %{$self->runtime->_interfaces} ) {

		$js .= $self->idl_compiler->compile ($interface);
	}

	return $js;
}


sub test_panel {
	my $self = shift;

	my $panel = new Rpc::Web::TestPanel;

	return $panel->render ( [values %{$self->runtime->_interfaces}] );
}


42;
