#User: Samantha Sevilla
#Date: 
#Course: BINF690
#Ch3 Assignment
#!/usr/bin/perl

use strict;
use warnings;

print "Which program (ES= A or INDEP = B or ROOT = C or E-Series = D)?";
	my $ans = <STDIN>; chomp $ans;

if($ans=~"A"){
	print "What is your ES:   ";
		my $es = <STDIN>; chomp $es;

	#Set Values
	my $val = exp(.5);
	my $x = .5; my $solnew;
	my $solold;

	#Run subroutine
	approx($val,$es, $x);

	sub approx{

		#Pass through variables
		my ($val, $es, $x) = @_;
		my $n=0; my $ea=100;

		#Run loop until the approx reaches past threshold
		until($ea<$es){
			if($n==0){
				$solnew = 1;
			}elsif($n==1){
				$solnew = 1+.5;
				$ea=abs(($solold-$solnew)/($solnew));
			} else{
				$solnew = $solold+($x**$n)/($n);
				$ea=abs(($solold-$solnew)/($solnew));
			}
			
			#Print values
			print "\nOld - Approx -- Error\n";
			print "$solold - $solnew - $ea\n";
			
			#Save old values, and increase counter
			$solold=$solnew; $n++;
		}
	}
} elsif ($ans=~"B"){
	my $n=0; my $sum1 =0;
	my $sum2 =0; my $sum3 =0;
	
	print "What is X1: ";
		my $X1=<STDIN>; chomp $X1;
	print "What is X2: ";
		my $X2=<STDIN>; chomp $X2;
	print "What is X3: ";
		my $X3=<STDIN>; chomp $X3;
	
	sum_indep($X1,$X2,$X3);
	
	sub sum_indep{
		my($X1,$X2,$X3)=@_;
		
		until($n==100000){
			$sum1 = $sum1 + $X1;
			$sum2 = $sum2 + $X2;
			$sum3 = $sum3 + $X3;
			$sum1 = sprintf "%.6f", $sum1;
			$sum2 = sprintf "%.6f", $sum2;
			print "$sum2 \n";
			$n++;
		}
		
		print "SUM1: $sum1 \n";
		print "SUM2: $sum2 \n";
		print "SUM3: $sum3 \n";
	}
} elsif ($ans=~"C"){
	
	my $a; my $b, my $c;

	input(\$a,\$b,\$c);

	sub input{
		
		my ($a, $b, $c)=@_;
			
		#Take in Variables A, B and C
		print "\n Variable A:";
			$$a = 1;
			### $$a = <STDIN>; chomp $$a;
			if($$a == "0") {print "\n**Cannot be a zero value**\n";
				exit;}
		print "\n Variable B:";
			$$b = 3000.001;
			### $$b = <STDIN>; chomp $$b;
			if($$b == "0") {print "\n**Cannot be a zero value**\n";
				exit;}
		print "\n Variable C:";
			$$c = 3;
			### $$c = <STDIN>; chomp $$c;
			if($$c == "0") {print "\n**Cannot be a zero value**\n";
				exit;}
				
	my $ans;
	my $x1=0; my $x2=0;
	my $num=0; my $denom=0;
	my $Rx1=-0.001; my $Rx2=-3000;

	#Single Precision
	$num = sprintf "%.7g",((($$b*$$b)-(4*$$a*$$c))**(1/2));
	print $num;
	$denom = sprintf "%.7g", (2*$$a);
	my $Sx1= sprintf "%.7g",((-$$b+$num)/$denom);
	my $Sx2=sprintf "%.7g",((-$$b-$num)/$denom);
	
	
	#Double precision
	$num = (($$b*$$b)-(4*$$a*$$c))**(1/2);
	print $num;
	$denom = 2*$$a;
	my $Dx1=(-$$b+$num)/$denom;
	my $Dx2=(-$$b-$num)/$denom;
		
	
	print "\nSingle: X1 is: $Sx1 and X2 value is $Sx2";
	print "\nDouble: X1 is: $Dx1 and X2 value is $Dx2";

	#Determine Error
	my $Ex1=abs(($Rx1-$Sx1)/($Sx2));
	my $Ex2=abs(($Rx1-$Sx1)/($Sx2));
	
	print "\nSingle: $Ex1";
	print "\nDouble: $Ex2";
	
	}	
} elsif ($ans=~"D"){
	my $n=0; my $sum=0; my $set_fac=2;
	my $term;
	
	#Take in Variables X1
	print "\n Variable X1:";
		my $x= <STDIN>; chomp $x;
		if($x == "0") {print "\n**Cannot be a zero value**\n";
			exit;}

	until ($n > 30){
	
		if($n==0){
			$sum=1;
		}elsif($n==1){
			$sum=$sum + $x;
		}elsif($n==2){
			$sum=$sum+((($x)**$n)/$n);
		} else{
			$set_fac = sprintf "%0.6f", ($set_fac * $n);
			$term = sprintf "%0.6f",((($x)**$n)/$set_fac);
			$sum=$sum+ $term;
			print "\n $n term $term\n";

		}
	$sum = sprintf "%0.6f", $sum;
	print "$sum\n";
	$n++;
	}
	
	print "X1 is: $sum";
}



else{exit;}