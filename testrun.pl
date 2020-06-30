#!/usr/bin/perl

use strict;
use warnings;

my $num = 10;
my $num_port = 50;
my $server_ip = "18.221.54.244";
#my $server_ip = "localhost";
my $cert_path = "./";

if (@ARGV != 1) {
    die "Usage: $0 [num_clients]";
} elsif (@ARGV == 1) {
    #$server_ip = $ARGV[0];
    #$cert_path = $ARGV[1];
    $num = $ARGV[0];
    #$num_port = $ARGV[2];
}
my $start_port = 5440;
my $port = $start_port;
my $end_port = $start_port + $num_port - 1;
for (my $i = 0; $i < $num; $i++) {
    system("curl -k https://$server_ip:$port/loadgenerator/exp$i/100");
    $port++;
    if ($port > $end_port) {
        $port = $start_port;
    }
}
exit 0;
