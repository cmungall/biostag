# $Id: locuslink.pm,v 1.1 2004/07/02 22:12:44 cmungall Exp $
#
# BioPerl module for Bio::SeqIO::locuslink
#
# Cared for by Keith Ching <kching at gnf.org>
#
# Copyright Keith Ching
#
# You may distribute this module under the same terms as perl itself

#
# (c) Keith Ching, kching at gnf.org, 2002.
# (c) GNF, Genomics Institute of the Novartis Research Foundation, 2002.
#
# You may distribute this module under the same terms as perl itself.
# Refer to the Perl Artistic License (see the license accompanying this
# software package, or see http://www.perl.com/language/misc/Artistic.html)
# for the terms under which you may use, modify, and redistribute this module.
# 
# THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
# MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#

# POD documentation - main docs before the code

=head1 NAME

Bio::Parser::locuslink - 

=head1 SYNOPSIS


=head1 DESCRIPTION


=cut

package Bio::Parser::locuslink;

use strict;
use vars qw(@ISA);

use Bio::Parser;

use base qw(Bio::Parser::base);

sub _initialize {
    my($self,@args) = @_;
    $self->SUPER::_initialize(@args);  
}


sub transitions {
    return
      qw(
         NM                transcript
         NG                0
         CONTIG            0
         EVID              evidence
         ACCNUM            accession
         OFFICIAL_SYMBOL   0
         BUTTON            url
         DB_DESCR          dbxref
         /DB_LINK          dbxref
        );
}

sub compounds {
    return
      (
       STS => [qw(sts_acc chr_num unk symbol type src)],
       GO  => [qw(aspect term evcode go_acc src unk)],
       EXTANNOT  => [qw(aspect term evcode src unk)],
       CDD => [qw(domain domain_acc num unk score)],
       NG => [qw(acc u1 u2 u3 u4)],
       CONTIG => [qw(contig_acc u1 u2 u3 u4 strand chr_num src)],
       XM  => [qw(acc gi)],
       XP  => [qw(acc gi)],
       XG  => [qw(acc gi)],
       ACCNUM  => [qw(acc gi)],
       PROT  => [qw(acc gi)],
       MAP => [qw(map_loc link code)],
       SUMFUNC => [qw(descr src)],
       GRIF => [qw(grif_pmid descr)],
       COMP => [qw(comp_acc symbol2 chr_num2 map_pos2 locusacc2 chr_num1 symbol1 src)],
      );
}

sub record_tag {'locusset'}

sub next_record {
    my $self = shift;
    my (%record,@results,$search,$ref,$cddref);
    my ($PRESENT,@keep);

    # LOCUSLINK entries begin w/ >>
    local $/=">>";

    # slurp in a whole entry and return if no more entries
    return unless my $entry = $self->_readline;

    # if its the first entry you have to slurp it in again
    if ($entry eq '>>'){ #first entry
        return unless $entry = $self->_readline;
    }

    if (!($entry=~/LOCUSID/)){
        $self->throw("entry:$entry\nNo LOCUSID in first line of record. ".
                     "Not LocusLink in my book.");
    }

    my %transitions = $self->transitions;
    my %compounds = $self->compounds;
#    my %grouped = ();
#    foreach (keys %transitions) {
#        if (/\;/) {
#            my $t = $transitions{$_};
#            my (@keylist) = split(/\;/, $_);
#            foreach (@keylist) {
#                $transitions{$_} = $t;
#                $grouped{$_} = $t;
#            }
#        }
#    }

    $self->start_event('locus');
    my $level = 0;
    my @lines = split(/\n/, $entry);
    foreach (@lines) {
        if (/(\w+):\s*(.*)/) {
            my ($k, $v) = (uc($1), $2);
            my $transition = $transitions{$k};
            if (defined $transition) {
                if (!$transition) {
                    if ($level) {
                        #$self->throw("uh oh $_") unless $level;
                        $self->end_event($level);
                    }
                    $level = 0;
                }
                elsif ($transition eq $level) {
                    $self->end_event($level);
                    $self->start_event($level);
                }
                else {
                    if ($level) {
                        $self->end_event($level);
                        $level = 0;
                    }
                    $self->start_event($transition);
                    $level = $transition;
                }
            }
            # for grouped keys, every key must be part of
            # group to remain part of the same super-element
#            if ($level &&
#                $grouped{$level}) {



#                if (!$grouped{$k} ||
#                    $grouped{$k} ne $grouped{$level}) {
#                    $self->end_event($level);
#                    $level = 0;
#                }
#            }

            if ($compounds{$k}) {
                my (@vals) = split(/\|/, $v);
                my @pairs = ([defline=>$v]);
                foreach (@{$compounds{$k}}) {
                    my $v = shift @vals;
                    push(@pairs, [$_ => $v]) unless $v eq 'na';
                }
                $self->event(lc($k) => [@pairs]);
            }
            else {
                $self->event(lc($k), $v);
            }

            my $end = $transitions{'/'.$k};
            if ($end) {
                $self->end_event($end);
                $level = 0;
            }
        }
    }
    if ($level) {
        $self->end_event($level);
    }
    $self->end_event('locus');
    return 1;
}

1;
