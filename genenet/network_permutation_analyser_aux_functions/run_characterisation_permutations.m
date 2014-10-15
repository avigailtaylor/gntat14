%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Characterises permutations of a network in terms of clustering coefficients and edge overlaps with the real network.
%Implementation:
%Keywords: characterise permutation permuted network clustering coefficient overlap network
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

function [ average_local_ccs , global_ccs , overlaps_with_network , overlaps_with_unique_network , num_Pedges_present_in_num_networks , num_networks ] = ...
    run_characterisation_permutations( network_matrix , permutations , num_switches , protect_perm_step , gui_handles )

average_local_ccs = zeros( 1 , permutations );
global_ccs = zeros( 1 , permutations );
overlaps_with_network = zeros( 1 , permutations );
overlaps_with_unique_network = zeros( 1 , permutations );
update_indices = find( triu( network_matrix ) );
edge_accumulator_vec = zeros( size ( update_indices ) );

% prep for permutations ***************************************************************************
[ each_node_degree , set_sizes , node_degrees , unique_degree_node_indices ] = prep_for_permute_network( network_matrix );
%**************************************************************************************************

for i = 1:permutations
    set( gui_handles.static_progress_status , 'string' , [ 'Starting permutation ' int2str(i) ' of ' int2str( permutations ) ] );
    drawnow
    if(  get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
    
    network_matrix_permuted = permute_network( network_matrix , ...
        each_node_degree , set_sizes , node_degrees , unique_degree_node_indices,...
        num_switches , protect_perm_step );
    
    
    set( gui_handles.static_progress_status , 'string' , [ 'Permutation ' int2str(i) ' of ' int2str(permutations) ' completed... now calculating cluster coefficients' ] );
    drawnow
    if(  get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
    
    [ ~ , average_local_cc , global_cc ] = calc_clustercoeffs( network_matrix_permuted , 'gui_handles' , gui_handles );
    average_local_ccs( i ) = average_local_cc;
    global_ccs( i ) = global_cc;
    
    set( gui_handles.static_progress_status , 'string' , ['Permutation ' int2str(i) ' of ' int2str(permutations) ' completed... now calculating overlap with real network'] );
    drawnow
    if(  get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
    
    overlaps_with_network( i ) = calc_overlap_with_network( network_matrix , network_matrix_permuted );
    overlaps_with_unique_network( i ) = calc_overlap_with_unique_network( network_matrix , network_matrix_permuted , unique_degree_node_indices );
    
    edge_accumulator_vec = edge_accumulator_vec + network_matrix_permuted( update_indices );
end

edge_accumulator_vec = edge_accumulator_vec( find( edge_accumulator_vec ) );
[ num_Pedges_present_in_num_networks , num_networks ] = hist( double( edge_accumulator_vec ) , 1:permutations );

end

