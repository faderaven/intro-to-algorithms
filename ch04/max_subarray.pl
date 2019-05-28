
use strict;
use warnings;

sub findCrossingMax($$$$) {
    my ($v, $low, $mid, $high) = @_;

    my %max = (begin => $mid,
               end => $mid + 1,
               sum => 0);
    my $sum_low = $v->[$mid];
    my $sum_high = $v->[$mid+1];

    for (my $i = $mid, my $sum = 0; $i >= $low; --$i) {
        $sum = $sum + $v->[$i];
        if ($sum > $sum_low) {
            $sum_low = $sum;
            $max{begin} = $i;
        }
    }

    for (my $j = $mid+1, my $sum = 0; $j <= $high; ++$j) {
        $sum = $sum + $v->[$j];
        if ($sum > $sum_high) {
            $sum_high = $sum;
            $max{end} = $j;
        }
    }

    $max{sum} = $sum_low + $sum_high;
    return %max;
}

sub findMax($$$) {
    my ($v, $low, $high) = @_;

    if ($low == $high) {
        my %one = (begin => $low, end => $high, sum => $v->[$low]);
        return %one;
    }

    my $mid = int(($low + $high) / 2);
    my %max_low = findMax($v, $low, $mid);
    my %max_high = findMax($v, $mid + 1, $high);
    my %max_cross = findCrossingMax($v, $low, $mid, $high);

    if ($max_low{sum} >= $max_high{sum} and
        $max_low{sum} >= $max_cross{sum}) {
        return %max_low;
    } elsif ($max_high{sum} >= $max_low{sum} and
             $max_high{sum} >= $max_cross{sum}) {
        return %max_high;
    } else {
        return %max_cross;
    }
}

sub readStringData($) {
    my $filename = shift;

    my @v = ();
    open(my $in, "<:encoding(utf-8)", $filename)
        or die("Can not open < $filename: $!");
    while (! eof($in)) {
        my @numbers = split(/\s+/, readline($in));
        if (@numbers) {
            push(@v, @numbers);
        }
    }
    close($in)
        or warn("close failed: $!");

    my %max = findMax(\@v, 0, scalar(@v) - 1);
    for my $key (keys %max) {
        print("$key: $max{$key}\n");
    }
}

readStringData("test");
