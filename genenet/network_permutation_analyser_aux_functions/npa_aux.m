%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Returns the network matrix corresponding to ntwk_edgelist_file, and analyses the network (for the Network Permutation Analyser) as a side effect.
%Implementation: 
%Keywords: network analysis nodes edges coefficient clustering assortativity neighbourhood metrics 
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

function network_matrix = npa_aux( ntwk_edgelist_file , ntwk_header , gui_handles )

set( gui_handles.static_progress_status , 'string' , 'Loading network file as edge list...' );
drawnow
if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
    err = MException( '' , 'User requested cancel' );
    throw( err );
end

% read in the network file ***********************************************************************
[ ~ , numeric_edgelist ] = edgelist_file_2_ordered_nodelist_and_numeric_edgelist( ntwk_edgelist_file , ntwk_header );
% ************************************************************************************************

%*********************************************
% turn edgelist into matrix
%*********************************************

% update progress bar ************************

set( gui_handles.static_progress_status , 'string' , 'Converting edge list to matrix format...' );
drawnow
if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
    err = MException( '' , 'User requested cancel' );
    throw( err );
end


% do the conversion***************************
network_matrix = edgelist2matrix( numeric_edgelist , 'sparse' );

% get the network stats
[ total_nodes , total_edges , total_u_nodes , total_u_edges ] = get_network_stats( network_matrix );
set( gui_handles.static_total_nodes , 'string' , num2str( total_nodes ) );
set( gui_handles.static_total_edges , 'string' , num2str( total_edges ) );
set( gui_handles.static_total_u_nodes , 'string' , num2str( total_u_nodes ) );
set( gui_handles.static_total_u_edges , 'string' , num2str( total_u_edges ) );
drawnow

%*********************************************
% calculate cluster coefficients
%*********************************************

% update progress bar ************************
set( gui_handles.static_progress_status , 'string' , 'Calculating cluster coefficient...' );
drawnow
if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
    err = MException( '' , 'User requested cancel' );
    throw( err );
end

% calculate the cluster coefficients *************
[ ~ , average_local_clustercoeff , global_clustercoeff ] = calc_clustercoeffs( network_matrix , 'gui_handles' , gui_handles );

% update cluster coefficients panel **************
set( gui_handles.static_mean_local_cc , 'string' , num2str( average_local_clustercoeff ) );
set( gui_handles.static_global_cc , 'string' , num2str( global_clustercoeff ) );
drawnow
if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
    err = MException( '' , 'User requested cancel' );
    throw( err );
end

%*********************************************
% calculate assortativity metrics
%*********************************************

% update progress bar ************************
set( gui_handles.static_progress_status , 'string' , 'Calculating assortativity coefficient...' );
drawnow
if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
    err = MException( '' , 'User requested cancel' );
    throw( err );
end

% calculate the assortativity coefficient ****
assortativity_coeff = calc_assortativity( network_matrix );

% update assortativity panel *****************
set( gui_handles.static_ac , 'string' , num2str( assortativity_coeff ) );
drawnow
if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
    err = MException( '' , 'User requested cancel' );
    throw( err );
end

% update progress bar*************************
set( gui_handles.static_progress_status , 'string' , 'Plotting neighbour connectivity distribution...' );
drawnow
if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
    err = MException( '' , 'User requested cancel' );
    throw( err );
end

% get neighbour connectivity distribution************
[ degrees , mean_neighbour_connectivity ] = get_neighbour_connectivity_distribution( network_matrix );

% plot neighbour connectivity distribution*****************
loglog( gui_handles.axes_nc , degrees , mean_neighbour_connectivity , 'x' );
xlabel( gui_handles.axes_nc , 'Degree' );
ylabel( gui_handles.axes_nc , 'Mean Neighbour Connectivity' );

drawnow
if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
    err = MException( '' , 'User requested cancel' );
    throw( err );
end
end

