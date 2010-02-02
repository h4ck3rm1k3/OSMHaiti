# haiti conversion script
# copyright 2010 James Michael DuPont jamesmikedupont@googlemail.com
use warnings;
use strict;
my @titles;
my $id=0;
print "<osm version='0.6'>\n";
while (<>)
{
    chomp;

    s/\'/&quot;/g  ; # escape the '
    s/\&/&amp;/g  ; # escape the &

    my @vals =  

	split(/\t/);
       
    if (!@titles)
    {
	
	@titles=map {
	    s/\"([^\"]+)\"/$1/  ;
	    $_;
	}@vals;
    }
    else
    {
	my %obj;
	$id--;
	foreach my $t (@titles)
	{
	    my $v = shift @vals;

	    $v =~ s/\"([^\"]+)\"/$1/  ;
	    if ($v)
	    {
		$obj{$t}=$v;
	    }
	}

	my $x= $obj{"X_DDS"}; 
#	delete $obj{"X_DDS"};
	my $y = $obj{"Y_DDS"};
#	delete $obj{"Y_DDS"};
	my $name = $obj{"NomInstitu"}; 
	delete $obj{"NomInstitu"};
	
	next if $x eq "0.000000000000";
	next if $y eq "0.000000000000";
	die "$_" unless $obj{"HealthC_ID"};


	printf "<node id='%d' visible='true' version='1' lat='%s' lon='%s' >\n",$id,$y,$x;

	#healthC_ID

	$name = $name || "FIXME";
	print "<tag k='name' v='$name' />\n";

	#  from #jgc

	print "<tag k='amenity' v='hospital' />\n";
 	print "<tag k='source' v='$obj{Source}' />\n";

	print "<tag k='healthC_ID' v='$obj{HealthC_ID}' />\n";

	# dont do all the tags
	 # foreach my $t (sort keys %obj)
	 # {
	 #     my $v=$obj{$t};
	 #     $v =~ s/\'/"/g;
	 #     print "<tag k='MSPP:$t' v='$v' />\n";
	 # }
	print "</node>\n";

    }
    
}

print "</osm>\n";
