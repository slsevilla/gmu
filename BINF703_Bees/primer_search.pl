#!/usr/bin/perl
use warnings;
use strict;
use File::chdir;

#################################################################################################################################
#Purpose
#################################################################################################################################
#This code takes in a text file with the name of fasta files to search against. It then searchs for a refernce PCR region that is
#unique to the inital refernce file. It then moves the second file to the reference position and repeats the process. A final text
#file is created with the unique sequences that were identified

#################################################################################################################################
#Main Code
#################################################################################################################################

#Ask for length of the inital sequnce - Primer Blast requires a minimum of 70bp
print "What is the length of the PCR sequence (minimum of 70)? ";
my $length=<STDIN>; chomp $length;

#Ask for the initial offset - this will offset the inital serach parameter
print "What inital offset (minimum of 0)? ";
my $start=<STDIN>; chomp $start;

#Ask for the name of the txt file with fasta names
#print "What is the text files with fasta names?";
#my $filename=<STDIN>; chomp $filename;
my $filename= "search_files.txt";

#Ask for the directory of the fasta files
#print "what is the full directory of fast##a files\n";
#my $dir =<STDIN>; chomp $dir; 
my $dir = "C:\\Users\\slsevilla\\Google Drive\\My Documents\\Education\\George Mason University\\BINF703\\2018_Spring_Lim\\Coding\\bacterial";

#Initialize variable
my @data1; my @data2; my @data3; my $winner; 
my @files; my @winner_data; my $validation='N'; my $n=2;

#Read the serach file in
search_filelist($filename, \@files);
my $max = scalar @files;	

#Run the loop until all the files have been used as the template
until ($max==0){
	
	#Runs the comparision until a sequence is found unique as compared to all other sequences
	until ($validation=~'Y'){
		
		#Print which file is being searched"
		print "\n********************************\n";
		print "Information for $files[0]\n";
		
		#Begin initial search
		ref_search($files[0], $dir, \@data1);

		#Find unique in data1/2
		compare_search($files[1], \@data2);
		primer_search($length, \$winner, $start, @data1, @data2);
		@data2=();

		#Compare the Unique sample to other files
		until ($n==scalar(@files)){
			my $name = $n+1;
			print "For file #$name:";
			compare_search($files[$n], \@data2);
			primer_verify(\$winner, \$validation, @data2);
			$n++;
			@data2=();
			
		}
		$start = $start+10;
	}
	
	#Start with a new file as the source
	my $swap = $files[0];
	shift(@files);
	push (@files, $swap);
	
	#Reset the markers
	$validation ='N';
	$max--;
	$n=2;

	#Save the winner sequence for printing
	push(@winner_data, $winner);

}

write_file(@winner_data, @files);

#################################################################################################################################
#Subroutines
#################################################################################################################################

#Read in the FASTA File with subroute
sub search_filelist {
	
	#Initialize variables
	my($filename, $files)=@_;
	
	#If filename not provided, give error message and close
	unless (open(READ_FILE, $filename)) {
		print "Cannot open file \$filename\"\n\n";
		exit;
	}

	#Read in the file, and close
	@$files= <READ_FILE>;
	close READ_FILE;
	
}

sub ref_search {
	
	#Initialize variables
	my($filename, $dir, $data)=@_;
	my @temp; my $n=0; my $num=1; my @stored;
	
	#Move to the directory
	$CWD= $dir;
	
	#If filename not provided, give error message and close
	unless (open(READ_FILE, $filename)) {
		print "Cannot open file \$filename\"\n\n";
		exit;
	}

	#Read in the file, and close
	@temp= <READ_FILE>;
	close READ_FILE;
	pop(@temp);
		
	foreach my $line (@temp){
		if ($n==0){ 
			$n++;
			next;
		} else{
			chomp $line;
			my @temp2 = split '', $line;
			push (@$data, @temp2);
		}
	}
}

sub compare_search {
	
	#Initialize variables
	my($filename, $data)=@_;
	my @temp; my $n=0; my $num=1; my @stored;
	
	#If filename not provided, give error message and close
	unless (open(READ_FILE, $filename)) {
		print "Cannot open file \$filename\"\n\n";
		exit;
	}

	#Read in the file, and close
	@temp= <READ_FILE>;
	close READ_FILE;
	pop(@temp);
		
	foreach my $line (@temp){
		if ($n==0){ 
			$n++;
			next;
		} else{
			chomp $line;
			push (@$data, $line);
		}
	}
}

sub primer_search{
	my ($length, $winner, $start, $data1, $data2)=@_;
	my $n=1; my $search1; my $attempt=1;
	my $complete='N';
	
	until ($complete=~'Y' or $attempt==5){
		if ($attempt==1){
			if($winner=~""){
				until ($length<$n){
					$search1 .= $data1[$start];
					$start++;
					$n++;
					}
			} else{$search1=$$winner};
			
			$attempt++;
		} else{
		
			if ( grep( /^$search1$/, @data2 ) ) {
				
				print "Attempt $attempt";
				$start = $length*($attempt-1);
				
				until ($length<$n){
				$search1 .= $data1[$start];
				$start++;
				$n++;
				}
				$attempt++;

			} else{
				print "$search1\n\n";
				print "For file#2: Winner!\n";
				$complete='Y';
				$$winner = $search1;
			}
		}
	}
}

sub primer_verify{
	my ($winner, $validation, $data2)=@_;
		
	if ( grep( /^$winner$/, @data2 ) ) {
		$$validation='N';
		print "Attempt was not sucessful. Repeating\n\n\n";
	} else{
		print "Still a winner!\n";
		$$validation='Y';
	}
	
}

sub write_file{
	my ($winner_data)=@_;
	my $n=0;
		
	#Print data to Nephele txt file
	open (FILE, ">final_sequences.txt") or die;
	
	#Print headers to file
	foreach my $file (@files){
		print FILE join ("\n", $file), "\n";
		print FILE join ("\n", $winner_data[$n]), "\n\n\n";
		$n++;
	}
	close FILE;
	
}