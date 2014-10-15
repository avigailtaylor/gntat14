%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Permutes a network.
%Implementation: Implements the network permutation algorithm described in main paper and supplemental materials.
%Keywords: network permutation alteration optimisation optimization MATLAB DAPPLE
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

function network_matrix_permuted = permute_network( network_matrix , each_node_degree , set_sizes , node_degrees , unique_degree_node_indices , num_switches , protect_perm_step , varargin )

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

% distinguish unique-degree and not-unique-degree node indices -- useful for switching step *****
total_nodes = length( each_node_degree ); % by the time we get here it's safe to assume no singleton nodes
not_unique_degree_node_indices = setdiff( 1:total_nodes , unique_degree_node_indices );
%************************************************************************

node_indices_permuted = 1:length(each_node_degree);

% PERMUTE node indices within each node-degree set *********************************************

for i = 1:length( node_degrees )
    node_degree = node_degrees( i );
    num_nodes_with_degree = set_sizes( i );
    
    if( num_nodes_with_degree > 1 )
        node_indices_in_set = find( each_node_degree == node_degree );
        node_indices_permuted( node_indices_in_set ) = node_indices_in_set( randperm( num_nodes_with_degree ) );
    end
end

network_matrix_permuted = sparse( network_matrix( node_indices_permuted , node_indices_permuted ) );

%***********************************************************************************************

% SWITCHING STEP *******************************************************************************

if( length( unique_degree_node_indices) > 1 ) % CAN ONLY DO SWITCHING STEP IF THERE IS MORE THAN ONE NODE IN G_UNIQUE
    
    % keep track of removed edges so that we don't make them again
    if( protect_perm_step )
        % if a full mix up is required then do not re-instate any edges destroyed in the permutation step
        [ removed_edge_rows , removed_edge_cols ] = find( network_matrix == 1 & network_matrix_permuted == 0 );
        all_removed_edges = [ removed_edge_rows removed_edge_cols ];
    end
    
    for s = 1:num_switches
        
        %***************************************************************************************************************************
        %***************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        end
        %***************************************************************************************************************************
        %***************************************************************************************************************************
        
        % extract all the edges that link to this set of nodes --- edges are described as node_index to node_index
        % (as opposed to node_label to node_label).
        
        [ Iu , Ju ] = find( triu( network_matrix_permuted( unique_degree_node_indices , unique_degree_node_indices ) ) );
        edges = [ unique_degree_node_indices( Iu ) unique_degree_node_indices( Ju ) ];
        
        [ I , J ] = find(network_matrix_permuted( unique_degree_node_indices , not_unique_degree_node_indices ) );
        edges = [ edges ; [ unique_degree_node_indices( I ) not_unique_degree_node_indices( J )' ] ];
        
        clear Iu Ju I J;
        
        % permute the edges
        [ num_edges , ~ ] = size( edges );
        edges_permuted = edges( randperm( num_edges ) , : );
        
        % create random pairs
        if( mod( num_edges , 2) == 0 )
            x = num_edges / 2;
        else
            x = ( num_edges - 1 ) / 2;
        end
        
        % replace pairs of edges which cannot be switched with pairs that can be
        rps = [ edges_permuted( 1:x , : ) edges_permuted( ( x + 1 ):( x * 2 ) , : ) ]; % rps = random pairs
        impossible_switch_indices =...
            find( ( rps( : , 1 ) == rps( : , 2 ) ) | ( rps( : , 1 ) == rps( : , 3 ) ) | ( rps( : , 1 ) == rps( : , 4 ) ) |...
            ( rps( : , 2 ) == rps( : , 3 ) ) | ( rps( : , 2 ) == rps( : , 4 ) ) | (rps( : , 3) == rps( : , 4 ) ) );
        
        NUM_ATTEMPTS = 0;
        ATTEMPT_THRESH = 100; % NEED THESE TWO PARAMETERS TO AVOID INFINITE LOOP IN THE FOLLOWING:
        
        while( ( length( impossible_switch_indices ) > 0 ) & ( NUM_ATTEMPTS < ATTEMPT_THRESH ) )
            
            %************************************************************************************************************************
            %************************************************************************************************************************
            if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
                drawnow
                if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                    err = MException( '' , 'User requested cancel');
                    throw( err );
                end
            else
                drawnow
            end % if gui_handles are not available because of parfor loop, then all we can do is update the display (but we can't check for cancel)...
            % if gui_handles are not available because there is no gui, then this call to drawnow will return cleanly
            %************************************************************************************************************************
            %************************************************************************************************************************
            
            edges_permuted = edges( randperm( num_edges ) , : );
            rps( impossible_switch_indices , [3 4] ) = edges_permuted( [ 1:length( impossible_switch_indices ) ] , : );
            
            impossible_switch_indices =...
                find( ( rps( : , 1 ) == rps( : , 2 ) ) | ( rps( : , 1 ) == rps( : , 3 ) ) | ( rps( : , 1 ) == rps( : , 4 ) ) |...
                ( rps( : , 2 ) == rps( : , 3 ) ) | ( rps( : , 2 ) == rps( : , 4) ) | ( rps( : , 3 ) == rps( : , 4 ) ) );
            
            NUM_ATTEMPTS = NUM_ATTEMPTS + 1;
        end
        
        
        % check how we exited the loop. If there are still impossible switches we need to remove them, and inform the user
        if( length( impossible_switch_indices ) > 0 )
            [ num_r_pairs , ~ ] = size( rps );
            possible_switch_indices = setdiff( 1 : num_r_pairs , impossible_switch_indices );
            
            disp( [ 'WARNING: in switching step ' int2str(s) ' it was not possible to replace all impossible switches, so they were removed instead' ] );
            
            rps = rps( possible_switch_indices , : );
        end
        
        
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        % now randomly choose half of the edge-pairs to switch one way (the other half will be switched the other way)
        [ num_r_pairs , ~ ] = size( rps );
        flip_choice = randi( 2 ,num_r_pairs , 1 );
        
        % now SWITCH the nodes to make new edge-pairs (nep)
        
        nep = zeros( size( rps ) );
        nep( find( flip_choice == 1 ) , : ) = rps( find( flip_choice == 1 ) , [1 3 2 4] );
        nep( find( flip_choice == 2 ) , : ) = rps( find( flip_choice == 2 ) , [1 4 2 3] );
        clear rps flip_choice;
        
        % can only make a new pair of edges if both of them do not already exist in the permuted matrix
        
        tester =...
            logical( ( network_matrix_permuted( sub2ind( size( network_matrix_permuted ) , nep( : , 1 ) , nep( : , 2 ) ) ) ==0 ) &...
            ( network_matrix_permuted( sub2ind( size( network_matrix_permuted ) , nep( : , 3 ) , nep( : , 4 ) ) ) == 0 ) );
        
        nep = nep( tester , : );
        clear tester;
        
        if( protect_perm_step ) % only check against all_removed_edges when this flag is set.
            
            % only want to make a new pair of edges if neither of them are re-instating previously removed edges
            % note that all_removed_edges lists each edge twice (once in each direction).
            
            nep = nep( find( ~ismember( nep( : ,[ 1 2 ] ) , all_removed_edges , 'rows' ) & ~ismember( nep( : , [ 3 4 ] ) , all_removed_edges , 'rows' ) ) , : );
        end
        
        
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        % each new pair of edges can only be made if the pair of edges that are broken in the process are
        % only broken once.
        
        potential_removed_edge_pairs = nep( : , [ 1 3 2 4 ] );
        [ ~ , locb11 ] = ismember( potential_removed_edge_pairs( : , [ 1 2 ] ) , potential_removed_edge_pairs( : , [ 1 2 ] ) , 'rows' );
        [ ~ , locb12 ] = ismember( potential_removed_edge_pairs( : , [ 2 1 ] ) , potential_removed_edge_pairs( : , [ 1 2 ] ) , 'rows' );
        [ ~ , locb13 ] = ismember( potential_removed_edge_pairs( : , [ 1 2 ] ) , potential_removed_edge_pairs( : , [ 3 4 ] ) , 'rows' );
        [ ~ , locb14 ] = ismember( potential_removed_edge_pairs( : , [ 2 1 ] ) , potential_removed_edge_pairs( : , [ 3 4 ] ) , 'rows' );
        
        pot_rem_edge_1_max_location = max( [ locb11 locb12 locb13 locb14 ] , [] , 2 );
        
        clear locb11 locb12 locb13 locb14;
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        
        [ ~ , locb15 ] = ismember( potential_removed_edge_pairs( : , [ 3 4 ] ) , potential_removed_edge_pairs( : , [ 1 2 ] ) , 'rows' );
        [ ~ , locb16 ] = ismember( potential_removed_edge_pairs( : , [ 4 3 ] ) , potential_removed_edge_pairs( : , [ 1 2 ] ) , 'rows' );
        [ ~ , locb17 ] = ismember( potential_removed_edge_pairs( : , [ 3 4 ] ) , potential_removed_edge_pairs( : , [ 3 4 ] ) , 'rows' );
        [ ~ , locb18 ] = ismember( potential_removed_edge_pairs( : , [ 4 3 ] ) , potential_removed_edge_pairs( : , [ 3 4 ] ) , 'rows' );
        
        pot_rem_edge_2_max_location = max([ locb15 locb16 locb17 locb18 ] , [] , 2 );
        
        clear locb15 locb16 locb17 locb18;
        
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        [ num_pot_rem_pairs , ~ ] = size( potential_removed_edge_pairs );
        pot_rem_pair_indices = [ 1:num_pot_rem_pairs ]';
        
        potential_removed_edge_pairs_to_try =...
            potential_removed_edge_pairs( find( ( pot_rem_pair_indices == pot_rem_edge_1_max_location ) & ( pot_rem_pair_indices == pot_rem_edge_2_max_location ) ) , : );
        clear pot_rem_edge_1_max_location pot_rem_edge_2_max_location potential_removed_edge_pairs;
        % and the new edge pairs that we still want to try making are just:
        nep = potential_removed_edge_pairs_to_try( : , [ 1 3 2 4 ] );
        
        
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        % each new pair of edges can only be made if both edges are only created once in the whole process.
        % to ensure this, only keep a pair of edges if both are the last instance of themselves in the whole of
        % nep. (Ideally we would pick which instance to keep at random, but this would mean we
        % couldn't process all the edges with just a few matrix comparisons)
        
        [ ~ , locb1] = ismember( nep( : , [ 1 2 ] ) , nep( : , [ 1 2 ] ) , 'rows' );
        [ ~ , locb2] = ismember( nep( : , [ 2 1 ] ) , nep( : , [ 1 2 ] ) , 'rows' );
        [ ~ , locb3] = ismember( nep( : , [ 1 2 ] ) , nep( : , [ 3 4 ] ) , 'rows' );
        [ ~ , locb4] = ismember( nep( : , [ 2 1 ] ) , nep( : , [ 3 4 ] ) , 'rows' );
        
        edge_1_max_location = max( [ locb1 locb2 locb3 locb4 ] , [] , 2 );
        
        clear locb1 locb2 locb3 locb4;
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel');
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        
        [ ~ , locb5 ] = ismember( nep( : , [ 3 4 ] ) , nep( : , [ 1 2 ] ) , 'rows' );
        [ ~ , locb6 ] = ismember( nep( : , [ 4 3 ] ) , nep( : , [ 1 2 ] ) , 'rows' );
        [ ~ , locb7 ] = ismember( nep( : , [ 3 4 ] ) , nep( : , [ 3 4 ] ) , 'rows' );
        [ ~ , locb8 ] = ismember( nep( : , [ 4 3 ] ) , nep( : , [ 3 4 ] ) , 'rows' );
        
        edge_2_max_location = max( [ locb5 locb6 locb7 locb8 ] , [] , 2 );
        
        clear locb5 locb6 locb7 locb8;
        
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        [ num_new_edge_pairs , ~ ] = size( nep );
        pair_indices = [ 1:num_new_edge_pairs ]';
        
        new_edge_pairs_to_keep = nep( find( ( pair_indices == edge_1_max_location ) & ( pair_indices == edge_2_max_location ) ) , : );
        clear edge_1_max_location edge_2_max_location pair_indices;
        
        % and the edges to remove are just:
        edges_to_remove = new_edge_pairs_to_keep( : , [ 1 3 2 4 ] );
        
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        
        if( protect_perm_step ) % only update all_removed_edges when this flag is set.
            % update all_removed_edges
            all_removed_edges = [ all_removed_edges ; new_edge_pairs_to_keep( : , [ 1 3 ] );...
                new_edge_pairs_to_keep( : , [ 3 1 ] );...
                new_edge_pairs_to_keep( : , [ 2 4 ] );...
                new_edge_pairs_to_keep( : , [ 4 2 ] ) ];
        end
        
        
        %************************************************************************************************************************
        %************************************************************************************************************************
        if( gui_handles_available ) % gui_handles may not always be available, even if gui is being used, because cannot pass them from a parfor loop.
            drawnow
            if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
                err = MException( '' , 'User requested cancel' );
                throw( err );
            end
        else
            drawnow
        end
        %*************************************************************************************************************************
        %************************************************************************************************************************
        
        
        % update the permuted network matrix accordingly
        
        new_edge_pairs_to_keep_vec = [ new_edge_pairs_to_keep( : , [ 1 2 ] ) ; new_edge_pairs_to_keep( : , [ 3 4 ] ) ];
        edges_to_remove_vec = [ edges_to_remove( : , [ 1 2 ] ) ; edges_to_remove( : , [ 3 4 ] ) ];
        
        clear new_edge_pairs_to_keep edges_to_remove;
        
        num_nodes = length( each_node_degree );
        new_edges_sparse_matrix = logical( sparse( [ new_edge_pairs_to_keep_vec( : , 1 ) ; new_edge_pairs_to_keep_vec( : , 2 ) ] ,...
            [ new_edge_pairs_to_keep_vec( : , 2 ) ; new_edge_pairs_to_keep_vec( : , 1 ) ] , 1 , num_nodes , num_nodes ) );
        
        edges_to_remove_sparse_matrix = logical( sparse( [ edges_to_remove_vec( : , 1 ) ; edges_to_remove_vec( : , 2 ) ] ,...
            [ edges_to_remove_vec( : , 2 ) ; edges_to_remove_vec( : , 1 ) ] , 1 , num_nodes , num_nodes ) );
        
        clear new_edge_pairs_to_keep_vec edges_to_remove_vec;
        
        network_matrix_permuted = logical( (network_matrix_permuted + new_edges_sparse_matrix) - edges_to_remove_sparse_matrix );
        
        clear new_edges_sparse_matrix new_edges_sparse_matrix;
        
    end
else
    disp('WARNING: Switching step could not be performed because Gunique only contains one or less unique-degree nodes');
end

% this code ensures that type of network_matrix_permuted is the same as type of network_matrix... not sure if
% necessary to do this for calling function, but keeps things neat.
if( ~issparse( network_matrix ) )
    network_matrix_permuted = full( network_matrix_permuted );
end


end
