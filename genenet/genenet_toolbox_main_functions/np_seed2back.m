function [ total_nodes , bb_subtotal_of_total_nodes , dir_network , indir_network , context_network , observed , expected , p_values ,...
    seed_bb_in_network , p_values_for_seed_bb ,  num_edges_to_bb , num_edges_to_bb_exp ,...
    seeds_connected_to_bb , num_seeds_connected_to_bb, num_bb_connected_to_seeds , p_value_to_bb ] =...
    np_seed2back( ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header , s_bb_comb , perms , num_switches , protect_perm_step , parallelise , quickview_flag , varargin )

% SYNTAX:
%
% [ total_nodes , bb_subtotal_of_total_nodes , dir_network , indir_network , context_network , observed , expected , p_values , seed_bb_in_network , p_values_for_seed_bb , num_edges_to_bb , num_edges_to_bb_exp , seeds_connected_to_bb , num_seeds_connected_to_bb, num_bb_connected_to_seeds , p_value_to_bb ] = np_seed2back( ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header , s_bb_comb , perms , num_switches , protect_perm_step , parallelise , quickview_flag , varargin )
%
% 
% DESCRIPTION:
%
% Seed to backbone connectivity analysis using network permutation.
%
% INPUT:
%
% ntwk_edgelist_file = (string) Full or relative path to text file containing the network of interest, represented as a list of edges (two columns, tab- or space-delimited). 
% ntwk_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in ntwk_edgelist_file. 
% seed_file = (string) Full or relative path to text file containing the seeds to analyse (one column).
% s_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in seed_file.  
% bb_file = (string) Full or relative path to text file containing the backbone-nodes (one column).
% bb_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in bb_file.
% s_bb_comb = (integer with value 1, 2 or 3) 1 = treat joint seed/backbone as backbone; 2 = treat joint seed/backbone as seeds; 3 = treat joint seed/backbone as neither.  
% perms = (positive integer) Number of permutations to perform.
% num_switches = (positive integer) Number of switching steps to perform per permutation.
% protect_perm_step = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to keep track of removed edges (after permutation step, and between switching steps) so that they are not re-instated as network permutation proceeds. We suggest you set this to false: it is unclear whether setting it to true speeds up permutation, in light of the fact that keeping track of removed edges can be expensive in very large networks. Previous implementations of network permutation (see Rossin et al. 2011, PLoS Genet), do not do this.
% parallelise = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to use multiple processors for parallel permutations.
% quickview_flag = boolean (true, false, 1 or 0)) Flag to indicate whether or not to plot a 'quickview' of the direct network among seeds.
%
% [varargin] = Specified as parameter value pairs where the parameters are:
%   'results_dir' = (string) Full or relative path to directory where results are to be stored. 
%   'results_tag' = (string) Tag with which to prefix all results files for this analysis.
%   'gui_handles' = Used by GUI - not intended for use by user.
%
% OUTPUT:
% total_nodes = Total number of seeds and backbone-nodes in the direct network among seeds and backbone-nodes.
% bb_subtotal_of_total_nodes = Total number of backbone-nodes in the direct network among seeds and backbone-nodes.
% dir_network = N x 2 cell array of edges in the direct network among seeds and backbone-nodes.
% indir_network = L x 2 cell array of edges in the indirect network among seeds , backbone-nodes and common connectors.
% context_network =  M x 2 cell array of edges in the context network, where the context network is comprised of all nodes connected to a seed or backbone-node (including seeds and backbone-nodes), and all the edges among this set of nodes.
% observed = 5 x 1 vector containing the observed values for: (1) Total number of edges in the direct network among seed and backbone-nodes; (2) Seed and backbone-node direct degrees mean; (3) Seed and backbone-node indirect degrees mean (unweighted); (4) Seed and backbone-node indirect degrees mean (weighted); (5) Common connectors degrees mean.
% expected = 5 x 1 vector containing the expected values for: (1) Total number of edges in the direct network among seed and backbone-nodes; (2) Seed and backbone-node direct degrees mean; (3) Seed and backbone-node indirect degrees mean (unweighted); (4) Seed and backbone-node indirect degrees mean (weighted); (5) Common connectors degrees mean. Note that all expected values are calculated as the mean of that value observed across permuted networks. 
% p_values = 5 x 1 vector containing the empirical P-values for: (1) Total number of edges in the direct network among seed and backbone-nodes; (2) Seed and backbone-node direct degrees mean; (3) Seed and backbone-node indirect degrees mean (unweighted); (4) Seed and backbone-node indirect degrees mean (weighted); (5) Common connectors degrees mean.
% seed_bb_in_network = Cell array of seeds and backbone-nodes in the specified/ input network, that is, those seeds and backbone-nodes that could be analysed... this is *not* the same as the list of seeds and backbone-nodes particpating in the identified direct network.
% p_values_for_seed_bb = total_nodes x 1 vector of empirical P-values for each seed's and backbone-node's connectedness to other seeds and backbone-nodes in the direct network among seeds and backbone-nodes (P-values only given for seeds and backbone-nodes participating in the direct network among seeds and backbone-nodes).
% num_edges_to_bb = Total number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes
% num_edges_to_bb_exp = Expected number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes. (Calculated as the mean observed over all permuted networks).
% seeds_connected_to_bb = Cell array of seeds connected to backbone-nodes in the direct network among seeds and backbone-nodes. 
% num_seeds_connected_to_bb = Total number of seeds connected to one or more backbone-nodes in the direct network among seeds and backbone-nodes.
% num_bb_connected_to_seeds = Total number of backbone-nodes connected to one or more seeds in the direct network among seeds and backbone-nodes.
% p_value_to_bb = Empirical P-value for the observed number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes.
%
% SEE ALSO: np_seed np_seed_bg np_seed2back_bg sr_seed sr_seed_bg sr_seed2back sr_seed2back_bg
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
sanity_check_standard_inputs( 'np_seed2back' , ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header , s_bb_comb , perms , num_switches , protect_perm_step , parallelise , quickview_flag );

% Parse parameter value pairs
results_dir_available = false;
results_tag_available = false;
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

if( results_dir_available & ~results_tag_available )
    err = MException( '' ,  'ERROR: results_dir supplied without results_tag' );
    throw( err );
end

if( ~results_dir_available & results_tag_available )
    err = MException( '' ,  'ERROR: results_tag supplied without results_dir' );
    throw( err );
end

if( results_dir_available )
    if( ~ischar( results_dir ) )
        err = MException( '' , 'ERROR: results_dir field must be a string' );
        throw( err );
    end
    if( ~( exist( results_dir , 'file' ) == 7 ) )
        err = MException( '' , 'ERROR: results_dir directory does not exist' );
        throw( err );
    end
end

if( results_tag_available )
    if( ~ischar( results_tag ) )
        err = MException( '' , 'ERROR: results_tag field must be a string' );
        throw( err );
    end
end

% do some error checking ***************************************************************************
if( perms < 1  )
    err = MException( '' ,  'ERROR: You need at least one permutation, preferrably many more. Quitting now.' );
    throw( err );
end

if( num_switches < 10  ) 
    disp( 'WARNING: the switching step is important in this algorithm. You may wish to assign a value >= 10 for this parameter' );
end

if( protect_perm_step  )
    disp( 'WARNING: You have chosen to protect permuted edges from being broken. This is fine, and in fact useful if you want your permuted networks to share fewer edges with the real network in less switching steps. However, this is a deviation from the DAPPLE implementation of this algorithm.' );
end
%*************************************************************************************************

if( gui_handles_available )
    set( gui_handles.static_progress_status , 'string' , 'Loading network file as edge list...' );
    drawnow
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
end

% read in the network file ***********************************************************************
[ ordered_nodelist , numeric_edgelist ] = edgelist_file_2_ordered_nodelist_and_numeric_edgelist( ntwk_edgelist_file , ntwk_header );
% ************************************************************************************************

if( gui_handles_available )
    set( gui_handles.static_progress_status , 'string' , 'Loading seed and backbone files...' );
    drawnow
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' ); 
        throw( err );
    end
end

% read in the two nodelist files *****************************************************************
seed_names_CELLARRAY = read_nodelist_file( seed_file , s_header );
bb_names_CELLARRAY = read_nodelist_file( bb_file , bb_header );
% ************************************************************************************************

% make sure the CELLARRAYs list each node name only once *****************************************
seed_names_CELLARRAY{ 1 } = unique( seed_names_CELLARRAY{ 1 } );
bb_names_CELLARRAY{ 1 } = unique( bb_names_CELLARRAY{ 1 } );
%*************************************************************************************************

% deal with any overlap between seeds and backbone as the user has requested *********************
switch s_bb_comb
    
    case 1 % treat joint seed/backbone names as backbone (remove from seeds)
        
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
% ************************************************************************************************

%*************************************************************************************************
% using the ordered node list, get the corresponding ordered combined seed and backbone(bb) list *
seed_bb_names_CELLARRAY = {};
seed_bb_names_CELLARRAY{ 1 } = unique( cat( 1 , seed_names_CELLARRAY{ 1 } , bb_names_CELLARRAY{ 1 } ) );

[ numeric_seed_bb_list , seed_bb_in_network , seed_bb_not_in_network ] = nodelist_names2numbers( seed_bb_names_CELLARRAY , ordered_nodelist );

% now get the ordered backbone list. *************************************************************
[ numeric_bb_list , bb_in_network , bb_not_in_network ] = nodelist_names2numbers( bb_names_CELLARRAY , ordered_nodelist );


% now get the ordered seed list. *****************************************************************
[ numeric_seed_list , seed_in_network , seed_not_in_network ] = nodelist_names2numbers( seed_names_CELLARRAY , ordered_nodelist );
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
clear seed_bb_names_CELLARRAY;
clear seed_names_CELLARRAY;
clear bb_names_CELLARRAY;
%************************************************************************************************

% run the permutations ***************************************************************************
if( gui_handles_available )
    set( gui_handles.static_progress_status , 'string' , 'Run permutations...' );
    drawnow
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
    
    [ total_nodes , dir_network , indir_network , context_network , observed , expected , p_values , p_values_for_seed_bb , num_edges_to_bb , num_edges_to_bb_exp ,...
        seeds_connected_to_bb , p_value_to_bb , num_seeds_connected_to_bb , num_bb_connected_to_seeds , bb_subtotal_of_total_nodes ] =...
        np_seed2back_aux( numeric_edgelist , ordered_nodelist , numeric_seed_bb_list , numeric_bb_list , numeric_seed_list , seed_bb_in_network , perms ,...
        num_switches , protect_perm_step , parallelise , quickview_flag , 'gui_handles' , gui_handles );
    
else
    [ total_nodes , dir_network , indir_network , context_network , observed , expected , p_values , p_values_for_seed_bb , num_edges_to_bb , num_edges_to_bb_exp ,...
        seeds_connected_to_bb , p_value_to_bb , num_seeds_connected_to_bb , num_bb_connected_to_seeds , bb_subtotal_of_total_nodes ] =...
        np_seed2back_aux( numeric_edgelist , ordered_nodelist , numeric_seed_bb_list , numeric_bb_list , numeric_seed_list , seed_bb_in_network , perms ,...
        num_switches , protect_perm_step , parallelise , quickview_flag );
end
% ************************************************************************************************

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
   
    fid_log = fopen( [ results_dir '/' results_tag '.LOG' ] , 'w' );
    fid_seed_bb_present = fopen( [ results_dir '/' results_tag '.SEED_BB_PRESENT' ] , 'w' );
    fid_seed_bb_scores = fopen( [ results_dir '/' results_tag '.SEED_BB_SCORES' ] , 'w' );
    fid_seeds_connected_to_bb = fopen( [ results_dir '/' results_tag '.SEEDS_CONNECTED_TO_BACKBONE' ] , 'w' );
    fid_direct_connections = fopen( [ results_dir '/' results_tag '.DIRECT_CONNECTIONS' ] , 'w' );
    fid_indirect_connections = fopen( [ results_dir '/' results_tag '.INDIRECT_CONNECTIONS' ] , 'w' );
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
    
    if( s_header )
        fprintf( fid_log , 'SEED FILE: %s (Header line removed)\n' , seed_file );
    else
        fprintf( fid_log , 'SEED FILE: %s (No header line removed)\n' , seed_file );
    end
    
    if( bb_header )
        fprintf( fid_log , 'BACKBONE FILE: %s (Header line removed)\n' , bb_file );
    else
        fprintf( fid_log , 'BACKBONE FILE: %s (No header line removed)\n' , bb_file );
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
    
    fprintf( fid_log , 'NUMBER OF PERMUTATIONS: %d\n' , perms );
    
    fprintf( fid_log , 'NUMBER OF SWITCHES IN EACH PERMUTATION: %d\n' , num_switches );
    
    if( protect_perm_step )
        fprintf( fid_log , 'PROTECT PERMUTATION STEP: yes\n' );
    else
        fprintf( fid_log , 'PROTECT PERMUTATION STEP: no\n' );
    end
    
    fprintf( fid_log , 'RESULTS DIRECTORY: %s\n' , results_dir );
    
    fprintf( fid_log , 'RESUTLS TAG: %s\n' , results_tag );
    %**********************************
    
    %***********************************
    [ nrows , ~ ]= size( seed_bb_in_network );
    for row = 1:nrows
        fprintf( fid_seed_bb_present , '%s\n' , seed_bb_in_network{ row , : } );
    end
    %***********************************
    
    %***********************************
    fprintf( fid_seed_bb_scores , '%s %12s\n' , 'GENE' , 'P-value' );
    [ nrows , ~ ] = size( seed_bb_in_network );
    for row = 1:nrows
        fprintf( fid_seed_bb_scores , '%s %.12f\n' , seed_bb_in_network{ row , : } , p_values_for_seed_bb( row ) );
    end
    %***********************************
    
    %***********************************
    [ nrows , ~ ]= size( seeds_connected_to_bb );
    for row=1:nrows
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
    [ nrows , ~ ] = size( indir_network );
    for row = 1:nrows
        fprintf( fid_indirect_connections , '%s %s\n' , indir_network{ row , : } );
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
    fprintf( fid_summary , 'There were %d direct edges in total.\n' , full( observed( 1 ) ) );
    fprintf( fid_summary , '\n' );
    fprintf( fid_summary , 'Seed direct degrees mean: %f\n' , full( observed( 2 ) ) );
    fprintf( fid_summary , 'Seed indirect degrees mean: %f\n' , full( observed( 3 ) ) );
    fprintf( fid_summary , 'Seed indirect degrees mean (weighted): %f\n' , full( observed( 4 ) ) );
    fprintf( fid_summary , 'Mean CC connectivity: %f\n' , full( observed( 5 ) ) );
    %**********************************
    
    %**********************************
    fprintf( fid_net_stats ,'%s\t%s\t%s\t%s\n' , 'PARAMETER' , 'OBSERVED' , 'EXPECTED' , 'P_VALUE' );
    fprintf( fid_net_stats ,'Direct seed connectivity\t%d\t%f\t%f\n' , full( observed( 1 ) ) , full( expected(1) ) , full( p_values(1) ) );
    fprintf( fid_net_stats ,'Seed direct degrees mean\t%f\t%f\t%f\n' , full( observed( 2 ) ) , full( expected(2) ) , full( p_values(2) ) );
    fprintf( fid_net_stats ,'Seed indirect degrees mean\t%f\t%f\t%f\n' , full( observed( 3 ) ) , full( expected( 3 ) ) , full( p_values( 3 ) ) );
    fprintf( fid_net_stats ,'Seed indirect degrees mean (weighted)\t%f\t%f\t%f\n' , full( observed( 4 ) ) , full( expected( 4 ) ) , full( p_values( 4 ) ) );
    fprintf( fid_net_stats ,'CC degrees mean\t%f\t%f\t%f\n' , full( observed( 5 ) ) , full( expected( 5 ) ) , full( p_values( 5 ) ) );
    
    fprintf( fid_net_stats , '\n');
    fprintf( fid_net_stats , 'Extra seed-to-backbone data\n');
    fprintf( fid_net_stats , 'Number of seeds connected to backbone-nodes\t%d\n' , full( num_seeds_connected_to_bb ) );
    fprintf( fid_net_stats , 'Number of backbone-nodes connected to seeds\t%d\n' , full( num_bb_connected_to_seeds ) );
    fprintf( fid_net_stats , 'Number of edges to backbone from seeds\t%d\n' , full( num_edges_to_bb ) );
    fprintf( fid_net_stats , 'Expected number of edges to backbone from seeds\t%d\n' , full( num_edges_to_bb_exp ) );
    fprintf( fid_net_stats , 'P-value for number of edges to backbone from seeds\t%f\n' , full( p_value_to_bb ) );
    %**********************************
    
    fclose( fid_log );
    fclose( fid_seed_bb_present );
    fclose( fid_seed_bb_scores );
    fclose( fid_seeds_connected_to_bb );
    fclose( fid_direct_connections );
    fclose( fid_indirect_connections );
    fclose( fid_context_connections );
    fclose( fid_summary );
    fclose( fid_net_stats );
end
end