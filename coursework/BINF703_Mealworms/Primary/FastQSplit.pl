######################################################################################
								##NOTES##
######################################################################################
###This script takes in the a FastQ file with multiple samples and splits it based on the locations
###Final file(s) are the header line, and three additional lines of sequences

# Name of file: FastQSPlit
# Your name: Samantha Sevilla
# Date: 4/8/18
######################################################################################
								##Main Code##
######################################################################################
use warnings;
use strict;
use Cwd;
use CPAN;
use File::chdir;
use File::Copy;#!/usr/bin/perl
use warnings;
use strict;

#Initialize variables for code
print "what is your file name of your full FastQ file\n";
my $file_name = <STDIN>; chomp $file_name;
my @file_data = ();

print "Which run do you want to split\n";
print "   1: PGM_073\n";
print "   2: PGM_074\n";
my $run = <STDIN>; chomp $run;

#Call Sub-Routes
@file_data = read_file($file_name);
split_fasta(\@file_data, $run);

#################################################################################################################################
#Called Subroutes below
#################################################################################################################################

#Read in the FASTA File with subroute
sub read_file {
	
	#Initialize variables
	my($seqname)=@_;
	my @seqdata = ();
	
	#If filename not provided, give error message and close
	unless (open(READ_FILE, $seqname)) {
		print "Cannot open file \$seqname\"\n\n";
		exit;
	}

	#Read in the file, and close
	@seqdata= <READ_FILE>;
	close READ_FILE;
	return @seqdata;
}
sub split_fasta{
	my ($data, $run) = @_;
	my @temp = ();
	my $i=0; my $new_file; my $n=0;
	my @sequences; my @file_name; my $runid;
	
	#Capture data depending on the run 
	if ($run==1){
		#Sample Labels for PGM_073
		@sequences= qw(A11 B11 C11 D11 E11 A10 B10 C10 D10 E10 F10 F11 G10 H10); 
		@file_name = qw(Sample1 Sample2 Sample3 Sample4 Sample5 Sample6 Sample7 Sample8 Sample9 Sample10 Sample11 Sample12 Sample13 Sample14); 
		$runid="PGM_073";
		} else{
			#Sample Labels for PGM_074
			@sequences= qw(A10 B10 C10 C12 D10 D12 E10 E12 F11 A11 A9 B11 B12 B9 C11 C9 C11 C9 D11 D9 E11 E9 F10 F12 F9 G10 G9 H10 H9);
			@file_name = qw(Sample15 Sample16 Sample17 Sample18 Sample19 Sample20 Sample21 Sample22 Sample23 Sample24 Sample25 Sample26 Sample27 Sample28 Sample29 Sample30 Sample29 Sample30 Sample31 Sample32 Sample33 Sample34 Sample35 Sample36 Sample37 Sample38 Sample39 Sample40 Sample41);
			$runid="PGM_074";
		}
	
	#For each of the sample locations, finds the header line starting with that locations
	#Pushes the next three lines of sequence data to a temp array
	foreach my $set (@sequences){
		foreach my $line (@$data){
			if ($line =~/^@/){
				if ($line =~/\_$set$/){
							print "$line/n"; #For QC - all prints should have only _location
					push (@temp, $line);
					push (@temp, @$data[$i+1]);
					push (@temp, @$data[$i+2]);
					push (@temp, @$data[$i+3]);
					$i++;
				} else {
					$i++;
					next;
				}
			} else {
					$i++;
					next;
				}
		}
		
	#Save temp file to a new file
	$new_file = $file_name[$n]; $new_file.= "_mod_$runid.fastq";
	
	#Print data to fastq file
	open (FILE, ">$new_file") or die;
	print (FILE @temp), "\n";
	close (FILE);
	
	#Reset Counters
	@temp=(); $i=0;
	$n++;
	}
}