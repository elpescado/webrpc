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

	my $id = 1;

	my $out = '<h1>Test Panel</h1>';

	for my $interface ( @{$interfaces} ) {
		$out .= sprintf ('<h2>%s</h2>', $interface->name);
		
		for my $method ($interface->methods) {
			$out .= sprintf ('<h3>%s</h3>', $method->name);
			$out .= sprintf ('<form id="el%d" onsubmit="return false;">', $id++);

			my @args;

			foreach my $arg ($method->arguments) {
				my $argid = $id++;
				$out .= sprintf ('<div><label for="el%d">%s</label><input id="el%d" type="text"></div>',
						$argid, $arg, $argid);

				push @args, sprintf (q/$('el%d').value/, $argid);
			}

			my $function = sprintf ('%s.%s (%s, function (r) { alert (Object.toJSON(r.result)); }); return false',
					$interface->name, $method->name, join (',', @args));
			$out .= sprintf ('<button onclick="%s">Call!</button>', $function);

			$out .= '</form>';
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
