function [ total_nodes , dir_network , indir_network , context_network , observed , expected , p_values , seeds_in_network , p_values_for_seeds ] =...
    np_seed_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , perms , num_switches , protect_perm_step , parallelise , quickview_flag , varargin )

% SYNTAX:
%
% [ total_nodes , dir_network , indir_network , context_network , observed , expected , p_values , seeds_in_network , p_values_for_seeds ] = np_seed_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , perms , num_switches , protect_perm_step , parallelise , quickview_flag , varargin )
% 
% DESCRIPTION:
%
% Seed connectivity analysis using network permutation, and restricting the analysis to a specified sub-network (background) of the primary network.
%
% INPUT:
%
% ntwk_edgelist_file = (string) Full or relative path to text file containing the network of interest, represented as a list of edges (two columns, tab- or space-delimited). 
% ntwk_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in ntwk_edgelist_file. 
% bg_file = (string) Full or relative path to text file containing nodes to be included in the background network (one column).
% bg_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in bg_file. 
% seed_file = (string) Full or relative path to text file containing the seeds to analyse (one column).
% s_header = (boolean (true, false, 1 or 0)) Flag to indicate whether or not to remove a header-line in seed_file.  
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
% total_nodes = Total number of seeds in the direct network.
% dir_network = N x 2 cell array of edges in the direct network among seeds. 
% indir_network = L x 2 cell array of edges in the indirect network among seeds and common connectors.
% context_network =  M x 2 cell array of edges in the context network, where the context network is comprised of all nodes connected to a seed (including seeds), and all the edges among this set of nodes.
% observed = 5 x 1 vector containing the observed values for: (1) Total number of edges in the direct network; (2) Seed direct degrees mean; (3) Seed indirect degrees mean (unweighted); (4) Seed indirect degrees mean (weighted); (5) Common connectors degrees mean.
% expected = 5 x 1 vector containing the expected values for: (1) Total number of edges in the direct network; (2) Seed direct degrees mean; (3) Seed indirect degrees mean (unweighted); (4) Seed indirect degrees mean (weighted); (5) Common connectors degrees mean. 
% p_values = 5 x 1 vector containing the empirical P-values for: (1) Total number of edges in the direct network; (2) Seed direct degrees mean; (3) Seed indirect degrees mean (unweighted); (4) Seed indirect degrees mean (weighted); (5) Common connectors degrees mean.
% seeds_in_network = Cell array of seeds in the specified/ input network, that is, those seeds that could be analysed... this is *not* the same as the list of seeds particpating in the identified direct network.
% p_values_for_seeds = total_nodes x 1 vector of empirical P-values for each seed's connectedness to other seeds in the direct network (P-values only given for seeds participating in the direct network.)
%
% SEE ALSO: np_seed np_seed2back np_seed2back_bg sr_seed sr_seed_bg sr_seed2back sr_seed2back_bg
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
sanity_check_standard_inputs( 'np_seed_bg' , ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , perms , num_switches , protect_perm_step , parallelise , quickview_flag );

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
    err = MException( '' , 'ERROR: results_dir supplied without results_tag' );
    throw( err );
end

if( ~results_dir_available & results_tag_available )
    err = MException( '' , 'ERROR: results_tag supplied without results_dir' );
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
    err = MException( '' , 'ERROR: You need at least one permutation, preferrably many more. Quitting now.' );
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
    set( gui_handles.static_progress_status , 'string' , 'Loading seed and background files...' );
    drawnow
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
end

% read in the nodelist files *********************************************************************
seed_names_CELLARRAY = read_nodelist_file( seed_file , s_header );
bg_names_CELLARRAY = read_nodelist_file( bg_file , bg_header );
% ************************************************************************************************

% make sure the CELLARRAYs list each node name only once *****************************************
seed_names_CELLARRAY{ 1 } = unique( seed_names_CELLARRAY{ 1 } );
bg_names_CELLARRAY{ 1 } = unique( bg_names_CELLARRAY{ 1 } );
%*************************************************************************************************

if( gui_handles_available )
    set( gui_handles.static_progress_status , 'string' , 'Making the background network...' );
    drawnow
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
end

%*************************************************************************************************
% get the ordered node list, and corresponding ordered seed list for the background network ******
if( results_dir_available & results_tag_available )
    % print background network at the same time, if printing results later *******************
    [ ordered_nodelist , numeric_edgelist ] = edgelist_file_2_ordered_nodelist_and_numeric_edgelist_inc_bg_pr( ntwk_edgelist_file , ntwk_header , bg_names_CELLARRAY , results_dir , results_tag );
else
    [ ordered_nodelist , numeric_edgelist ] = edgelist_file_2_ordered_nodelist_and_numeric_edgelist_inc_bg( ntwk_edgelist_file , ntwk_header , bg_names_CELLARRAY );
end

[ numeric_seed_list , seeds_in_network , seeds_not_in_network ] = nodelist_names2numbers( seed_names_CELLARRAY , ordered_nodelist );
%*************************************************************************************************
%*************************************************************************************************

% Another couple of checks ***********************************************************************
if( length( seeds_in_network ) <= 1 )
    err = MException( '' , 'ERROR: You have 1 or less seeds to test for connectivity in your chosen network.' );
    throw( err );
end

if( ~isempty( seeds_not_in_network ) )
    disp( 'WARNING: The following seeds are not present in the network: ' );
    seeds_not_in_network
end
%*************************************************************************************************

% clear all the big variables *******************************************************************
clear seed_names_CELLARRAY;
%************************************************************************************************

% run the permutations ***************************************************************************
if( gui_handles_available )
    set( gui_handles.static_progress_status , 'string' , 'Run permutations...' );
    drawnow
    
    if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
        err = MException( '' , 'User requested cancel' );
        throw( err );
    end
    
    [ total_nodes , dir_network , indir_network , context_network , observed , expected , p_values , p_values_for_seeds ] =...
        np_seed_aux( numeric_edgelist , ordered_nodelist , numeric_seed_list , seeds_in_network , perms , num_switches , protect_perm_step ,...
        parallelise , quickview_flag , 'gui_handles' , gui_handles );    
else
    [ total_nodes , dir_network , indir_network , context_network , observed , expected , p_values , p_values_for_seeds ] =...
        np_seed_aux( numeric_edgelist , ordered_nodelist , numeric_seed_list , seeds_in_network , perms , num_switches , protect_perm_step , parallelise , quickview_flag );
end

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
    fid_seeds_present = fopen( [ results_dir '/' results_tag '.SEEDS_PRESENT' ] , 'w' );
    fid_seed_scores = fopen( [ results_dir '/' results_tag '.SEED_SCORES' ] , 'w' );
    fid_direct_connections = fopen( [ results_dir '/' results_tag '.DIRECT_CONNECTIONS' ] , 'w' );
    fid_indirect_connections = fopen( [ results_dir '/' results_tag '.INDIRECT_CONNECTIONS' ] , 'w' );
    fid_context_connections = fopen( [ results_dir '/' results_tag '.CONTEXT_CONNECTIONS'  ] , 'w' );
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
        fprintf( fid_log , '\n!!! USED BACKGROUND SUBSET OF NETWORK, DEFINED IN: %s (Header line removed)!!!\n' , bg_file );
    else
        fprintf( fid_log , '\n!!! USED BACKGROUND SUBSET OF NETWORK, DEFINED IN: %s (No header line expected)!!!\n' , bg_file );
    end
    
    fprintf( fid_log , '!!! THE NETWORK ACTUALLY USED IS PRINTED IN: %s.BACKGROUND_NETWORK !!!\n\n' , results_tag );
     
    if( s_header )
        fprintf( fid_log , 'SEED FILE: %s (Header line removed)\n' , seed_file );
    else
        fprintf( fid_log , 'SEED FILE: %s (No header line removed)\n' , seed_file );
    end
        
    fprintf( fid_log , 'NUMBER OF PERMUTATIONS: %d\n' , perms );
    
    fprintf( fid_log , 'NUMBER OF SWITCHES IN EACH PERMUTATION: %d\n' , num_switches );
    
    if( protect_perm_step )
        fprintf( fid_log , 'PROTECT PERMUTATION STEP: yes\n' );
    else
        fprintf( fid_log , 'PROTECT PERMUTATION STEP: no\n' );
    end
    
    fprintf( fid_log , 'RESULTS DIRECTORY: %s\n' , results_dir );
    
    fprintf( fid_log , 'RESULTS TAG: %s\n' , results_tag );
    %**********************************
    
    %***********************************
    [ nrows , ~ ]= size( seeds_in_network );
    for row = 1:nrows
        fprintf( fid_seeds_present , '%s\n' , seeds_in_network{ row , : } );
    end
    %***********************************
    
    %***********************************
    fprintf( fid_seed_scores , '%s %12s\n' , 'GENE' , 'P-value' );
    [ nrows , ~ ]= size( seeds_in_network );
    for row = 1:nrows
        fprintf( fid_seed_scores , '%s %.12f\n' , seeds_in_network{ row , : } , p_values_for_seeds( row ) );
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
    fprintf( fid_summary , '\n' );
    fprintf( fid_summary , 'There were %d direct edges in total.\n' , full( observed( 1 ) ) );
    fprintf( fid_summary , '\n' );
    fprintf( fid_summary , 'Seed direct degrees mean: %f\n' , full( observed( 2 ) ) );
    fprintf( fid_summary , 'Seed indirect degrees mean: %f\n' , full( observed( 3 ) ) );
    fprintf( fid_summary , 'Seed indirect degrees mean (weighted): %f\n' , full( observed( 4 ) ) );
    fprintf( fid_summary , 'Mean CC connectivity: %f\n' , full( observed( 5 ) ) );
    %**********************************
    
    %**********************************
    fprintf( fid_net_stats , '%s\t%s\t%s\t%s\n' , 'PARAMETER' , 'OBSERVED' , 'EXPECTED' , 'P_VALUE' );
    fprintf( fid_net_stats , 'Direct seed connectivity\t%d\t%f\t%f\n' , full( observed( 1 ) ) , full( expected( 1 ) ) , full( p_values( 1) ) );
    fprintf( fid_net_stats , 'Seed direct degrees mean\t%f\t%f\t%f\n' , full( observed( 2 ) ) , full( expected( 2 ) ) , full( p_values( 2 ) ) );
    fprintf( fid_net_stats , 'Seed indirect degrees mean\t%f\t%f\t%f\n' , full( observed( 3 ) ) , full( expected( 3 ) ) , full( p_values( 3 ) ) );
    fprintf( fid_net_stats , 'Seed indirect degrees mean (weighted)\t%f\t%f\t%f\n' , full( observed( 4 ) ) , full( expected( 4 ) ) , full( p_values( 4 ) ) );
    fprintf( fid_net_stats , 'CC degrees mean\t%f\t%f\t%f\n' , full( observed( 5 ) ) , full( expected( 5 ) ) , full( p_values( 5 ) ) );
    %**********************************
    
    fclose( fid_log );
    fclose( fid_seeds_present );
    fclose( fid_seed_scores );
    fclose( fid_direct_connections );
    fclose( fid_indirect_connections );
    fclose( fid_context_connections );
    fclose( fid_summary );
    fclose( fid_net_stats );
end
end
