%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Calculates simple network statistics.
%Implementation:
%Keywords: network statistics total edges nodes unique
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

function [ total_nodes , total_edges , total_u_nodes , total_u_edges ] = get_network_stats( network_matrix )

% prep for permutations ***************************************************************************
[ each_node_degree , ~ , ~ , unique_degree_node_indices ] = prep_for_permute_network( network_matrix );
%**************************************************************************************************

% get edge and node stats to return to calling function *******************************************
total_nodes = length( each_node_degree ); % by the time we get here it's safe to assume no singleton nodes
total_edges = sum( sum( network_matrix ) ) / 2;

total_u_nodes = length( unique_degree_node_indices );

not_unique_degree_node_indices = setdiff( 1:total_nodes , unique_degree_node_indices );
total_u_edges_a = sum(sum(network_matrix( unique_degree_node_indices , unique_degree_node_indices ) ) ) / 2;
total_u_edges_b = sum(sum(network_matrix( unique_degree_node_indices , not_unique_degree_node_indices ) ) );
total_u_edges = total_u_edges_a + total_u_edges_b;

end