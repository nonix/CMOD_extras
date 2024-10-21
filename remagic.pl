#!/usr/bin/perl -w
use File::Basename qw(basename);
use Fcntl qw( SEEK_CUR SEEK_SET );
use strict;

die "Usage: $0 7z_file [magic]\n" unless (scalar(@ARGV));

my $magic = $ARGV[1];
open(my $fhi,'<:raw',$ARGV[0]);
sysseek($fhi, 0, SEEK_SET) or die($!);

my $fho;
my $buf;

if ($magic) {
        $buf = pack('H*',$magic);
        open($fho,'>:raw',basename($ARGV[0],'.dat').'.7z');
        sysseek($fhi, 4, SEEK_SET) or die($!);
} else {
        open($fho,'>:raw',basename($ARGV[0],'.7z').'.dat');
        sysread($fhi,$buf,4);
        print 'Magic: ',unpack("(H2)*", $buf),"\n";
        $buf = 'DAT ';
}

# Write new magic
sysseek($fho, 0, SEEK_SET) or die($!);
syswrite($fho,$buf,4);

# copy the rest
while(1) {
        my $len = sysread($fhi,$buf,4096);
        syswrite($fho,$buf,$len);
        last if ($len < 4096);
}
close($fho);
close($fhi);
