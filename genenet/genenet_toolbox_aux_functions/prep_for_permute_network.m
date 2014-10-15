%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Calculates parameters that each permutation will need.
%Implementation:
%Keywords: network permutation preparation parameters DAPPLE
%Example: This is an auxiliary file. It is not intended for direct calling by the user.

% This file is distributed as part of GeneNet Toolbox.
% Copyright (C) 2014  Avigail Taylor.
%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License 
% as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
% 
% You can contact the author at avigail.taylor@dpag.ox.ac.uk

function [ each_node_degree , set_sizes , node_degrees , unique_degree_node_indices ] = prep_for_permute_network( network_matrix )

% find all possible node degrees in the network, and the number of nodes with each degree *****
each_node_degree = sum( network_matrix , 2 );

if( length( find( each_node_degree == 0 ) ) > 0 )
    err = MException( '' , 'ERROR: there are singleton nodes in the network' );
    throw( err );
end

[ set_sizes , node_degrees ] = hist( each_node_degree , 1:max( each_node_degree ) );

unique_degrees = node_degrees( find( set_sizes == 1 ) );
unique_degree_node_indices = find( ismember( each_node_degree ,unique_degrees ) );

end


