#User: Samantha Sevilla
#Date: 09/22/17
#Course: BINF730
#Homework 1
#!/usr/bin/perl
use strict;

print "Which alignment would you like to use: \n";
print "1) Needleman-Wunsch 2) Smith-Waterman\n";
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
	my $sq1 = "GATCT";
	my $sq2 = "GCGTA";
	#my $sq1 = "GAGATTTGACTCATGCTATT";	
	#my $sq2 = "GGAGATTTGACTCATGCTAT";
	my $gap=-1; my $mismatch=-1;
	my $match = 1;
	
	#Initialize Variables
	my @score = (); my @pointer=();
	my $abo_score; my $left_score; my $diag_score;
	my @seq1_final; my @seq2_final;
	
	#Turn sequences into arrays
	my @seq1 = split '', $sq1;
	my @seq2 = split '', $sq2;

	#Determine the parameters of the matrix based on sequence lengths
	my $row = scalar(@seq1)+1;
	my $col = scalar(@seq2)+1;
	
	#Create a matrix of sequence letters, and matrix scores
	#For each row position add either the sequence letter, or matrix score
	for (my $i=0; $i < $row; $i++) {
		
		#Create the scoring penalty
		for (my $j=0; $j < $col; $j++) {
			
			#If in the first row or column, create gap penalty
			if ($i==0){
				$score[$i][$j] = $gap*$j;
				$pointer[$i][$j] = "left";
			}elsif($j==0){
				$score[$i][$j] = $gap*$i;
				$pointer[$i][$j] = "above";
			} else {
		
				### 1) Calculate diag score: match then +match, otherwise +mismatch
				if($seq1[$j-1] =~ $seq2[$i-1]){
					$diag_score = $score[$i-1][$j-1]+$match;
				} else{$diag_score = $score[$i-1][$j-1]+$mismatch;
				
				### 2) Calculate above/left scores by score +gap penalty
				}	$abo_score = $score[$i-1][$j] + $gap;
					$left_score = $score[$i][$j-1] + $gap;
					
				#Determine the highest score to use, and create pointer matrix
				if($diag_score>=$abo_score&& $diag_score>=$left_score){
					$score[$i][$j]=$diag_score;
					$pointer[$i][$j] = "diag";
				} elsif($abo_score>=$left_score){
					$score[$i][$j]=$abo_score;
					$pointer[$i][$j] = "above";
				} else{
					$score[$i][$j]=$left_score;
					$pointer[$i][$j] = "left";
				}
			}
		}
	}
	
	#Print the Resulting Scoring Matrix 
	print "\n This is the scoring matrix:\n";
		printarray(\@score, \$row, \$col);
		print "\n";

	#Print the optimal sequence alingment
	print "This is the optimal sequence alignment:\n";
		seq_NW(\@pointer, \@seq1, \@seq2, \$row, \$col);
		print "\n";

	#Print the optimal score
	seq_score(\@seq1, \@seq2, $gap, $mismatch, $match);
}

if($ans==2){
	
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
	my $sq1 = "ATTCGA";
	my $sq2 = "ACGATA";
	#my $sq1 = "GAGATTTGACTCATGCTATT";	
	#my $sq2 = "GGAGATTTGACTCATGCTAT";
	my $gap=-1; my $mismatch=0;
	my $match = 1; my $i_max; my $j_max;
	
	#Initialize Variables
	my @score = (); my @pointer=();
	my $abo_score; my $left_score; my $diag_score;
	my @seq1_final; my @seq2_final;
	
	#Turn sequences into arrays
	my @seq1 = split '', $sq1;
	my @seq2 = split '', $sq2;

	#Determine the parameters of the matrix based on sequence lengths
	my $row = scalar(@seq1)+1;
	my $col = scalar(@seq2)+1;
	
	#Create a matrix of sequence letters, and matrix scores
	#For each row position add either the sequence letter, or matrix score
	for (my $i=0; $i < $row; $i++) {
		
		#Create the scoring penalty
		for (my $j=0; $j < $col; $j++) {
			
			#If in the first row or column, create gap penalty
			if ($i==0){
				$score[$i][$j] = 0;
				$pointer[$i][$j] = "left";
			}elsif($j==0){
				$score[$i][$j] = 0;
				$pointer[$i][$j] = "above";
			} else {
		
				### 1) Calculate diag score: match then +match, otherwise +mismatch
				if($seq1[$j-1] =~ $seq2[$i-1]){
					$diag_score = $score[$i-1][$j-1]+$match;
				} else{$diag_score = $score[$i-1][$j-1]+$mismatch;
				
				### 2) Calculate above/left scores by score +gap penalty
				} 	$abo_score = $score[$i-1][$j]+$gap;
					$left_score = $score[$i][$j-1] + $gap;
							
				#Determine the highest score to use, and create pointer matrix
				if($diag_score>=$abo_score&& $diag_score>=$left_score){
					$score[$i][$j]=$diag_score;
					$pointer[$i][$j] = "diag";
				} elsif($abo_score>=$left_score){
					$score[$i][$j]=$abo_score;
					$pointer[$i][$j] = "above";
				} else{
					$score[$i][$j]=$left_score;
					$pointer[$i][$j] = "left";
				}
			}
		}
	}

	#Print the Resulting Scoring Matrix 
	print "\n This is the scoring matrix:\n";
		printarray(\@score, \$row, \$col);
		print "\n";

	#Calculate the maximum score position to begin
	seq_max(\@score,\$i_max, \$j_max, \$row, \$col);	
	

	#Print the optimal sequence alingment
	print "This is the optimal sequence alignment:\n";
		seq_SW(\@score, \@pointer, \@seq1, \@seq2, \$row, \$col, \$i_max, \$j_max);
		print "\n";
	#Print the optimal score
	#seq_score(\@seq1, \@seq2, $gap, $mismatch, $match);
}


########################################################################################
################################# SUBROUTINES ##########################################
########################################################################################

#This subroutine takes in a matrix, and prints each component row by column
sub printarray {
	
	#Initialize Variables
	my ($array, $row, $col) = @_;

	#Create loop to print the array
	for (my $i=0; $i < $$row; $i++) {
		for (my $j=0; $j < $$col; $j++) {
			#print " $$array[$i][$j]  ";
			printf "%5d", $$array[$i][$j];
		} print "\n";
	}
}

sub seq_max{
	
	#Initialize Variables
	my ($score, $i_max, $j_max, $row, $col) = @_;
	my $current=0; my $max=0;
	my $i=0; my $j=0;

	#Pass through the scoring matrix to determine the highest value, save the value location
	for ($i=0; $i < $$row; $i++) {
		for ($j=0; $j < $$col; $j++) {
			$current = $$score[$i][$j];
			if ($current > $max){
				$$i_max = $i;
				$$j_max = $j;
				$max = $$score[$i][$j];
			}
		}

	}
	
	#Offset the counter for sequence alignment
}

sub seq_NW{
	
	#Initialize Variables
	my ($pointer, $seq1, $seq2, $row, $col)=@_;
	my @seq1_final; my @seq2_final;

	##Sequence 1
	my $tcol=$$col-1;
	my $trow=$$row-1; my $n=0;
	
	#For each column position add either the sequence letter, or matrix score
	until ($n>$$col){
		if($$pointer[$trow][$tcol]=~ "diag"){
			unshift (@seq1_final, $$seq1[$tcol-1]);
			$trow=$trow-1;
			$tcol=$tcol-1;
		} elsif($$pointer[$trow][$tcol]=~"above"){
			unshift (@seq1_final, "-");
			$trow=$trow-1;
		} else{
			unshift (@seq1_final, $$seq1[$tcol-1]);
			$tcol=$tcol-1;
		} 
		$n++;
	}

	##Sequence 2
	$tcol=$$col-1;
	$trow=$$row-1; $n=0;
		
	#For each column position add either the sequence letter, or matrix score
	until ($n>$$row){
		if($$pointer[$trow][$tcol]=~ "diag"){
			unshift (@seq2_final, $$seq2[$trow-1]);
			$trow=$trow-1;
			$tcol=$tcol-1;
		} elsif($$pointer[$trow][$tcol]=~"left"){
			unshift (@seq2_final, "-");
			$tcol=$tcol-1;
		} else{
			unshift (@seq2_final, $$seq2[$trow-1]);
			$trow=$trow-1;
		} 
		$n++;
	}

	#Print the optimal sequences
	foreach my $line (@seq1_final){
		print "$line  ";
	} print "\n";
	
	foreach my $line (@seq2_final){
		print "$line  ";
	} print "\n";
}

sub seq_SW{
	
	#Initialize Variables
	my ($score, $pointer, $seq1, $seq2, $row, $col, $i_max,$j_max)=@_;
	my @seq1_final; my @seq2_final;

	#Begin as the highest score position (imax,jmax) and move through matrix by following
	#the pointer. Stop when the scoring matrix reaches a score of 0, for sequence 1.
	my $tcol=$$j_max; 	my $trow=$$i_max; my $n=0;
	
	until ($$score[$trow][$tcol]==0){
		if($$pointer[$trow][$tcol]=~ "diag"){
			unshift (@seq1_final, $$seq1[$tcol-1]);
			$trow=$trow-1;
			$tcol=$tcol-1;
		} elsif($$pointer[$trow][$tcol]=~"above"){
			unshift (@seq1_final, "-");
			$trow=$trow-1;
		} else{
			unshift (@seq1_final, $$seq1[$tcol-1]);
			$tcol=$tcol-1;
		} 
		$n++;
	}

	#Begin as the highest score position (imax,jmax) and move through matrix by following
	#the pointer. Stop when the scoring matrix reaches a score of 0, for sequence 2.
	$tcol=$$j_max; $trow=$$i_max; $n=0;
		
	until ($$score[$trow][$tcol]==0){
		if($$pointer[$trow][$tcol]=~ "diag"){
			unshift (@seq2_final, $$seq2[$trow-1]);
			$trow=$trow-1;
			$tcol=$tcol-1;
		} elsif($$pointer[$trow][$tcol]=~"left"){
			unshift (@seq2_final, "-");
			$tcol=$tcol-1;
		} else{
			unshift (@seq2_final, $$seq2[$trow-1]);
			$trow=$trow-1;
		} 
		$n++;
	}

	#Print the optimal sequences
	foreach my $line (@seq1_final){
		print "$line  ";
	} print "\n";
	
	foreach my $line (@seq2_final){
		print "$line  ";
	} print "\n";
}

sub seq_score{
	
	#Initialize Variables
	my ($seq1_final, $seq2_final, $gap, $mismatch, $match) = @_;
	my $score=0; my $n=0;

	#Print the optimal sequence1
	foreach my $line (@$seq1_final){
		if($line =~ $$seq2_final[$n]){
			$score=$score + $match;
			$n++;
		} elsif($line=~ "-"){
			$score=$score+$gap;
			$n++;
		} else{$score=$score+$mismatch};
	} 
	print "The optimal alignment has a score of: $score\n\n";
}

