#User: Samantha Sevilla
#Date: 09/22/17
#Course: BINF730
#Homework 1
#!/usr/bin/perl
use strict;

print "Which alignment would you like to use: \n";
print "1) Needleman-Wunsch 2) Waterman-Smith-Beyer 3) Smith-Waterman\n";
my $ans = <STDIN>; chomp $ans;

if($ans==1){
	
	## Take input from user
	print "What is your first sequence?\n";
	#	my $seq1= <STDIN>; chomp $seq1;
	print "What is your second sequence?\n";
	#	my $seq2= <STDIN>; chomp $seq2;
	print "What is your gap penalty?\n";
	#	my $gap=<STDIN>; chomp $gap;
	print "What is your match score?\n";
	#	my $mat=<STDIN>; chomp $mat;
	print "What is your mismatch score?\n";
	#	my $mismat=<STDIN>; chomp $mismat;

	## Testing Only	
	my $seq1 = "GATCT";
	my $seq2 = "GCGTA";
	#my $seq1 = "GAGATTTGACTCATGCTATTATGGAAGCCAAGAAGTCCTACAATATGCCATCTTCAAATT";	
	#my $seq2 = "GGAGATTTGACTCATGCTATTATGGAAGCCAAGAAGTCCTACAATATGCCATCTTCATATT";
	my $gap=-1; my $mismat=-1;
	my $mat = 1;
	
	#Initialize Variables
	my @gaps; my $i=0;
	my @score = (); my @pointer=();
	my $abo_score; my $left_score; my $diag_score;
	
	#Create array for gap penalty
	until ($i>length($seq1)){
		push(@gaps,$i*$gap);
		$i++;
	} $i=1;
	until ($i>length($seq2)){
		push(@gaps,$i*$gap);
		$i++;
	} 
	
	#Turn sequences into arrays
	my @seq_1 = split '', $seq1;
	my @seq_2 = split '', $seq2;

	#Add spaces for sequence for matrix
	unshift(@seq_1," "); unshift(@seq_1," ");
	unshift(@seq_2," "); unshift(@seq_2," ");
	
	#Determine the parameters of the matrix based on sequence lengths
	my $row = scalar(@seq_1);
	my $col = scalar(@seq_2);
	my $n = 0; my $val=1; my $vals=0;
	
	#Create a matrix of sequence letters, and matrix scores
	#For each row position add either the sequence letter, or matrix score
	for (my $i=0; $i < $row; $i++) {
		
		#For each column position add either the sequence letter, or matrix score
		for (my $j=0; $j < $col; $j++) {
			
			#If in the first row, iterate through each sequence
			if ($i==0){
				$score[$i][$j] = $seq_1[$vals];
				$vals=$vals+1; 
			
			#If in the first column, iterate through each sequence
			} elsif($j==0){
				$score[$i][$j] = $seq_2[$val];
				$val=$val+1;
			
			#Otherwise, iterate through each remaining space in the matrix
			} else {
				#If in the second row or column (I OR J = 1), iterate through increasing gap penalties
				if($i==1 || $j==1){
					$score[$i][$j] = $gaps[$n];
					$n++;
				
				#Calculate the scoring of the sequences by:
				} else{
					
					### 1) Comparing Row:Column Seq - if there is a match then +match, otherwise +mismatch
					if($score[$i][0] ne $score[0][$j]){
						$diag_score = $score[$i-1][$j-1]+$mismat;
					} else{ $diag_score = $score[$i-1][$j-1]+$mat;	
					}
					
					### 2) Calculate above and below scores by score +gap penalty
					$abo_score = $score[$i-1][$j] + $gap;
					$left_score = $score[$i][$j-1] + $gap;
					
					#Determine the highest score to use, and create pointer matrix
					if($diag_score>$abo_score){
						if($diag_score>$left_score){
							$score[$i][$j]=$diag_score;
							$pointer[$i][$j] = "diag";
						} else{
							$score[$i][$j]=$left_score;
							$pointer[$i][$j] = "left";
						}
					} elsif($abo_score>$left_score){
						$score[$i][$j]=$abo_score;
						$pointer[$i][$j] = "above";
					} else{
						$score[$i][$j]=$left_score;
						$pointer[$i][$j] = "left";
					}
					
				}	
			}
		}
	}
	
	#Print the Results 
	print "\n This is the scoring matrix:\n";
		printarray(\@score, \$row, \$col);
		print "\n";
	print "This is the optimal sequence alignmnet:\n";
		seq_create(\@score, \@pointer, \$row, \$col);
		print "\n";
}

######################################################################################
################################# SUBROUTES ##########################################
######################################################################################

#This subroutine takes in a matrix, and prints each component row by column
sub printarray {
	
	#Initialize Variables
	my ($array, $row, $col) = @_;

	#Create loop to print the array
	for (my $i=0; $i < $$row; $i++) {
		for (my $j=0; $j < $$col; $j++) {
			if ($$array[$i][$j]<0){
			print "  $$array[$i][$j]  ";
			} else{print "   $$array[$i][$j]  "};
	   }
	   print "\n";
	}
}

sub seq_create{
	
	#Initialize Variables
	my ($score, $pointer, $row, $col)=@_;
	my @seq1_final; my @seq2_final;
	my $i=$$row; my $j=$$col;
	my $tcol=$$col-1;
	my $trow=$$row-1; my $n=2;

	##Sequence 1
		#Initialize Counters
		my $tcol=$$col-1;
		my $trow=$$row-1; my $n=1;
		
		#For each column position add either the sequence letter, or matrix score
		until ($n>$$col){
			if($$pointer[$trow][$tcol]=~ "diag"){
				unshift (@seq1_final, $$score[0][$tcol]);
				$trow=$trow-1;
				$tcol=$tcol-1;
			} elsif($$pointer[$trow][$tcol]=~"above"){
				unshift (@seq1_final, "-");
				$trow=$trow-1;
			} else{
				unshift (@seq1_final, $$score[0][$tcol]);
				$tcol=$tcol-1;
			} 
			$n++;
		}

	#Print the optimal sequence1
	foreach my $line (@seq1_final){
		print "$line  ";
	} print "\n";
		
	##Sequence 2
		#Initialize Counters
		$tcol=$$col-1;
		$trow=$$row-1; $n=1;
	
		#For each column position add either the sequence letter, or matrix score
		until ($n>$$row){
			if($$pointer[$trow][$tcol]=~ "diag"){
				unshift (@seq2_final, $$score[$trow][0]);
				$trow=$trow-1;
				$tcol=$tcol-1;
			} elsif($$pointer[$trow][$tcol]=~"left"){
				unshift (@seq2_final, "-");
				$tcol=$tcol-1;
			} else{
				unshift (@seq2_final, $$score[$trow][0]);
				$trow=$trow-1;
			} 
			$n++;
		}

	#Print the optimal sequence2
	foreach my $line (@seq2_final){
		print "$line  ";
	} print "\n";
}

sub seq_score{



}
