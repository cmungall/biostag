# $Id: Transformer.pm,v 1.1 2004/07/02 22:12:43 cmungall Exp $
#
#

=head1 NAME

  Bio::Transformer     - parses all Bio files formats and types

=head1 SYNOPSIS

  use Bio::Transformer;
  my $parser = new Bio::Transformer({handler=>'dbloader'})
  $parser->parse("omim.TXT", "omim");

=cut

=head1 DESCRIPTION

Module for parsing flat files


=cut

package Bio::Transformer;

use Exporter;
use Bio::Cabal::Root;
use Data::Stag;
@ISA = qw(Bio::Cabal::Root Exporter);

use Carp;
use FileHandle;
use strict;

=head2 new

  Usage   - my $transformer = Bio::Transformer->new()
  Returns - Bio::Transformer

creates a new transformer

=cut

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my ($fmt) =
      $self->_rearrange([qw(format)], @_);
    my $hclass = $fmt =~ /::/ ? $fmt : "Bio::Transformer::$fmt";
    $self->load_module($hclass);
    my $obj = $hclass->new;
    return $obj;
}



1;
