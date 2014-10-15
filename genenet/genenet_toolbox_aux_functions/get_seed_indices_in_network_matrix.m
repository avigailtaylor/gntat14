%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Gets the indices, within the network matrix, of seed nodes
%Implementation: Wraps the in-built MATLAB ismember function.
%Keywords: seed indices network matrix
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

function seed_indices = get_seed_indices_in_network_matrix( numeric_seedlist , ordered_nodelist )

[ ~ , seed_indices ] = ismember( numeric_seedlist , ordered_nodelist );

end
