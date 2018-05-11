#User: Samantha Sevilla
#Date: 10/29
#Course: BINF730
#Homework 3
#!/usr/bin/perl
use strict;

######################################################################################
								##NOTES##
######################################################################################
#Search for ###UPDATE to update necessary inputs before running

######################################################################################
								##CODE##
######################################################################################
#Chose the method
print "Which method to run?\n";
print "1) WPGMA\n";
print "2) UPGMA\n";
print "3) Neighbor Adjoining\n";
print "ANS:";
	my $ans = <STDIN>; chomp $ans;
	
if ($ans==1){
	#Initialize Variables
	my @a = qw(A C T G G G C T);
	my @b = qw(C G T G A G C T);
	my @c = qw(A G T G G G C T);
	my @d = qw(C C C G G A G T);

	wpgma(\@a, \@b, \@c, \@d);
} if ($ans==2){
	#Initialize Variables
	my @a = qw(A C T G G G C T);
	my @b = qw(C G T G A G C T);
	my @c = qw(A C T G G G T T);
	my @d = qw(C C T T A G C T);
	
	upgma(\@a, \@b, \@c, \@d);

} if ($ans==3){
	#Initialize Variables
	my @a = qw(A C T G G G C T);
	my @b = qw(C G T G A G C T);
	my @c = qw(A C T G G G T T);
	my @d = qw(C C T T A G C T);
	my @e = qw(C G T G A G C A);
	my @f = qw(A C T G G G T T);
	
	neighbor_adj(\@a, \@b, \@c, \@d, \@e, \@f);
}

######################################################################################
								##Subroutines##
######################################################################################
sub wpgma{
	#Take in Variables
	my ($a, $b, $c, $d)=@_;
	
	#Initialize Variables
	my @matrixvalues; my $current; my $i1_max; my $i2_max;
	my $iter=1; my @branch = qw (A B C D);

	#Determine the matrix limits
	my $row = scalar @branch-1;
	my $col = $row;
	
	#Send the sequences to be compared, and scores generated
	for (my $i=0; $i<$row+1; $i++){
		if($i==0){
			matrix_scores(\@matrixvalues, \@$a, \@$a, \@$b, \@$c, \@$d, \$i);
		} elsif($i==1){
			matrix_scores(\@matrixvalues, \@$b, \@$a, \@$b, \@$c, \@$d, \$i);
		} elsif($i==2){
			matrix_scores(\@matrixvalues, \@$c, \@$a, \@$b, \@$c, \@$d, \$i);
		} else{matrix_scores(\@matrixvalues, \@$d, \@$a, \@$b, \@$c, \@$d, \$i);
		}
	}
	
	for (my $i=0; $i<$row; $i++){
			my $newrow=$row-$i; my $newcol=$col-$i;

			#Determine the matrix minimum
			matrix_min(\@matrixvalues, \$i1_max, \$i2_max, \$iter, \$newrow, \$newcol);
				
			#Print the location of the first branch
			find_branch(\@branch, \$i1_max, \$i2_max);
				print "\nThe top connection is located between @branch[0]\n";
				print "The distance matrix for this branch was:\n";
			printarray(\@matrixvalues, \$newrow, \$newcol);
			
			#Reset the values and perform the tree matrix again
			max_shift(\@matrixvalues, \$i1_max, \$i2_max, \$newrow, \$newcol,\$iter);
		}
}

sub upgma{
	#Take in Variables
	my ($a, $b, $c, $d)=@_;
	
	#Initialize Variables
	my @matrixvalues; my $current; my $i1_max; my $i2_max;
	my $iter=1; my @branch = qw (A B C D);

	#Determine the matrix limits
	my $row = scalar @branch-1;
	my $col = $row;
	
	#Send the sequences to be compared, and scores generated
	for (my $i=0; $i<$row+1; $i++){
		if($i==0){
			matrix_scores(\@matrixvalues, \@$a, \@$a, \@$b, \@$c, \@$d, \$i);
		} elsif($i==1){
			matrix_scores(\@matrixvalues, \@$b, \@$a, \@$b, \@$c, \@$d, \$i);
		} elsif($i==2){
			matrix_scores(\@matrixvalues, \@$c, \@$a, \@$b, \@$c, \@$d, \$i);
		} else{matrix_scores(\@matrixvalues, \@$d, \@$a, \@$b, \@$c, \@$d, \$i);
		}
	}
	
	for (my $i=0; $i<$row; $i++){
		my $newrow=$row-$i; my $newcol=$col-$i;

		#Determine the matrix minimum
		matrix_min(\@matrixvalues, \$i1_max, \$i2_max, \$iter, \$newrow, \$newcol);
			
		#Print the location of the first branch
		find_branch(\@branch, \$i1_max, \$i2_max);
			print "\nThe top connection is located between @branch[0]\n";
			print "The distance matrix for this branch was:\n";
		printarray(\@matrixvalues, \$newrow, \$newcol);
		
		#Reset the values and perform the tree matrix again
		max_shift(\@matrixvalues, \$i1_max, \$i2_max, \$newrow, \$newcol,\$iter);
		
	}
}

sub neighbor_adj{
	#Take in Variables
	my ($a, $b, $c, $d, $e, $f)=@_;
	
	#Initialize Variables
	my @matrixvalues; my $current; my $i1_max; my $i2_max;
	my $iter=1; my @branch = qw (A B C D E F); my @sum_terms;
	my @calmatrix; my $branchlength1; my $branchlength2;
	
	#Determine the matrix limits
	my $row = scalar @branch-1;
	my $col = $row;
	
	#Send the sequences to be compared, and scores generated
	for (my $i=0; $i<$row+1; $i++){
		if($i==0){
			matrix_scores_adj(\@matrixvalues, \@$a, \@$a, \@$b, \@$c, \@$d, \@$e, \@$f, \$i);
		} elsif($i==1){
			matrix_scores_adj(\@matrixvalues, \@$b, \@$a, \@$b, \@$c, \@$d, \@$e, \@$f, \$i);
		} elsif($i==2){
			matrix_scores_adj(\@matrixvalues, \@$c, \@$a, \@$b, \@$c, \@$d, \@$e, \@$f,\$i);
		}  elsif($i==3){
			matrix_scores_adj(\@matrixvalues, \@$d, \@$a, \@$b, \@$c, \@$d, \@$e, \@$f,\$i);
		} elsif($i==4){
			matrix_scores_adj(\@matrixvalues, \@$e, \@$a, \@$b, \@$c, \@$d, \@$e, \@$f,\$i);
		} else{
			matrix_scores_adj(\@matrixvalues, \@$f, \@$a, \@$b, \@$c, \@$d,\@$e, \@$f, \$i);
		}
	}
	
	#Sum the terms (S values), and calculate the matrix (M values)
	term_sum(\@matrixvalues, \@calmatrix, \@branch, \@sum_terms);

	for (my $i=0; $i<$row; $i++){
		my $newrow=$row-$i; my $newcol=$col-$i;

		#Determine the matrix minimum
		matrix_min(\@calmatrix, \$i1_max, \$i2_max, \$iter, \$newrow, \$newcol);
			
		#Print the location of the first branch
		find_branch(\@branch, \$i1_max, \$i2_max);
		branch_length(\@matrixvalues,\@sum_terms, \$branchlength1, \$branchlength2, \$i1_max, \$i2_max);
			print "\nThe top connection is located between @branch[0]\n";
			print "the branch distances from U$i is $branchlength1 and $branchlength2\n";
			print "The distance matrix for this branch was:\n";
		printarray(\@calmatrix, \$newrow, \$newcol);
		
		#Reset the values and perform the tree matrix again
		max_shift_adj(\@matrixvalues, \$i1_max, \$i2_max, \$newrow, \$newcol,\$iter);
	}
}

sub matrix_scores_adj{
	my ($matrixvalues, $set, $value1, $value2, $value3, $value4, $value5, $value6, $row)=@_;
	my $n; my @score; my @matrix = @$matrixvalues;
	
	#Create scoring matrix
	for(my $i=0; $i<$$row; $i++){
		push (@score, "0");
	}
		
	#Compare the Sequences to one another, saving values to matrix
	foreach(@$set){
		if(@$set[$n] ne @$value1[$n]){
			$score[0] = $score[0] + 1;
		} if (@$set[$n] ne  @$value2[$n]){
			$score[1] = $score[1] + 1;
		} if (@$set[$n] ne  @$value3[$n]){
			$score[2] = $score[2] + 1;
		} if (@$set[$n] ne  @$value4[$n]){
			$score[3] = $score[3] + 1;
		} if (@$set[$n] ne  @$value5[$n]){
			$score[4] = $score[4] + 1;
		}if (@$set[$n] ne  @$value6[$n]){
			$score[5] = $score[5] + 1;
		}
			$n++;
		}

	for (my $i=0; $i<scalar(@score); $i++){
		$$matrixvalues[$$row][$i]=$score[$i];
	}
}

sub branch_length{
	my ($matrixvalues, $sum_terms, $branchlength1, $branchlength2, $i1_max, $i2_max)=@_;

	my $max = $$matrixvalues[$$i1_max][$$i2_max];
	my $u1sum = $$sum_terms[$$i1_max]-$$sum_terms[$$i2_max];
	my $u2sum = $$sum_terms[$$i2_max]-$$sum_terms[$$i1_max];
	
	$$branchlength1 = ($max/2)+($u1sum/2);
	$$branchlength2 = ($max/2)+($u2sum/2);
}


sub max_shift_adj{
	my ($matrixvalues, $i1_max, $i2_max, $row, $col,$iter)=@_;
	my @newmatrix; my $j_old=0; my $i_old=0;
	my @oldmatrix = @$matrixvalues;
	my $max = $$matrixvalues[$$i1_max][$$i2_max];
		
	for (my $i=0; $i<=$$row-$$iter; $i++){
		for (my $j=0; $j<=$$col-$$iter; $j++){
			if ($i==$j){
				$newmatrix[$i][$j] = "0";
			} elsif($i==0){
				if($j==$$i1_max){
					$newmatrix[$i][$j] = ($oldmatrix[$$i1_max-1][$$i1_max] + $oldmatrix[$$i1_max-1][$$i2_max])-$max; 
				} elsif($j==$$i2_max){
					$newmatrix[$i][$j] = ($oldmatrix[$$i2_max+1][$$i1_max] + $oldmatrix[$$i2_max+1][$$i2_max])-$max; 
				} else{
					$newmatrix[$i][$j] = ($oldmatrix[$j][$$i1_max] + $oldmatrix[$j][$$i2_max])-$max; 
				}
			} elsif($j==0){
				if($i==$$i1_max){
					$newmatrix[$i][$j] = ($oldmatrix[$$i1_max-1][$$i1_max] + $oldmatrix[$$i1_max-1][$$i2_max])-$max;
				} elsif($i==$$i2_max){
					$newmatrix[$i][$j] = ($oldmatrix[$$i2_max+1][$$i1_max] + $oldmatrix[$$i2_max+1][$$i2_max])-$max; 		
				} else{
					$newmatrix[$i][$j] = ($oldmatrix[$$i1_max][$i] + $oldmatrix[$$i2_max][$i])-$max; 
				}
			} elsif($j==$$i1_max){
				if($i==$$i2_max){
					$newmatrix[$i][$j] = $oldmatrix[$i+1][$j-1];
				} else{$newmatrix[$i][$j] = $oldmatrix[$i][$j-1];}
			} elsif($j==$$i2_max){
				if($i==$$i1_max){
					$newmatrix[$i][$j] = $oldmatrix[$i-1][$j+1];
				} else{$newmatrix[$i][$j] = $oldmatrix[$i][$j+1];}
			} else{
				if($i==$$i2_max){
					$newmatrix[$i][$j] = $oldmatrix[$i+1][$j];
				} elsif($i==$$i1_max){
					$newmatrix[$i][$j] = $oldmatrix[$i-1][$j];
				} else{$newmatrix[$i][$j] = $oldmatrix[$i][$j];}
			}
		}
	}
	@$matrixvalues=@newmatrix;
}

sub term_sum{
	#Take in variables
	my ($matrixvalues, $calcmatrix, $branch,$sum_terms)=@_;

	#Initialize Variables
	my $n=0; my $length = scalar @$branch; my @newmatrix;
	my $x=1;
	
	#Calculate Term Sums
	for(my $j=0; $j<$length; $j++){
		for(my $i=0; $i<$length; $i++){
			@$sum_terms[$j]= @$sum_terms[$j] + $$matrixvalues[$i][$j];
		}
	}
	
	#Determine and print the final S = Dx/(n/2) value for each term
	$n=0;
	foreach my $temp1 (@$sum_terms){
		@$sum_terms[$n]=$temp1/($length-2);
		$n++;
	} $n=0;
		
	#Calculate the M matrix from Dij - Si - Sj
	for(my $i=0; $i<$length; $i++){
		for (my $j=0; $j<$length; $j++){
			if($i==$j){
				$newmatrix[$i][$j]=0;
			} else{
				$newmatrix[$i][$j]=$$matrixvalues[$i][$j]-@$sum_terms[$i] - @$sum_terms[$j];
			}
		}
	}
	
	@$calcmatrix=@newmatrix;
}

sub matrix_scores{
	my ($matrixvalues, $set, $value1, $value2, $value3, $value4, $row)=@_;
	my @score=qw(0 0 0 0); my $n; my $i=0;
	my @matrix = @$matrixvalues;
	
	#Compare the Sequences to one another, saving values to matrix
	foreach(@$set){

		if(@$set[$n] ne @$value1[$n]){
			$score[0] = $score[0] + 1;
		} if (@$set[$n] ne  @$value2[$n]){
			$score[1] = $score[1] + 1;
		} if (@$set[$n] ne  @$value3[$n]){
			$score[2] = $score[2] + 1;
		} if (@$set[$n] ne  @$value4[$n]){
			$score[3] = $score[3] + 1;
		}
		$n++;
	}
		
	#Use the Jukes-Cantor model to determine distance matrix
	foreach (@score){
		$score[$i]=abs(-(3/4)*(log(1-(4/3)*($score[$i]/scalar@$set))/log(10)));
		$i++;
	}
	
	for (my $i=0; $i<scalar(@score); $i++){
		$$matrixvalues[$$row][$i]=$score[$i];
	}
}

sub max_shift{
	my ($matrixvalues, $i1_max, $i2_max, $row, $col,$iter)=@_;
	my @newmatrix; my $j_old=0; my $i_old=0;
	my @oldmatrix = @$matrixvalues;
	
	for (my $i=0; $i<=$$row-$$iter; $i++){
		for (my $j=0; $j<=$$col-$$iter; $j++){
			if ($i==$j){
				$newmatrix[$i][$j] = "0";
			} elsif($i==$$i2_max or $j==$$i2_max){
				if($i==0){
					$newmatrix[$i][$j] = ($oldmatrix[$$i1_max][$j+1] + $oldmatrix[$$i2_max][$j+1])/2;
				} elsif($j==0){
					$newmatrix[$i][$j] = ($oldmatrix[$i+1][$$i1_max] + $oldmatrix[$i+1][$$i2_max])/2;
				} else{
					if($i==$$i2_max){
						$newmatrix[$i][$j]=$oldmatrix[$i+$$iter][$j];
					} else{
						$newmatrix[$i][$j]=$oldmatrix[$i][$j+$$iter];
					}
				}
			} elsif($$iter==1){
				if($i==0){
					$newmatrix[$i][$j] = ($oldmatrix[$$i1_max][$j] + $oldmatrix[$$i2_max][$j])/2;
				} else{
					$newmatrix[$i][$j] = ($oldmatrix[$i][$$i1_max] + $oldmatrix[$i][$$i2_max])/2;
				}
			} elsif($$iter==2){
				if($i==0){
					$newmatrix[$i][$j] = ($oldmatrix[$$i1_max][$j] + $oldmatrix[$$i2_max][$j])/2;
				} else{
					$newmatrix[$i][$j] = ($oldmatrix[$i][$$i1_max] + $oldmatrix[$i][$$i2_max])/2;
				}
			}
		}
	}
	@$matrixvalues=@newmatrix;
}

sub find_branch{
	my($branch, $i1_max, $i2_max)=@_;
	my $i=0; my @solution; my $save;
	
	#Determine the branch match
	foreach my $temp (@$branch){
		if ($i==$$i1_max){
			$save .= @$branch[$i];
		} elsif($i==$$i2_max){
			$save .= @$branch[$i];
		} else {
			push(@solution,$$branch[$i]);
		}
		$i++;
	}
	unshift(@solution,$save);

	@$branch=@solution;
}

sub matrix_min{
	my ($matrixvalues, $i1_max, $i2_max, $iter, $row, $col)=@_;
	my $max=100; my $current; 
	
	#Search through the matrix to determine lowest values
	for (my $i=0; $i <= $$row; $i++) {
		for (my $j=0; $j <= $$col; $j++) {
			$current = $$matrixvalues[$i][$j]; 
			
			if ($current < $max && $current !=0){
				$$i1_max = $i;
				$$i2_max = $j;
				$max=$current;
			}
		}
	}
}

#This subroutine takes in a matrix, and prints each component row by column
sub printarray {
	
	#Initialize Variables
	my ($array, $row, $col) = @_;

	#Create loop to print the array
	for (my $i=0; $i <= $$row; $i++) {
		for (my $j=0; $j <= $$col; $j++) {
			$$array[$i][$j]= sprintf("%.2f",$$array[$i][$j]);
			print " $$array[$i][$j]  ";
		} print "\n";
	}
}
