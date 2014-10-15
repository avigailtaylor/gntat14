%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Takes a file of node attributes and stores data in a struct.
%Implementation:
%Keywords: node attribute data struct seed randomisation
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

function node_attribute_matrix_struct =...
    node_attribute_file_2_struct( node_attribute_file , node_attribute_indices , node_attribute_bins_available , node_attribute_bins )

% all the way through reading in this file we need to check for various formatting errors ****************
try
    t_attempt = readtable( node_attribute_file , 'Delimiter' , 'tab' , 'ReadVariableNames' , false );
catch
    err = MException( '' , 'ERROR: there was a problem opening your node attribute file. Please check that the file exists and that the file format matches requirements given in the help documentation.' );
    throw( err );
end

t_attempt_rows_size = size( t_attempt( : , 1 ) );
t_attempt_rows_unique_size = size( unique( t_attempt( : , 1 ) ) );

if( t_attempt_rows_size( 1 ) > t_attempt_rows_unique_size( 1 ) )
    err = MException( '' , 'ERROR: there is something wrong with your node attribute file: attribute-names are not unique. Please check that the file format matches requirements given in the help documentation.' );
    throw( err );
end

t_attempt_cols_size = size( t_attempt{ 1 , : } );
t_attempt_cols_unique_size = size( unique( t_attempt{ 1 , : } ) );

if( t_attempt_cols_size( 2 ) > t_attempt_cols_unique_size( 2 ) )
    err = MException( '' , 'ERROR: there is something wrong with your node attribute file: node-names are not unique. Please check that the file format matches requirements given in the help documentation.' );
    throw( err );
end

try
    t = readtable( node_attribute_file , 'Delimiter' , 'tab' , 'ReadRowNames' , true );
    t_data = num2cell( t{ : , : } );
    t_data_as_matrix = cell2mat( t_data );
catch
    err = MException( '' , 'ERROR: there was a problem opening your node attribute file. Please check that the file format matches requirements given in the help documentation.' );
    throw( err );
end


% further error checks that we can only do now **************************************
[ t_data_matrix_num_rows , ~  ] = size( t_data_as_matrix );
if( t_data_matrix_num_rows < max( node_attribute_indices ) )
    err = MException( '' , 'ERROR: maximum node attribute index exceeds number of attributes.' );
    throw( err );
end

if( t_data_matrix_num_rows < length( node_attribute_indices ) ) % probably don't need this check, as covered by previous check
    % and the fact that node_attribute_indices must be unique
    % array of positive integers... but just in case I've got my logic
    % wrong I'll keep it...
    err = MException( '' , 'ERROR: maximum node attribute index exceeds number of attributes.' );
    throw( err );
end
%*************************************************************************************


% set bin sizes if necessary, otherwise do another error check on the user-provided node_attribute_bins
if( ~node_attribute_bins_available )
    best_bins = get_best_bins( t_data_as_matrix );
    node_attribute_bins = best_bins( node_attribute_indices );
else % node_attribute_bins has been provided, but want to check that its length equals length of node_attribute_indices
    if( length( node_attribute_bins ) ~= length( node_attribute_indices ) )
        err = MException( '' , 'ERROR: length of node_attribute_indices does not equal length of node_attribute_bins.' );
        throw( err );
    end
    
    % also want to check that all of the bins are numbers
    if( ~all( isnumeric( node_attribute_bins ) ) )
        err = MException( '' , 'ERROR: one or more elements in node_attribute_bins is not a number.' );
        throw( err );
    end
    
    % also want to check that all of the bins are positive integers
    if( ~all( arrayfun( @( x ) ( ( x > 0 ) & ( ~mod( x , 1 ) ) ) , node_attribute_bins ) ) )
        err = MException( '' , 'ERROR: one or more elements in node_attribute_bins is not a positive integer.' );
        throw( err );
    end
end

node_attribute_matrix_struct = struct();

node_attribute_matrix_struct.naf = node_attribute_file;
node_attribute_matrix_struct.data_matrix = t_data_as_matrix( node_attribute_indices , : );
node_attribute_matrix_struct.num_bins = node_attribute_bins;
node_attribute_matrix_struct.node_names = transpose( t.Properties.VariableNames );
node_attribute_matrix_struct.attribute_names = t.Properties.RowNames( node_attribute_indices );

