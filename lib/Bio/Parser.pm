# $Id: Parser.pm,v 1.1 2004/07/02 22:12:43 cmungall Exp $
#
#

=head1 NAME

  Bio::Parser     - parses all Bio files formats and types

=head1 SYNOPSIS

  use Bio::Parser;
  my $parser = new Bio::Parser({handler=>'dbloader'});
  $parser->parse("omim.TXT", "omim");

=cut

=head1 DESCRIPTION

Module for parsing flat files


=cut

package Bio::Parser;

use Exporter;
use Bio::Cabal::Root;
use Data::Stag;
@ISA = qw(Bio::Cabal::Root Exporter);

use Carp;
use FileHandle;
use strict qw(subs vars refs);

# Constructor


=head2 new

  Usage   - my $parser = Bio::Parser->new()
  Returns - Bio::Parser

creates a new parser

=cut

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my ($fmt, $handler) =
      $self->_rearrange([qw(format handler)], @_);
    if (!$fmt) {
	# this parser guesses/defers on what type it is parsing
	$fmt = "unknown_format";
    }
    my $p = $self->get_parser_impl($fmt);
    if (!$handler) {
        $handler = Data::Stag->makehandler;
    }
    $handler = Data::Stag->findhandler(-fmt=>$handler);
    $p->handler($handler);
    return $p;
}


sub get_parser_impl {
    my $self = shift;
    my $fmt = shift;
    my $mod;
    if ($fmt =~ /::/) {
	$mod = $fmt;
    }
    else {
	$mod = "Bio::Parser::$fmt";
    }
    $self->load_module($mod);
    my $p = $mod->new();
    return $p;
}


sub load_module {

    my $self = shift;
    my $classname = shift;
    my $mod = $classname;
    $mod =~ s/::/\//g;

    if ($main::{"_<$mod.pm"}) {
    }
    else {
	eval {
	    require "$mod.pm";
	};
        if ($@) {
            print $@;
	    $self->throw;
        }
    }
}

1;
