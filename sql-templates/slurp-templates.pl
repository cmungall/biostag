#!/bin/perl

use strict;

print STDERR "Administrator use only!\n\n";


my %sources = (
               chado   => "~/chado/stag-templates",
               go      => "~/cvs/go-dev/sql/stag-templates",
               ensembl => "~/chai/sql-templates",
               biosql  => "~/chai/sql-templates",
              );

print "Retrieving templates from source directories...\n";
foreach my $schema (keys %sources) {
    print "  retrieving $schema templates\n";
    mkdir $schema unless -d $schema;
    my $sdir = $sources{$schema};
    system("cp $sdir/$schema-*.stg $schema/") && print STDERR "problem with $schema";
}
print STDERR "Done!\n";
