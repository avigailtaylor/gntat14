function [ total_nodes , bb_subtotal_of_total_nodes , dir_network , context_network , observed , expected , p_value , seed_bb_in_network , num_edges_to_bb , num_edges_to_bb_exp ,...
    seeds_connected_to_bb , num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] =...
    sr_seed2back_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , bb_file , bb_header , s_bb_comb , bb_bg_comb , rands ,...
    parallelise , quickview_flag , varargin )

% SYNTAX:
%
% [ total_nodes , bb_subtotal_of_total_nodes , dir_network , context_network , observed , expected , p_value , seed_bb_in_network , num_edges_to_bb , num_edges_to_bb_exp , seeds_connected_to_bb , num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = sr_seed2back_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , bb_file , bb_header , s_bb_comb , bb_bg_comb , rands , parallelise , quickview_flag , varargin )
%
% DESCRIPTION:
%
% Seed to backbone connectivity analysis using seed randomisation, and restricting the analysis to a specified sub-network (background) of the primary network.
%
% INPUT:
%
% ntwk_edgelist_file = (string) Full or relative path to text file containing the network of interest, represented as a list of edges (two columns, tab- or space-delimited). 
% ntwk_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in ntwk_edgelist_file.
% bg_file = (string) Full or relative path to text file containing nodes to be included in the background network (one column).
% bg_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in bg_file. 
% seed_file = (string) Full or relative path to text file containing the seeds to analyse (one column).
% s_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in seed_file.  
% bb_file = (string) Full or relative path to text file containing the backbone-nodes (one column).
% bb_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in bb_file.
% s_bb_comb = (integer with value 1, 2 or 3) 1 = treat joint seed/backbone as backbone; 2 = treat joint seed/backbone as seeds; 3 = treat joint seed/backbone as neither.
% bb_bg_comb = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to add backbone-nodes to the background.
% rands = (positive integer) Number of randomisations to perform.
% parallelise = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to use multiple processors for parallel randomisations.
% quickview_flag = boolean (true, false, 1 or 0)) Flag to indicate whether or not to plot a 'quickview' of the direct network among seeds.
%
% [varargin] = Specified as parameter value pairs where the parameters are:
%   'results_dir' = (string) Full or relative path to directory where results are to be stored. 
%   'results_tag' = (string) Tag with which to prefix all results files for this analysis.
%   'node_attribute_file' = (string) Full or relative path to text file containing node attributes to account for. The data should be stored as a table where rows are attributes and columns are nodes. The first row of the file must contain the node names, and the first column of the file must contain attribute names. The first element of the table (first row, first column) must be left blank. See user manual for further details.  
%   'node_attribute_indices' = (column or row vector of positive integers) Row indices (indexing starts at 1) into the table stored in node_attribute_file, corresponding to the attributes to account for. This must be supplied if node_attribute_file is supplied.
%   'node_attribute_bins' = (column or row vector of positive integers) Number of groups (or bins) to be used for each attribute. Must be the same length as node_attribute_indices. If this is not supplied, then a suggested 'best' number of groups for each attribute is calculated.  
%   'node_attribute_matrix_struct' = Used by GUI - not intended for use by user.
%   'gui_handles' = Used by GUI - not intended for use by user.
%
% OUTPUT:
% total_nodes = Total number of seeds and backbone-nodes in the direct network among seeds and backbone-nodes.
% bb_subtotal_of_total_nodes = Total number of backbone-nodes in the direct network among seeds and backbone-nodes.
% dir_network = N x 2 cell array of edges in the direct network among seeds and backbone-nodes.
% context_network =  M x 2 cell array of edges in the context network, where the context network is comprised of all nodes connected to a seed or backbone-node (including seeds and backbone-nodes), and all the edges among this set of nodes.
% observed = Total number of edges in the direct network among seed and backbone-nodes.
% expected = Expected number of edges in the direct network among seed and backbone-nodes (calculated as the mean number of edges found in direct networks amongst randomised seeds and backbone-nodes (backbone-nodes not randomised)).
% p-value = Empirical P-value for the observed number of edges in the direct network amonng seed and backbone-nodes.
% seed_bb_in_network = Cell array of seeds and backbone-nodes in the specified/ input network, that is, those seeds and backbone-nodes that could be analysed... this is *not* the same as the list of seeds and backbone-nodes particpating in the identified direct network.
% num_edges_to_bb = Total number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes.
% num_edges_to_bb_exp = Expected number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes. (Calculated as the mean observed over all sets of randomised seeds).
% seeds_connected_to_bb = Cell array of seeds connected to backbone-nodes in the direct network among seeds and backbone-nodes.
% num_seeds_connected_to_bb = Total number of seeds connected to one or more backbone-nodes in the direct network among seeds and backbone-nodes.
% num_bb_connected_to_seeds = Total number of backbone-nodes connected to one or more seeds in the direct network among seeds and backbone-nodes.
% p_value_to_bb = Empirical P-value for the observed number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes.
%
% SEE ALSO: sr_seed sr_seed_bg sr_seed2back np_seed np_seed_bg np_seed2back np_seed2back_bg
%
% By: Avigail Taylor  --  (July 2014)

%**************************************************************************
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
%**************************************************************************

% sanity-check the standard inputs
sanity_check_standard_inputs( 'sr_seed2back_bg' , ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , bb_file , bb_header , s_bb_comb , bb_bg_comb , rands ,...
    parallelise , quickview_flag );

% Parse parameter value pairs
results_dir_available = false;
results_dir = '';
results_tag_available = false;
results_tag = '';
node_attribute_matrix_struct_available = false;
node_attribute_file_available = false;
node_attribute_file = '';
node_attribute_indices_available = false;
node_attribute_indices = [];
node_attribute_bins_available = false;
node_attribute_bins = [];
gui_handles_available = false;

n_varargin = length( varargin );
for kk = 1:2:n_varargin
    switch lower( varargin{ kk } )
        case 'results_dir'
            results_dir_available = true;
            try
                results_dir = varargin{ kk + 1 };
            catch ME
                err = MException( '' , 'ERROR: results_dir is missing.' );
                throw( err );
            end
        case 'results_tag'
            results_tag_available = true;
            try
                results_tag = varargin{ kk + 1 };
            catch ME
                err = MException( '' , 'ERROR: results_tag is missing.' );
                throw( err );
            end
        case 'node_attribute_matrix_struct'
            node_attribute_matrix_struct_available = true;
            try
                node_attribute_matrix_struct = varargin{ kk + 1 };
            catch ME
                err = MException( '' , 'ERROR: node_attribute_matrix_struct is missing.' );
                throw( err );
            end
        case 'node_attribute_file'
            node_attribute_file_available = true;
            try
                node_attribute_file = varargin{ kk + 1 };
            catch ME
                err = MException( '' , 'ERROR: node_attribute_file is missing.' );
                throw( err );
            end
        case 'node_attribute_indices'
            node_attribute_indices_available = true;
            try
                node_attribute_indices = varargin{ kk + 1 };
            catch ME
                err = MException( '' , 'ERROR: node_attribute_indices is missing.' );
                throw( err );
            end
        case 'node_attribute_bins'
            node_attribute_bins_available = true;
            try
                node_attribute_bins = varargin{ kk + 1 };
            catch ME
                err = MException( '' , 'ERROR: node_attribute_bins is missing.' );
                throw( err );
            end
        case 'gui_handles'
            gui_handles_available = true;
            try
                gui_handles = varargin{ kk + 1 };
            catch ME
                err = MException( '' , 'ERROR: gui_handles is missing.' );
                throw( err );
            end
        otherwise
            err = MException( '' , [ 'ERROR: Unknown parameter ' , varargin{kk} , '.' ] );
            throw( err );
    end
end

% sanity-check the variable inputs
sanity_check_var_inputs( results_dir_available , results_dir , ...
    results_tag_available , results_tag , ...
    node_attribute_matrix_struct_available , ...
    node_attribute_file_available , ...
    node_attribute_file , ...
    node_attribute_indices_available , ...
    node_attribute_indices , ...
    node_attribute_bins_available );

% read node_attribute_file into a node_attribute_matrix_struct
if( node_attribute_file_available & node_attribute_indices_available )
    node_attribute_matrix_struct = node_attribute_file_2_struct( node_attribute_file , node_attribute_indices , node_attribute_bins_available, node_attribute_bins );
    node_attribute_matrix_struct_available = true;
end

% do some error checking ***************************************************************************
if( rands < 1  )
    err = MException( '' , 'ERROR: You need at least one randomisation, preferrably many more. Quitting now.' );
    throw( err );
end
%*************************************************************************************************

if( gui_handles_available )
    set( gui_handles.static_progress_status , 'string' , 'Loading seed, background and backbone files...' );
    drawnow
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
end

% read in the three nodelist files *******************************************
seed_names_CELLARRAY = read_nodelist_file( seed_file , s_header );
bg_names_CELLARRAY = read_nodelist_file( bg_file , bg_header );
bb_names_CELLARRAY = read_nodelist_file( bb_file , bb_header );
% ****************************************************************************

% make sure all the CELLARRAYs list each node name only once *****************
seed_names_CELLARRAY{ 1 } = unique( seed_names_CELLARRAY{ 1 } );
bg_names_CELLARRAY{ 1 } = unique( bg_names_CELLARRAY{ 1 } );
bb_names_CELLARRAY{ 1 } = unique( bb_names_CELLARRAY{ 1 } );
%*****************************************************************************

% deal with any overlap between seeds and backbone as the user has requested ******************
switch s_bb_comb
    case 1 % treat joint seed/bacbone names as backbone (remove from seeds)
        
        seed_names_not_in_bb = setdiff( seed_names_CELLARRAY{ 1 } , bb_names_CELLARRAY{ 1 } );
        seed_names_CELLARRAY{ 1 } = seed_names_not_in_bb;
        
    case 2 % treat joint seed/backbone names as seeds (remove from backbone)
        
        bb_names_not_in_seeds = setdiff( bb_names_CELLARRAY{ 1 } , seed_names_CELLARRAY{ 1 } );
        bb_names_CELLARRAY{ 1 } = bb_names_not_in_seeds;
        
    case 3 % treat joint seed/backbone names as neither (remove from both lists)
        
        seed_names_not_in_bb = setdiff( seed_names_CELLARRAY{ 1 } , bb_names_CELLARRAY{ 1 } );
        bb_names_not_in_seeds = setdiff( bb_names_CELLARRAY{ 1 } , seed_names_CELLARRAY{ 1 } );
        
        seed_names_CELLARRAY{ 1 } = seed_names_not_in_bb;
        bb_names_CELLARRAY{ 1 } = bb_names_not_in_seeds;        
end
% **********************************************************************************************

% combine backbone with background as the user has requested ***********************************
if( bb_bg_comb ) % user has asked to add backbone names to background **************************    
    bg_names_CELLARRAY{ 1 } = unique( cat( 1 , bg_names_CELLARRAY{ 1 } , bb_names_CELLARRAY{ 1 } ) );
end
% **********************************************************************************************

if( gui_handles_available )
    set( gui_handles.static_progress_status , 'string' , 'Making the background network...' );
    drawnow
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
end

%*************************************************************************************************
% get the ordered node list, and corresponding ordered combined seed and backbone(bb) list *******
% on this background *****************************************************************************

if( results_dir_available & results_tag_available )
    % print background network at the same time, if printing results later *******************
    [ ordered_nodelist , numeric_edgelist ] = edgelist_file_2_ordered_nodelist_and_numeric_edgelist_inc_bg_pr( ntwk_edgelist_file , ntwk_header , bg_names_CELLARRAY , results_dir , results_tag );
else
    [ ordered_nodelist , numeric_edgelist ] = edgelist_file_2_ordered_nodelist_and_numeric_edgelist_inc_bg( ntwk_edgelist_file , ntwk_header , bg_names_CELLARRAY );
end

% now we can do the last prep-steps required if node-attributes are going
% to be accounted for. ****************************************************

% first of all, initialise n-Dimensional bins for all nodes, such that they
% are all in the same n-Dimensional bin. If node-attributes are not going
% to be accounted for then this initial assignment is all that will be
% passed on to the randomisation function (via call to sr_seed2back_aux, etc).

nD_bins = ones( length( ordered_nodelist ) , 1 );

% now do the work required if node-attributes need to be accounted for ****

if( node_attribute_matrix_struct_available )
    
    if( gui_handles_available )
        set( gui_handles.static_progress_status , 'string' , 'Assigning n-dimensional bins to nodes according to node-attribute matrix...' );
        drawnow
        if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
            err = MException( '' , 'User requested cancel' );
            throw( err );
        end
    end
    
    % first, another error check that we can only do now that we have ordered_nodelist
    % and node_attribute_matrix_struct.node_names *****************************
    
    if( ~all( ismember( ordered_nodelist , node_attribute_matrix_struct.node_names ) ) )
        err = MException( '' ,'ERROR: All nodes must have a column in the node-attribute table.' );
        throw( err );
    end
    
    % re-arrange the columns of node_attribute_matrix_struct.data_matrix so
    % that nodes are in the same order as they appear in ordered_nodelist
    [ ~ , node_reorder ] = ismember( ordered_nodelist , node_attribute_matrix_struct.node_names );
    
    data_matrix = node_attribute_matrix_struct.data_matrix( : , node_reorder );
    
    % convert nDimensional attribute data for each node into an
    % nDimensional-bin assignment.
    nD_bins = convert_to_nD_bins( data_matrix , node_attribute_matrix_struct.num_bins );   
end
%**************************************************************************

% continue with the rest of the function **********************************
%**************************************************************************
seed_bb_names_CELLARRAY = {};
seed_bb_names_CELLARRAY{ 1 } = unique( cat( 1 , seed_names_CELLARRAY{ 1 } , bb_names_CELLARRAY{ 1 } ) );

[ numeric_seed_bb_list , seed_bb_in_network , seed_bb_not_in_network ] = nodelist_names2numbers( seed_bb_names_CELLARRAY , ordered_nodelist );

% now get the ordered backbone list. *************************************************************
[ numeric_bb_list , bb_in_network , bb_not_in_network] = nodelist_names2numbers( bb_names_CELLARRAY , ordered_nodelist );

% now get the ordered seed list. *****************************************************************
[ numeric_seed_list , seed_in_network , seed_not_in_network] = nodelist_names2numbers( seed_names_CELLARRAY , ordered_nodelist );
%*************************************************************************************************
%*************************************************************************************************

% Another couple of checks ***********************************************************************
if( length( seed_in_network ) <= 1 )
    err = MException( '' , 'ERROR: You have 1 or less seeds to test for connectivity in your chosen network.' );
    throw( err );
end

if( ~isempty( seed_not_in_network ) )
    disp( 'WARNING: The following seeds are not present in the network: ' );
    seed_not_in_network
end

if( ~isempty( bb_not_in_network ) )
    disp( 'WARNING: The following backbone-nodes are not in the network: ' );
    bb_not_in_network
end
%*************************************************************************************************

% clear all the big variables *******************************************************************
clear bg_ntwk_edgelist_names_CELLARRAY;
clear seed_bb_names_CELLARRAY;
clear seed_names_CELLARRAY;
clear bb_names_CELLARRAY;
%************************************************************************************************

% run the randomisations *********************************************************************************
if( gui_handles_available )
    set( gui_handles.static_progress_status , 'string' , 'Run randomisations...' );
    drawnow
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , ...
            'User requested cancel' );
        throw( err );
    end
    [ total_nodes , dir_network , context_network , observed , expected , p_value , num_edges_to_bb , num_edges_to_bb_exp , seeds_connected_to_bb , p_value_to_bb ,...
        num_seeds_connected_to_bb , num_bb_connected_to_seeds , bb_subtotal_of_total_nodes ] =...
        sr_seed2back_aux( numeric_edgelist , ordered_nodelist , numeric_seed_bb_list , numeric_bb_list , numeric_seed_list , seed_bb_in_network , rands ,...
        nD_bins , parallelise , quickview_flag , 'gui_handles' , gui_handles );
else
    [ total_nodes , dir_network , context_network , observed , expected , p_value , num_edges_to_bb, num_edges_to_bb_exp, seeds_connected_to_bb, p_value_to_bb ,...
        num_seeds_connected_to_bb , num_bb_connected_to_seeds , bb_subtotal_of_total_nodes ] =...
        sr_seed2back_aux( numeric_edgelist , ordered_nodelist , numeric_seed_bb_list , numeric_bb_list , numeric_seed_list , seed_bb_in_network , rands ,...
        nD_bins , parallelise , quickview_flag );
end
%*******************************************************************************************************

% print results if requested ****************************************************************************
if( results_dir_available & results_tag_available )
    
    if( gui_handles_available )
        set( gui_handles.static_progress_status , 'string' , 'Saving results...' );
        drawnow
        if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
            err = MException( '' , 'User requested cancel' );
            throw( err );
        end
    end
    
    % print out the output files *********************************************************************
    fid_log = fopen( [ results_dir '/' results_tag '.LOG' ] , 'w' );
    fid_seed_bb_present = fopen( [ results_dir '/' results_tag '.SEED_BB_PRESENT' ] , 'w' );
    fid_seeds_connected_to_bb = fopen( [ results_dir '/' results_tag '.SEEDS_CONNECTED_TO_BACKBONE' ] , 'w' );
    fid_direct_connections = fopen( [ results_dir '/' results_tag '.DIRECT_CONNECTIONS' ] , 'w' );
    fid_context_connections = fopen( [ results_dir '/' results_tag '.CONTEXT_CONNECTIONS' ] , 'w' );
    fid_summary = fopen( [ results_dir '/' results_tag '.SUMMARY' ] , 'w' );
    fid_net_stats = fopen( [ results_dir '/' results_tag '.NET_STATS' ] , 'w' );
    %***********************************
    
    %***********************************
    if( ntwk_header )
        fprintf( fid_log , 'NETWORK EDGE FILE: %s (Header line removed)\n' , ntwk_edgelist_file );
    else
        fprintf( fid_log , 'NETWORK EDGE FILE: %s (No header line expected)\n' , ntwk_edgelist_file );
    end
        
    if( bg_header )
        fprintf( fid_log, '\n!!! USED BACKGROUND SUBSET OF NETWORK, DEFINED IN: %s (Header line removed)!!!\n' , bg_file );
    else
        fprintf( fid_log, '\n!!! USED BACKGROUND SUBSET OF NETWORK, DEFINED IN: %s (No header line expected)!!!\n' , bg_file );
    end
    
    fprintf( fid_log, '!!! THE NETWORK ACTUALLY USED IS PRINTED IN: %s.BACKGROUND_NETWORK !!!\n\n' , results_tag );
    
    if( s_header )
        fprintf( fid_log , 'SEED FILE: %s (Header line removed)\n' , seed_file );
    else
        fprintf( fid_log , 'SEED FILE: %s (No header line expected)\n' , seed_file );
    end
    
    if( bb_header )
        fprintf( fid_log , 'BACKBONE FILE: %s (Header line removed)\n' , bb_file );
    else
        fprintf( fid_log , 'BACKBONE FILE: %s (No header line expected)\n' , bb_file );
    end
    
    fprintf( fid_log , 'TREATMENT OF JOINT SEED / BACKBONE NAMES:\n' );
    
    switch s_bb_comb    
        case 1 % treat joint seed/backbone names as backbone (remove from seeds)
            fprintf( fid_log , 'Treated joint seed / backbone names as backbone (removed from seeds)\n' );
        case 2 % treat joint seed/backbone names as seeds (remove from backbone)
            fprintf( fid_log , 'Treated joint seed / backbone names as seeds (removed from backbone)\n' );
        case 3 % treat joint seed/backbone names as neither (remove from both lists)
            fprintf( fid_log , 'Treated joint seed / backbone names as seeds (removed from both lists)\n' );
    end
    
    fprintf( fid_log , 'COMBINING BACKBONE AND BACKGROUND NAMES:\n' );
    
    if( bb_bg_comb ) % user has asked to add backbone names to background **************************        
        fprintf( fid_log , 'Backbone names ADDED to background:\n' );
    else
        fprintf( fid_log , 'Backbone names NOT ADDED to background:\n' );
    end
    
    if( node_attribute_matrix_struct_available )
        fprintf( fid_log , 'NODE ATTRIBUTES WERE CONTROLLED FOR:\n' );
        
        fprintf( fid_log , 'Node attribute file: %s \n' , node_attribute_matrix_struct.naf );
        
        fprintf( fid_log , 'Attribute names: \n' );
        [ nrows , ~ ] = size( node_attribute_matrix_struct.attribute_names );
        for row = 1:nrows
            fprintf( fid_log , '%s\n' , node_attribute_matrix_struct.attribute_names{ row } );
        end
        
        fprintf( fid_log , 'Groups per node attribute: \n' );
        [ nrows , ~ ] = size( node_attribute_matrix_struct.num_bins );
        for row = 1:nrows
            fprintf( fid_log , '%s\n' , int2str( node_attribute_matrix_struct.num_bins( row ) ) );
        end
        
    else
        fprintf( fid_log , 'NODE ATTRIBUTES WERE NOT CONTROLLED FOR.\n' );
    end
    
    % **********************************************************************************************
    fprintf( fid_log , 'NUMBER OF RANDOMISATIONS: %d\n' , rands );    
    fprintf( fid_log , 'RESULTS DIRECTORY: %s\n' , results_dir );
    fprintf( fid_log , 'RESULTS TAG: %s\n' , results_tag );
    %**********************************
    
    %***********************************
    [ nrows , ~ ] = size( seed_bb_in_network );
    for row = 1:nrows
        fprintf( fid_seed_bb_present , '%s\n' , seed_bb_in_network{ row , : } );
    end
    %***********************************
    
    %***********************************
    [ nrows , ~ ] = size( seeds_connected_to_bb );
    for row = 1:nrows
        fprintf( fid_seeds_connected_to_bb , '%s\n' , seeds_connected_to_bb{ row , : } );
    end
    %***********************************
    
    %***********************************
    [ nrows , ~ ] = size( dir_network );
    for row = 1:nrows
        fprintf( fid_direct_connections , '%s %s\n' , dir_network{ row , : } );
    end
    %***********************************
    
    %***********************************
    [ nrows , ~ ] = size( context_network );
    for row = 1:nrows
        fprintf( fid_context_connections , '%s %s\n' , context_network{ row , : } );
    end
    %***********************************
    
    %**********************************
    fprintf( fid_summary , 'There were %d seeds participating in the direct network.\n' , total_nodes );
    fprintf( fid_summary , '(... Of which %d were backbone-nodes.)\n' , full( bb_subtotal_of_total_nodes ) );
    fprintf( fid_summary , '\n' );
    fprintf( fid_summary , 'There were %d direct interactions in total.\n' , full( observed ) );
    %**********************************
    
    %**********************************
    fprintf( fid_net_stats , '%s\t%s\t%s\t%s\n' , 'PARAMETER' , 'OBSERVED' , 'EXPECTED' , 'P_VALUE' );
    fprintf( fid_net_stats , 'Direct seed connectivity\t%d\t%f\t%f\n' , full( observed ) , full( expected ) , full( p_value ) );
    fprintf( fid_net_stats , '\n' );
    fprintf( fid_net_stats , 'Extra seed-to-backbone data\n' );
    fprintf( fid_net_stats , 'Number of seeds connected to backbone-nodes\t%d\n' , full( num_seeds_connected_to_bb ) );
    fprintf( fid_net_stats , 'Number of backbone-nodes connected to seeds\t%d\n' , full( num_bb_connected_to_seeds ) );
    fprintf( fid_net_stats , 'Number of edges to backbone from seeds\t%d\n' , full( num_edges_to_bb ) );
    fprintf( fid_net_stats , 'Expected number of edges to backbone from seeds\t%d\n' , full( num_edges_to_bb_exp ) );
    fprintf( fid_net_stats , 'P-value for number of edges to backbone from seeds\t%f\n' , full( p_value_to_bb ) );
    %**********************************
    
    fclose( fid_log );
    fclose( fid_seed_bb_present );
    fclose( fid_seeds_connected_to_bb );
    fclose( fid_direct_connections );
    fclose( fid_context_connections );
    fclose( fid_summary );
    fclose( fid_net_stats );
end
end

