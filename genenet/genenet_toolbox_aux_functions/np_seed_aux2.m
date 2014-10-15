%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Called by np_seed_aux. Carries out the nuts and bolts of the seed connectivity analysis using network permutation.
%Implementation: See main paper and supplemental materials.
%Keywords: network permutation seed connectivity
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

function [ total_nodes , numeric_dir_network , numeric_indir_network , numeric_context_network , observed , expected , p_values , p_values_for_seeds , network_matrix , seed_indices ] =...
    np_seed_aux2( numeric_edgelist , numeric_seed_list , perms , num_switches , protect_perm_step , parallelise , varargin )

% Parse parameter value pairs
gui_handles_available = false;

n_varargin = length( varargin );
for kk = 1:2:n_varargin
    switch lower( varargin{ kk } )
        case 'gui_handles'
            gui_handles_available = true;
            gui_handles = varargin{ kk + 1 };
        otherwise
            err = MException( '' , [ 'ERROR: Unknown parameter ' , varargin{ kk } , '.' ] );
            throw( err );
    end
end


% format the network into a matrix *****************************************************************
[ network_matrix , ordered_nodelist ] = edgelist2matrix( numeric_edgelist , 'sparse' );

% get the seed indices *****************************************************************************
seed_indices = get_seed_indices_in_network_matrix( numeric_seed_list , ordered_nodelist );
seed_indices = seed_indices( find( seed_indices ) ); % get rid of zeros

% get the edge counts and the total number of nodes in the direct network *************************
seed_edge_counts = sum( network_matrix( seed_indices , seed_indices ) , 2 );
total_nodes = length( find( seed_edge_counts ) );

% get the indirect network edge counts and the CC degrees
%not_seed_indices = ordered_nodelist(find(~ismember(ordered_nodelist,seed_indices)));

node_indices = 1:length( ordered_nodelist );
not_seed_indices = setdiff( node_indices , seed_indices );

[ CC_mean_connectivity , seed_indir_edge_counts , seed_indir_edge_sum_weights ] = get_indirect_network_stats( network_matrix , seed_indices , not_seed_indices  );
%***************************************************************************************************


% initialise storage for permutations **************************************************************
all_perm_seed_edge_counts = zeros( length( seed_indices ) , perms );
all_perm_seed_indir_edge_counts = zeros( length( seed_indices ) , perms );
all_perm_seed_indir_edge_sum_weights = zeros( length( seed_indices ) , perms );
all_perm_mean_CC_connectivity = zeros( 1 , perms );

% prep for permutations ***************************************************************************
[ each_node_degree , set_sizes , node_degrees , unique_degree_node_indices ] = prep_for_permute_network( network_matrix );


% permutations *************************************************************************************
tic
if( parallelise )
    matlabpool
end

if( gui_handles_available )
    for I = 1:10:perms
        set( gui_handles.static_progress_status , 'string' , [ int2str( I - 1 ) ' out of ' int2str( perms ) ' permutations completed' ] );
        drawnow
        if(  get( gui_handles.toggle_cancel , 'Value' ) == 1 )
            err = MException( '' , 'User requested cancel');
            throw( err );
        end
        
        if( parallelise )
            parfor i = I:( min( [ ( I + 9 ) perms ] ) )
                drawnow % we can call drawnow to update gui even though we can't access gui_handles from within parfor loop...
                % but we can't check for cancel
                
                network_matrix_permuted = permute_network( network_matrix , each_node_degree , set_sizes , node_degrees , unique_degree_node_indices, num_switches , protect_perm_step );
                
                all_perm_seed_edge_counts( : , i ) = sum( network_matrix_permuted( seed_indices , seed_indices ) , 2 );
                
                [ perm_CC_mean_connectivity , perm_seed_indir_edge_counts , perm_seed_indir_edge_sum_weights ] =...
                    get_indirect_network_stats( network_matrix_permuted , seed_indices , not_seed_indices  );
                
                all_perm_mean_CC_connectivity( i ) = perm_CC_mean_connectivity;
                all_perm_seed_indir_edge_counts( : , i ) = perm_seed_indir_edge_counts;
                all_perm_seed_indir_edge_sum_weights( : , i ) = perm_seed_indir_edge_sum_weights;
                
            end
        else
            for i = I:( min( [ ( I + 9 ) perms ] ) )
                drawnow 
                
                if(  get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                    err = MException( '' , 'User requested cancel');
                    throw( err );
                end
                
                network_matrix_permuted = permute_network( network_matrix , each_node_degree , set_sizes , node_degrees , unique_degree_node_indices, num_switches , protect_perm_step );
                
                all_perm_seed_edge_counts( : , i ) = sum( network_matrix_permuted( seed_indices , seed_indices ) , 2 );
                
                [ perm_CC_mean_connectivity , perm_seed_indir_edge_counts , perm_seed_indir_edge_sum_weights ] =...
                    get_indirect_network_stats( network_matrix_permuted , seed_indices , not_seed_indices );
                
                all_perm_mean_CC_connectivity( i ) = perm_CC_mean_connectivity;
                all_perm_seed_indir_edge_counts( : , i ) = perm_seed_indir_edge_counts;
                all_perm_seed_indir_edge_sum_weights( : , i ) = perm_seed_indir_edge_sum_weights;
                
            end
        end
    end
    
else
    if( parallelise )
        parfor i = 1:perms
            
            network_matrix_permuted = permute_network( network_matrix , each_node_degree , set_sizes , node_degrees , unique_degree_node_indices, num_switches , protect_perm_step );
            
            all_perm_seed_edge_counts( : , i ) = sum( network_matrix_permuted( seed_indices , seed_indices ) , 2 );
            
            [ perm_CC_mean_connectivity , perm_seed_indir_edge_counts , perm_seed_indir_edge_sum_weights ] =...
                get_indirect_network_stats( network_matrix_permuted , seed_indices , not_seed_indices  );
            
            all_perm_mean_CC_connectivity( i ) = perm_CC_mean_connectivity;
            all_perm_seed_indir_edge_counts( : , i ) = perm_seed_indir_edge_counts;
            all_perm_seed_indir_edge_sum_weights( : , i ) = perm_seed_indir_edge_sum_weights;
        end
    else
        for i = 1:perms
            
            network_matrix_permuted = permute_network( network_matrix , each_node_degree , set_sizes , node_degrees , unique_degree_node_indices , num_switches , protect_perm_step );
            
            all_perm_seed_edge_counts( : , i ) = sum( network_matrix_permuted( seed_indices , seed_indices ) , 2 );
            
            [ perm_CC_mean_connectivity , perm_seed_indir_edge_counts , perm_seed_indir_edge_sum_weights ] =...
                get_indirect_network_stats( network_matrix_permuted , seed_indices , not_seed_indices  );
            
            all_perm_mean_CC_connectivity( i ) = perm_CC_mean_connectivity;
            all_perm_seed_indir_edge_counts( : , i ) = perm_seed_indir_edge_counts;
            all_perm_seed_indir_edge_sum_weights( : , i ) = perm_seed_indir_edge_sum_weights;
        end
    end
end

if( parallelise )
    matlabpool close
end
toc
%****************************************************************************************************

% calculate observed, expected and p-values for various edge statistics *****************************

observed_edge_count = sum( seed_edge_counts ) / 2;

if( sum( seed_edge_counts ) == 0 ) % find mean edge count
    observed_mean_edge_count = 0; % mean edge count is zero if there are no seeds in the network
else
    observed_mean_edge_count = mean( seed_edge_counts( find( seed_edge_counts ) ) ); % find mean edge count, but only for nodes in the network
end

if( sum( seed_indir_edge_counts ) == 0 ) % find mean indirect edge counts
    observed_mean_indir_edge_count = 0;
else
    observed_mean_indir_edge_count = mean( seed_indir_edge_counts( find( seed_indir_edge_counts ) ) );
end

if( sum( seed_indir_edge_sum_weights ) == 0 ) % find mean indirect edge sum weights
    observed_mean_indir_edge_sum_weight = 0;
else
    observed_mean_indir_edge_sum_weight = mean( seed_indir_edge_sum_weights( find( seed_indir_edge_sum_weights ) ) );
end

observed_CC_mean_connectivity = CC_mean_connectivity;

expected_edge_count = mean( sum( all_perm_seed_edge_counts , 1 ) / 2 );
p_value = ( length( find( ( sum( all_perm_seed_edge_counts , 1 ) / 2 ) >= observed_edge_count ) ) + 1 ) / ( perms + 1 );

edge_count_means = sum( all_perm_seed_edge_counts , 1 ) ./ sum( ( all_perm_seed_edge_counts > 0 ) , 1 );
% can't just do mean(all_perm_seed_edge_counts) because only want to divide by the number of nodes actually in the permuted networks
edge_count_means( find( isnan( edge_count_means ) ) ) = 0; % If there are no seeds in a permuted network then mean edge count is 0 (not NaN)
expected_mean_edge_count = mean( edge_count_means );
p_value2 = ( length( find( edge_count_means >= observed_mean_edge_count ) ) + 1 ) / ( perms + 1 );

indirect_edge_count_means = sum( all_perm_seed_indir_edge_counts , 1 ) ./ sum( ( all_perm_seed_indir_edge_counts > 0 ) , 1 );
indirect_edge_count_means( find( isnan( indirect_edge_count_means ) ) ) = 0;
expected_mean_indir_edge_count = mean( indirect_edge_count_means  );
p_value3 = ( length( find( indirect_edge_count_means >= observed_mean_indir_edge_count ) ) + 1 ) / ( perms + 1 );

indirect_edge_sum_weight_means = sum( all_perm_seed_indir_edge_sum_weights , 1 ) ./ sum( ( all_perm_seed_indir_edge_sum_weights > 0 ) , 1 );
indirect_edge_sum_weight_means( find( isnan( indirect_edge_sum_weight_means ) ) ) = 0;
expected_mean_indir_edge_sum_weight = mean( indirect_edge_sum_weight_means  );
p_value4 = ( length( find( indirect_edge_sum_weight_means >= observed_mean_indir_edge_sum_weight ) ) + 1 ) / ( perms + 1 );

expected_CC_mean_connectivity = mean( all_perm_mean_CC_connectivity );
p_value5 = ( length( find( all_perm_mean_CC_connectivity >= observed_CC_mean_connectivity ) ) + 1 ) / ( perms + 1 );

observed = [ observed_edge_count ; observed_mean_edge_count ; observed_mean_indir_edge_count ; observed_mean_indir_edge_sum_weight ; observed_CC_mean_connectivity ];
expected = [ expected_edge_count ; expected_mean_edge_count ; expected_mean_indir_edge_count ; expected_mean_indir_edge_sum_weight ; expected_CC_mean_connectivity ];
p_values = [ p_value ; p_value2 ; p_value3 ; p_value4 ; p_value5 ];
%****************************************************************************************************


% get the p_values for individual seeds in the direct network ***************************************
p_values_for_seeds = ( sum( bsxfun( @ge , all_perm_seed_edge_counts , seed_edge_counts ) , 2 ) + 1 ) ./ ( perms + 1 );
%****************************************************************************************************

% output the actual networks ************************************************************************
context_node_indices = unique( [seed_indices; find( sum( network_matrix( seed_indices , : ) ) )'] );

[ Idir , Jdir ] = find( triu( network_matrix( seed_indices , seed_indices ) ) );
numeric_dir_network = [ ordered_nodelist( seed_indices( Idir ) ) ordered_nodelist( seed_indices( Jdir ) ) ];

[ Icontext , Jcontext ] = find( triu( network_matrix( context_node_indices , context_node_indices ) ) );
numeric_context_network = [ ordered_nodelist( context_node_indices( Icontext ) ) ordered_nodelist( context_node_indices( Jcontext ) ) ];

numeric_indir_network = get_numeric_indirect_network( network_matrix , seed_indices , not_seed_indices , ordered_nodelist );
end


