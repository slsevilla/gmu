#User: Samantha Sevilla
#Date: 12/3
#Course: BINF690
#Chapter Monte Carlo
#!/usr/bin/perl
use strict;
use List::Util qw(reduce);
use List::Util qw( sum );
use GD::Graph::mixed;

######################################################################################
								##NOTES##
######################################################################################
#Performance of the MC algorithm, per the 11th homework instructions. Code is unable to accurately estimate the temperature over time

#Search for ###UPDATE to update necessary inputs before running

######################################################################################
								##CODE##
######################################################################################
energy();


######################################################################################
								##Subroutines##
######################################################################################
sub energy{
	#Initialize variables
	my $En; my $Eo; my $Es;
	my $xn; my $xo; my $x;
	my @energy; my @temp; my @count; my @arate;
	my $n=0;
	
	##UPDATE Initial Conditions
	my $kc=0.1;
	my $ti = 0.1; my $tf = .2;
	my $step =0.1;	my $dmax=10;
	my $tt= $ti/2;	
	
	#Determine the starting energy and x value
	my $x = 100; my $E=$kc*$x**2;
	my $counter=1;
	#my $accept=abs(($tt - $E)/($tt));
	my $accept=100;
	
	
	for (my $tn=$ti; $tn<$tf; $tn+=$step){
	
		until (.1 >= $accept | $counter>1000000){
			
			#Generate the random X, determine new energy, save old energy and x value 
			$xn = $x +(-1*$dmax + rand($dmax - (-1*$dmax)));
			$En=$kc*($xn**2);
			$Eo = $E; $xo = $x;

			#If the new energy is less than or equal to the old energy, accept the new x and new energy
			if($En<=$Eo){
				$x = $xn;
				$E = $En; 
				$counter = $counter+1;
				$Es = $Es + $E;
								
				#Determine the acceptance rate
				$tt= $tn/2;	
				$accept = abs(($tt - $E)/($tt));
								
				#If the new conformation (XN) does not pass the MC Criterion, then it fails
			} else{
				$x=$xo;
				$E=$Eo;
				$counter = $counter+1;
			}
		} 
		
		#Determine the average value
		$Es = $Es/$counter;
			
		#Save values to an array
		push (@energy, $E);	push (@arate, $accept);
		push (@temp, $tn);	push (@count, $counter);
		
		#Reset the counter
		$counter=0; $Es = 0;
		#$x = 100; $accept = 100;
	}
	print scalar @arate; print scalar @energy;
	
	#Print the values
	print "Temperature | Energy    |   Counter | AcceptRate\n";
	foreach (@temp){
		printf ("%.1f", $temp[$n]);
		printf ("          %.2e", $energy[$n]);
		printf ("     %2d", $count[$n]);
		printf ("         %.1f", $arate[$n]);
		print "\n";
		$n++;
	}
	
	#Graph Data
	graph_data(\@arate, \@energy);
}

sub graph_data{
	my ($data1_in, $data2_in)=@_;
	
	#Initialize Variables
	my @data; my @xval; my @yval;
	
	#Create file name
	my $file="Graph_EQ";

	#Pass through data
	@xval= @$data1_in;
	@yval = @$data2_in;
	@data = (\@xval,\@yval);
	
	#Set graph dimensions and label information for the points provided and linear
	#regression line
	my $graph = GD::Graph::mixed -> new(500,400);
		$graph -> set(
			types => [qw(line)],
			markers => 2,
			marker_size =>3,
			dclrs=>[qw(purple)],
			x_label => "ARate",
			y_label => "Energy",
			zero_axis=>"true",
			title => "Comparison Energy vs Acceptance Rate at T=0.1");
	
	#Create and save graph to gift file
	my $lineimage= $graph ->plot(\@data);
	open(IMG,"> $file.gif") or die$!;
		binmode IMG;
		print IMG $lineimage->gif;
		close IMG;
}