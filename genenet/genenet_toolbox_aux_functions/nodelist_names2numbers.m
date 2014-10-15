%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Turns a list of node names into numbers suitable for use in MATLAB code. Function read_nodelist_file is called before this function is called; that function reads a nodelist file in to a CELLARRAY (passed as node_names_CELLARRAY here).
%Implementation: --
%Keywords: node names numbers list
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

function [ numeric_nodelist, names_in_list, names_not_in_list ] = nodelist_names2numbers( node_names_CELLARRAY , ordered_nodelist )

[ ~ , numeric_nodelist ] = ismember( node_names_CELLARRAY{ 1 } , ordered_nodelist );

names_in_list = node_names_CELLARRAY{ 1 }( find( numeric_nodelist > 0 ) );

names_not_in_list = node_names_CELLARRAY{ 1 }(find( numeric_nodelist == 0 ) );

numeric_nodelist = numeric_nodelist( find( numeric_nodelist > 0 ) );
end
