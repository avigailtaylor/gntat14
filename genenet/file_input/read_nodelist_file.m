%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Reads in a list of nodes and carries out error checking.
%Implementation:
%Keywords: reads nodes file auxiliary
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

function node_names_CELLARRAY = read_nodelist_file( nodelist_file , header )


% open the file and throw an error if file won't open *********************
[ fid , errmsg ] = fopen( nodelist_file );

if( fid < 0 )
    err = MException( '' , errmsg );
    throw( err );
end
% *************************************************************************

% deal with the header line, if necessary *********************************
switch header
    
    case 0 % no header line
        
        % do nothing
        
    case 1 % header line
        
        try	% Try to read in the header line. Throw an error if it is not of the correct format.
            textscan( fid , '%s' , 1 , 'Delimiter' , { '\n' , '\r' } , 'whitespace' , '' , 'ReturnOnError' , false );
	catch ME
            err = MException( '' , [ 'Node list file ' nodelist_file ' is not formatted properly. Got stuck reading header line. Each node should be on a new line. Node names should only contain alphanumeric characters (including underscore character). Make sure there are no empty lines in your file, including the last line.' ] );
            throw( err );
        end
        
end
%**************************************************************************

% now read the node list in from nodelist_file ****************************

try	% Try to read in the file. Throw an error if it is not of the correct format.
    node_names_CELLARRAY = textscan( fid , '%s' , 'Delimiter' , { '\n' , '\r' } , 'whitespace' , '' , 'ReturnOnError' , false );
catch ME
    err = MException( '' , [ 'Node list file ' nodelist_file ' is not formatted properly. Each node should be on a new line. Node names should only contain alphanumeric characters (including underscore character). Make sure there are no empty lines in your file, including the last line.' ] );
    throw( err );
end

% Do a bit more error checking. Nodes should not contain commas or be completely white space. If these rules are violated then there is probably
% a problem with the file format.

%error_1 = any( cellfun( @( node_string ) any( [ all( isstrprop( node_string , 'wspace' ) ) , length( strfind( node_string , ',' ) ) ] ) , node_names_CELLARRAY{ 1 } ) );

error_1 = ~all( cellfun( @( node_string ) isequal( regexp( node_string , '^\w*$' ) , [ 1 ] ) , node_names_CELLARRAY{ 1 } ) );

if( error_1 )
    err = MException( '' , [ 'Node list file ' nodelist_file ' is not formatted properly. Each node should be on a new line. Node names should only contain alphanumeric characters (including underscore character). Make sure there are no empty lines in your file, including the last line.' ] );
    throw( err );
end

fclose( fid );
end

