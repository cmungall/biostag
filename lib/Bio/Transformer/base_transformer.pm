# $Id: base_transformer.pm,v 1.1 2004/07/02 22:12:44 cmungall Exp $
# POD documentation - main docs before the code

=head1 NAME

Bio::Transformer::base_transformer 

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

package Bio::Transformer::base_transformer;

use strict;
use vars qw(@ISA);
use FileHandle;
use Bio::Root::IO;
use Bio::Root::Root;
use Data::Stag::BaseHandler;

@ISA = qw(Data::Stag::BaseHandler Bio::Cabal::Root);


=head2 handler

  Usage   -
  Returns -
  Args    -

=cut

sub handler {
    my $self = shift;
    $self->{_handler} = shift if @_;
    return $self->{_handler};
}

sub printfunc {
    my $self = shift;
    my $H = $self->handler;
    return 
      sub {
	  $H->event(out => shift);
	  return;
      }
}

sub out {
    my $self = shift;
    my $fmt = shift;
    my $str = @_ ? sprintf($fmt, @_) : $fmt;
    my $H = $self->handler;
    $H->event(out=>$str);
    return;
}

sub printrow {
    my $self = shift;
    my @cols = @_;
    print join("\t", @cols), "\n";
}

1;
