function varargout = network_permutation_analyser(varargin)
% NETWORK_PERMUTATION_ANALYSER MATLAB code for network_permutation_analyser.fig
%      NETWORK_PERMUTATION_ANALYSER, by itself, creates a new NETWORK_PERMUTATION_ANALYSER or raises the existing
%      singleton*.
%
%      H = NETWORK_PERMUTATION_ANALYSER returns the handle to a new NETWORK_PERMUTATION_ANALYSER or the handle to
%      the existing singleton*.

% Last Modified by GUIDE v2.5 07-Aug-2014 12:46:02

% Network Permutation Analyser. A pre-analysis tool for use with GeneNet Toolbox.
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

%**************************************************************************
% INITIALIZATION AND OPENING CODE, ETC.
%**************************************************************************

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct( 'gui_Name' ,       mfilename , ...
    'gui_Singleton' ,  gui_Singleton , ...
    'gui_OpeningFcn' , @network_permutation_analyser_OpeningFcn , ...
    'gui_OutputFcn' ,  @network_permutation_analyser_OutputFcn , ...
    'gui_LayoutFcn' ,  [] , ...
    'gui_Callback' ,   [] );
if nargin && ischar( varargin{ 1 } )
    gui_State.gui_Callback = str2func( varargin{ 1 } );
end

if nargout
    [ varargout{ 1:nargout } ] = gui_mainfcn( gui_State , varargin{ : } );
else
    gui_mainfcn( gui_State , varargin{ : } );
end
% End initialization code - DO NOT EDIT


% --- Executes just before network_permutation_analyser is made visible.
function network_permutation_analyser_OpeningFcn( hObject , eventdata , handles , varargin )
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to network_permutation_analyser (see VARARGIN)

% Choose default command line output for network_permutation_analyser
handles.output = hObject;

% Update handles structure
guidata( hObject , handles );

% UIWAIT makes network_permutation_analyser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = network_permutation_analyser_OutputFcn( hObject , eventdata , handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{ 1 } = handles.output;

%**************************************************************************
% END INITIALIZATION AND OPENING CODE, ETC.
%**************************************************************************



%**************************************************************************
% INPUT  PANEL (CALLBACK FUNCTIONS ONLY )
%**************************************************************************

% --- Executes on button press in pb_browse.
function pb_browse_Callback( hObject , eventdata , handles)
% hObject    handle to pb_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ file_name , path_name , ~ ] = uigetfile( '*.*' , 'Select Network File' );
if( file_name ~= 0 )
    set( handles.edit_network_file , 'string' , [ path_name file_name ] );
end


% --- Executes on button press in pb_browse_background.
function pb_browse_background_Callback( hObject , eventdata , handles)
% hObject    handle to pb_browse_background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ file_name , path_name , ~ ] = uigetfile( '*.*' , 'Select Background File' );
if( file_name ~= 0 )
    set( handles.edit_background_file , 'string' , [ path_name file_name ] );
end

% --- Executes on button press in checkbox_specify_background.
function checkbox_specify_background_Callback( hObject , eventdata , handles)
% hObject    handle to checkbox_specify_background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_specify_background
% Action when checkbox is toggled on
if( get( hObject , 'Value' ) == 1 )
    set( handles.static_background_file , 'Enable' , 'on' );
    set( handles.edit_background_file , 'Enable' , 'on' );
    set( handles.checkbox_rm_bg_headers , 'Enable' , 'on' );
    set( handles.pb_browse_background , 'Enable' , 'on' );
    
    drawnow
    
% Action when checkbox is toggled off
else
    set( handles.static_background_file , 'Enable' , 'off' );
    set( handles.edit_background_file , 'Enable' , 'off' );
    set( handles.checkbox_rm_bg_headers , 'Enable' , 'off' );
    set( handles.pb_browse_background , 'Enable' , 'off' );
    
    drawnow
end

%**************************************************************************
% END INPUT PANEL
%*************************************************************************



%**************************************************************************
% CONTROLS PANEL
%**************************************************************************

% --- Executes on button press in pb_start.
function pb_start_Callback( hObject , eventdata , handles )
% hObject    handle to pb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset outputs in case reset button was not pressed **********************
% reset inputs and progress bar

% reset network attributes text
set( handles.static_total_nodes , 'string' , '' );
set( handles.static_total_edges , 'string' , '' );
set( handles.static_total_u_nodes , 'string' , '' );
set( handles.static_total_u_edges , 'string' , '' );

set( handles.static_mean_local_cc , 'string' , '' );
set( handles.static_global_cc , 'string' , '' );
set( handles.static_ac , 'string' , '' );

% reset network attributes axes
loglog( handles.axes_nc , [ 0 ] , [ 0 ] , 'x' );
set( handles.axes_nc , 'YTick' , [] );
set( handles.axes_nc , 'YTickLabel' , { ' ' } );
set( handles.axes_nc , 'XTick' , [] );
set( handles.axes_nc , 'XTickLabel' , { ' ' } );

% reset permuted network and permutations attributes
set( handles.static_mean_mean_local_cc , 'string' , '' );
set( handles.static_mean_global_cc , 'string' , '' );
set( handles.static_mean_percent_unbroken_edges , 'string' , '' );
set( handles.static_mean_percent_unbroken_gunique_edges , 'string' , '' );

% reset plot of percentage of edges remaining unbroken in 1..N permuted Networks
%************************************************************
bar( handles.axes_edges_present_in_perm_networks_bar , [ NaN ] , [ NaN ] );
set( handles.axes_edges_present_in_perm_networks_bar , 'YTick' , [] );
set( handles.axes_edges_present_in_perm_networks_bar , 'YTickLabel' , { ' ' } );
set( handles.axes_edges_present_in_perm_networks_bar , 'XTick' , []);
set( handles.axes_edges_present_in_perm_networks_bar , 'XTickLabel' , { ' ' } );

% reset the reset button
set( handles.pb_reset , 'Enable' , 'off' );
%**************************************************************************

ntwk_edgelist_file = get( handles.edit_network_file , 'string' );
ntwk_header = get( handles.checkbox_rm_nf_headers , 'Value' );

bg_file = get( handles.edit_background_file , 'string' );
bg_header = get( handles.checkbox_rm_bg_headers , 'Value' );

permutations_str = get( handles.edit_permutations , 'string' );
switches_str = get( handles.edit_switches , 'string' );
protect_perm_step = get( handles.checkbox_protect_permutation_step , 'Value' );
%**************************************************************************

% now get the input requirements according to the checkboxes the user has
% ticked (plus default settings)

input_requirements_code = eval_input_requirements( handles );
%**************************************************************************

switch input_requirements_code
    
    case 0 % basic input
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 )...
                & ( check_integer_field( switches_str ) == 1 ) )
            
            % turn the start button off ******************
            set( handles.pb_start , 'Enable' , 'off' );
            drawnow
            %*********************************************
            
            % turn the cancel toggle button on ***********
            set( handles.toggle_cancel , 'Enable' , 'on' );
            drawnow
            %*********************************************
            
            % turn permutations_str and switches_str into numbers *****
            perms = str2num( permutations_str );
            num_switches = str2num( switches_str );
            % *********************************************************
            
            try
                % analyse network *************************************
                network_matrix = npa_aux( ntwk_edgelist_file , ntwk_header , handles );
                
                
                %*********************************************
                % run permutations
                %*********************************************
                % update progress bar*************************
                set( handles.static_progress_status , 'string' , 'Permutations...' );
                drawnow
                if( get( handles.toggle_cancel , 'Value' ) == 1 )
                    err = MException( '', 'User requested cancel' );
                    throw( err );
                end
                
                % do the permutations ************************
                [ average_local_ccs , global_ccs , overlaps_with_network , overlaps_with_Gunique_network , num_Pedges_present_in_num_networks , num_networks ] =...
                    run_characterisation_permutations( network_matrix , perms , num_switches , protect_perm_step , handles );
                
                % update text boxes in permuted network and permutation attributes
                % panels***************************************
                set( handles.static_mean_mean_local_cc , 'string' , num2str( mean( average_local_ccs ) ) );
                set( handles.static_mean_global_cc , 'string' , num2str( mean( global_ccs ) ) );
                set( handles.static_mean_percent_unbroken_edges , 'string' , num2str( mean( overlaps_with_network * 100 ) ) );
                set( handles.static_mean_percent_unbroken_gunique_edges , 'string' , num2str( mean( overlaps_with_Gunique_network * 100 ) ) );
                %**********************************************
                
                % plot percentage of edges remaining unbroken in 1..N permuted Networks
                %************************************************************
                if( perms > 1 )
                    bar( handles.axes_edges_present_in_perm_networks_bar , num_networks , ( num_Pedges_present_in_num_networks ./ sum( num_Pedges_present_in_num_networks ) ) .* 100 );
                else
                    bar( handles.axes_edges_present_in_perm_networks_bar , [ 1 ] , [ 100 ] );
                end
                
                xlabel( handles.axes_edges_present_in_perm_networks_bar , 'Number of Permuted Networks' );
                ylabel( handles.axes_edges_present_in_perm_networks_bar , '% Persistent Edges' );
                
                %*************************************************************
                
                % update progress bar ************************
                set( handles.static_progress_status , 'string' , 'Done' );
                drawnow
                %*********************************************
                
                % turn the reset button on *******************
                set( handles.pb_reset , 'Enable' , 'on' );
                %*********************************************
                
                % turn the start button on ******************
                set( handles.pb_start , 'Enable' , 'on' );
                %********************************************
                
                % turn the cancel toggle button off *********
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                %*********************************************
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                
                drawnow
                return
            end
        else
            field_names = { 'Network File' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , permutations_str , switches_str };
            field_codes = [ 0 1 2 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 1 % basic input with background
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 )...
                & ( check_integer_field( switches_str ) == 1 ) )
            
            % turn the start button off ******************
            set( handles.pb_start , 'Enable' , 'off' );
            drawnow
            %*********************************************
            
            % turn the cancel toggle button on ***********
            set( handles.toggle_cancel , 'Enable' , 'on' );
            drawnow
            %*********************************************
            
            % turn permutations_str and switches_str into numbers *****
            perms = str2num( permutations_str );
            num_switches = str2num( switches_str );
            % *********************************************************
            
            try
                % analyse network *************************************
                network_matrix = npa_on_bg_aux( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , handles );
                
                
                %*********************************************
                % run permutations
                %*********************************************
                % update progress bar*************************
                set( handles.static_progress_status , 'string' , 'Permutations...' );
                drawnow
                if( get( handles.toggle_cancel , 'Value' ) == 1 )
                    err = MException( '' , 'User requested cancel' );
                    throw( err );
                end
                
                % do the permutations ************************
                [ average_local_ccs , global_ccs , overlaps_with_network , overlaps_with_Gunique_network , num_Pedges_present_in_num_networks , num_networks ] =...
                    run_characterisation_permutations( network_matrix , perms , num_switches , protect_perm_step , handles );
                
                % update text boxes in permuted network and permutation attributes
                % panels***************************************
                set( handles.static_mean_mean_local_cc , 'string' , num2str( mean( average_local_ccs ) ) );
                set( handles.static_mean_global_cc , 'string' , num2str( mean( global_ccs ) ) );
                set( handles.static_mean_percent_unbroken_edges , 'string' , num2str( mean( overlaps_with_network * 100 ) ) );
                set( handles.static_mean_percent_unbroken_gunique_edges , 'string' , num2str( mean( overlaps_with_Gunique_network * 100 ) ) );
                %**********************************************
                
                % plot percentage of edges remaining unbroken in 1..N permuted Networks
                %************************************************************
                if( perms > 1 )
                    bar( handles.axes_edges_present_in_perm_networks_bar , num_networks , ( num_Pedges_present_in_num_networks ./ sum( num_Pedges_present_in_num_networks ) ) .* 100 );
                else
                    bar(handles.axes_edges_present_in_perm_networks_bar , [ 1 ] , [ 100 ] );
                end
                
                xlabel( handles.axes_edges_present_in_perm_networks_bar , 'Number of Permuted Networks' );
                ylabel( handles.axes_edges_present_in_perm_networks_bar , '% Persistent Edges' );
                
                %*************************************************************
                
                % update progress bar ************************
                set( handles.static_progress_status , 'string' , 'Done' );
                drawnow
                %*********************************************
                
                % turn the reset button on *******************
                set( handles.pb_reset , 'Enable' , 'on' );
                %*********************************************
                
                % turn the start button on ******************
                set( handles.pb_start , 'Enable' , 'on' );
                %********************************************
                
                % turn the cancel toggle button off *********
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                %*********************************************
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                
                drawnow
                return
            end
        else
            field_names = { 'Network File' , 'Background File' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , bg_file , permutations_str , switches_str };
            field_codes = [ 0 0 1 2 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
end


% --- Executes on button press in pb_reset.
function pb_reset_Callback( hObject , eventdata , handles )
% hObject    handle to pb_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset inputs and progress bar
set( handles.edit_network_file , 'string' , '' );
set( handles.checkbox_rm_nf_headers , 'Value' , 0 );
set( handles.edit_permutations , 'string' , '10' );
set( handles.edit_switches , 'string' , '10' );
set( handles.checkbox_protect_permutation_step , 'Value' , 0 );

set( handles.checkbox_specify_background , 'Value' , 0 );
set( handles.edit_background_file , 'string' , '' );
set( handles.checkbox_rm_bg_headers , 'Value' , 0 );
set( handles.static_background_file , 'Enable' , 'off' );
set( handles.edit_background_file , 'Enable' , 'off' );
set( handles.checkbox_rm_bg_headers , 'Enable' , 'off' );
set( handles.pb_browse_background , 'Enable' , 'off' );

% reset network attributes text
set( handles.static_total_nodes , 'string' , '' );
set( handles.static_total_edges , 'string' , '' );
set( handles.static_total_u_nodes , 'string' , '' );
set( handles.static_total_u_edges , 'string' , '' );

set( handles.static_mean_local_cc , 'string' , '' );
set( handles.static_global_cc , 'string' , '' );
set( handles.static_ac , 'string' , '' );

% reset network attributes axes
loglog( handles.axes_nc , [ 0 ] , [ 0 ] , 'x' );
set( handles.axes_nc , 'YTick' , [] );
set( handles.axes_nc , 'YTickLabel' , { ' ' } );
set( handles.axes_nc , 'XTick' , [] );
set( handles.axes_nc , 'XTickLabel' , { ' ' } );

% reset permuted network and permutations attributes
set( handles.static_mean_mean_local_cc , 'string' , '' );
set( handles.static_mean_global_cc , 'string' , '' );
set( handles.static_mean_percent_unbroken_edges , 'string' , '' );
set( handles.static_mean_percent_unbroken_gunique_edges , 'string' , '' );

% reset plot of percentage of edges remaining unbroken in 1..N permuted Networks
%************************************************************
bar( handles.axes_edges_present_in_perm_networks_bar , [ NaN ] , [ NaN ] );
set( handles.axes_edges_present_in_perm_networks_bar , 'YTick' , [] );
set( handles.axes_edges_present_in_perm_networks_bar , 'YTickLabel' , { ' ' } );
set( handles.axes_edges_present_in_perm_networks_bar , 'XTick' , [] );
set( handles.axes_edges_present_in_perm_networks_bar , 'XTickLabel' , { ' ' } );

% reset controls area
set( handles.static_progress_status , 'string' , '' );
set( handles.pb_start , 'Enable' , 'on' );
set( handles.pb_reset , 'Enable' , 'off' );
set( handles.toggle_cancel , 'Enable' , 'off' );
set( handles.toggle_cancel , 'Value' , 0 );

%**************************************************************************
% END CONTROLS PANEL
%**************************************************************************



% *************************************************************************
% AUXILIARY FUNCTIONS (CALLED BY CALLBACK FUNCTIONS, OR OTHER AUX
% FUNCTIONS )
% *************************************************************************

% --- Executes when called by callback function for pb_start
function input_requirements_code = eval_input_requirements( handles )

input_requirements_code = 0;

if( get( handles.checkbox_specify_background , 'Value' ) == 1 )
    input_requirements_code = 1;
end


% --- Executes when called by callback function for pb_start
function warning_message = get_warning_message( field_names , field_vals , field_codes ) % works for directory names too

warning_message_as_list = [ 'Warning. There are problems with your input.\n\n' ];

for i = 1:length( field_codes )
    switch field_codes( i )
        
        case 0 % checking a file
            
            if( ~( exist( field_vals{ i } , 'file' ) == 2 ) ) % only need a warning when file does not exist
                warning_message_as_list = [ warning_message_as_list field_names{ i } '- ' get_warning_message_aux( field_vals{ i } , field_codes( i ) ) '\n\n' ];
            end
            
        case 1 % checking permutations field
            if( check_integer_field( field_vals{ i } ) > 1 ) % only need a warning when there is a problem with the permutations string
                warning_message_as_list = [ warning_message_as_list field_names{ i } '- ' get_warning_message_aux( field_vals{ i } , field_codes( i ) ) '\n\n' ];
            end
            
        case 2 % checking switches field
            if( check_integer_field( field_vals{ i } ) > 1 ) % only need a warning when there is a problem with the switches string
                warning_message_as_list = [ warning_message_as_list field_names{ i } '- ' get_warning_message_aux( field_vals{ i } , field_codes( i ) ) '\n\n' ];
            end
    end
end

warning_message = sprintf( warning_message_as_list );


% --- Executes when called by get_warning_message (in turn called by
% callback function for pb_start)
function integer_field_code = check_integer_field( integer_field )

integer_field_code = 1; % return a value of 1 if integer_field is fine

if( length( integer_field ) == 0 | length( integer_field ) == [ 1 0 ] | all( isstrprop( integer_field , 'wspace' ) ) )
    integer_field_code = 2; % return a value of 2 if integer_field is empty
    % or is all whitespace
else
    if( ~all( isstrprop( strtrim( integer_field ) , 'digit' ) ) )
        integer_field_code = 3; % return a value of 3 if non-digit characters
        % are present in integer_field
        % (but ignore leading and trailing white space
        % characters)
    else
        if( str2num( integer_field ) == 0 )
            integer_field_code = 4;
        end
    end
end


% --- Executes when called by get_warning_message (in turn called by
% callback function for pb_start)
function warning_string = get_warning_message_aux( field_val , field_code ) % works for directory names too

switch field_code
    
    case 0 % make warning message for file
        
        if( length( field_val ) == 0 | length( field_val ) == [ 1 0 ] | all( isstrprop( field_val , 'wspace' ) ) )
            warning_string = 'You have not specified a name for this file.';
        else
            if( exist( field_val , 'file' ) == 7 )
                % user has specified a directory that exists, but they need to
                % specify a file
                warning_string = [ field_val ' is a directory, not a file name.' ];
            else
                warning_string = [ 'File does not exist: ' field_val '.' ];
            end
        end
        
        
    case 1 % make warning message for permutations field
        integer_field_code = check_integer_field( field_val );
        
        switch  integer_field_code
            
            case 1
                warning_string = [ '' ];
            case 2
                warning_string = [ 'You have not specified the number of permutations required.' ];
            case 3
                warning_string = [ 'Permutations must be a positive integer.' ];
            case 4
                warning_string = [ 'Permutations must be greater than 0.' ];
        end
        
    case 2 % make warning message for switches field
        integer_field_code = check_integer_field( field_val )
        
        switch  integer_field_code
            
            case 1
                warning_string = [ '' ];
            case 2
                warning_string = [ 'You have not specified the number of switches required.' ];
            case 3
                warning_string = [ 'Switches must be a positive integer.' ];
            case 4
                warning_string = [ 'Switches must be greater than 0.' ];
        end
end


% --- Executes when called by callback function for pb_start
function reset_bad_fields( handles )

% get the text from all the editable text boxes, and reset if file (or
% directory) does not exist
% note that we only reset text boxes that are currently enabled.

ntwk_edgelist_file = get( handles.edit_network_file , 'string' );
if( ~( exist( ntwk_edgelist_file , 'file' ) == 2 ) )
    set( handles.edit_network_file , 'string' , '' );
end

bg_file = get( handles.edit_background_file , 'string' );
if( ~( exist( bg_file , 'file' ) == 2 )...
        & get( handles.checkbox_specify_background , 'Value' ) )
    set( handles.edit_background_file , 'string' , '' );
end

permutations_str = get( handles.edit_permutations , 'string' );
if( check_integer_field( permutations_str ) > 1 )
    set( handles.edit_permutations , 'string' , '10' );
end

switches_str = get( handles.edit_switches , 'string' );
if( check_integer_field( switches_str ) > 1 )
    set( handles.edit_switches , 'string' , '10' );
end

% *************************************************************************
% END AUX FUNCTIONS
% *************************************************************************



% *************************************************************************
% CREATE FUNCTIONS (generated by GUIDE... listed in no particular order )
% *************************************************************************

% --- Executes during object creation, after setting all properties.
function edit_network_file_CreateFcn( hObject , eventdata , handles)
% hObject    handle to edit_network_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end


% --- Executes during object creation, after setting all properties.
function edit_permutations_CreateFcn( hObject , eventdata , handles )
% hObject    handle to edit_permutations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end


% --- Executes during object creation, after setting all properties.
function edit_background_file_CreateFcn( hObject , eventdata , handles )
% hObject    handle to edit_background_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor') , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end


% --- Executes during object creation, after setting all properties.
function edit_switches_CreateFcn( hObject , eventdata , handles )
% hObject    handle to edit_switches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end

% *************************************************************************
% END CREATE FUNCTIONS
% *************************************************************************



% *************************************************************************
% EMPTY FUNCTIONS (generated by GUIDE... listed in no particular order )
% *************************************************************************

function uipanel3_ButtonDownFcn( hObject , eventdata , handles )
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%end


% --- Executes on button press in checkbox_rm_nf_headers.
function checkbox_rm_nf_headers_Callback( hObject , eventdata , handles )
% hObject    handle to checkbox_rm_nf_headers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rm_nf_headers


function edit_background_file_Callback( hObject , eventdata , handles )
% hObject    handle to edit_background_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_background_file as text
%        str2double(get(hObject,'String')) returns contents of edit_background_file as a double


% --- Executes on button press in checkbox_rm_bg_headers.
function checkbox_rm_bg_headers_Callback( hObject , eventdata , handles )
% hObject    handle to checkbox_rm_bg_headers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rm_bg_headers


% --- Executes on button press in toggle_cancel.
function toggle_cancel_Callback( hObject , eventdata , handles )
% hObject    handle to toggle_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_cancel


% --- Executes on button press in checkbox_protect_permutation_step.
function checkbox_protect_permutation_step_Callback( hObject , eventdata , handles )
% hObject    handle to checkbox_protect_permutation_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_protect_permutation_step


function edit_network_file_Callback( hObject , eventdata , handles )
% hObject    handle to edit_network_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_network_file as text
%        str2double(get(hObject,'String')) returns contents of edit_network_file as a double


function edit_switches_Callback( hObject , eventdata , handles )
% hObject    handle to edit_switches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_switches as text
%        str2double(get(hObject,'String')) returns contents of edit_switches as a double


function edit_permutations_Callback( hObject , eventdata , handles )
% hObject    handle to edit_permutations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_permutations as text
%        str2double(get(hObject,'String')) returns contents of edit_permutations as a double


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn( hObject , eventdata , handles )
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%function edit_switches_Callback( hObject , eventdata , handles )
% hObject    handle to edit_switches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_switches as text
%        str2double(get(hObject,'String')) returns contents of edit_switches as a double


%function edit_permutations_Callback( hObject , eventdata , handles )
% hObject    handle to edit_permutations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_permutations as text
%        str2double(get(hObject,'String')) returns contents of edit_permutations as a double


%function edit_network_file_Callback( hObject , eventdata , handles )
% hObject    handle to edit_network_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_network_file as text
%        str2double(get(hObject,'String')) returns contents of edit_network_file as a double


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
license_message = sprintf( 'Network Permutation Analyser. A pre-analysis tool for use with GeneNet Toolbox.\nCopyright (C) 2014  Avigail Taylor.\n\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.\n\nYou can contact the author at avigail.taylor@dpag.ox.ac.uk' );

uiwait( msgbox( license_message ) );