package Music::Duration;
BEGIN {
  $Music::Duration::AUTHORITY = 'cpan:GENE';
}
# ABSTRACT: Add useful note lengths to MIDI-Perl

our $VERSION = '0.03';
use strict;
use warnings;

use MIDI::Simple;


{
    # Set the initial duration to one below 32nd,
    my $last = 's'; # ..which is a sixteenth.

    # Add 32nd and 64th as y and x.
    for my $duration (qw( y x )) {
        # Create a MIDI::Simple format note identifier.
        my $n = $duration . 'n';

        # Compute the note duration.
        $MIDI::Simple::Length{$n} = $duration eq $last
            ? 4 : $MIDI::Simple::Length{$last . 'n'} / 2;
        # Compute the dotted duration.
        $MIDI::Simple::Length{'d'  . $n} = $MIDI::Simple::Length{$n}
            + $MIDI::Simple::Length{$n} / 2;
        # Compute the double-dotted duration.
        $MIDI::Simple::Length{'dd' . $n} = $MIDI::Simple::Length{'d' . $n}
            + $MIDI::Simple::Length{$n} / 4;
        # Compute triplet duration.
        $MIDI::Simple::Length{'t'  . $n} = $MIDI::Simple::Length{$n} / 3 * 2;

        # Increment the last duration seen.
        $last = $duration;
    }
}


sub fractional {
    # Get the new name and the division factor.
    my ($name, $factor) = @_;

    # Add a named factor for each note value.
    for my $n (keys %MIDI::Simple::Length) {
        next if length $n > 2;
        $MIDI::Simple::Length{$name . $n} = $MIDI::Simple::Length{$n} / $factor;
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Music::Duration - Add useful note lengths to MIDI-Perl

=head1 VERSION

version 0.03

=head1 SYNOPSIS

  # Compare:
  > perl -MMIDI::Simple -MData::Dumper -e'print Dumper \%MIDI::Simple::Length'
  > perl -MMusic::Duration -MData::Dumper -e'print Dumper \%MIDI::Simple::Length'

  # In a program:
  use MIDI::Simple;
  use Music::Duration;
  Music::Duration::fractional('z', 5);
  new_score();
  patch_change(1, 33);          # Jazz kit
  n('zsn', 'n38') for 1 .. 5;   # Snare sixteenth quintuplet
  n('qn', 'n38');

=head1 DESCRIPTION

This module adds thirtysecond and sixtyfourth note divisions to L<MIDI::Simple>.
These are 32nd: y, dy, ddy, ty and 64th: x, dx, ddx, tx.

=head1 NAME

Music::Duration - Add useful note lengths to MIDI-Perl

=head1 FUNCTIONS

=head2 fractional()

  $z = Music::Duration::fractional('z', 5)

Add a fractional duration-division for each note, to the L<MIDI::Simple>
C<Length> hash.

In the example above, we add z-notes, or 5th quarter note divisions

=head1 TO DO

Decouple from L<MIDI> and provide a subroutine of lengths.

Allow addition of any literal or coderef entry to the C<Length> hash.

Only require L<MIDI::Simple> and set the C<Length> hash if present.

=head1 SEE ALSO

L<MIDI> and L<MIDI::Simple>

The code in the C<t/> directory

=head1 AUTHOR

Gene Boggs <gene@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Gene Boggs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
