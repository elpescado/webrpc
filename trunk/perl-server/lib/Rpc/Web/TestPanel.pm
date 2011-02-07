#!/usr/bin/perl

use strict;
use warnings;

package Rpc::Web::TestPanel;
use base 'uObject';

use Rpc::Web::Meta::Interface;
use Rpc::Web::Meta::Method;



sub render {	
	my $self = shift;
	my $interfaces = shift;

	my $out = '<h1>Test Panel</h1>';

	for my $interface ( @{$interfaces} ) {
		$out .= sprintf ('<h2>%s</h2>', $interface->name);
		
		for my $method ($interface->methods) {
			$out .= sprintf ('<h3>%s</h3>', $method->{NAME});
		}
	}

	return $self->template ('Test pane', $out);
}


sub template {
	my $self = shift;
	my $title = shift;
	my $content = shift;
	return <<"EOF";
<html>
	<head>
		<title>$title</title>
		<script src="https://ajax.googleapis.com/ajax/libs/prototype/1.7.0.0/prototype.js"></script>
		<script src="http://localhost/test.fcgi?js=1"></script>
	</head>
	<body>
		$content
	</body>
</html>
EOF
}


66;
