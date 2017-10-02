#User: Samantha Sevilla
#Date: 09/18/17
#Course: BINF690
#Chapter 13, 14
#!/usr/bin/perl

#Initialize Values
my $d, $fx1, $fx2, $fx3;
my $x0, $x1, $x2, $x3; 
my $EA=100;
my $R = ((5**(.5))-1)*(.5);
my $xopt, $num, $den;

print "Which problem: 1) 13.1-Golden OR 2) Parabolic  3) NM-Max/Min 4) random Max \n";
my $ans = <STDIN>; chomp $ans;

if($ans==1){

	##Inputs
	my $xl=0;
	my $xu=4;
	my $EA_val = 1;


	until ($EA < $EA_val){

		#Print the Current Lower and Upper Limits
		print "xL: $xl | xU: $xu | EA: $EA\n";

		#Calculate the D, X1, and X2 per golden-section
		$d = (((5)**(1/2)-1)/2)*($xu-$xl);
		$x1 = $xl + $d;
		$x2 = $xu - $d;
		
		#Determine FX values
		$fx1 = fx($x1);
		$fx2 = fx($x2);
		$xopt=$xu-$xl;
		
		#Change Lower and Upper Value based on FX Values
		if($fx1>$fx2){
			$xl=$x2;
			$xopt=$x2;
		} else {
			$xu=$x1;
			$xopt=$x1;
		}
		
		#Find the EA for the current iteration
		$EA = ((1-$R)*($xu-$xl)*(1/$xopt))*100;
	}
}

if($ans==2){
	
	#Inputs
	$x0=0;
	$x1=1;
	$x2=4;
	$n=1;
	
	until ($n > 5){
				
		$fx0=fx($x0);
		$fx1=fx($x1);
		$fx2=fx($x2);
		
		$num =($fx0*($x1**2-$x2**2)+$fx1*($x2**2-$x0**2)+$fx2*($x0**2-$x1**2));
		$den=(2*$fx0*($x1-$x2)+2*$fx1*($x2-$x0)+2*$fx2*($x0-$x1));
		$x3=$num/$den;
		$fx3=fx($x3);
	
		if($x3>$x1){
			$x0=$x1;
			$x1=$x3;
		} else{
			$x2=$x1;
			$x1=$x3;
		}
			
	#Print the Current Lower and Upper Limits
	print "f0: $fx0 | f1: $fx1 | f2: $fx2 | f3:$fx3\n";
	
	$n++;
	}
	$x3 = sprintf ("%.5f", $x3);
	print "The final solution is $x3";
}

if($ans==3){
	
	#Inputs
	my $x=2.5;
	
	#Initialize
	my $x_new=$x;
	my $x_old;
		
	until ($n > 5){
				
		$fx=fx($x_new);
		$fx_1=fx1d($x_new);
		$fx_2=fx2d($x_new);
	
		#Print the Current Lower and Upper Limits
		print "i:$n | x: $x_new | FX: $fx\n";	
		
		#Calculate the man/min using the NM formula, saving the new X
		$x_old=$x_new;
		$x_new=$x_old - $fx_1/$fx_2;
			
	$n++;
	}
	
	#Print the final value
	$x_new = sprintf ("%.5f", $x_new);
	print "The final solution is $x_new";
}


if($ans==4){
	#Initialize Variables
	my $x; my $y; my $r;
	my $max_x=0; my $max_y=0;
	my $fx_current=0; my $fx_old=0;
	
	for (my $i=0; $i<2000; $i++){
		$r=rand(1);
		$x = -2 + 4*$r;
		$y = 1+ 2*$r;
		
		$fx_current = $y - $x - 2*$x**2 - 2*$x*$y - $y**2;
		if ($fx_current>$fx_old){
			$max_x=$x;
			$max_y=$y;
		}
		print "$fx_current\n";
		$fx_old=$fx_current;
	}
	
	print "X: $max_x, Y: $max_y, FX: $fx_current";
}

######################################################################################
								##SUBROUTINE##
######################################################################################

sub fx{
	#Initialize
	my ($x)=@_;
		##Inputs
	my $fx = 2*sin($x) - ($x**2)/10;
	
	return $fx;
}

sub fx1d{
	#Initialize
	my ($x)=@_;
		##Inputs
	my $fx = 2*cos($x) - ($x)/5;
	
	return $fx;
}

sub fx2d{
	#Initialize
	my ($x)=@_;
		##Inputs
	my $fx = -2*sin($x) - 1/5;
	
	return $fx;
}