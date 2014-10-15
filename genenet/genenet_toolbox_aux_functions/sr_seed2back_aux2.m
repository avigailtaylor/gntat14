%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Called by sr_seed2back_aux. Carries out the nuts and bolts of the seed to backbone analysis using seed randomisation.
%Implementation: See main paper and supplemental materials.
%Keywords: seed randomisation backbone
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

function [ total_nodes , numeric_dir_network , numeric_context_network , observed , expected , p_value ,...
    network_matrix , seed_bb_indices , seed_indices_connected_to_bb , bb_indices , num_edges_to_bb , num_edges_to_bb_exp , p_value_to_bb ,...
    num_seeds_connected_to_bb , num_bb_connected_to_seeds , bb_subtotal_of_total_nodes ] =...
    sr_seed2back_aux2( numeric_edgelist , numeric_seed_bb_list , numeric_bb_list , numeric_seed_list , rands , nD_bins , parallelise , varargin )

% Parse parameter value pairs
gui_handles_available = false;

n_varargin = length( varargin );
for kk = 1:2:n_varargin
    switch lower( varargin{ kk } )
        case 'gui_handles'
            gui_handles_available = true;
            gui_handles = varargin{ kk + 1 };
        otherwise
            err = MException( '' , [ 'ERROR: Unknown parameter ' , varargin{kk} , '.' ] );
            throw( err );
    end
end


% format the network into a matrix *****************************************************************
[ network_matrix , ordered_nodelist ] = edgelist2matrix( numeric_edgelist , 'sparse' );

% get the seed and bb indices *****************************************************************************
seed_bb_indices = get_seed_indices_in_network_matrix( numeric_seed_bb_list , ordered_nodelist );
seed_bb_indices = seed_bb_indices( find( seed_bb_indices ) ); % get rid of zeros

% get the edge counts and the total number of nodes in the direct network *************************
seed_bb_edge_counts = sum( network_matrix( seed_bb_indices , seed_bb_indices ) , 2 );
total_nodes = length( find( seed_bb_edge_counts ) );

% set up the variable node_indices for use a  bit later on **************
node_indices = 1:length( ordered_nodelist );

% get the indices for those seeds that are not in the backbone (numeric_seed_list) *************
seed_indices = get_seed_indices_in_network_matrix( numeric_seed_list , ordered_nodelist );
seed_indices = seed_indices( find( seed_indices ) ); % get rid of zeros

% get the indices for the backbone nodes **********************************************************
bb_indices = get_seed_indices_in_network_matrix( numeric_bb_list , ordered_nodelist );
bb_indices = bb_indices( find( bb_indices ) ); % get rid of zeros

% get the total number of edges from seeds to backbone ********************************************
num_edges_to_bb = sum( sum( network_matrix( seed_indices , bb_indices ) ) );

% find the seed_sub_indices of the seeds that are connected to the backbone ***********************
seed_indices_connected = seed_indices( find( sum( network_matrix( seed_indices , bb_indices ) , 2 ) ) );

% get the total number of seeds connected to backbone ********************************************
num_seeds_connected_to_bb = length( find( sum( network_matrix( seed_indices , bb_indices ) , 2 ) ) );

% get the total number of backbone nodes connected to seeds ***************************************
num_bb_connected_to_seeds = length( find( sum( network_matrix( bb_indices , seed_indices ) , 2 ) ) );

% get the total number of backbone nodes in the overall seed and bb
% network... that is the nodes in total_nodes (see above) that are backbone
bb_subtotal_of_total_nodes = length( find( sum( network_matrix( bb_indices , seed_bb_indices ) , 2 ) ) );

%***************************************************************************************************

% initialise storage for randomisations **************************************************************
all_rand_seed_bb_edges = zeros( 1 , rands );
all_rand_num_edges_to_bb = zeros( 1 , rands );

% randomisations *************************************************************************************
if( parallelise )
    matlabpool
end

if( gui_handles_available )
    for I = 1:10:rands
        set( gui_handles.static_progress_status , 'string' , [ int2str( I - 1 ) ' out of ' int2str( rands ) ' randomisations completed' ] );
        drawnow
        if(  get( gui_handles.toggle_cancel , 'Value' ) == 1 )
            err = MException( '' , 'User requested cancel' );
            throw( err );
        end
        
        if( parallelise )
            parfor i = I:( min( [ ( I + 9 ) rands ] ) )
                drawnow % we can call drawnow to update gui even though we can't access gui_handles from within parfor loop...
                % but we can't check for cancel
                
                random_seed_indices = randomise_seeds( node_indices , bb_indices , seed_indices , nD_bins );
                all_rand_seed_bb_edges( i ) = sum( sum( network_matrix( [ random_seed_indices ; bb_indices ] , [ random_seed_indices; bb_indices ] ) ) ) / 2;
                all_rand_num_edges_to_bb( i ) = sum( sum( network_matrix( random_seed_indices , bb_indices ) ) );
            end
        else
            for i = I:( min([ ( I + 9 ) rands ] ) )
                drawnow 
                
                random_seed_indices = randomise_seeds( node_indices , bb_indices , seed_indices , nD_bins );
                all_rand_seed_bb_edges( i ) = sum( sum( network_matrix( [ random_seed_indices ; bb_indices ] , [ random_seed_indices ; bb_indices ] ) ) ) / 2;
                all_rand_num_edges_to_bb( i ) = sum( sum( network_matrix( random_seed_indices , bb_indices ) ) );
            end
        end
    end
else
    
    if( parallelise )
        parfor i = 1:rands
            random_seed_indices = randomise_seeds( node_indices , bb_indices , seed_indices , nD_bins );
            all_rand_seed_bb_edges( i ) = sum( sum( network_matrix( [ random_seed_indices ; bb_indices ] , [ random_seed_indices ; bb_indices ] ) ) ) / 2;
            all_rand_num_edges_to_bb( i ) = sum( sum( network_matrix( random_seed_indices , bb_indices ) ) );
        end
    else
        for i = 1:rands
            random_seed_indices = randomise_seeds( node_indices , bb_indices , seed_indices , nD_bins );
            all_rand_seed_bb_edges( i ) = sum( sum( network_matrix( [ random_seed_indices ; bb_indices ] , [ random_seed_indices ; bb_indices ] ) ) ) / 2;
            all_rand_num_edges_to_bb( i ) = sum( sum( network_matrix( random_seed_indices , bb_indices ) ) );
        end
    end
end

if( parallelise )
    matlabpool close
end
%****************************************************************************************************

% calculate observed, expected and p-values for various edge statistics *****************************

observed = sum( seed_bb_edge_counts ) / 2;
expected = mean( all_rand_seed_bb_edges );
p_value = ( length( find( all_rand_seed_bb_edges >= observed ) ) + 1) / ( rands + 1 );

% output the seeds that are connected to the backbone ***********************************************
seed_indices_connected_to_bb = ordered_nodelist( seed_indices_connected );

% get the expected number of edges to the backbone *******************************************
num_edges_to_bb_exp = mean( all_rand_num_edges_to_bb );

% get the p_value for the number of edges to the backbone *******************************************
p_value_to_bb = ( length( find( all_rand_num_edges_to_bb >= num_edges_to_bb ) ) + 1) / ( rands + 1 );

% output the actual networks ************************************************************************
context_node_indices = unique( [ seed_bb_indices; find( sum( network_matrix( seed_bb_indices , : ) ) )' ] );

[ Idir , Jdir ] = find( triu( network_matrix( seed_bb_indices , seed_bb_indices ) ) );
numeric_dir_network = [ ordered_nodelist( seed_bb_indices( Idir ) ) ordered_nodelist( seed_bb_indices( Jdir ) ) ];

[ Icontext , Jcontext ] = find( triu( network_matrix( context_node_indices , context_node_indices ) ) );
numeric_context_network = [ ordered_nodelist( context_node_indices( Icontext ) ) ordered_nodelist( context_node_indices( Jcontext ) ) ];

end


