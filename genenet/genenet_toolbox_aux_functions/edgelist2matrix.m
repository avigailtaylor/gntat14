%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Auxiliary function file. Turns an edge list representation of a network into a matrix representation.
%Implementation: --
%Keywords: edge list matrix network
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

function [ network_matrix , ordered_nodelist ] = edgelist2matrix( network  , varargin )

% Parse parameter value pairs
%--------------------

keep_sparse = false;

n_varargin = length( varargin );
for kk = 1:n_varargin
    switch lower( varargin{ kk } )
        case 'sparse'
            keep_sparse = true;
        otherwise
            err = MException( '' , [ 'ERROR: Unknown parameter ' , varargin{ kk } , '.' ] );
            throw( err );
    end
end

network_matrix = [];

% check input *******************************************************************
[ row_check , col_check ] = size( network );

if( row_check <= 1 )
    err = MException( '' , 'ERROR: the network has one or less edges.' );
    throw( err );
end

if( col_check ~= 2 )
    err = MException( '' , 'ERROR: there are the wrong number of columns in the input network; there should be two.' );
    throw( err );
end

num_self_edges = length( find( network( : , 1 ) == network( : , 2 ) ) );
if( num_self_edges > 0 )
    disp( 'WARNING: some nodes have edges pointing to themselves; these will be ignored.' );
end
%**********************************************************************************

ordered_nodelist = unique( [ network( : , 1 ) ; network( : , 2 ) ] );

% represent the network as a matrix ***********************************************************
sub_network = network( find( network( : , 1 ) ~= network( : , 2 ) ) , : );
[ ~ , node_indices1 ] = ismember( sub_network( : , 1 ) , ordered_nodelist );
[ ~ , node_indices2 ] = ismember( sub_network( : , 2 ) , ordered_nodelist );

% network_matrix(sub2ind(size(network_matrix),node_indices1,node_indices2)) = 1;
% network_matrix(sub2ind(size(network_matrix),node_indices2,node_indices1)) = 1;

network_matrix_sparse_indices = unique( [ [ node_indices1 ; node_indices2 ] [ node_indices2 ; node_indices1 ] ] , 'rows' );

network_matrix = sparse( network_matrix_sparse_indices( : , 1 ) , network_matrix_sparse_indices( : , 2 ) , logical( 1 ) );

if( ~keep_sparse )
    network_matrix = full( network_matrix );
end

%check output *********************************************************************************
if( length( find( sum( network_matrix ) == 0 ) ) > 0 )
    disp('WARNING: there are singleton nodes in the network.');
end

if( isempty( network_matrix ) )
    err = MException( '' , 'ERROR: the network has one or less edges... check warnings, it may be that all edges consist of nodes pointing to themselves.' );
    throw( err );
end

end
