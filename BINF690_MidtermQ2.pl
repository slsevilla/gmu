#User: Samantha Sevilla
#Date: 10/10
#Course: BINF690
#Midterm Q2
#!/usr/bin/perl
use strict; 
######################################################################################
								##NOTES##
######################################################################################
#This code takes in the information from the user relating the number of equation and variables and then performs Gaussian elimination. The output of the code is the N# of X variables, solved, as well as verification of the solution. Finally the code will ask the user whether or not they would like to calculate the determinant before ending.
#Search for ###UPDATE to update the necessary variables and ###TESTING for testing shortcuts



######################################################################################
								##Code##
######################################################################################
#Initialize values
my $n=0; my $e=1;my $v=1; my $i=0;
my %variables; my %variables_ori;
my @ans; my @pos; my @terms;

#Number of variables and equations
###UPDATE the number of equations and variables
my $eq = 3; my $var = 3;

#Create variables depending on N equations and N variables	
until ($i>$eq-1){		
	until  ($n>$var){

		#Create the A variable positions until N variables met, then create B variable
		if($n<$var){
			my $temp = "a";
			$temp .=$e;	$temp .=$v;
			push (@pos,$temp);
		} else{
			my $temp = "b";	$temp .=$e;
			push (@pos,$temp);
		} $v=$v+1; $n++;
	}

	# Increase counts, reset after full equation set
	$i++; $e=$e+1; $n=0; $v=1;
}

#Ask user for variable values, saving to hash with position as key
foreach $i (@pos){
	###UPDATE the term values
	@terms = qw(6 15 55 152.6 15 55 225 585.6 55 225 979 2488.8);
	
	#Create a hash of the variables and values
	my $temp = $terms[$n];
	$variables{@pos[$n]}=$temp;
	$n++;
}

#Save has of original variables
%variables_ori=%variables;

#Call variables to manipulate equations, and then solve for X's
eq_man(\%variables, \@pos, \$eq, \$var);
eq_solve(\%variables, \@pos, \@terms, \@ans, \$eq, \$var);
eq_verify(\%variables_ori, \@pos, \@ans, \$eq, \$var);

#Ask user if the determinant is needed
print "\n Do you want the determinant?\n";
print "Ans:";
my $det = <STDIN>; chomp $det;
if ($det=~'Y'){
	determinant(\%variables, \@pos, \@ans, \$eq, \$var);
}

######################################################################################
								##Subroutine##
######################################################################################
sub eq_man{
	
	#Initialize Variables
	my ($variables, $pos, $eq, $var)=@_;
	my $n=0; my $fac; my $temp;
	my $pairs = 0; my $iter=0;
	my $rounds=0; my $prim=0; my $prim_old=0;
	my $sec=$$var+1;
	my @primary; my @secondary; 
	
	
	#Eliminate variables moving through each variable
	until($rounds>$$eq-2){
		
		#For each equation pair, determine the factor, and eliminate one variable until the secondary N equals the N of equations
		until ($pairs>$$eq-2){
			
			#Create array of primary and secondary positions
			until ($iter > $$var) {
				$temp=@$pos[$prim];
				push (@primary,$temp);
				$prim=$prim+1;

				$temp=@$pos[$sec];
				push (@secondary,$temp);
				$sec=$sec+1;
				$iter=$iter+1;
			}
			
			#Calculate factor
			$fac = $$variables{$secondary[$rounds]} / $$variables{$primary[$rounds]};
		
			#For each equation, multiple the factor and eliminate the variable
			until($n>$$var){
			
				$$variables{$secondary[$n]}= $$variables{$secondary[$n]}-$$variables{$primary[$n]}*$fac;
				
				#Increase the counter
				$n++;
			}
			
			#Increase/reset the counters
			$pairs = $pairs +1;
			$n=0; $prim =$prim_old;
			$iter=0; @secondary=();
			@primary=(); 
		}
		
		#Set the next equation as the primary equation
		$prim=$prim_old+$$var+1; ##Sets the new primary equation location
		$prim_old = $prim;		##Saves this location for iterations
		
		$rounds = $rounds+1; ##Increases the round
		$pairs = $rounds;	#Sets the pair number as the round
		$sec=$$var+1+$prim; ##Sets the new secondary equation position
	}
	
	###TESTING
	#for my $pos (keys %$variables){
	#	print "the value of '$pos' is $variables{$pos}\n";
	#}
}

sub eq_solve{
	
	#Initialize Values
	my ($variables, $pos, $terms, $ans, $eq, $var)=@_;
	my $n=0;
	my $length=scalar @$pos - 1;
	my $add=1; my $num=0;
	my $den; my $sol=$$eq;

	#Determine the solution for each equation
	until ($n==$$eq){
		
		##For each variable, multiply times EQ+1's solution
		foreach my $line (@$ans){
			$num = $num+$line*$$variables{@$pos[$length-$add]};
			$add = $add+1;
		}
		
		#Subtract EQ's B value to determine numerator
		$num = $$variables{@$pos[$length]}-$num;

		#Determine the denominator
		$den = $$variables{@$pos[$length-$add]};

		#Push the answer to Answer Array
		push(@$ans,sprintf("%.4f",$num/$den));
		
		#Move to the next line of equations, set counters
		$length=$length-$$var-1;
		$add=1; $num=0;
		$n++;
	}

	#Print the final solution
	print "\n";
	foreach my $line (@$ans){
		print "X$sol: $line\n";
		$sol=$sol-1;
	}
}

sub eq_verify{
	
	#Initialize Variables
	my ($variables_ori, $pos, $ans, $eq, $var)=@_;
	my $sol=0; my $n=1; my $i=1; my $count=0;
	my $iter=$$var-1;
	print "\n";
	
	#For each equation verify the answers solved above
	until ($n>$$eq){
		
		#For each variable, multiple term by answer
		until ($i>$$var){
			$sol = $sol + $$variables_ori{@$pos[$count]}*@$ans[$iter];
			$i++;
			$count = $count+1;
			$iter=$iter-1;
		}
		
		#Print the solved solution, and equation solution
		print "EQ$n: Calulated Sol using ans:$sol verifies to EQ Sol $$variables_ori{@$pos[$count]}\n";
		
		#Reset and increase counters
		$count = $count+1;
		$n++; $sol=0; $i=1;
		$iter=$$var-1;
	}
}

sub determinant{

	#Initialize Variables
	my ($variables, $pos, $eq, $var)=@_;
	my $constant; $n=1; my $term;
	my $determinant =0; 
	until ($n>3){
		
		#Create the determinant term
		$term = "a1"; $term .= $n;
		$constant = %$variables{$term};
		if($n==1) {
				$determinant = $constant*(%$variables{'a22'}*%$variables{'a33'}-%$variables{'a32'}*%$variables{'a23'});
		} elsif ($n==2){
				$determinant = $determinant - $constant*(%$variables{'a21'}*%$variables{'a33'}-%$variables{'a31'}*%$variables{'a23'});
		} elsif ($n==3){
				$determinant = $determinant + $constant*(%$variables{'a21'}*%$variables{'a32'}-%$variables{'a31'}*%$variables{'a22'});
		}
	$n++;
	}
	print "the determinant is: $determinant";

}

