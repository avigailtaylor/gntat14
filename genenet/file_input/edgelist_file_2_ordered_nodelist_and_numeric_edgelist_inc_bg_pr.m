%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Auxiliary function file. Turns an edgelist (stored as an edgelist file) in which the node names can have any format, into a list of edges where each of the nodes is replaced by a number. Also outputs the corresponding list of ordered nodes. Does all of this on a user-specified background. Also prints out the background network to file. Uses a perl script at the moment... may change to MATLAB in a later version
%Implementation: --
%Keywords: edge list names nodes ordered number auxiliary background bg perl print
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

function [ ordered_nodelist , numeric_edgelist ] = edgelist_file_2_ordered_nodelist_and_numeric_edgelist_inc_bg_pr( ntwk_edgelist_file , header , bg_names_CELLARRAY , results_dir , results_tag )

working_dir_str = [ 'working_dir_' int2str( floor( rand * 1000000 ) ) ];

[ ~ , ~ , ~ ] = rmdir( working_dir_str , 's' );

[ working_dir_stat , ~ , messid ] = mkdir( working_dir_str );

if( ~working_dir_stat )
    err = MException( '' , 'Unable to create temporary working folder (directory). Please change folder (directory) permissions.' );
    throw( err );
end

if( strcmp( messid , 'MATLAB:MKDIR:DirectoryExists' ) ) %% THIS SHOULD NEVER HAPPEN
    err = MException( '' , [ 'A folder (directory) called ' working_dir_str ' already exists in the current folder. Please rename or remove this folder and rerun.' ] );
    throw( err );
end

% make the background file for perl script ***********************************************************************************************
[ fid_bgf , ~ ] = fopen( [ working_dir_str '/bgf' ] , 'w' );

if( fid_bgf < 0 )
    err = MException( '' , 'Unable to create temporary file in working folder (directory). Please change folder (directory) permissions.' );
    throw( err );
else
    for i = 1:length( bg_names_CELLARRAY{ 1 } )
        fprintf( fid_bgf , '%s\n' , bg_names_CELLARRAY{ 1 }{ i } );
    end
    fclose( fid_bgf );
end
% ****************************************************************************************************************************************


status_code = str2num( perl( 'edgelist_file_2_ordered_nodelist_and_numeric_edgelist_files_inc_bg_print.pl' , ntwk_edgelist_file , num2str( header ) , [ working_dir_str '/onf' ] , [ working_dir_str '/nef' ] , [ working_dir_str '/bgf' ] , [results_dir '/' results_tag '.BACKGROUND_NETWORK' ] ) );

switch status_code
    
    case -4
        rmdir( working_dir_str , 's' );
        err = MException( '' , 'Unable to create background network file in results folder (directory). Please check permissions.' );
        throw( err );
    case -3
        rmdir( working_dir_str , 's' );
        err = MException( '' , 'Unable to open network edgelist file. File does not exist.' );
        throw( err );
    case -2
        rmdir( working_dir_str , 's' );
        err = MException( '' , 'Unable to create file in working folder (directory). Please check permissions.' );
        throw( err );
    case -1
        rmdir( working_dir_str , 's' );
        err = MException( '' , 'Network edge list file is not formatted properly. It should have two columns, be space or tab delimited, with each edge on a new line. Node names should only contain alphanumeric characters (including underscore character). Make sure there are no empty lines in your file, including the last line.' );
        throw( err );
        
    case 1
        ordered_nodelist = read_nodelist_file( [ working_dir_str '/onf' ] , 0 );
        ordered_nodelist = ordered_nodelist{ 1 };
        numeric_edgelist = load( [ working_dir_str '/nef' ] );
        
end

rmdir( working_dir_str , 's' );

end

