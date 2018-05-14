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

#Note: All testing parameters marked with ##Testing

#################################################################################################################################
#Main Code
#################################################################################################################################

#Ask for length of the inital sequnce - template Blast requires a minimum of 70bp
print "What is the length of the PCR template sequence to create (minimum of 70)? ";
my $length=<STDIN>; chomp $length;

#Ask for the name of the txt file with fasta names
#print "What is the text files with fasta names?";
#my $filename=<STDIN>; chomp $filename;
my $filename= "search_files.txt"; ##Testing

#Ask for the directory of the fasta files
#print "what is the full directory of fast##a files\n";
#my $dir =<STDIN>; chomp $dir; 
my $dir = "C:\\Users\\sevillas2\\Google Drive\\My Documents\\Education\\George Mason University\\BINF703\\2018_Spring_Lim\\Coding\\Bacterial"; ##Testing

#Initialize variable
my @data1; my @data2; my @files; my @template_data;
my $validation='N'; my $n;
my $attempt=1; my $template; 


#Read the Text files with fasta names into an array
fasta_files($filename, \@files);
my $max = scalar @files;	

#Run until all the files have been used as the "template" sequence
until ($max==0){
	
	#Print which file is being searched"
	print "\n********************************\n";
	print "Information for $files[0]\n";
		
	#Reads in the template fasta file
	my $type = "ref";
	fasta_read($files[0], $dir, $type, \@data1);
	
	#Set a random starting point for the sequence finder
	my $start=int rand(15);
	
	#Runs the comparision until a sequence is found unique as compared to all other sequences
	until ($validation=~'Y' | $attempt==10){
		
		#Creates a template of the necessary length
		template_create($length, \$template, $start, @data1);

		#Starting with the second sequencing file, run a search
		$type = "search"; $n++;
		
		#Determines whether this sequence is unique in all other fasta files
		until ($n>scalar(@files)-1){
			my $name = $n+1;
			print "For file #$name:";
			fasta_read($files[$n],$dir, $type, \@data2);
			template_verify($template, \$validation, @data2);
			$n++;
			@data2=();
		}
		
		#If there is a duplicate, will repeat the process with a new start point, and an empty template
		$start = $start+10; $template = "";
		$attempt++; $n=0;
	}
	
	#Start with a new file as the source by moving the first fastq file to the end of the array
	my $swap = $files[0];
	shift(@files); push (@files, $swap);
	
	#Save the template sequence for printing
	push(@template_data, $template);

	#Reset the markers
	$validation ='N'; $template="";
	$max--; $n=0; $attempt=1;
}

#Print the final document with the template sequences
write_file(@template_data, @files);

#################################################################################################################################
#Subroutines
#################################################################################################################################

#Read in the FASTA File with subroute
sub fasta_files {
	
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

sub fasta_read {
	
	#Initialize variables
	my($filename, $dir, $type, $data)=@_;
	my @temp; my $n=0; my $num=1;
	my $stored;
	
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
	my $n=1; my $search1; my $attempt=1;
	my $complete='N';
	
	#Create a sequence from the template data that is the correct length
	until ($length<$n){
		$$template .= $data1[$start];
		$start++;
		$n++;
	}
	
	#Print the tested sequence to the CML
	print "PCR Template Sequence:\n";
	print "$$template\n\n";
}

sub template_verify{
	my ($template, $validation, $data2)=@_;
	my $length = length $template;
	
	#Search through the fasta file to determine if the sequence is unique
	if (index($data2[0], $template) !=-1){
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