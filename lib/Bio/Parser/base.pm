# $Id: base.pm,v 1.1 2004/07/02 22:12:43 cmungall Exp $
# POD documentation - main docs before the code

=head1 NAME

Bio::Parser::base - 

=head1 SYNOPSIS


=head1 DESCRIPTION

=cut

package Bio::Parser::base;

use strict;
use vars qw(@ISA);
use FileHandle;
use base qw(Data::Stag::BaseGenerator);


sub fh {
    my $self = shift;
    $self->{_fh} = shift if @_;
    return $self->{_fh};
}

sub linebuffer {
    my $self = shift;
    $self->{_linebuffer} = shift if @_;
    return $self->{_linebuffer};
}

sub _readline {
    my $self = shift;
    my $lb = $self->linebuffer;
    if ($lb) {
	return pop @$lb
    }
    my $fh = $self->fh;
    my $line = <$fh>;
    return $line;
}

sub _pushback {
    my $self = shift;
    my $line = shift;
    push(@{$self->{_linebuffer}}, $line);
    return;
}

sub parse_fh {
    my $self = shift;
    my $fh = shift;
    $self->fh($fh);
    $self->pre_parse();
    while ($self->next_record) {
    }
    $self->post_parse();
}

sub pre_parse {
    my $self = shift;
    $self->start_event($self->record_tag);
}

sub post_parse {
    my $self = shift;
    $self->end_event($self->record_tag);
}

sub record_tag {
    return "record";
}


1;
