# $Id: unknown_format.pm,v 1.1 2004/07/02 22:12:44 cmungall Exp $
#
# You may distribute this module under the same terms as perl itself

package Bio::Parser::unknown_format;

=head1 NAME

  Bio::Parser::unknown_format_parser     - base class for parsers

=head1 SYNOPSIS

  do not use this class directly; use Bio::Parser

=cut

=head1 DESCRIPTION

=head1 AUTHOR

=cut

use Carp;
use FileHandle;
use base qw(Bio::Parser::BaseParser Exporter);
use strict qw(subs vars refs);

sub parse_file_by_type {
    shift->parse_file(@_);
}

sub parse {
    my ($self, $file) = @_;
    my $fmt;   # input file format
    my $p;
    if ($file =~ /\.(\w+)$/) {
	$fmt = $1;
	my $mfmt = $self->fmt_mapping->{$fmt};
	$fmt = $mfmt if $mfmt;
	$p = Bio::Parser->get_parser_impl($fmt);
	%$p = %$self;
	$p->parse($file);
	%$self = %$p;
	return;
    }
    else {
	$self->throw("cannot guess parser for file $file");
    }
}

=head2 fmt_mapping

 Title   : fmt_mapping
 Usage   : $obj->fmt_mapping({gb => 'genbank', fst => 'fasta'})
 Function: 
 Example : 
 Returns : value of fmt_mapping (a hashref)
 Args    : on set, new value (a hashref or undef, optional)


=cut

sub fmt_mapping{
    my $self = shift;

    return $self->{'fmt_mapping'} = shift if @_;
    return $self->{'fmt_mapping'} || 
      {
       gb => 'genbank',
       fst => 'fasta',
       fa => 'fasta',
       ll => 'locuslink',
       master => 'starcode',
      };
}



1;
