# Author: Avigail Taylor
# auxiliary perl script called by MATLAB function: edgelist_file_2_ordered_nodelist_and_numeric_edgelist

# This file is distributed as part of GeneNet Toolbox.
# Copyright (C) 2014  Avigail Taylor.
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
# 
# You can contact the author at avigail.taylor@dpag.ox.ac.uk

# $ARGV[0] edgelist_file
# $ARGV[1] header line flag
# $ARGV[2] ordered_nodelist_file (output)
# $ARGV[3] numeric_edgelist_file (output)

# set result code. 1 = executed without error, <0 = execution aborted due to error.
my $status_code = 1;

# open edgelist_file. Calling function will check that it exists.
open( NET , $ARGV[0] ) || ($status_code = -3);

# check if header line needs to be removed
if( $ARGV[1] == 1 ){
        <NET>;
}


# go through the edges in the network, giving each edge a number, and printing out the corresponding
# ordered_nodelist_file and numeric_edgelist_file

# we need a node counter so we can assign each node a unique number the first time it is seen in an edge.
my $node_counter=1;

# set up output files *****************************************
my $ordered_nodelist_file = $ARGV[2];
open( OUT_onf , ">$ordered_nodelist_file" ) || ($status_code = -2);

my $numeric_edgelist_file = $ARGV[3];
open( OUT_nef , ">$numeric_edgelist_file" ) || ($status_code = -2);
#*************************************************************

open( debug , ">/home/avigail/debug" );

while( <NET> ){
        if( $status_code < 0 ){
                last;
        }
	
        chomp;
        #if( ( $_ !~ /^\S+\s\S+$/ ) || ( $_ =~ /,/ ) ){
                #$status_code=-1;
        #}

	my @node_array = split(/\s/, $_);
	my $node_array_length = scalar @node_array;
	
	if( ( $node_array_length != 2 ) ){
		$status_code = -1;
	}
	else{
		my ( $node1, $node2 ) = split /\s/, $_;
		
		if( ( $node1 !~ /^\w+$/ ) || ( $node2 !~ /^\w+$/ ) ){
			$status_code = -1;
		}
        	else{
			print debug "$node1\t$node2\n";
			
                	#my ($node1, $node2) = split("\s+", $_);
			#my ($node1, $node2) = split /\s+/, $_;		

			if( !$ordered_nodelist_hash{$node1} ){
				$ordered_nodelist_hash{$node1} = $node_counter;
				print OUT_onf "$node1\n";
				$node_counter = $node_counter + 1;
			}

			if( !$ordered_nodelist_hash{$node2} ){
                        	$ordered_nodelist_hash{$node2} = $node_counter;
				print OUT_onf "$node2\n";
                        	$node_counter = $node_counter + 1;
               		}

			print OUT_nef "$ordered_nodelist_hash{$node1}\t$ordered_nodelist_hash{$node2}\n";		
          
        	}
	}
}

close(NET);
close(OUT_onf);
close(OUT_nef);

# print the error code so calling Matlab function knows if execution was completed.
print $status_code;
