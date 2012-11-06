package Music::Duration;
BEGIN {
  $Music::Duration::AUTHORITY = 'cpan:GENE';
}
# ABSTRACT: Musical Timing Metrics

our $VERSION = '0.01';
use strict;
use warnings;

use MIDI::Simple;


{
    # Calculate named note durations. 
    my @durations = qw(w h q e s y x);

    # Set the initial duration.
    my $last = 'w';

    # Compute the durations for each note.
    for my $duration (@durations) {
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

1;

__END__

=pod

=head1 NAME

Music::Duration - Musical Timing Metrics

=head1 VERSION

version 0.01

=head1 SYNOPSIS

  perl -MMIDI::Simple -MData::Dumper -e'print Dumper \%MIDI::Simple::Length'

  perl -MMusic::Duration -MData::Dumper -e'print Dumper \%MIDI::Simple::Length'

=head1 DESCRIPTION

This module adds C<thirtysecond> (y) and C<sixtyfourth> (x) note divisions to
L<MIDI>, and corrects the
L<'dden' duration bug|https://rt.cpan.org/Public/Bug/Display.html?id=60658>.

=head1 NAME

Music::Duration - Musical Timing Metrics

=head1 TO DO

Decouple from L<MIDI> and provide a subroutine of lengths.

Allow addition of any literal or coderef entry to the C<Length> hash.

Only require L<MIDI::Simple> and set the C<Length> hash if present.

=head1 SEE ALSO

L<MIDI> and L<MIDI::Simple>

The code in the C<t/> directory

=head1 AUTHOR

Gene Boggs E<lt>gene@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2012, Gene Boggs

=head1 LICENSE

This program is free software; you can redistribute or modify it under the same terms as Perl itself.

=head1 AUTHOR

Gene Boggs <gene@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gene Boggs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
