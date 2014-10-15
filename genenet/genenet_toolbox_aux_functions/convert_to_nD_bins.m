%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Outputs a column vector (nD_bins) of the nDimensional bin-assignment for each node.
%Implementation:
%Keywords: multi dimensional bin assignment node attribute seed randomisation
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

function nD_bins = convert_to_nD_bins( data_matrix , num_bins )

% pre-conditions:
% data_matrix rows are attributes and columns are nodes
% num_bins is a vector with length = length( attributes )

% first of all, we need to convert each node-attribute value to a corresponding
% bin-number for the attribute in question.

[ num_attributes , num_nodes ] = size( data_matrix );
all_oneD_bins = ones( num_attributes , num_nodes );

for na_i = 1:num_attributes
    
    na_values = data_matrix( na_i , : );
    na_num_bins = num_bins( na_i );
    
    if( na_num_bins ) > 1
        [ ~ , centres ] = hist( na_values , na_num_bins );
        
        centre_half_diff = ( centres(2) - centres(1) )/2;
        binranges = [ -inf ( centres( 2:end ) - centre_half_diff ) inf ];
        
        [ ~ , oneD_bins ]= histc( na_values , binranges );
        
        all_oneD_bins( na_i , : ) = oneD_bins;
    end
end

% note: unique and ismember have an option to compare rows, but no option
% for columns, therefore we need to work with the transpose of
% all_oneD_bins

if( num_attributes == 1)
    nD_bins = transpose( all_oneD_bins );
else
    all_oneD_bins = transpose( all_oneD_bins );
    
    unique_bin_combinations = unique( all_oneD_bins , 'rows' );
    
    [ ~ , nD_bins ] = ismember( all_oneD_bins , unique_bin_combinations , 'rows' );
end

