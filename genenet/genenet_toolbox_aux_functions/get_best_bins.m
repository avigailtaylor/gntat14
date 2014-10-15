%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Gets the 'best' suggested number of bins for each row (attribute) in the data matrix
%Implementation:
%Keywords: bin group number best suggested data matrix node attributes seed randomisation
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

function bin_sizes = get_best_bins( data_matrix )

[ num_rows , ~ ] = size( data_matrix );
bin_sizes = zeros( num_rows , 1 );

for i = 1:num_rows
    bin_sizes(i) = calcnbins( data_matrix( i , : ) , 'middle' );
end
