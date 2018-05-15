#!/usr/bin/perl
#Date of Creation: 5/1/18
#Author: Samantha Sevilla

use warnings;
use strict;
use File::chdir;

#################################################################################################################################
#Purpose
#################################################################################################################################
#This code takes in a text file with the file names of fasta files. It then searchs for a reference PCR region that is
#unique to the inital reference file, at a length set by the user. It searches this reference template againtst other files listed in the 
#text file. If a duplicate is found, the process is repeated for a max of 10 attempts. A final text file is created with the unique
#sequences that were identified for each file

#Note: All testing parameters marked with ##Testing

#################################################################################################################################
#Main Code
#################################################################################################################################

#Ask for length of the inital sequnce - template Blast requires a minimum of 70bp
#print "What is the length of the PCR template sequence to create (minimum of 70)? ";
#my $length=<STDIN>; chomp $length;
	my $length=400; ##Testing

#Ask for the name of the txt file with fasta names
#print "What is the text files with fasta names?";
#my $filename=<STDIN>; chomp $filename;
	my $filename= "search_files.txt"; ##Testing

#Ask for the directory of the fasta files
#print "what is the full directory of fasta files\n";
#my $dir =<STDIN>; chomp $dir; 
	my $dir = "C:\\Users\\slsevilla\\Google Drive\\My Documents\\Education\\George Mason University\\BINF703\\2018_Spring_Lim\\Coding\\Fungi"; ##Testing

	#Initialize variable
my @files; my @template_data;

#Read the Text files with fasta names into an array
fasta_files($filename, \@files, $dir);

#Run through each file, creating a template, and comparing it to all other files
process_files(\@files, $dir, \@template_data, $length);

#Print the final document with the template sequences
write_file(@template_data, @files);

#################################################################################################################################
#Subroutines
#################################################################################################################################

sub process_files{

	#Initialize variables
	my ($files,$dir, $template_data, $length)=@_;
	my @data1; my @data2;
	my $validation='N'; my $n=1; my $a=0;
	my $attempt=1; my $template; 
	
	#Create an array with the file names to rotate through during search
	my @rotatingfiles= @$files;
	
	#Run until all the files have been used as the "template" sequence
	foreach (@$files){
	
		#Print which file is being searched"
		print "\n********************************\n";
		print "Information for $files[$a]\n";
		
		#Reads in the template fasta file
		my $type = "ref";
		fasta_read($files[$a], $dir, $type, \@data1);
	
		#Set a random starting point for the sequence finder
		my $start=int rand(15);
	
		#Starting with the second sequencing file, run a search
		$type = "search"; $validation='N';
		
		#Runs the comparision until a sequence is found unique as compared to all other sequences (max of 10 attempts)
		until ($n>scalar(@$files)-1 or $attempt==11){

			#Creates a template of specified length, changes flag to Y for second iteration and N to 1, to skip first 
			#template file, moves start to Start+10 for second iteration, if one is necessary, increased the attempt counter
			if ($validation=~'N'){
				print "Attempt #$attempt\n";
				template_create($length, \$template, $start, \@data1);
				$start = $start+10; $attempt++;
			}
			
			#Print out the file search
			chomp $rotatingfiles[$n]; print "For file: $rotatingfiles[$n]-";
			
			#Read in the fasta file, then search through the file to determine if the template sequence is unique
			fasta_read($rotatingfiles[$n], $dir, $type, \@data2);
			template_verify(\$template, \$validation, \@data2);
			@data2=(); 
			
			#Increase the counter if the template is unique, otherwise start over
			if ($validation=~'N'){
				$n=1; $template="";
			} else{$n++};
		}
	
		#Start with a new file as the source by moving the first fastq file to the end of the array
		my $swap = $rotatingfiles[0];
		shift(@rotatingfiles); push (@rotatingfiles, $swap);
		
		#Save the template sequence for printing
		push(@$template_data, $template);

		#Reset the marker
		$attempt=1; $a++; $n=1;
		@data1=(); $template = "";
	}
}	


#Read in the FASTA File with subroute
sub fasta_files {
	
	#Initialize variables
	my($filename, $files, $dir)=@_;
	$CWD = $dir;
	#If filename not provided, give error message and close
	unless (open(READ_FILE, $filename)) {
		print "Cannot open text search file \$filename\"\n\n";
		exit;
	}

	#Read in the file, and close
	@$files= <READ_FILE>;
	close READ_FILE;
}

sub fasta_read {
	
	#Initialize variables
	my($filename, $dir, $type, $data)=@_;
	my @temp; my $n=0; my $num=1;
	my $stored;

	#Move to the directory
	$CWD= $dir;

	#If filename not provided, give error message and close
	unless (open(READ_FILE, $filename)) {
		print "Cannot open fasta file \$filename\n\n";
		exit;
	}

	#Read in the file, and close
	@temp= <READ_FILE>;
	close READ_FILE;
	pop(@temp);
		
	if ($type=~"ref"){
		foreach my $line (@temp){
			#Skip the first header line of the fasta file
			if ($n==0){ 
				$n++;
				next;
			} else{
				chomp $line;
				my @temp2 = split '', $line;
				push (@$data, @temp2);
			}
		}
	} else{
		foreach my $line (@temp){
			#Skip the first header line of the fasta file
			if ($n==0){ 
				$n++;
				next;
			} else{
				chomp $line;
				$stored .=$line;
			}
		}
		push (@$data, $stored);
	}
}

sub template_create{
	
	#Initialize variables
	my ($length, $template, $start, $data1)=@_;
	my $n=1; 

	#Create a sequence from the template data that is the correct length
	until ($length<$n){
		$$template .= @$data1[$start];
		$start++; 	
		$n++;
	}
	
	#Print the tested sequence to the CML
	print "PCR Template Sequence:\n";
	print "$$template\n\n";
}

sub template_verify{
	my ($template, $validation, $data2)=@_;

	#Search through the fasta file to determine if the sequence is unique
	if (index($$data2[0], $$template) !=-1){
		$$validation='N';
		print "Attempt was not sucessful. Repeating\n\n\n";
	} else{
		print " Unique Sequence\n";
		$$validation='Y';
	}
}

sub write_file{
	my ($template_data)=@_;
	my $n=0;
		
	#Print data to Nephele txt file
	open (FILE, ">final_sequences.txt") or die;
	
	#Print headers to file
	foreach my $file (@files){
		print FILE join ("\n", $file), "\n";
		print FILE join ("\n", $template_data[$n]), "\n\n\n";
		$n++;
	}
	close FILE;
}