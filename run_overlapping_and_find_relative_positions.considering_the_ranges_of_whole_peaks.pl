#!/bin/perl
use strict;

## For calculating the distance from central coordinates to binding peaks; Note: the maximum length of peaks should be less than $maxLength

sub find_relative_positions {
	my ($FileWithCentralCoordinates,$FileForOverlapping,$maxLength,$FileOutput) = @_;
        open IN1,"$FileWithCentralCoordinates" or die $!;
	open(OUT, ">$FileOutput");
	while (<IN1>) {
		chomp;
		my $line1 = $_;
#		my $tmpD = 0; # $tmpD is used as "temporary shortest distance"
                my $Dist = 0;
		my $start = 0;
		my $end = 0;
		my @Columns1 = split(/\t/, $line1);
		if ($Columns1[5] eq "+") {
			open IN2, "$FileForOverlapping" or die $!;
				while (<IN2>) {
					chomp;
					my $line2 = $_;
					my @Columns2 = split(/\t/, $line2);
					next if ($Columns2[0] ne $Columns1[0]);
					if (($Columns1[1] - $maxLength > $Columns2[1] && $Columns1[1] - $maxLength <= $Columns2[2])) {
						$start = 0 - $maxLength;
						$end = $Columns2[2] - $Columns1[1];
						print OUT "$line1\t$start\t$end\n";
					}
					elsif ($Columns1[1] - $maxLength < $Columns2[1] && $Columns1[1] >= $Columns2[2]) {
						$start = $Columns2[1] - $Columns1[1];
						$end = $Columns2[2] - $Columns1[1];
						print OUT "$line1\t$start\t$end\n";
					}
					elsif ($Columns1[1] >= $Columns2[1] && $Columns1[1] < $Columns2[2]) {
						$start = $Columns2[1] - $Columns1[1];
						print OUT "$line1\t$start\t0\n";
						$end = $Columns2[2] - $Columns1[2];
						print OUT "$line1\t1\t$end\n";
					}
					elsif ($Columns1[2] < $Columns2[1] && $Columns1[2] + $maxLength >= $Columns2[2]) {
						$start = $Columns2[1] - $Columns1[2];
						$end = $Columns2[2] - $Columns1[2];
						print OUT "$line1\t$start\t$end\n";
					}
					elsif ($Columns1[2] + $maxLength >= $Columns2[1] && $Columns1[2] + $maxLength < $Columns2[2]) {
						$start = $Columns2[1] - $Columns1[2];
						$end = $maxLength;
						print OUT "$line1\t$start\t$end\n";
					}
				}
			close(IN2);
		}
		else {
			open IN2, "$FileForOverlapping" or die $!;
                                while (<IN2>) {
                                        chomp;
                                        my $line2 = $_;
                                        my @Columns2 = split(/\t/, $line2);
                                        next if ($Columns2[0] ne $Columns1[0]);                                        
					if (($Columns1[1] - $maxLength > $Columns2[1] && $Columns1[1] - $maxLength <= $Columns2[2])) {
                                                $end = $maxLength;
                                                $start = $Columns1[1] - $Columns2[2];
                                                print OUT "$line1\t$start\t$end\n";
                                        }
                                        elsif ($Columns1[1] - $maxLength <= $Columns2[1] && $Columns1[1] >= $Columns2[2]) {
                                                $end = $Columns1[1] - $Columns2[1];
                                                $start = $Columns1[1] - $Columns2[2];
                                                print OUT "$line1\t$start\t$end\n";
                                        }
                                        elsif ($Columns1[1] >= $Columns2[1] && $Columns1[1] < $Columns2[2]) {
                                                $end = $Columns1[1] - $Columns2[1];
                                                print OUT "$line1\t0\t$end\n";
                                                $start = $Columns1[2] - $Columns2[2];
                                                print OUT "$line1\t$start\t-1\n";
                                        }
                                        elsif ($Columns1[2] < $Columns2[1] && $Columns1[2] + $maxLength >= $Columns2[2]) {
                                                $end = $Columns1[2] - $Columns2[1]; 
                                                $start = $Columns1[2] - $Columns2[2];
                                                print OUT "$line1\t$start\t$end\n";
                                        }
                                        elsif ($Columns1[2] + $maxLength > $Columns2[1] && $Columns1[2] + $maxLength < $Columns2[2]) {       
                                                $end = $Columns1[2] - $Columns2[1];
                                                $start = 0 - $maxLength; 
                                                print OUT "$line1\t$start\t$end\n";
                                        }
                                }
                        close(IN2);     
		}
        }
        close(IN1);
	close(OUT);
}

if(@ARGV < 4){
        print "usage:FileWithCentralCoordinates\tFileForOverlapping\tmaxLength\tFileOutput\n";
        exit(0);
}else{
        &find_relative_positions($ARGV[0],$ARGV[1],$ARGV[2],$ARGV[3]);
}
