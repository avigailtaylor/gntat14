%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Calculates the overlap between a network and a permutation of the network.
%Implementation: 
%Keywords: overlap network permuted permutation
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

function overlap_with_network = calc_overlap_with_network( network_matrix , network_matrix_permuted )

% ASSUMPTIONS: ************************************************************************************
% network_matrix and network_matrix_permuted have the same dimensions as
% one another.
% There are no negative or weighted edges in either network_matrix or
% network_matrix_permuted.
%**************************************************************************************************

num_network_edges = sum( sum( network_matrix ) );

overlap_with_network = sum( sum( network_matrix_permuted + network_matrix == 2 ) )/num_network_edges;

end

