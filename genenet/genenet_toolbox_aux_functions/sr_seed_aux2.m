%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Called by sr_seed_aux. Carries out the nuts and bolts of the seed connectivity analysis using seed randomisation.
%Implementation: See main paper and supplemental materials.
%Keywords: seed randomisation connectivity
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

function [ total_nodes , numeric_dir_network , numeric_context_network , observed , expected , p_value , network_matrix , seed_indices ] =...
    sr_seed_aux2( numeric_edgelist , numeric_seed_list , rands , nD_bins , parallelise , varargin )

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

% set up the variable node_indices for use a  bit later on **************
node_indices = 1:length( ordered_nodelist );
%***************************************************************************************************

% initialise storage for randomisations **************************************************************
all_rand_seed_edges = zeros( 1 , rands );

% randomisations *************************************************************************************
tic
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
                
                random_seed_indices = randomise_seeds( node_indices , [] , seed_indices , nD_bins );
                all_rand_seed_edges( i ) = sum( sum( network_matrix( random_seed_indices , random_seed_indices ) ) ) / 2;
            end
        else
            for i = I:( min( [ ( I + 9 ) rands ] ) )
                drawnow
                
                random_seed_indices = randomise_seeds( node_indices , [] , seed_indices , nD_bins );
                all_rand_seed_edges( i ) = sum( sum( network_matrix( random_seed_indices , random_seed_indices ) ) ) / 2;
            end
        end
    end
else
    if( parallelise )
        parfor i = 1:rands
            random_seed_indices = randomise_seeds( node_indices , [] , seed_indices , nD_bins );        
            all_rand_seed_edges(i) = sum( sum( network_matrix( random_seed_indices , random_seed_indices ) ) ) / 2;
        end
    else
        for i = 1:rands
            random_seed_indices = randomise_seeds( node_indices , [] , seed_indices , nD_bins );
            all_rand_seed_edges(i) = sum( sum( network_matrix( random_seed_indices , random_seed_indices ) ) ) / 2;
        end    
    end
end

if( parallelise )
    matlabpool close
end
toc
%****************************************************************************************************

% calculate observed, expected and p-value  *********************************************************
observed = sum( seed_edge_counts ) / 2;
expected = mean( all_rand_seed_edges );
p_value = ( length( find( all_rand_seed_edges >= observed ) ) + 1 ) / ( rands + 1 );
%****************************************************************************************************

% output the actual networks ************************************************************************
context_node_indices = unique( [ seed_indices ; find( sum( network_matrix( seed_indices , : ) ) )' ] );

[ Idir , Jdir ] = find( triu( network_matrix( seed_indices , seed_indices ) ) );
numeric_dir_network = [ ordered_nodelist( seed_indices( Idir ) ) ordered_nodelist( seed_indices( Jdir ) ) ];

[ Icontext , Jcontext ] = find( triu( network_matrix( context_node_indices , context_node_indices ) ) );
numeric_context_network = [ ordered_nodelist( context_node_indices( Icontext ) ) ordered_nodelist( context_node_indices( Jcontext ) ) ];

end


