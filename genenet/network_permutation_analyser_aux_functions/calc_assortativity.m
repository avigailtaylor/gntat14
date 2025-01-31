%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Calculates the network assortativity coefficient.
%Implementation: The assortativity coefficient is the Pearson correlation coefficient of degree between pairs of linked nodes ( M.E.J. Newman. "Assortative mixing in networks." Phys. Rev. Lett. 89, 208701 (2002) )
%Keywords: network assortativity pearson correlation coefficient
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

function [ assortativity_coeff ] = calc_assortativity( network_matrix )

deg_counts_vec = sum( network_matrix , 2 );

[ r, c ] = find( triu( network_matrix ) );

corrcoef_matrix = corrcoef( deg_counts_vec( [ r c ] ) - 1 );

assortativity_coeff = corrcoef_matrix( 1 , 2 );

end





