%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Gets the numeric indirect network.
%Implementation: Gets the indirect network as described in DAPPLE. (Rossin et al., PLoS Genetics 2007)
%Keywords: indirect network auxiliary
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

function numeric_indir_network = get_numeric_indirect_network( network_matrix , seed_indices , not_seed_indices , ordered_nodelist )

subnetwork = network_matrix( seed_indices , not_seed_indices );
CC_indices_in_subnetwork = find( sum( subnetwork , 1 ) > 1 );

cc_indices = not_seed_indices( CC_indices_in_subnetwork );

[ Iindir , Jindir ] = find( network_matrix( seed_indices , cc_indices ) );
numeric_indir_network = [ ordered_nodelist( seed_indices( Iindir ) )  ordered_nodelist( cc_indices( Jindir ) ) ];

end
