%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Gets the stats for the indirect network.
%Implementation: Calculates indirect network stats as in DAPPLE. (Rossin et al., PLoS Genetics 2007). Note that DAPPLE only uses an indirect network represented as a weighted direct network, but that we have also represented it as an unweighted network.
%Keywords: indirect network statistics weighted unweighted direct representation
%Example: This is an auxiliary function. Not intended for direct calling by the user.

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

function [ CC_mean_connectivity , seed_indir_edge_counts , seed_indir_edge_sum_weights ] = get_indirect_network_stats( network_matrix , seed_indices , not_seed_indices  )

subnetwork = network_matrix( seed_indices , not_seed_indices );
CC_indices_in_subnetwork = find( sum( subnetwork , 1 ) > 1 );
indirect_network = double( subnetwork( : , CC_indices_in_subnetwork ) ); % need to convert to double because network is type Integer, and MTIMES is not fully supported for integer classes.

if( length( CC_indices_in_subnetwork ) == 0 )
    CC_mean_connectivity = 0; %If there are no common connectors then DEFINE CC mean connectivity to be 0.
else
    CC_mean_connectivity = mean( sum( indirect_network , 1 ) );
end

indirect_network_as_direct_unweighted = ( indirect_network * indirect_network' ) .* ~eye( length( seed_indices ) )>0;
seed_indir_edge_counts = sum( indirect_network_as_direct_unweighted , 2 );

indirect_network_as_direct_weighted = ( indirect_network * indirect_network' ) .* ~eye( length( seed_indices ) );
seed_indir_edge_sum_weights = sum( indirect_network_as_direct_weighted , 2 );
end
