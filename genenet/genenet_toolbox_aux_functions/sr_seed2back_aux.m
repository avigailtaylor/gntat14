%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Called by sr_seed2back. Calls sr_seed2back_aux2 to do most of the work required for seed to backbone analysis using seed randomisation. Converts seed indices and numeric networks back into original node names. Also draws the direct network comprised of seeds and backbone nodes.
%Implementation:
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

function [ total_nodes , dir_network , context_network , observed , expected , p_value ,...
    num_edges_to_bb , num_edges_to_bb_exp , seeds_connected_to_bb , p_value_to_bb , num_seeds_connected_to_bb , num_bb_connected_to_seeds , bb_subtotal_of_total_nodes ] =...
    sr_seed2back_aux( numeric_edgelist , ordered_nodelist , numeric_seed_bb_list , numeric_bb_list , numeric_seed_list , seed_bb_in_network ,...
    rands , nD_bins , parallelise , quickview_flag , varargin )

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

% OK - Let's do this !! ***************************************************************************

if( gui_handles_available )
    [ total_nodes , numeric_dir_network , numeric_context_network , observed , expected , p_value , network_matrix ,...
        seed_bb_indices , seed_indices_connected_to_bb , bb_indices , num_edges_to_bb , num_edges_to_bb_exp , p_value_to_bb ,...
        num_seeds_connected_to_bb , num_bb_connected_to_seeds , bb_subtotal_of_total_nodes ] =...
        sr_seed2back_aux2( numeric_edgelist , numeric_seed_bb_list , numeric_bb_list , numeric_seed_list , rands , nD_bins , parallelise , 'gui_handles' , gui_handles);
else
    [ total_nodes , numeric_dir_network , numeric_context_network , observed , expected , p_value , network_matrix ,...
        seed_bb_indices , seed_indices_connected_to_bb , bb_indices , num_edges_to_bb , num_edges_to_bb_exp , p_value_to_bb , num_seeds_connected_to_bb ,...
        num_bb_connected_to_seeds , bb_subtotal_of_total_nodes ] =...
        sr_seed2back_aux2( numeric_edgelist , numeric_seed_bb_list , numeric_bb_list , numeric_seed_list , rands , nD_bins , parallelise );
end

seeds_connected_to_bb = ordered_nodelist( seed_indices_connected_to_bb );
dir_network = [ ordered_nodelist( numeric_dir_network( : , 1 ) ) ordered_nodelist( numeric_dir_network( : , 2 ) ) ];
context_network = [ ordered_nodelist( numeric_context_network( : , 1 ) ) ordered_nodelist( numeric_context_network( : , 2 ) ) ];

% plot direct network *****************************************************************************
if( quickview_flag )
   
    direct_network_matrix = network_matrix( seed_bb_indices , seed_bb_indices );
    seed_bb_with_edges = find( sum( direct_network_matrix ) );
     
    direct_network_matrix_useful = double( direct_network_matrix( seed_bb_with_edges , seed_bb_with_edges ) ); % needs to be converted to double for remaining function calls to work.
 
    [ ~ , bb_indices_in_direct_network ] = ismember( bb_indices , seed_bb_indices(seed_bb_with_edges) );
    bb_indices_in_direct_network = bb_indices_in_direct_network( find( bb_indices_in_direct_network ) );

    if( gui_handles_available )
        set( gui_handles.static_progress_status , 'string' , 'Drawing direct network of seeds and backbone-nodes' );
        drawnow
        if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
            err = MException( '' , 'User requested cancel' );
            throw( err );
        end
    end
    
    coords = fruc_rein( direct_network_matrix_useful , 0.1 );
    
    if( gui_handles_available )
        wgPlot( direct_network_matrix_useful , coords , 'vertexlabel' , seed_bb_in_network( seed_bb_with_edges ) , 'vertexweight' , ( ones( size( seed_bb_with_edges ) ) ) ,...
            'gui_handles' , gui_handles , 'highlight' , bb_indices_in_direct_network );       
    else
        figure;
        wgPlot( direct_network_matrix_useful , coords , 'vertexlabel' , seed_bb_in_network( seed_bb_with_edges ) , 'vertexweight' , ( ones( size( seed_bb_with_edges ) ) ) ,...
                'highlight' , bb_indices_in_direct_network );
    end
end
end
