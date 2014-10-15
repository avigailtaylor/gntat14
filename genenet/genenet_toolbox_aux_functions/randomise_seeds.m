%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: General function to randomly select node(gene)-sets containing the same number of nodes(genes) as there are in the real set of seeds. It is called, in some form or other, by all seed randomisation (sr) functions. If nodes need to be excluded from the selection process (for example if they are part of the backbone), then they can be specified using the 'excluded_indices' parameter. Function can be called with and without accounting for attributes. If attributes do not need to be accounted for then nD_bins is just an array of ones (same size as node_indices).
%Implementation: See supplemental materials.
%Keywords: seed randomisation
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

function random_seed_indices = randomise_seeds( node_indices , excluded_indices , seed_indices , nD_bins )

random_seed_indices = [];

seed_nD_bins = nD_bins( seed_indices );

unique_seed_nD_bins = unique( seed_nD_bins );

for bi = 1:length( unique_seed_nD_bins )
    unique_seed_nD_bin = unique_seed_nD_bins( bi );
    
    num_seeds_in_bin = length( find( seed_nD_bins == unique_seed_nD_bin ) );
    
    nodes_in_bin_indices = node_indices( find( nD_bins == unique_seed_nD_bin ) );
    
    node_indices_to_choose_from = setdiff( nodes_in_bin_indices , excluded_indices );
    
    randomiser = randperm( length( node_indices_to_choose_from ) );
    
    random_seed_indices = [ random_seed_indices ; node_indices_to_choose_from( randomiser( 1:num_seeds_in_bin ) )' ];
    
end
