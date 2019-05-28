#!/usr/bin/perl

use strict;
use warnings;
use Cwd qw();
use File::Find;

my($argc, $option, $dir, $find, $replace, @files);

$argc = scalar @ARGV;
if ($argc != 3 and $argc != 4) {
    die "wrong arguments\n";
}

if ($ARGV[0] eq "-f") {
    $option = 1;
} elsif ($ARGV[0] eq "-r") {
    $option = 0;
} else {
    print("wrong options\n",
          "\t-f :: find\n",
          "\t-r :: replace\n");
    exit;
}

mkdir($dir . "_replaced_", 0755);

if (-d $ARGV[1]) {
    $dir = $ARGV[1];
    $find = $ARGV[2];
} elsif (-f $ARGV[1]) {
    if ($option) {
        find_in_file($ARGV[1], $ARGV[2]);
    } else {
        replace_in_file($ARGV[1], $ARGV[2], $ARGV[3]);
    }
    exit;
} else {
    print("$ARGV[1] :: invalid directory or file name\n");
}

if ($ARGV[3]) {
    $replace = $ARGV[3];
} else {
    $replace = "";
}

# find all files
find(\&wanted, $dir);


if ($option) {
    for my $e (@files) {
        find_in_file($e, $find);
    }
} else {
    mkdir($dir."_replaced_", 0755);
    for my $e (@files) {

    }
}

exit;

sub wanted {
    push(@files, $File::Find::name);
    return;
}

sub find_in_file ($$) {
    my($file, $find)= @_;

    open(my $read_handle, '<', $file) or die "Cannot open file to read: $!\n";

    my $line = 1;
    while (<$read_handle>) {
        if ($_ =~ /\Q$find\E/) {
            print("$file :: $line\n", "$_\n");
        }
        ++$line;
    }

    close($read_handle);
}

sub replace_in_file ($$$) {
    my($file, $find, $replace) = @_;
    my @file_replaced = ();

    open(my $read_handle, '<', $file) or die "Cannot open file to read: $!\n";

    my $line = 1;
    while (<$read_handle>) {
        if ($_ =~ s/\Q$find\E/\Q$replace\E/g) {
            print("$file :: $line\n", "$_");
        }
        push(@file_replaced, $_);
        ++$line;
    }
    close($read_handle);

    open(my $write_handle, '>', $file) or die "Cannot open file to write: $!\n";
    for $line (@file_replaced) {
        print $write_handle $line;
    }
    close($write_handle);
}
