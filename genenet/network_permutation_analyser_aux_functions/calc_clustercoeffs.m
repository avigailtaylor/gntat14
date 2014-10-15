%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Calculates the local and global clustering coefficients for a network. Also calculates the mean average local clustering coefficient.
%Implementation: The local clustering coefficient is as defined in: D. J. Watts and Steven Strogatz (June 1998). "Collective dynamics of 'small-world' networks". Nature 393. 
%Implementation: The global clustering coefficient implemented here is defined as the number of closed triplets over the total number of triplets (both open and closed), see R. D. Luce and A. D. Perry (1949). "A method of matrix analysis of group structure". Psychometrika 14 (1): 95?116.
%Keywords: local global average clustering coefficient.
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

function [ local_cluster_coeffs, average_local_clustercoeff, global_clustercoeff ] = calc_clustercoeffs( network_matrix , varargin )


network_matrix = full( network_matrix ); % this function is too slow using sparse matrix,
%so convert network_matrix to full
%just for this function.

% Parse parameter value pairs
gui_handles_available = false;

n_varargin = length( varargin );
for kk = 1:2:n_varargin
    switch lower( varargin{ kk } )
        case 'gui_handles'
            gui_handles_available = true;
            gui_handles = varargin{ kk + 1 };
        otherwise
            err = MException( '', [ 'ERROR: Unknown parameter ' , varargin{kk} , '.' ] );
            throw( err );
    end
end

[ num_nodes , ~ ] = size( network_matrix );

num_triplets = 0;
num_closed_triplets = 0;
local_cluster_coeffs = [];


for ni = 1:num_nodes
    
    if( gui_handles_available )
        drawnow
        if( get( gui_handles.toggle_cancel , 'Value' ) == 1 )
            err = MException( '' , 'User requested cancel' );
            throw( err );
        end
    end
    
    ni_edges = find( network_matrix( ni , : ) );
    ni_num_edges = length( ni_edges );
    network_of_connected_nodes = network_matrix( ni_edges , ni_edges );
    
    if( ni_num_edges <= 1 )
        local_cluster_coeffs = [ local_cluster_coeffs 0 ];
    else
        %if( ni_num_edges > 1 )
        local_cluster_coeffs = [ local_cluster_coeffs  ( ( sum( sum( network_of_connected_nodes ) ) ) / ( ni_num_edges * ( ni_num_edges - 1 ) ) ) ];
        num_triplets = num_triplets + nchoosek( ni_num_edges , 2 );
        num_closed_triplets = num_closed_triplets + ( sum( sum( network_of_connected_nodes ) ) / 2 );
    end
    
end

average_local_clustercoeff = mean( local_cluster_coeffs );
global_clustercoeff = num_closed_triplets / ( num_triplets );

end
