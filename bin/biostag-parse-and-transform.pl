#!/usr/local/bin/perl -w
use strict;

use Bio::Transformer;
use Bio::Parser;

use Getopt::Long;

my ($parser, $dest, $writer, $xml);
$writer = 'xml';
my $tfn;
my $unit;
my $noparse;

GetOptions("parser|p=s"=>\$parser,
           "dest|d=s"=>\$dest,
           "writer|w=s"=>\$writer,
	   "transformer|t=s"=>\$tfn,
	   "unit|u=s"=>\$unit,
           "xml|x"=>\$xml,
	   "noparse|np"=>\$noparse,
	  );

if ($tfn) {
    if ($tfn =~ /^(\w+)_to_(\w+)$/) {
	$parser = $1;
	$dest = $2;
    }
    else {
	die $tfn;
    }
}
else {
    $tfn = sprintf("%s_to_%s", $parser, $dest);
}
my $handler;
my $transformer = Bio::Transformer->new($tfn);
if ($unit) {
    my $outhandler = Data::Stag->getformathandler($writer || 'xml');
    $handler = Data::Stag->chainhandlers($unit,
					$transformer,
					$outhandler,
				       );
}
else {
    $handler = $transformer;
}
foreach my $f (@ARGV) {
    if ($noparse) {
	Data::Stag->parse(-file=>$f, -handler=>$handler);
    }
    else {
	my $parser;
	$parser = Bio::Parser->new($parser);
	$parser->handler($handler);
	$parser->parse($f);
    }
}

