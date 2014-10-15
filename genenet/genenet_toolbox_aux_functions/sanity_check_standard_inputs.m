%Author: Avigail Taylor
%Version: 1
%Date: 20140722
%Description: Caries out a number of sanity checks on the standard input for all the main functions.
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

function sanity_check_standard_inputs( main_function_name , varargin )

switch main_function_name
    case 'np_seed'
        for kk = 1:9
            switch kk
                case 1 %ntwk_edgelist_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: ntwk_edgelist_file must be a string.' );
                        throw( err );
                    end
                case 2 %ntwk_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: ntwk_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 3 %seed_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: seed_file must be a string.' );
                        throw( err );
                    end
                case 4 %s_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: s_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 5 %perms
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: perms must be a positive integer.' );
                        throw( err );
                    end
                case 6 %num_switches
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: num_switches must be a positive integer.' );
                        throw( err );
                    end
                case 7 %protect_perm_step
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: protect_perm_step must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 8 %parallelise
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: parallelise must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 9 %quickview_flag
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: quickview_flag must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
            end
        end
    case 'np_seed_bg'
        for kk = 1:11
            switch kk
                case 1 %ntwk_edgelist_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: ntwk_edgelist_file must be a string.' );
                        throw( err );
                    end
                case 2 %ntwk_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: ntwk_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 3 %bg_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: bg_file must be a string.' );
                        throw( err );
                    end
                case 4 %bg_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bg_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 5 %seed_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: seed_file must be a string.' );
                        throw( err );
                    end
                case 6 %s_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: s_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 7 %perms
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: perms must be a positive integer.' );
                        throw( err );
                    end
                case 8 %num_switches
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: num_switches must be a positive integer.' );
                        throw( err );
                    end
                case 9 %protect_perm_step
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: protect_perm_step must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 10 %parallelise
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: parallelise must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 11 %quickview_flag
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: quickview_flag must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
            end
        end
    case 'np_seed2back'
        for kk = 1:12
            switch kk
                case 1 %ntwk_edgelist_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: ntwk_edgelist_file must be a string.' );
                        throw( err );
                    end
                case 2 %ntwk_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: ntwk_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 3 %seed_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: seed_file must be a string.' );
                        throw( err );
                    end
                case 4 %s_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: s_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 5 %bb_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: bb_file must be a string.' );
                        throw( err );
                    end
                case 6 %bb_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bb_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 7 %s_bb_comb
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } >= 1 ) & ( varargin{ kk } <= 3 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , [ 'ERROR: s_bb_comb must be an integer between 1 and 3: ' ,...
                            '1 = treat joint seed/backbone as backbone; ',...
                            '2 = treat joint seed/backbone as seeds; ',...
                            '3 = treat joint seed/backbone as neither.' ] );
                        throw( err );
                    end
                case 8 %perms
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: perms must be a positive integer.' );
                        throw( err );
                    end
                case 9 %num_switches
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: num_switches must be a positive integer.' );
                        throw( err );
                    end
                case 10 %protect_perm_step
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: protect_perm_step must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 11 %parallelise
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: parallelise must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 12 %quickview_flag
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: quickview_flag must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
            end
        end
    case 'np_seed2back_bg'
        for kk = 1:15
            switch kk
                case 1 %ntwk_edgelist_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: ntwk_edgelist_file must be a string.' );
                        throw( err );
                    end
                case 2 %ntwk_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: ntwk_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 3 %bg_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: bg_file must be a string.' );
                        throw( err );
                    end
                case 4 %bg_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bg_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 5 %seed_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: seed_file must be a string.' );
                        throw( err );
                    end
                case 6 %s_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: s_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 7 %bb_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: bb_file must be a string.' );
                        throw( err );
                    end
                case 8 %bb_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bb_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 9 %s_bb_comb
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } >= 1 ) & ( varargin{ kk } <= 3 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , [ 'ERROR: s_bb_comb must be an integer between 1 and 3: ' ,...
                            '1 = treat joint seed/backbone as backbone; ',...
                            '2 = treat joint seed/backbone as seeds; ',...
                            '3 = treat joint seed/backbone as neither.' ] );
                        throw( err );
                    end
                case 10 %bb_bg_comb
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bb_bg_comb must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 11 %perms
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: perms must be a positive integer.' );
                        throw( err );
                    end
                case 12 %num_switches
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: num_switches must be a positive integer.' );
                        throw( err );
                    end
                case 13 %protect_perm_step
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: protect_perm_step must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end    
                case 14 %parallelise
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: parallelise must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 15 %quickview_flag
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: quickview_flag must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
            end
        end
    case 'sr_seed'
        for kk = 1:7
            switch kk
                case 1 %ntwk_edgelist_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: ntwk_edgelist_file must be a string.' );
                        throw( err );
                    end
                case 2 %ntwk_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: ntwk_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 3 %seed_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: seed_file must be a string.' );
                        throw( err );
                    end
                case 4 %s_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: s_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 5 %rands
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: rands must be a positive integer.' );
                        throw( err );
                    end
                case 6 %parallelise
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: parallelise must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 7 %quickview_flag
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: quickview_flag must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
            end
        end
    case 'sr_seed_bg'
        for kk = 1:9
            switch kk
                case 1 %ntwk_edgelist_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: ntwk_edgelist_file must be a string.' );
                        throw( err );
                    end
                case 2 %ntwk_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: ntwk_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 3 %bg_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: bg_file must be a string.' );
                        throw( err );
                    end
                case 4 %bg_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bg_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 5 %seed_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: seed_file must be a string.' );
                        throw( err );
                    end
                case 6 %s_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: s_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 7 %rands
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: rands must be a positive integer.' );
                        throw( err );
                    end
                case 8 %parallelise
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: parallelise must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 9 %quickview_flag
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: quickview_flag must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
            end
        end
    case 'sr_seed2back'
        for kk = 1:10
            switch kk
                case 1 %ntwk_edgelist_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: ntwk_edgelist_file must be a string.' );
                        throw( err );
                    end
                case 2 %ntwk_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: ntwk_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 3 %seed_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: seed_file must be a string.' );
                        throw( err );
                    end
                case 4 %s_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: s_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 5 %bb_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: bb_file must be a string.' );
                        throw( err );
                    end
                case 6 %bb_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bb_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 7 %s_bb_comb
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } >= 1 ) & ( varargin{ kk } <= 3 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , [ 'ERROR: s_bb_comb must be an integer between 1 and 3: ' ,...
                            '1 = treat joint seed/backbone as backbone; ',...
                            '2 = treat joint seed/backbone as seeds; ',...
                            '3 = treat joint seed/backbone as neither.' ] );
                        throw( err );
                    end
                case 8 %rands
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: rands must be a positive integer.' );
                        throw( err );
                    end
                case 9 %parallelise
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: parallelise must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 10 %quickview_flag
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: quickview_flag must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
            end
        end
    case 'sr_seed2back_bg'
        for kk = 1:13
            switch kk
                case 1 %ntwk_edgelist_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: ntwk_edgelist_file must be a string.' );
                        throw( err );
                    end
                case 2 %ntwk_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: ntwk_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 3 %bg_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: bg_file must be a string.' );
                        throw( err );
                    end
                case 4 %bg_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bg_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 5 %seed_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: seed_file must be a string.' );
                        throw( err );
                    end
                case 6 %s_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: s_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 7 %bb_file
                    if( ~ischar( varargin{ kk } ) )
                        err = MException( '' , 'ERROR: bb_file must be a string.' );
                        throw( err );
                    end
                case 8 %bb_header
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bb_header must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 9 %s_bb_comb
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } >= 1 ) & ( varargin{ kk } <= 3 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , [ 'ERROR: s_bb_comb must be an integer between 1 and 3: ' ,...
                            '1 = treat joint seed/backbone as backbone; ',...
                            '2 = treat joint seed/backbone as seeds; ',...
                            '3 = treat joint seed/backbone as neither.' ] );
                        throw( err );
                    end
                case 10 %bb_bg_comb
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: bb_bg_comb must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 11 %rands
                    if( ~( isnumeric(  varargin{ kk } ) & ( varargin{ kk } > 0 ) & ( ~mod( varargin{ kk } ,1 ) ) ) )
                        err = MException( '' , 'ERROR: rands must be a positive integer.' );
                        throw( err );
                    end
                case 12 %parallelise
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: parallelise must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
                case 13 %quickview_flag
                    if( ~( islogical( varargin{ kk } ) | varargin{ kk } == 0 | varargin{ kk } == 1 ) )
                        err = MException( '' , 'ERROR: quickview_flag must be true or false ( 1 or 0 ).' );
                        throw( err );
                    end
            end
        end
end
