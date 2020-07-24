#!/usr/bin/perl
use warnings;
use strict;

#Initialize variables for code
my @fasta_data; my @header; my @sequence;

#Take in file, read
my $file_name = "SRR4436218_1.fastq_illu.fq_filtered";

print "do you want to 1) print headers or edit headers 2)\n";
my $ans = <STDIN>;
chomp $ans;

if ($ans ==1){
	#Call sub-routines
	@fasta_data= read_file($file_name); print "File read\n";
	file_heads(\@fasta_data, \@header);
	save_file(\@header, \$file_name);
} else{
	@fasta_data= read_file($file_name); print "File read\n";
	file_edit(\@fasta_data,\@header);
	new_file(\@fasta_data,\@header);

}

##############################################################################################################
#Subroutes#
##############################################################################################################
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
sub file_heads{
	
	#Initialize variables
	my($fasta_data, $header)=@_;
	my $n = 0; my $line;

	
	#Take data file and initialize into headers and sequences
	foreach $line (@$fasta_data) {
		if ($line =~ /^>/) {
		  $n++;
		} elsif ($line =~/^@/){
		  $n++;
		  $header[$n] = $line;
		} 
	}
}
sub save_file {
	
	my ($header,$file_name) =@_;
	my $newfile = $$file_name;
	$newfile.= "_headers.txt";
	
	open(NEWFILE, '>'.$newfile) or die $!;

	for my $line (@header){
		print NEWFILE "$line\n";
	}
	close(NEWFILE);
}
sub file_edit{
	
	#Initialize variables
	my($fasta_data,$header)=@_;
	my $n = 0; my $line;
	my @number; my @length;
	my @name; my @value;
	
	#Take data file and initialize into headers and sequences
	foreach $line (@$fasta_data) {
		if ($line =~/^@/){
			my @temp = split ' ', $line;
			$name[$n] = $temp[0];
			$number[$n] = $temp[1];
			$length[$n] = $temp[2];
		  
		  	my @temp2 = split /\./, $name[$n];
			$value[$n]=$temp2[1];
		  $n++;
		}
	}
		
	$n=0;
	my $end = scalar @value;

	foreach $line (@value){
		
		if($n<$end-1){
			if ($line>$value[$n+1]){
				$value[$n+1]=$value[$n]+1;
				$number[$n+1]=$value[$n]+1;
			}
		}
		$n++;
	}
	
	$n=0;
	foreach $line (@value){
		
		$header[$n]= "\@SRR4436218.";
		$header[$n].=$value[$n]; $header[$n].=" ";
		$header[$n].=$value[$n]; $header[$n].=" ";
		$header[$n].=$length[$n];
		$n++;
	}
}
sub new_file{
	my($fasta_data,$header)=@_;
	my $newfile = "test_updated.fastq";
	my $n=0;
	
	open(NEWFILE, '>'.$newfile) or die $!;
	
	foreach my $line (@$fasta_data){
		if ($line =~/^@/){
			print NEWFILE "$header[$n]\n";
			$n++;
		} else{
			print NEWFILE "$line";
		}
		
	}
	
	close(NEWFILE);

}