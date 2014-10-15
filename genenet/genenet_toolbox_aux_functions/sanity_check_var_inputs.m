%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Caries out a number of sanity checks on the variable input for all the seed randomisation (sr) main functions.
%Implementation:
%Keywords:
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

function sanity_check_var_inputs( results_dir_available , results_dir , ...
    results_tag_available , results_tag , ...
    node_attribute_matrix_struct_available , ...
    node_attribute_file_available , ...
    node_attribute_file , ...
    node_attribute_indices_available , ...
    node_attribute_indices , ...
    node_attribute_bins_available )

if( results_dir_available & ~results_tag_available )
    err = MException( '' , 'ERROR: results_dir supplied without results_tag.' );
    throw( err );
end

if( ~results_dir_available & results_tag_available )
    err = MException( '' , 'ERROR: results_tag supplied without results_dir.' );
    throw( err );
end

if( results_dir_available )
    if( ~ischar( results_dir ) )
        err = MException( '' , 'ERROR: results_dir field must be a string' );
        throw( err );
    end
    
    if( ~ ( exist( results_dir , 'file' ) == 7 ) )
        err = MException( '' , 'ERROR: results_dir directory does not exist' );
        throw( err );
    end
end

if( results_tag_available )
    if( ~ischar( results_tag ) )
        err = MException( '' , 'ERROR: results_tag field must be a string' );
        throw( err );
    end
end

if( node_attribute_matrix_struct_available & node_attribute_file_available )
    err = MException( '' , 'ERROR: node-attribute data supplied in two formats, please only provide one.' );
    throw( err );
end

if( node_attribute_file_available & ~ischar( node_attribute_file ) )
    err = MException( '' , 'ERROR: node_attribute_file field must be a string.' );
    throw( err );
end

if( node_attribute_file_available & ~has_txt_extension( node_attribute_file ) )
    err = MException( '' , 'ERROR: node_attribute_file must be a text file and have a .txt extension.' );
    throw( err );
end

if( node_attribute_file_available & ~( exist( node_attribute_file  , 'file' ) == 2 ) )
    err = MException( '' , 'ERROR: node_attribute_file does not exist.'  );
    throw( err );
end

if( node_attribute_file_available & ( ~node_attribute_indices_available | ( length(node_attribute_indices) == 0 ) ) )
    err = MException( '' , 'ERROR: node_attribute_file supplied without node_attribute_indices.' );
    throw( err );
end

if( ~node_attribute_file_available & node_attribute_indices_available )
    err = MException( '' , 'ERROR: node_attribute_indices supplied without node_attribute_file.' );
    throw( err );
end

if( node_attribute_bins_available & (~node_attribute_file_available | ~node_attribute_indices_available | ( length(node_attribute_indices) == 0 ) ) )
    err = MException( '' , 'ERROR: node_attribute_bins supplied, but node_attribute_file and/or node_attribute_indices are missing.' );
    throw( err );
end

if( node_attribute_indices_available & ( length( node_attribute_indices ) > length( unique( node_attribute_indices ) ) ) )
    err = MException( '' , 'ERROR: there are repeated node-attribute indices in node_attribute_indices.' );
    throw( err );
end

if( node_attribute_indices_available & ~all( arrayfun( @(x) ( ( x > 0 ) & ( ~mod( x , 1 ) ) ) , node_attribute_indices ) ) )
    err = MException( '' , 'ERROR: node-attribute indices in node_attribute_indices must be positive integers.' );
    throw( err );
end
