#!/usr/local/bin/perl -w

use strict;
use Bio::Parser;
use Getopt::Long;

my ($parser,$type, $writer);

GetOptions(
           "parser|p=s"=>\$parser,
           "writer|w=s"=>\$writer,
          );

#$parser->handler('sxpr');
foreach my $f (@ARGV) {
    my $parser = Bio::Parser->new($parser, $writer || 'xml');
    $parser->parse($f);
    if ($xml) {
        print $parser->handler->tree->xml;
    }
}

