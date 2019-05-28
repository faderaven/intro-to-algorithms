
use strict;
use warnings;

our %CONST = (
    rmin => -0x8000, rmax => 0x7FFF,
    bytes => 4,
);

sub newRandom($$) {
    my ($min, $max) = @_;

    return($min + int(rand($max - $min + 1)));
}

sub makeRandomNumbers($$) {
    my ($filename, $n) = @_;

    open(my $out, '>:raw', $filename) or die("Unable to open: $!");
    for (; $n != 0; --$n) {
        my $rd = newRandom($CONST{rmin}, $CONST{rmax});
        print $out pack('l<', $rd);
    }
    close($out);
}

sub lookRandomNumbers($;$$) {
    my ($filename, $pos, $n) = @_;
    defined($pos) or $pos = 0;
    defined($n) or $n = (stat($filename))[7] / $CONST{bytes};

    open(my $in, '<:raw', $filename) or die("Unable to open: $!");
    my $bytes = 0;
    my $int = 0;
    seek($in, $pos * $CONST{bytes}, 0);
    while (read($in, $bytes, $CONST{bytes})) {
        $int = unpack('l<', $bytes);
        print("$int\n");
        (0 != --$n) or last;
    }
}

sub arrayCopy($$$) {
    my ($v, $pos, $n) = @_;

    my @tmp = ();
    while ($n != 0) {
        push(@tmp, $v->[$pos]);
        ++$pos;
        --$n;
    }
    return @tmp;
}

sub mergeSort($$$) {
    my ($v, $left, $right) = @_;

    if ($left < $right) {
        my $mid = int(($left + $right) / 2);
        mergeSort($v, $left, $mid);
        mergeSort($v, $mid + 1, $right);

        my @Lv = arrayCopy($v, $left, $mid - $left + 1);
        my @Rv = arrayCopy($v, $mid + 1, $right - $mid);

        for (my $i = 0, my $j = 0; $left <= $right; ++$left) {
            if ($i == scalar(@Lv)) {
                $v->[$left] = $Rv[$j];
                ++$j;
            } elsif ($j == scalar(@Rv)) {
                $v->[$left] = $Lv[$i];
                ++$i;
            } else {
                if ($Lv[$i] < $Rv[$j]) {
                    $v->[$left] = $Lv[$i];
                    ++$i;
                } else {
                    $v->[$left] = $Rv[$j];
                    ++$j;
                }
            }
        }
    }
}

sub sortRandomNumbers($$$) {
    my ($sort, $in_file, $out_file) = @_;

    my @v = ();
    # read random numbers
    open(my $in, '<:raw', $in_file) or die("Unable to open: $!");
    my $bytes = 0;
    my $int = 0;
    while (read($in, $bytes, $CONST{bytes})) {
        $int = unpack('l<', $bytes);
        push(@v, $int);
    }
    close($in);

    # sort random numbers
    $sort->(\@v, 0, scalar(@v) - 1);

    # write random numbers
    open(my $out, '>:raw', $out_file) or die("Unable to open: $!");
    for (my $n = scalar(@v), my $i = 0; $i != $n; ++$i) {
        print $out pack('l<', $v[$i]);
    }
    close($out);
}

makeRandomNumbers("test", 1024 * 1024);
sortRandomNumbers(\&mergeSort, "test", "out-test");
lookRandomNumbers("out-test", 512 * 1024, 512 * 1024);
# take about 25 seconds
