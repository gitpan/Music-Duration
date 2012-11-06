#!perl -T
use strict;
use warnings;
use Test::More;

require_ok('MIDI::Simple');
ok %MIDI::Simple::Length, 'MIDI::Simple::Length exists';
is $MIDI::Simple::Length{dden}, '0.75', 'MIDI::Simple::Length dden typo';

require_ok('Music::Duration');
is $MIDI::Simple::Length{dden}, '0.875', 'dden fixed';
is $MIDI::Simple::Length{yn}, '0.125', 'yn added';
is $MIDI::Simple::Length{xn}, '0.0625', 'xn added';

done_testing();

