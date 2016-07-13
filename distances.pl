#!/usr/bin/perl -w

# Quit unless we have the correct number of command-line args
$num_args = $#ARGV + 1;
if ($num_args != 3) {
    print "\nUsage: distances.pl last_struct topol index\n";
    exit;
}

use strict;

# loop g_dist command - measure distance in each frame, write to a file
for (my $i=0; $i<=$ARGV[0]; $i++) {
        print "Processing configuration $i...\n";
        system("/mb/apps/gromacs-4.5.5/bin/g_dist -s $ARGV[1] -f conf${i}.gro -n $ARGV[2] -o dist${i}.xvg < groups.txt &>exe.err");
}

# write output to single file
open(OUT, ">>summary_distances.dat");

for (my $j=0; $j<=$ARGV[0]; $j++) {
        open(IN, "<dist${j}.xvg");
        my @array = <IN>;

        my $distance;

        foreach $_ (@array) {
                if ($_ =~ /[#@]/) {
                        # do nothing, it's a comment or formatting line
                } else {
                        my @line = split(" ", $_);
                        $distance = $line[2];
                }
        }

        close(IN);
        print OUT "$j\t$distance\n";
}

close(OUT);

# clean up
print "Cleaning up...\n";

for (my $k=0; $k<=$ARGV[0]; $k++) {
        unlink "dist${k}.xvg";
}

exit;
