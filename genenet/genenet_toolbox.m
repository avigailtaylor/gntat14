function varargout = genenet_toolbox( varargin )
% GENENET_TOOLBOX MATLAB code for genenet_toolbox.fig
%      GENENET_TOOLBOX, by itself, creates a new GENENET_TOOLBOX or raises the existing
%      singleton*.
%
%      H = GENENET_TOOLBOX returns the handle to a new GENENET_TOOLBOX or the handle to
%      the existing singleton*.

% Last Modified by GUIDE v2.5 07-Aug-2014 13:05:03

% GeneNet Toolbox. A flexible platform for the analysis of gene connectivity in biological networks.
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
gui_State = struct( 'gui_Name', mfilename, ...
    'gui_Singleton' ,  gui_Singleton , ...
    'gui_OpeningFcn' , @genenet_toolbox_OpeningFcn , ...
    'gui_OutputFcn' , @genenet_toolbox_OutputFcn , ...
    'gui_LayoutFcn' , [] , ...
    'gui_Callback' , [] );
if nargin && ischar( varargin{ 1 } )
    gui_State.gui_Callback = str2func( varargin{ 1 } );
end

if nargout
    [ varargout{ 1:nargout } ] = gui_mainfcn( gui_State , varargin{ : } );
else
    gui_mainfcn( gui_State , varargin{ : } );
end
% End initialization code - DO NOT EDIT


% --- Executes just before genenet_toolbox is made visible.
function genenet_toolbox_OpeningFcn( hObject, eventdata, handles, varargin )
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )
% varargin   command line arguments to genenet_toolbox (see VARARGIN )

%********************************************************************
% Choose default command line output for genenet_toolbox
handles.output = hObject;

% Update handles structure
guidata( hObject , handles );

% set global variable necessary for proper functioning of axes zoom and pan
global original_axes_properties;
original_axes_properties = get( handles.axes_quickview );


global settable_axes_properties;
settable_axes_properties = fieldnames( set( handles.axes_quickview ) );

% set global variables required for saving node attribute data
global node_attribute_matrix_struct;
node_attribute_matrix_struct = struct( );
node_attribute_matrix_struct.data_matrix = [];
node_attribute_matrix_struct.num_bins = [];
node_attribute_matrix_struct.node_names = {};
node_attribute_matrix_struct.attribute_names = {};

global node_attribute_matrix_struct_set;
node_attribute_matrix_struct_set = false;

%***************************************************************************

% UIWAIT makes genenet_toolbox wait for user response (see UIRESUME )
%uiwait(handles.figure1 );


% --- Outputs from this function are returned to the command line.
function varargout = genenet_toolbox_OutputFcn( hObject , eventdata , handles )
% varargout  cell array for returning output args (see VARARGOUT );
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Get default command line output from handles structure
varargout{ 1 } = handles.output;

%**************************************************************************
% END INITIALIZATION AND OPENING CODE, ETC. 
%**************************************************************************



%**************************************************************************
% BASIC PANEL (CALLBACK FUNCTIONS ONLY )
%**************************************************************************

% --- Executes on button press in pb_browse_network_file.
function pb_browse_network_file_Callback( hObject , eventdata , handles )
% hObject    handle to pb_browse_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

[ file , path , filter_index ] = uigetfile( '*.*' , 'Select Network File' );
if(file~=0 )
    set(handles.edit_network_file , 'string' , [ path file ] );
end


% --- Executes on button press in pb_browse_seed_file.
function pb_browse_seed_file_Callback( hObject , eventdata , handles )
% hObject    handle to pb_browse_seed_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

[ file , path , filter_index ] = uigetfile( '*.*' , 'Select Seed File' );
if(file~=0 )
    set(handles.edit_seed_file , 'string' , [ path file ] );
end

% --- Executes on selection change in popupmenu_perm_type.
function popupmenu_perm_type_Callback( hObject , eventdata , handles )
% hObject    handle to popupmenu_perm_type (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: contents = cellstr(get(hObject,'String' ) ) returns popupmenu_perm_type contents as cell array
%        contents{get(hObject,'Value' )} returns selected item from popupmenu_perm_type
if(  get( hObject , 'Value' ) == 1 )
    
    set( handles.edit_switches , 'Enable' , 'on' );
    set( handles.text_switches , 'Enable' , 'on' );
    set( handles.checkbox_protect_permutation_step , 'Enable' , 'on' );
    set( handles.checkbox_control_for_node_attributes , 'Enable' , 'off' );
    set( handles.text_sddm , 'Enable' , 'on' );
    set( handles.text_sidm , 'Enable' , 'on' );
    set( handles.text_sidm_w , 'Enable' , 'on' );
    set( handles.text_cidm , 'Enable' , 'on' );
    set( handles.static_ob2 , 'Enable' , 'on' );
    set( handles.static_ob3 , 'Enable' , 'on' );
    set( handles.static_ob4 , 'Enable' , 'on' );
    set( handles.static_ob5 , 'Enable' , 'on' );
    set( handles.static_exp2 , 'Enable' , 'on' );
    set( handles.static_exp3 , 'Enable' , 'on' );
    set( handles.static_exp4 , 'Enable' , 'on' );
    set( handles.static_exp5 , 'Enable' , 'on' );
    set( handles.static_p2 , 'Enable' , 'on' );
    set( handles.static_p3 , 'Enable' , 'on' );
    set( handles.static_p4 , 'Enable' , 'on' );
    set( handles.static_p5 , 'Enable' , 'on' );
    
    drawnow
    
    % Action when checkbox is toggled off
else
    set( handles.edit_switches , 'Enable' , 'off' );
    set( handles.text_switches , 'Enable' , 'off' );
    set( handles.checkbox_protect_permutation_step , 'Enable' , 'off' );
    set( handles.checkbox_control_for_node_attributes , 'Enable' , 'on' );
    set( handles.text_sddm , 'Enable' , 'off' );
    set( handles.text_sidm , 'Enable' , 'off' );
    set( handles.text_sidm_w , 'Enable' , 'off' );
    set( handles.text_cidm , 'Enable' , 'off' );
    set( handles.static_ob2 , 'Enable' , 'off' );
    set( handles.static_ob3 , 'Enable' , 'off' );
    set( handles.static_ob4 , 'Enable' , 'off' );
    set( handles.static_ob5 , 'Enable' , 'off' );
    set( handles.static_exp2 , 'Enable' , 'off' );
    set( handles.static_exp3 , 'Enable' , 'off' );
    set( handles.static_exp4 , 'Enable' , 'off' );
    set( handles.static_exp5 , 'Enable' , 'off' );
    set( handles.static_p2 , 'Enable' , 'off' );
    set( handles.static_p3 , 'Enable' , 'off' );
    set( handles.static_p4 , 'Enable' , 'off' );
    set( handles.static_p5 , 'Enable' , 'off' );
    
    drawnow
end

% Evaluate new analysis type
new_analysis_code = eval_chosen_analysis( handles );

% Update analysis text box
update_analysis_text( new_analysis_code , handles );


% --- Executes on button press in checkbox_control_for_node_attributes.
function checkbox_control_for_node_attributes_Callback( hObject , eventdata , handles )
% hObject    handle to checkbox_control_for_node_attributes (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_control_for_node_attributes
% Evaluate new analysis type
new_analysis_code = eval_chosen_analysis( handles );

% Update analysis text box
update_analysis_text( new_analysis_code , handles );


%**************************************************************************
% END BASIC PANEL 
%**************************************************************************



%**************************************************************************
% BACKGROUND PANEL
%**************************************************************************

% --- Executes on button press in checkbox_specify_background.
function checkbox_specify_background_Callback( hObject , eventdata , handles ) 
% hObject    handle to checkbox_specify_background (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_specify_background

% Action when checkbox is toggled on
if( get( hObject , 'Value' ) == 1 )
    
    set( handles.uipanel_background_choices , 'ForegroundColor' , 'black' );
    set( handles.static_background_file , 'Enable' , 'on' );
    set( handles.edit_background_file , 'Enable' , 'on' );
    set( handles.checkbox_rm_bg_headers , 'Enable' , 'on' );
    set( handles.pb_browse_background , 'Enable' , 'on' );
    
    
    if( get( handles.checkbox_seeds_to_backbone , 'Value' ) == 1 )
        set( handles.checkbox_bb_bg_comb , 'Enable' , 'on' );
    end
    
    drawnow
    
    % Action when checkbox is toggled off
else
    
    set( handles.uipanel_background_choices , 'ForegroundColor' , [ 0.5 , 0.5 , 0.5 ] );
    set( handles.static_background_file , 'Enable' , 'off' );
    set( handles.edit_background_file , 'Enable' , 'off' );
    set( handles.checkbox_rm_bg_headers , 'Enable' , 'off' );
    set( handles.pb_browse_background , 'Enable' , 'off' );
    
    if( get( handles.checkbox_seeds_to_backbone , 'Value' ) == 1 )
        set( handles.checkbox_bb_bg_comb , 'Enable' , 'off' );
    end
    
    drawnow
end

% Evaluate new analysis type
new_analysis_code = eval_chosen_analysis( handles );

% Update analysis text box
update_analysis_text( new_analysis_code , handles );


% --- Executes on button press in pb_browse_background.
function pb_browse_background_Callback( hObject , eventdata , handles )
% hObject    handle to pb_browse_background (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

[ file , path , filter_index ] = uigetfile( '*.*' , 'Select Background File' );
if( file~=0 )
    set( handles.edit_background_file , 'string' , [ path file ] );
end

%**************************************************************************
% END BACKGROUND PANEL
%**************************************************************************



%**************************************************************************
% BACKBONE PANEL
%**************************************************************************

% --- Executes on button press in checkbox_seeds_to_backbone.
function checkbox_seeds_to_backbone_Callback( hObject , eventdata , handles ) 
% hObject    handle to checkbox_seeds_to_backbone (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_seeds_to_backbone

% Action when checkbox is toggled on
if( get( hObject , 'Value' ) == 1 )
    
    set( handles.uipanel_backbone_choices , 'ForegroundColor' , 'black' );
    set( handles.static_backbone_file , 'Enable' , 'on' );
    set( handles.edit_backbone_file , 'Enable' , 'on' );
    set( handles.checkbox_rm_bb_headers , 'Enable' , 'on' );
    set( handles.pb_browse_backbone , 'Enable' , 'on' );
    
    if( get( handles.checkbox_specify_background , 'Value' ) == 1 )
        set( handles.checkbox_bb_bg_comb , 'Enable' , 'on' );
    end
    
    set( handles.static_s_bb_comb , 'Enable' , 'on' );
    set( handles.popupmenu_s_bb_comb , 'Enable' , 'on' );
   
    set( handles.static_bb_nodes_label ,  'Enable' , 'on' );
    set( handles.static_bb_nodes ,  'Enable' , 'on' );
    
    set( handles.static_s_bb_results_label , 'Enable' , 'on' );
    set( handles.static_s_connected_to_bb_label , 'Enable' , 'on' );
    set( handles.static_s_connected_to_bb , 'Enable' , 'on' );
    set( handles.static_bb_connected_to_s_label , 'Enable' , 'on' );
    set( handles.static_bb_connected_to_s , 'Enable' , 'on' );
    set( handles.static_s_bb_edges_label , 'Enable' , 'on' );
    set( handles.static_s_bb_edges , 'Enable' , 'on' );
    set( handles.static_s_bb_edges_exp , 'Enable' , 'on' );
    set( handles.static_s_bb_pvalue , 'Enable' , 'on' );
    
    drawnow
    
    % Action when checkbox is toggled off
else
    
    set( handles.uipanel_backbone_choices , 'ForegroundColor' , [ 0.5 , 0.5 , 0.5 ] );
    set( handles.static_backbone_file , 'Enable' , 'off' );
    set( handles.edit_backbone_file , 'Enable' , 'off' );
    set( handles.checkbox_rm_bb_headers , 'Enable' , 'off' );
    set( handles.pb_browse_backbone , 'Enable' , 'off' );
    set( handles.checkbox_bb_bg_comb , 'Enable' , 'off' );
    set( handles.static_s_bb_comb , 'Enable' , 'off' );
    set( handles.popupmenu_s_bb_comb , 'Enable' , 'off' );
    
    set( handles.static_bb_nodes_label ,  'Enable' , 'off' );
    set( handles.static_bb_nodes ,  'Enable' , 'off' );
    
    set( handles.static_s_bb_results_label , 'Enable' , 'off' );
    set( handles.static_s_connected_to_bb_label , 'Enable' , 'off' );
    set( handles.static_s_connected_to_bb , 'Enable' , 'off' );
    set( handles.static_bb_connected_to_s_label , 'Enable' , 'off' );
    set( handles.static_bb_connected_to_s , 'Enable' , 'off' );    
    set( handles.static_s_bb_edges_label , 'Enable' , 'off' );
    set( handles.static_s_bb_edges , 'Enable' , 'off' );
    set( handles.static_s_bb_edges_exp , 'Enable' , 'off' );
    set( handles.static_s_bb_pvalue , 'Enable' , 'off' );
    
    drawnow
end

% Evaluate new analysis type
new_analysis_code = eval_chosen_analysis( handles );

% Update analysis text box
update_analysis_text( new_analysis_code , handles );

% --- Executes on button press in pb_browse_backbone.
function pb_browse_backbone_Callback( hObject , eventdata , handles )
% hObject    handle to pb_browse_backbone (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

[ file , path , filter_index ] = uigetfile( '*.*' , 'Select Backbone File' );
if( file~=0 )
    set( handles.edit_backbone_file , 'string' , [ path file ] );
end

%**************************************************************************
% END BACKBONE PANEL
%**************************************************************************



%**************************************************************************
% RESULTS PANEL
%**************************************************************************

% --- Executes on button press in checkbox_save_results.
function checkbox_save_results_Callback( hObject , eventdata , handles )
% hObject    handle to checkbox_save_results (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_save_results

% Action when checkbox is toggled on
if( get( hObject , 'Value' ) == 1 )
    
    set( handles.uipanel_results , 'ForegroundColor' , 'black' );
    set( handles.static_results_dir , 'Enable' , 'on' );
    set( handles.edit_results_dir , 'Enable' , 'on' );
    set( handles.static_results_tag , 'Enable' , 'on' );
    set( handles.edit_results_tag , 'Enable' , 'on' );
    set( handles.pb_browse_results_dir , 'Enable' , 'on' );
    drawnow
    
    % Action when checkbox is toggled off
else
    
    set( handles.uipanel_results , 'ForegroundColor' , [ 0.5 , 0.5 , 0.5 ] );
    set( handles.static_results_dir , 'Enable' , 'off' );
    set( handles.edit_results_dir , 'Enable' , 'off' );
    set( handles.static_results_tag , 'Enable' , 'off' );
    set( handles.edit_results_tag , 'Enable' , 'off' );
    set( handles.pb_browse_results_dir , 'Enable' , 'off' );
    drawnow
end


% --- Executes on button press in pb_browse_results_dir.
function pb_browse_results_dir_Callback( hObject , eventdata , handles )
% hObject    handle to pb_browse_results_dir (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

path = uigetdir( '' , 'Select directory for saving results' );
if( path~=0 )
    set( handles.edit_results_dir , 'string' , path );
end

%**************************************************************************
% END RESULTS PANEL
%**************************************************************************



%**************************************************************************
% CONTROLS PANEL
%**************************************************************************

% --- Executes on button press in pb_start.
function pb_start_Callback( hObject , eventdata , handles )
% hObject    handle to pb_start (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% declare global variables necesary for zoom and pan to work time after
% time******************************************************************
global original_axes_properties;
global settable_axes_properties;
%***********************************************************************

% declare global variable necesary if user wants to use a node attribute
% file
% time******************************************************************
global node_attribute_matrix_struct;
%***********************************************************************

% clear the progress bar in case reset wasn't pressed ********************
set( handles.static_progress_status , 'string' , '' );
%**************************************************************************

% turn the reset button off in case reset wasn't pressed ******************
set( handles.pb_reset , 'Enable' , 'off' );
%**************************************************************************

% clear results in case reset wasn't pressed *****************************
set( handles.static_num_seeds_in_network , 'string' , '' );

set( handles.static_ob1 , 'string' , '' );
set( handles.static_ob2 , 'string' , '' );
set( handles.static_ob3 , 'string' , '' );
set( handles.static_ob4 , 'string' , '' );
set( handles.static_ob5 , 'string' , '' );

set( handles.static_exp1 , 'string' , '' );
set( handles.static_exp2 , 'string' , '' );
set( handles.static_exp3 , 'string' , '' );
set( handles.static_exp4 , 'string' , '' );
set( handles.static_exp5 , 'string' , '' );

set( handles.static_p1 , 'string' , '' );
set( handles.static_p2 , 'string' , '' );
set( handles.static_p3 , 'string' , '' );
set( handles.static_p4 , 'string' , '' );
set( handles.static_p5 , 'string' , '' );

set( handles.static_bb_nodes , 'string' , '' );
set( handles.static_s_connected_to_bb , 'string' , '' );
set( handles.static_bb_connected_to_s , 'string' , '' );
set( handles.static_s_bb_edges , 'string' , '' );
set( handles.static_s_bb_edges_exp , 'string' , '' );
set( handles.static_s_bb_pvalue , 'string' , '' );

% clear and reset the axes in case they have already been used************

cla
handles.axes_quickview = axes;

for sap_i = 1:length(settable_axes_properties )
    if(~strcmp(settable_axes_properties{ sap_i } , 'Children' ) &...
            ~strcmp(settable_axes_properties{ sap_i } , 'Title' ) &...
            ~strcmp(settable_axes_properties{ sap_i } , 'XLabel' ) &...
            ~strcmp(settable_axes_properties{ sap_i } , 'YLabel' ) &...
            ~strcmp(settable_axes_properties{ sap_i } , 'ZLabel' ) )
        
        set( handles.axes_quickview , settable_axes_properties{ sap_i } , original_axes_properties.( settable_axes_properties{ sap_i } ) );
    end
end
set( handles.toggle_zoom , 'Value' , 0 );
set( handles.toggle_pan , 'Value' , 0 );
%*************************************************************************

ntwk_edgelist_file = get( handles.edit_network_file , 'string' );
ntwk_header = get( handles.checkbox_rm_nf_headers , 'Value' );

seed_file = get( handles.edit_seed_file , 'string' );
s_header = get( handles.checkbox_rm_sf_headers , 'Value' );

bg_file = get( handles.edit_background_file , 'string' );
bg_header = get( handles.checkbox_rm_bg_headers , 'Value' );

bb_file = get( handles.edit_backbone_file , 'string' );
bb_header = get( handles.checkbox_rm_bb_headers , 'Value' );

s_bb_comb = get( handles.popupmenu_s_bb_comb , 'Value' );
bb_bg_comb = get( handles.checkbox_bb_bg_comb , 'Value' );

permutations_str = get( handles.edit_permutations , 'string' );
switches_str = get( handles.edit_switches , 'string' );

protect_perm_step = get( handles.checkbox_protect_permutation_step , 'Value' );
parallelise = get( handles.checkbox_multiple_processors , 'Value' );
quickview_flag = get( handles.checkbox_quickview , 'Value' );

results_dir = get( handles.edit_results_dir , 'string' );
results_tag = get( handles.edit_results_tag , 'string' );


% now get the input requirements according to the checkboxes the user has
% ticked (plus default settings )

input_requirements_code = eval_input_requirements( handles );

% switch behaviour according to input requirements

switch input_requirements_code
    
    case 0 % basic input
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 ) & ( exist ( seed_file , 'file' ) == 2 )...
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
                
                [ total_nodes , ~ , ~ , ~ , observed , expected , p_values , ~ , ~  ] =...
                    np_seed( ntwk_edgelist_file , ntwk_header , seed_file , s_header , perms , num_switches , protect_perm_step ,...
                    parallelise , quickview_flag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                
                set( handles.static_ob1 , 'string' , num2str( observed(1 ) ) );
                set( handles.static_ob2 , 'string' , num2str( observed(2 ) ) );
                set( handles.static_ob3 , 'string' , num2str( observed(3 ) ) );
                set( handles.static_ob4 , 'string' , num2str( observed(4 ) ) );
                set( handles.static_ob5 , 'string' , num2str( observed(5 ) ) );
                
                set( handles.static_exp1 , 'string' , num2str( expected(1 ) ) );
                set( handles.static_exp2 , 'string' , num2str( expected(2 ) ) );
                set( handles.static_exp3 , 'string' , num2str( expected(3 ) ) );
                set( handles.static_exp4 , 'string' , num2str( expected(4 ) ) );
                set( handles.static_exp5 , 'string' , num2str( expected(5 ) ) );
                
                set( handles.static_p1 , 'string' , num2str( p_values(1 ) ) );
                set( handles.static_p2 , 'string' , num2str( p_values(2 ) ) );
                set( handles.static_p3 , 'string' , num2str( p_values(3 ) ) );
                set( handles.static_p4 , 'string' , num2str( p_values(4 ) ) );
                set( handles.static_p5 , 'string' , num2str( p_values(5 ) ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
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
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , seed_file , permutations_str , switches_str };
            field_codes = [ 0 0 3 4 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 1 % basic input + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
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
                
                [ total_nodes , ~ , ~ , ~ , observed , expected , p_values , ~ , ~ ] = ...
                    np_seed( ntwk_edgelist_file , ntwk_header , seed_file , s_header , perms , num_switches , protect_perm_step ,...
                    parallelise , quickview_flag , 'results_dir' , results_dir, 'results_tag' , results_tag, 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                
                set( handles.static_ob1 , 'string' , num2str( observed(1 ) ) );
                set( handles.static_ob2 , 'string' , num2str( observed(2 ) ) );
                set( handles.static_ob3 , 'string' , num2str( observed(3 ) ) );
                set( handles.static_ob4 , 'string' , num2str( observed(4 ) ) );
                set( handles.static_ob5 , 'string' , num2str( observed(5 ) ) );
                
                set( handles.static_exp1 , 'string' , num2str( expected(1 ) ) );
                set( handles.static_exp2 , 'string' , num2str( expected(2 ) ) );
                set( handles.static_exp3 , 'string' , num2str( expected(3 ) ) );
                set( handles.static_exp4 , 'string' , num2str( expected(4 ) ) );
                set( handles.static_exp5 , 'string' , num2str( expected(5 ) ) );
                
                set( handles.static_p1 , 'string' , num2str( p_values(1 ) ) );
                set( handles.static_p2 , 'string' , num2str( p_values(2 ) ) );
                set( handles.static_p3 , 'string' , num2str( p_values(3 ) ) );
                set( handles.static_p4 , 'string' , num2str( p_values(4 ) ) );
                set( handles.static_p5 , 'string' , num2str( p_values(5 ) ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Results Directory' , 'Results Tag' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , seed_file , results_dir , results_tag , permutations_str , switches_str };
            field_codes = [ 0 0 1 2 3 4 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 2 % basic input + background file
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
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
                [ total_nodes , ~ , ~ , ~ , observed , expected , p_values , ~ , ~ ] = ...
                    np_seed_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , perms ,...
                    num_switches , protect_perm_step , parallelise , quickview_flag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                
                set( handles.static_ob1 , 'string' , num2str( observed(1 ) ) );
                set( handles.static_ob2 , 'string' , num2str( observed(2 ) ) );
                set( handles.static_ob3 , 'string' , num2str( observed(3 ) ) );
                set( handles.static_ob4 , 'string' , num2str( observed(4 ) ) );
                set( handles.static_ob5 , 'string' , num2str( observed(5 ) ) );
                
                set( handles.static_exp1 , 'string' , num2str( expected(1 ) ) );
                set( handles.static_exp2 , 'string' , num2str( expected(2 ) ) );
                set( handles.static_exp3 , 'string' , num2str( expected(3 ) ) );
                set( handles.static_exp4 , 'string' , num2str( expected(4 ) ) );
                set( handles.static_exp5 , 'string' , num2str( expected(5 ) ) );
                
                set( handles.static_p1 , 'string' , num2str( p_values(1 ) ) );
                set( handles.static_p2 , 'string' , num2str( p_values(2 ) ) );
                set( handles.static_p3 , 'string' , num2str( p_values(3 ) ) );
                set( handles.static_p4 , 'string' , num2str( p_values(4 ) ) );
                set( handles.static_p5 , 'string' , num2str( p_values(5 ) ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , permutations_str , switches_str };
            field_codes = [ 0 0 0 3 4 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 3 % basic input + background file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
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
                [ total_nodes , ~ , ~ , ~ , observed , expected , p_values , ~ , ~ ] = ...
                    np_seed_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , perms ,...
                    num_switches , protect_perm_step , parallelise , quickview_flag , 'results_dir' , results_dir, 'results_tag' , results_tag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                
                set( handles.static_ob1 , 'string' , num2str( observed(1 ) ) );
                set( handles.static_ob2 , 'string' , num2str( observed(2 ) ) );
                set( handles.static_ob3 , 'string' , num2str( observed(3 ) ) );
                set( handles.static_ob4 , 'string' , num2str( observed(4 ) ) );
                set( handles.static_ob5 , 'string' , num2str( observed(5 ) ) );
                
                set( handles.static_exp1 , 'string' , num2str( expected(1 ) ) );
                set( handles.static_exp2 , 'string' , num2str( expected(2 ) ) );
                set( handles.static_exp3 , 'string' , num2str( expected(3 ) ) );
                set( handles.static_exp4 , 'string' , num2str( expected(4 ) ) );
                set( handles.static_exp5 , 'string' , num2str( expected(5 ) ) );
                
                set( handles.static_p1 , 'string' , num2str( p_values(1 ) ) );
                set( handles.static_p2 , 'string' , num2str( p_values(2 ) ) );
                set( handles.static_p3 , 'string' , num2str( p_values(3 ) ) );
                set( handles.static_p4 , 'string' , num2str( p_values(4 ) ) );
                set( handles.static_p5 , 'string' , num2str( p_values(5 ) ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Results Directory' , 'Results Tag' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , results_dir , results_tag , permutations_str , switches_str };
            field_codes = [ 0 0 0 1 2 3 4 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 4 % basic input + backbone file
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
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
                [ total_nodes, bb_subtotal_of_total_nodes , ~ , ~ , ~ , observed , expected , p_values , ~ , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    np_seed2back( ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header ,...
                    s_bb_comb , perms , num_switches , protect_perm_step , parallelise , quickview_flag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                
                set( handles.static_ob1 , 'string' , num2str( observed(1 ) ) );
                set( handles.static_ob2 , 'string' , num2str( observed(2 ) ) );
                set( handles.static_ob3 , 'string' , num2str( observed(3 ) ) );
                set( handles.static_ob4 , 'string' , num2str( observed(4 ) ) );
                set( handles.static_ob5 , 'string' , num2str( observed(5 ) ) );
                
                set( handles.static_exp1 , 'string' , num2str( expected(1 ) ) );
                set( handles.static_exp2 , 'string' , num2str( expected(2 ) ) );
                set( handles.static_exp3 , 'string' , num2str( expected(3 ) ) );
                set( handles.static_exp4 , 'string' , num2str( expected(4 ) ) );
                set( handles.static_exp5 , 'string' , num2str( expected(5 ) ) );
                
                set( handles.static_p1 , 'string' , num2str( p_values(1 ) ) );
                set( handles.static_p2 , 'string' , num2str( p_values(2 ) ) );
                set( handles.static_p3 , 'string' , num2str( p_values(3 ) ) );
                set( handles.static_p4 , 'string' , num2str( p_values(4 ) ) );
                set( handles.static_p5 , 'string' , num2str( p_values(5 ) ) );
                
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Backbone File' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , seed_file , bb_file , permutations_str , switches_str };
            field_codes = [ 0 0 0 3 4 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 5 % basic input + backbone file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
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
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , ~ , observed , expected , p_values , ~ , ~ ,  num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    np_seed2back( ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header ,...
                    s_bb_comb , perms , num_switches , protect_perm_step , parallelise , quickview_flag , 'results_dir' , results_dir , 'results_tag' , results_tag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                
                set( handles.static_ob1 , 'string' , num2str( observed(1 ) ) );
                set( handles.static_ob2 , 'string' , num2str( observed(2 ) ) );
                set( handles.static_ob3 , 'string' , num2str( observed(3 ) ) );
                set( handles.static_ob4 , 'string' , num2str( observed(4 ) ) );
                set( handles.static_ob5 , 'string' , num2str( observed(5 ) ) );
                
                set( handles.static_exp1 , 'string' , num2str( expected(1 ) ) );
                set( handles.static_exp2 , 'string' , num2str( expected(2 ) ) );
                set( handles.static_exp3 , 'string' , num2str( expected(3 ) ) );
                set( handles.static_exp4 , 'string' , num2str( expected(4 ) ) );
                set( handles.static_exp5 , 'string' , num2str( expected(5 ) ) );
                
                set( handles.static_p1 , 'string' , num2str( p_values(1 ) ) );
                set( handles.static_p2 , 'string' , num2str( p_values(2 ) ) );
                set( handles.static_p3 , 'string' , num2str( p_values(3 ) ) );
                set( handles.static_p4 , 'string' , num2str( p_values(4 ) ) );
                set( handles.static_p5 , 'string' , num2str( p_values(5 ) ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Backbone File' , 'Results Directory' , 'Results Tag' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , seed_file , bb_file , results_dir , results_tag , permutations_str , switches_str };
            field_codes = [ 0 0 0 1 2 3 4 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 6 % basic input + background file + backbone file
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
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
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , ~ , observed , expected , p_values , ~ , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    np_seed2back_bg( ntwk_edgelist_file , ntwk_header , bg_file, bg_header , seed_file , s_header , bb_file, bb_header ,... 
                    s_bb_comb , bb_bg_comb , perms , num_switches , protect_perm_step , parallelise , quickview_flag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                
                set( handles.static_ob1 , 'string' , num2str( observed(1 ) ) );
                set( handles.static_ob2 , 'string' , num2str( observed(2 ) ) );
                set( handles.static_ob3 , 'string' , num2str( observed(3 ) ) );
                set( handles.static_ob4 , 'string' , num2str( observed(4 ) ) );
                set( handles.static_ob5 , 'string' , num2str( observed(5 ) ) );
                
                set( handles.static_exp1 , 'string' , num2str( expected(1 ) ) );
                set( handles.static_exp2 , 'string' , num2str( expected(2 ) ) );
                set( handles.static_exp3 , 'string' , num2str( expected(3 ) ) );
                set( handles.static_exp4 , 'string' , num2str( expected(4 ) ) );
                set( handles.static_exp5 , 'string' , num2str( expected(5 ) ) );
                
                set( handles.static_p1 , 'string' , num2str( p_values(1 ) ) );
                set( handles.static_p2 , 'string' , num2str( p_values(2 ) ) );
                set( handles.static_p3 , 'string' , num2str( p_values(3 ) ) );
                set( handles.static_p4 , 'string' , num2str( p_values(4 ) ) );
                set( handles.static_p5 , 'string' , num2str( p_values(5 ) ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Backbone File' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , bb_file , permutations_str , switches_str };
            field_codes = [ 0 0 0 0 3 4 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 7 % basic input + background file + backbone file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
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
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , ~ , observed, expected, p_values , ~ , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    np_seed2back_bg( ntwk_edgelist_file , ntwk_header , bg_file, bg_header , seed_file , s_header , bb_file, bb_header ,...
                    s_bb_comb , bb_bg_comb , perms , num_switches , protect_perm_step , parallelise , quickview_flag , 'results_dir' , results_dir , 'results_tag' , results_tag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                
                set( handles.static_ob1 , 'string' , num2str( observed(1 ) ) );
                set( handles.static_ob2 , 'string' , num2str( observed(2 ) ) );
                set( handles.static_ob3 , 'string' , num2str( observed(3 ) ) );
                set( handles.static_ob4 , 'string' , num2str( observed(4 ) ) );
                set( handles.static_ob5 , 'string' , num2str( observed(5 ) ) );
                
                set( handles.static_exp1 , 'string' , num2str( expected(1 ) ) );
                set( handles.static_exp2 , 'string' , num2str( expected(2 ) ) );
                set( handles.static_exp3 , 'string' , num2str( expected(3 ) ) );
                set( handles.static_exp4 , 'string' , num2str( expected(4 ) ) );
                set( handles.static_exp5 , 'string' , num2str( expected(5 ) ) );
                
                set( handles.static_p1 , 'string' , num2str( p_values(1 ) ) );
                set( handles.static_p2 , 'string' , num2str( p_values(2 ) ) );
                set( handles.static_p3 , 'string' , num2str( p_values(3 ) ) );
                set( handles.static_p4 , 'string' , num2str( p_values(4 ) ) );
                set( handles.static_p5 , 'string' , num2str( p_values(5 ) ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Backbone File' , 'Results Directory' , 'Results Tag' , 'Permutations' , 'Switches' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , bb_file , results_dir , results_tag , permutations_str , switches_str };
            field_codes = [ 0 0 0 0 1 2 3 4 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
        
        
        %******************************************************************
        
        
    case 10 % seed randomisation. basic input
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 ) & ( exist ( seed_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                
                [ total_nodes , ~ , ~ , observed , expected , p_value , ~ ] =...
                    sr_seed( ntwk_edgelist_file , ntwk_header , seed_file , s_header , perms ,...
                    parallelise , quickview_flag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
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
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , permutations_str };
            field_codes = [ 0 0 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 11 % seed randomisation. basic input + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            
            try
                
                [ total_nodes , ~ , ~ , observed , expected , p_value , ~ ] = ...
                    sr_seed( ntwk_edgelist_file , ntwk_header , seed_file , s_header , perms ,...
                    parallelise , quickview_flag , 'results_dir' , results_dir , 'results_tag' , results_tag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Results Directory' , 'Results Tag' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , results_dir , results_tag , permutations_str };
            field_codes = [ 0 0 1 2 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 12 % seed randomisation. basic input + background file
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                [ total_nodes , ~ , ~ , observed , expected , p_value , ~ ] = ...
                    sr_seed_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header ,...
                    seed_file , s_header , perms , parallelise , quickview_flag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , permutations_str };
            field_codes = [ 0 0 0 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 13 % seed randomisation. basic input + background file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
            
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
            % *********************************************************
            
            try
                [ total_nodes , ~ , ~ , observed , expected , p_value , ~ ] = ...
                    sr_seed_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header ,...
                    seed_file , s_header , perms , parallelise , quickview_flag , 'results_dir' , results_dir , 'results_tag' , results_tag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Results Directory' , 'Results Tag' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , results_dir , results_tag , permutations_str };
            field_codes = [ 0 0 0 1 2 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 14 % seed randomisation. basic input + backbone file
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , observed , expected , p_value , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    sr_seed2back( ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header , s_bb_comb , perms , parallelise , quickview_flag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );                
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Backbone File' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bb_file , permutations_str };
            field_codes = [ 0 0 0 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 15 % seed randomisation. basic input + backbone file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            
            try
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , observed , expected , p_value , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    sr_seed2back( ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header ,...
                    s_bb_comb , perms , parallelise , quickview_flag , 'results_dir' , results_dir , 'results_tag' , results_tag , 'gui_handles' , handles );
                
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Backbone File' , 'Results Directory' , 'Results Tag' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bb_file , results_dir , results_tag , permutations_str };
            field_codes = [ 0 0 0 1 2 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 16 % seed randomisation. basic input + background file + backbone file
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , observed , expected , p_value , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds, p_value_to_bb ] = ...
                    sr_seed2back_bg( ntwk_edgelist_file , ntwk_header , bg_file, bg_header , seed_file , s_header , bb_file, bb_header ,...
                    s_bb_comb , bb_bg_comb , perms , parallelise , quickview_flag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Backbone File' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , bb_file , permutations_str };
            field_codes = [ 0 0 0 0 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 17 % seed randomisation. basic input + background file + backbone file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , observed, expected, p_value, ~ , num_edges_to_bb, num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    sr_seed2back_bg( ntwk_edgelist_file , ntwk_header , bg_file, bg_header , seed_file , s_header , bb_file, bb_header ,...
                    s_bb_comb , bb_bg_comb , perms , parallelise , quickview_flag , 'results_dir' , results_dir , 'results_tag' , results_tag , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Backbone File' , 'Results Directory' , 'Results Tag' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , bb_file , results_dir , results_tag , permutations_str };
            field_codes = [ 0 0 0 0 1 2 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
        
        %******************************************************************
        
        
    case 20 % seed randomisation and account for node attributes. basic input
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 ) & ( exist ( seed_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                
                get_node_attribute_data( handles )
                
                [ total_nodes , ~ , ~ , observed , expected , p_value , ~ ] =...
                    sr_seed( ntwk_edgelist_file , ntwk_header , seed_file , s_header , perms ,...
                    parallelise , quickview_flag , 'node_attribute_matrix_struct' , node_attribute_matrix_struct , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
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
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , permutations_str };
            field_codes = [ 0 0 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 21 % seed randomisation and account for node attributes. basic input + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            
            try
                
                get_node_attribute_data( handles )
                
                [ total_nodes , ~ , ~ , observed , expected , p_value , ~ ] = ...
                    sr_seed( ntwk_edgelist_file , ntwk_header , seed_file , s_header , perms ,...
                    parallelise , quickview_flag , 'results_dir' , results_dir, 'results_tag' , results_tag, ...
                    'node_attribute_matrix_struct' , node_attribute_matrix_struct , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Results Directory' , 'Results Tag' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , results_dir , results_tag , permutations_str };
            field_codes = [ 0 0 1 2 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 22 % seed randomisation and account for node attributes. basic input + background file
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                get_node_attribute_data( handles )
                
                [ total_nodes , ~ , ~ , observed , expected , p_value , ~ ] = ...
                    sr_seed_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , perms ,...
                    parallelise , quickview_flag , 'node_attribute_matrix_struct' , node_attribute_matrix_struct , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , permutations_str };
            field_codes = [ 0 0 0 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 23 % seed randomisation and account for node attributes. basic input + background file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
            
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
            % *********************************************************
            
            try
                
                get_node_attribute_data( handles )
                
                [ total_nodes , ~ , ~ , observed , expected , p_value , ~ ] = ...
                    sr_seed_bg( ntwk_edgelist_file , ntwk_header , bg_file , bg_header , seed_file , s_header , perms ,...
                    parallelise , quickview_flag , 'results_dir' , results_dir, 'results_tag' , results_tag, ...
                    'node_attribute_matrix_struct' , node_attribute_matrix_struct , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Results Directory' , 'Results Tag' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , results_dir , results_tag , permutations_str };
            field_codes = [ 0 0 0 1 2 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 24 % seed randomisation and account for node attributes. basic input + backbone file
        
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            
            try
                
                get_node_attribute_data( handles )
                
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , observed , expected , p_value , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    sr_seed2back( ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header , s_bb_comb , perms ,...
                    parallelise , quickview_flag , 'node_attribute_matrix_struct' , node_attribute_matrix_struct , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Backbone File' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bb_file , permutations_str };
            field_codes = [ 0 0 0 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 25 % seed randomisation and account for node attributes. basic input + backbone file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                
                get_node_attribute_data( handles )
                
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , observed , expected , p_value , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    sr_seed2back( ntwk_edgelist_file , ntwk_header , seed_file , s_header , bb_file, bb_header , s_bb_comb , perms ,...
                    parallelise , quickview_flag , 'results_dir' , results_dir , 'results_tag' , results_tag , ...
                    'node_attribute_matrix_struct' , node_attribute_matrix_struct , 'gui_handles' , handles );
                
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Backbone File' , 'Results Directory' , 'Results Tag' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bb_file , results_dir , results_tag , permutations_str };
            field_codes = [ 0 0 0 1 2 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 26 % seed randomisation and account for node attributes. basic input + background file + backbone file
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            try
                
                get_node_attribute_data( handles )
                
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , observed , expected , p_value , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb, num_bb_connected_to_seeds, p_value_to_bb ] = ...
                    sr_seed2back_bg( ntwk_edgelist_file , ntwk_header , bg_file, bg_header , seed_file , s_header , bb_file, bb_header , s_bb_comb , bb_bg_comb , perms ,...
                    parallelise , quickview_flag , 'node_attribute_matrix_struct' , node_attribute_matrix_struct , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Backbone File' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , bb_file , permutations_str };
            field_codes = [ 0 0 0 0 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
    case 27 % seed randomisation and account for node attributes. basic input + background file + backbone file + save results
        
        if( ( exist( ntwk_edgelist_file , 'file' ) == 2 )...
                & ( exist ( seed_file , 'file' ) == 2 )...
                & ( exist( bg_file , 'file' ) == 2 )...
                & ( exist( bb_file , 'file' ) == 2 )...
                & exist( results_dir , 'dir' ) & ( check_results_tag( results_tag ) == 1 )...
                & ( check_integer_field( permutations_str ) == 1 ) )
            
            
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
            % *********************************************************
            
            
            try
                
                get_node_attribute_data( handles );
                
                [ total_nodes , bb_subtotal_of_total_nodes , ~ , ~ , observed , expected , p_value , ~ , num_edges_to_bb , num_edges_to_bb_exp , ~ ,...
                    num_seeds_connected_to_bb , num_bb_connected_to_seeds , p_value_to_bb ] = ...
                    sr_seed2back_bg( ntwk_edgelist_file , ntwk_header , bg_file, bg_header , seed_file , s_header , bb_file, bb_header , s_bb_comb , bb_bg_comb , perms ,...
                    parallelise , quickview_flag , 'results_dir' , results_dir , 'results_tag' , results_tag , ...
                    'node_attribute_matrix_struct' , node_attribute_matrix_struct , 'gui_handles' , handles );
                
                set( handles.static_num_seeds_in_network , 'string' , num2str( total_nodes ) );
                set( handles.static_bb_nodes , 'string' , num2str( bb_subtotal_of_total_nodes ) );
                set( handles.static_ob1 , 'string' , num2str( observed ) );
                set( handles.static_exp1 , 'string' , num2str( expected ) );
                set( handles.static_p1 , 'string' , num2str( p_value ) );
                
                set( handles.static_s_connected_to_bb , 'string' , num2str( num_seeds_connected_to_bb ) );
                set( handles.static_bb_connected_to_s , 'string' , num2str( num_bb_connected_to_seeds ) );
                set( handles.static_s_bb_edges , 'string' , num2str( num_edges_to_bb ) );
                set( handles.static_s_bb_edges_exp , 'string' , num2str( num_edges_to_bb_exp ) );
                set( handles.static_s_bb_pvalue , 'string' , num2str( p_value_to_bb ) );
                
            catch ME
                uiwait( msgbox( ME.message ) );
                set( handles.pb_start , 'Enable' , 'on' );
                set( handles.pb_reset , 'Enable' , 'on' );
                set( handles.static_progress_status , 'string' , '' );
                set( handles.toggle_cancel , 'Enable' , 'off' );
                set( handles.toggle_cancel , 'Value' , 0 );
                try
                    matlabpool close
                catch
                end
                drawnow
                return
            end
            
            % update progress bar ************************
            set( handles.static_progress_status , 'string' , 'Done' );
            drawnow
            %*********************************************
            
            % turn the reset button on *******************
            set( handles.pb_reset , 'Enable' , 'on' );
            %********************************************
            
            % turn the start button on ******************
            set( handles.pb_start , 'Enable' , 'on' );
            %********************************************
            
            % turn the cancel toggle button off *********
            set( handles.toggle_cancel , 'Enable' , 'off' );
            set( handles.toggle_cancel , 'Value' , 0 );
            %*********************************************
            
        else
            
            field_names = { 'Network File' , 'Seed File' , 'Background File' , 'Backbone File' , 'Results Directory' , 'Results Tag' , 'Permutations' };
            field_vals = { ntwk_edgelist_file , seed_file , bg_file , bb_file , results_dir , results_tag , permutations_str };
            field_codes = [ 0 0 0 0 1 2 3 ];
            warning_message = get_warning_message( field_names , field_vals , field_codes );
            uiwait( msgbox( warning_message ) );
            reset_bad_fields( handles );
        end
        
end


% --- Executes on button press in pb_reset.
function pb_reset_Callback( hObject, eventdata, handles )
% hObject    handle to pb_reset (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )#

% reset inputs, options, analysis bar and progress bar

set( handles.edit_network_file , 'string' , '' );
set( handles.checkbox_rm_nf_headers , 'Value' , 0 );
set( handles.edit_seed_file , 'string' , '' );
set( handles.checkbox_rm_sf_headers , 'Value' , 0 );
set( handles.edit_permutations , 'string' , '1000' );
set( handles.edit_switches , 'Enable' , 'on' );
set( handles.edit_switches , 'string' , '10' );
set( handles.text_switches , 'Enable' , 'on' );
set( handles.checkbox_protect_permutation_step , 'Value' , 0 );
set( handles.checkbox_protect_permutation_step , 'Enable' , 'on' );
set( handles.checkbox_control_for_node_attributes , 'Value' , 0 );
set( handles.checkbox_control_for_node_attributes , 'Enable' , 'off' );
set( handles.popupmenu_perm_type , 'Value', 1 );

set( handles.checkbox_specify_background , 'Value' , 0 );
set( handles.edit_background_file , 'string' , '' );
set( handles.checkbox_rm_bg_headers , 'Value' , 0 );
set( handles.uipanel_background_choices , 'ForegroundColor' , [ 0.5 , 0.5 , 0.5 ] );
set( handles.static_background_file , 'Enable' , 'off' );
set( handles.edit_background_file , 'Enable' , 'off' );
set( handles.checkbox_rm_bg_headers , 'Enable' , 'off' );
set( handles.pb_browse_background , 'Enable' , 'off' );

set( handles.checkbox_seeds_to_backbone , 'Value' , 0 );
set( handles.edit_backbone_file , 'string' , '' );
set( handles.checkbox_rm_bb_headers , 'Value' , 0 );
set( handles.checkbox_bb_bg_comb , 'Value' , 0 );
set( handles.popupmenu_s_bb_comb , 'Value', 1 );

set( handles.uipanel_backbone_choices , 'ForegroundColor' , [ 0.5 , 0.5 , 0.5 ] );
set( handles.static_backbone_file , 'Enable' , 'off' );
set( handles.edit_backbone_file , 'Enable' , 'off' );
set( handles.checkbox_rm_bb_headers , 'Enable' , 'off' );
set( handles.pb_browse_backbone , 'Enable' , 'off' );
set( handles.checkbox_bb_bg_comb , 'Enable' , 'off' );
set( handles.static_s_bb_comb , 'Enable' , 'off' );
set( handles.popupmenu_s_bb_comb , 'Enable' , 'off' );


set( handles.checkbox_save_results , 'Value' , 1 );
set( handles.edit_results_dir , 'string' , '' );
set( handles.edit_results_tag , 'string' , '' );
set( handles.uipanel_results , 'ForegroundColor' , 'black' );
set( handles.static_results_dir , 'Enable' , 'on' );
set( handles.edit_results_dir , 'Enable' , 'on' );
set( handles.static_results_tag , 'Enable' , 'on' );
set( handles.edit_results_tag , 'Enable' , 'on' );
set( handles.pb_browse_results_dir , 'Enable' , 'on' );

set( handles.checkbox_multiple_processors , 'Value' , 0 );
set( handles.checkbox_quickview , 'Value' , 1 );


% reset results
set( handles.static_num_seeds_in_network , 'string' , '' );

set( handles.static_ob1 , 'string' , '' );
set( handles.static_ob2 , 'string' , '' );
set( handles.static_ob3 , 'string' , '' );
set( handles.static_ob4 , 'string' , '' );
set( handles.static_ob5 , 'string' , '' );

set( handles.static_exp1 , 'string' , '' );
set( handles.static_exp2 , 'string' , '' );
set( handles.static_exp3 , 'string' , '' );
set( handles.static_exp4 , 'string' , '' );
set( handles.static_exp5 , 'string' , '' );

set( handles.static_p1 , 'string' , '' );
set( handles.static_p2 , 'string' , '' );
set( handles.static_p3 , 'string' , '' );
set( handles.static_p4 , 'string' , '' );
set( handles.static_p5 , 'string' , '' );

set( handles.text_sddm , 'Enable' , 'on' );
set( handles.text_sidm , 'Enable' , 'on' );
set( handles.text_sidm_w , 'Enable' , 'on' );
set( handles.text_cidm , 'Enable' , 'on' );
set( handles.static_ob2 , 'Enable' , 'on' );
set( handles.static_ob3 , 'Enable' , 'on' );
set( handles.static_ob4 , 'Enable' , 'on' );
set( handles.static_ob5 , 'Enable' , 'on' );
set( handles.static_exp2 , 'Enable' , 'on' );
set( handles.static_exp3 , 'Enable' , 'on' );
set( handles.static_exp4 , 'Enable' , 'on' );
set( handles.static_exp5 , 'Enable' , 'on' );
set( handles.static_p2 , 'Enable' , 'on' );
set( handles.static_p3 , 'Enable' , 'on' );
set( handles.static_p4 , 'Enable' , 'on' );
set( handles.static_p5 , 'Enable' , 'on' );

set( handles.static_bb_nodes , 'string' , '' );
set( handles.static_s_connected_to_bb , 'string' , '' );
set( handles.static_bb_connected_to_s , 'string' , '' );
set( handles.static_s_bb_edges , 'string' , '' );
set( handles.static_s_bb_edges_exp , 'string' , '' );
set( handles.static_s_bb_pvalue , 'string' , '' );

set( handles.static_bb_nodes_label , 'Enable' , 'off' );
set( handles.static_bb_nodes , 'Enable' , 'off' );
set( handles.static_s_bb_results_label , 'Enable' , 'off' );
set( handles.static_s_connected_to_bb_label , 'Enable' , 'off' );
set( handles.static_s_connected_to_bb , 'Enable' , 'off' );
set( handles.static_bb_connected_to_s_label , 'Enable' , 'off' );
set( handles.static_bb_connected_to_s , 'Enable' , 'off' );
set( handles.static_s_bb_edges_label , 'Enable' , 'off' );
set( handles.static_s_bb_edges , 'Enable' , 'off' );
set( handles.static_s_bb_edges_exp , 'Enable' , 'off' );
set( handles.static_s_bb_pvalue , 'Enable' , 'off' );

% reset plot area

% clear and reset the axes in case they have already been used************
global settable_axes_properties;
global original_axes_properties;
cla;
handles.axes_quickview = axes;

for sap_i = 1:length(settable_axes_properties )
    if(~strcmp(settable_axes_properties{ sap_i } , 'Children' ) &...
            ~strcmp(settable_axes_properties{ sap_i } , 'Title' ) &...
            ~strcmp(settable_axes_properties{ sap_i } , 'XLabel' ) &...
            ~strcmp(settable_axes_properties{ sap_i } , 'YLabel' ) &...
            ~strcmp(settable_axes_properties{ sap_i } , 'ZLabel' ) )
        
        set( handles.axes_quickview , settable_axes_properties{ sap_i } , original_axes_properties.( settable_axes_properties{ sap_i } ) );
    end
end

set( handles.toggle_zoom , 'Value' , 0 );
set( handles.toggle_pan , 'Value' , 0 );
%**************************************************************************

% reset controls area
set( handles.static_analysis_status , 'string' , 'Seed connectivity. Network permutation.' );
set( handles.static_progress_status , 'string' , '' );
set( handles.pb_start , 'Enable' , 'on' );
set( handles.pb_reset , 'Enable' , 'off' );
set( handles.toggle_cancel , 'Enable' , 'off' );
set( handles.toggle_cancel , 'Value' , 0 );

%**************************************************************************
% END CONTROLS PANEL
%**************************************************************************



% *************************************************************************
% QUICKVIEW CONTROLS
%**************************************************************************

% --- Executes on button press in toggle_zoom.
function toggle_zoom_Callback( hObject, eventdata, handles )
% hObject    handle to toggle_zoom (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )
% Hint: get(hObject,'Value' ) returns toggle state of toggle_zoom
if( get( hObject,'Value' ) == 0 )
    zoom off
else
    set( handles.toggle_pan , 'Value' , 0 );
    pan off
    zoom reset
    zoom on
end

% --- Executes on button press in toggle_pan.
function toggle_pan_Callback( hObject, eventdata, handles ) %#ok<*INUSL>
% hObject    handle to toggle_pan (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of toggle_pan
if( get( hObject,'Value' ) == 0 )
    pan off
else
    set( handles.toggle_zoom , 'Value' , 0 );
    zoom off
    pan on
end

% --- Executes on button press in push_zoom_reset.
function push_zoom_reset_Callback( hObject, eventdata, handles ) %#ok<INUSL,DEFNU>
% hObject    handle to push_zoom_reset (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

zoom off
pan off
%zoom out

axis tight;
ax=axis;
dxRange=1+(ax(2 )-ax(1 ) )/500;
dyRange=1+(ax(4 )-ax(3 ) )/500;

%axis tight;
%ax=axis;
%dxRange=(ax(2 )-ax(1 ) )/500;
%dyRange=(ax(4 )-ax(3 ) )/500;
axis([ ax(1 )-dxRange,ax(2 )+dxRange,ax(3 )-dyRange,ax(4 )+dyRange ] );

set( handles.toggle_zoom , 'Value' , 0 );
set( handles.toggle_pan , 'Value' , 0 );

%**************************************************************************
% END QUICKVIEW CONTROLS
%**************************************************************************



% *************************************************************************
% AUXILIARY FUNCTIONS (CALLED BY CALLBACK FUNCTIONS, OR OTHER AUX
% FUNCTIONS )
% *************************************************************************

% --- Executes whenever user changes input type (eg changes from network
% permutation to seed randomisation, or clicks "Seeds to Backbone"
% checkbox, etc. Also called by eval_input_requirements (itself called by
% the callback function for the pb_start (labelled 'Start' ) button ).

function analysis_code = eval_chosen_analysis( handles )

if( get( handles.popupmenu_perm_type , 'Value' ) == 1 )
    analysis_code = 0;
else
    if( get( handles.checkbox_control_for_node_attributes , 'Value' ) == 0 )
        analysis_code = 10;
    else
        analysis_code = 20;
    end
end

if( get( handles.checkbox_specify_background , 'Value' )==1 & get( handles.checkbox_seeds_to_backbone , 'Value' )==0 )
    analysis_code = analysis_code + 2;
end

if( get( handles.checkbox_specify_background , 'Value' )==0 & get( handles.checkbox_seeds_to_backbone , 'Value' )==1 )
    analysis_code = analysis_code + 4;
end

if( get( handles.checkbox_specify_background , 'Value' )==1 & get( handles.checkbox_seeds_to_backbone , 'Value' )==1 )
    analysis_code = analysis_code + 6;
end


% --- Executed after eval_chosen_analysis so that 'Analysis' text is
% updated (handle.static_analysis_status ).

function update_analysis_text( chosen_analysis , handles )


switch chosen_analysis
    
    case 0
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity. Network Permutation.' );
    case 2
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity & Specified Background. Network Permutation.' );
    case 4
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity & Seeds to Backbone. Network Permutation.' );
    case 6
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity, Seeds to Backbone & Specified Background. Network Permutation.' );
        
    case 10
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity. Seed Randomisation.' );
    case 12
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity & Specified Background. Seed Randomisation.' );
    case 14
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity & Seeds to Backbone. Seed Randomisation.' );
    case 16
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity, Seeds to Backbone & Specified Background. Seed Randomisation.' );
        
    case 20
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity. Seed Randomisation. Controlling for Node Attributes.' );
    case 22
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity & Specified Background. Seed Randomisation. Controlling for Node Attributes.' );
    case 24
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity & Seeds to Backbone. Seed Randomisation. Controlling for Node Attributes.' );
    case 26
        set( handles.static_analysis_status , 'string' , 'Seed Connectivity, Seeds to Backbone & Specified Background. Seed Randomisation. Controlling for Node Attributes.' );
        
end


% --- Executes when called by callback function for pb_start
function input_requirements_code = eval_input_requirements( handles )

analysis_code = eval_chosen_analysis( handles );
input_requirements_code = analysis_code + get( handles.checkbox_save_results , 'Value' );


% --- Executes when called by callback function for pb_start
function warning_message = get_warning_message( field_names , field_vals , field_codes ) % works for directory names too

warning_message_as_list = [ 'Warning. There are problems with your input.\n\n' ];

for i = 1:length( field_codes )
    switch field_codes(i )
        
        case 0 % checking a file
            
            if( ~( exist( field_vals{ i } , 'file' ) == 2 ) ) % only need a warning when file does not exist
                warning_message_as_list = [ warning_message_as_list field_names{ i } '- ' get_warning_message_aux( field_vals{ i } , field_codes(i ) ) '\n\n' ];
            end
            
        case 1 % checking a directory
            
            if( ~exist( field_vals{ i } , 'dir' ) ) % only need a warning when directory does not exist
                warning_message_as_list = [ warning_message_as_list field_names{ i } '- ' get_warning_message_aux( field_vals{ i } , field_codes(i ) ) '\n\n' ];
            end
            
        case 2 % checking results tag
            if( check_results_tag( field_vals{ i } ) > 1 ) % only need a warning when there is a problem with the results tag
                warning_message_as_list = [ warning_message_as_list field_names{ i } '- ' get_warning_message_aux( field_vals{ i } , field_codes(i ) ) '\n\n' ];
            end
            
        case 3 % checking permutations field
            if( check_integer_field( field_vals{ i } ) > 1 ) % only need a warning when there is a problem with the permutations string
                warning_message_as_list = [ warning_message_as_list field_names{ i } '- ' get_warning_message_aux( field_vals{ i } , field_codes(i ) ) '\n\n' ];
            end
            
        case 4 % checking switches field
            if( check_integer_field( field_vals{ i } ) > 1 ) % only need a warning when there is a problem with the switches string
                warning_message_as_list = [ warning_message_as_list field_names{ i } '- ' get_warning_message_aux( field_vals{ i } , field_codes(i ) ) '\n\n' ];
            end
    end
end

warning_message = sprintf( warning_message_as_list );

% --- Executes when called by get_warning_message (in turn called by
% callback function for pb_start )
function warning_string = get_warning_message_aux( field_val , field_code ) % works for directory names too

switch field_code
    
    case 0 % make warning message for file
        
        if( length( field_val ) == 0 | length( field_val ) == [ 1 0 ] | all( isstrprop( field_val , 'wspace' ) ) )
            warning_string = 'You have not specified a name for this file.';
        else
            if( exist( field_val , 'file' ) == 7 )
                % user has specified a directory that exists, but they need to
                % specify a file
                warning_string = [ field_val '  is a directory, not a file name.' ];
            else
                warning_string = [ 'File does not exist: ' field_val '.' ];
            end
        end
        
    case 1 % make warning message for directory name
        
        if( length( field_val ) == 0 | length( field_val ) == [ 1 0 ] | all( isstrprop( field_val , 'wspace' ) ) )
            warning_string = 'You have not specified a name for this directory.';
            
        else
            if( exist( field_val , 'file' ) == 2 )
                % user has specified a file that exists, but they need to
                % specify a directory
                warning_string = [ field_val '  is a file name, not a directory.' ];
            else
                warning_string = [ 'Directory does not exist: ' field_val '.' ];
            end
        end
        
    case 2 % make warning message for results tag
        results_tag_code = check_results_tag( field_val );
        
        switch results_tag_code
            
            case 1
                warning_string = [ '' ];
            case 2
                warning_string = [ 'You have not specified a results tag.' ];
            case 3
                warning_string = [ 'Your results tag contains illegal characters.' ];
        end
        
    case 3 % make warning message for permutations field
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
        
    case 4 % make warning message for switches field
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
function results_tag_code = check_results_tag( results_tag )

results_tag_code = 1; % return a value of 1 if results_tag is fine

if( length( results_tag ) == 0 | length( results_tag ) == [ 1 0 ] | all( isstrprop( results_tag , 'wspace' ) ) )
    results_tag_code = 2; % return a value of 2 if results_tag is empty or is all whitespace
else
    results_tag_contains_slash = ( length( strfind( results_tag , '/' ) ) > 0 );
    results_tag_contains_star = ( length( strfind( results_tag , '*' ) ) > 0 );
    results_tag_contains_whitespace = any( isstrprop( results_tag , 'wspace' ) );
    
    if( results_tag_contains_slash | results_tag_contains_star | results_tag_contains_whitespace )
        results_tag_code = 3; % return a value of 3 if results_tag contains illegal characters
    end
end


% --- Executes when called by callback function for pb_start
function integer_field_code = check_integer_field( integer_field )

integer_field_code = 1; % return a value of 1 if integer_field is fine

if( length( integer_field ) == 0 | length( integer_field ) == [ 1 0 ] | all( isstrprop( integer_field , 'wspace' ) ) )
    integer_field_code = 2; % return a value of 2 if integer_field is empty
    % or is all whitespace
else
    if( ~all( isstrprop( strtrim(integer_field ) , 'digit' ) ) )
        integer_field_code = 3; % return a value of 3 if non-digit characters
        % are present in integer_field
        % (but ignore leading and trailing white space
        % characters )
    else
        if( str2num(integer_field ) == 0 )
            integer_field_code = 4;
        end
    end
end


% --- Executes when called by callback function for pb_start
function reset_bad_fields( handles )

% get the text from all the editable text boxes, and reset if file (or
% directory ) does not exist
% note that we only reset text boxes that are currently enabled.

ntwk_edgelist_file = get( handles.edit_network_file , 'string' );
if( ~( exist( ntwk_edgelist_file , 'file' ) == 2 ) )
    set( handles.edit_network_file , 'string' , '' );
end

seed_file = get( handles.edit_seed_file , 'string' );
if( ~( exist( seed_file , 'file' ) == 2 ) )
    set( handles.edit_seed_file , 'string' , '' );
end

bg_file = get( handles.edit_background_file , 'string' );
if( ~( exist( bg_file , 'file' ) == 2 )...
        & get( handles.checkbox_specify_background , 'Value' ) )
    set( handles.edit_background_file , 'string' , '' );
end

bb_file = get( handles.edit_backbone_file , 'string' );
if( ~( exist( bb_file , 'file' ) == 2 )...
        & get( handles.checkbox_seeds_to_backbone , 'Value' ) )
    set( handles.edit_backbone_file , 'string' , '' );
end

results_dir = get( handles.edit_results_dir , 'string' );
if( ~exist( results_dir , 'dir' ) & get( handles.checkbox_save_results , 'Value' ) )
    set( handles.edit_results_dir , 'string' , '' );
end

results_tag = get( handles.edit_results_tag , 'string' );
if( check_results_tag( results_tag ) > 1 & get( handles.checkbox_save_results , 'Value' ) )
    set( handles.edit_results_tag , 'string' , '' );
end

permutations_str = get( handles.edit_permutations , 'string' );
if( check_integer_field( permutations_str ) > 1 )
    set( handles.edit_permutations , 'string' , '1000' );
end

switches_str = get( handles.edit_switches , 'string' );
if( check_integer_field( switches_str ) > 1 )
    set( handles.edit_switches , 'string' , '10' );
end

% *************************************************************************
% END AUX FUNCTIONS
% *************************************************************************



% *************************************************************************
% CODE FOR ADDITIONAL GUI, REQUIRED WHEN USER WANTS TO INPUT NODE
% ATTRIBUTES
%**************************************************************************

% --- Executes in pb_start_Callback if the user has chosen seed
% randomisation and checked checkbox_control_for_node_attributes
function get_node_attribute_data( handles )

% declare global variables used in this function
global node_attribute_matrix_struct;
global node_attribute_matrix_struct_set;

[ file , path , filter_index ] = uigetfile( '*.txt' , 'Select node attribute File' );

if(file~=0 )
    
    get_node_attribute_data_aux( handles , path , file );
   
    if( isempty(node_attribute_matrix_struct.data_matrix ) | (~node_attribute_matrix_struct_set ) )
        
        err = MException('', 'ERROR: You have not chosen node attributes to account for. Please choose one or more, or uncheck "control for node attributes".' );
        throw( err );
    end
   
    
    if( any( isnan( node_attribute_matrix_struct.num_bins ) ) )
        err = MException('', 'ERROR: No. of bins must be a positive integer.' );
        throw( err );
    end
    
    if( ~all( arrayfun( @(x ) ( ( x > 0 ) & ( ~mod( x , 1 ) ) ) , node_attribute_matrix_struct.num_bins ) ) )
        err = MException('' , 'ERROR: No. of bins must be a positive integer.' );
        throw( err );
    end
    
    
else
    err = MException('', 'ERROR: No attribute file was chosen. Please choose one, or uncheck "control for node attributes".' );
    throw( err );
end


% --- Executes when called by get_node_attribute_data
function get_node_attribute_data_aux( handles , path , file )

global node_attribute_matrix_struct;
global node_attribute_matrix_struct_set;

node_attribute_matrix_struct = struct( );
node_attribute_matrix_struct.naf = '';
node_attribute_matrix_struct.data_matrix = [];
node_attribute_matrix_struct.num_bins = [];
node_attribute_matrix_struct.node_names = {};
node_attribute_matrix_struct.attribute_names = {};

node_attribute_matrix_struct_set = false;

try
    t_attempt = readtable([ path file ] , 'Delimiter','tab','ReadVariableNames' , false );
catch
    err = MException('', 'ERROR: There was a problem opening your node attribute file. Please check that the file format matches requirements given in the help documentation. Otherwise, uncheck "control for node attributes".' );
    throw( err );
end

t_attempt_rows_size = size( t_attempt( : , 1 ) );
t_attempt_rows_unique_size = size( unique( t_attempt( : , 1 ) ) );

if( t_attempt_rows_size(1 ) > t_attempt_rows_unique_size(1 ) )
    err = MException('', 'ERROR: There is something wrong with your node attribute file: attribute-names are not unique. Please check that the file format matches requirements given in the help documentation. Otherwise, uncheck "control for node attributes".' );
    throw( err );
end

t_attempt_cols_size = size( t_attempt{ 1 , : } );
t_attempt_cols_unique_size = size( unique( t_attempt{ 1 , : } ) );

if( t_attempt_cols_size(2 ) > t_attempt_cols_unique_size(2 ) )
    err = MException('', 'ERROR: There is something wrong with your node attribute file: node-names are not unique. Please check that the file format matches requirements given in the help documentation. Otherwise, uncheck "control for node attributes".' );
    throw( err );
end

try
    t = readtable( [ path file ] , 'Delimiter','tab','ReadRowNames',true );
    t_data = num2cell( t{ : , : } );
    t_data_as_matrix = cell2mat( t_data );
catch
    err = MException('', 'ERROR: There was a problem opening your node attribute file. Please check that the file format matches requirements given in the help documentation. Otherwise, uncheck "control for node attributes".' );
    throw( err );
end

% make data table for display ( only want to display first 10 nodes /
% columns *****************************************************************

[ ~ , num_nodes ] = size( t_data_as_matrix );
t_data_disp = num2cell(t{ :, 1:( min( [ num_nodes , 10 ] ) ) } );

col_names_disp = t.Properties.VariableNames(1:  min( [ num_nodes , 10 ] ) );
%**************************************************************************


best_bins = get_best_bins( t_data_as_matrix );

sz = [ 250 700 ]; % figure size
screensize = get( 0 , 'ScreenSize' );
xpos = ceil( ( screensize( 3 )-sz( 2 ) )/2 );
ypos = ceil( ( screensize( 4 )-sz( 1 ) )/2 );
h.dialog = dialog( 'position' , [ xpos , ypos , sz( 2 ) , sz( 1 ) ] );

h.maintable = uitable('parent' , h.dialog , 'position' , [ 10 50 400 150 ] , 'data', t_data_disp , 'RowName' , t.Properties.RowNames , 'ColumnName' , col_names_disp );

[ mt_rows , ~ ] = size( get( h.maintable , 'data' ) );

choice_data = cell( mt_rows , 1 );
choice_data(: ) = { false };

h.choicestable = uitable( 'parent' , h.dialog , 'position' , [ 450 50 80 130 ] , 'data' , choice_data , 'ColumnFormat' , { 'logical' } , 'ColumnEditable' , [ true ] ,...
    'RowName',[] , 'ColumnName' , [] , 'ColumnWidth' , { 75 } );

h.binstable = uitable( 'parent' , h.dialog , 'position' , [ 550 50 80 130 ] , 'data' , best_bins , 'ColumnFormat' , { 'numeric' } ,...
    'ColumnEditable' , [ true ] , 'RowName' , [] , 'ColumnName' , [] , 'ColumnWidth' , { 75 } );

h.static1 = uicontrol( 'position' , [ 10 210 290 20 ] , 'style' , 'text' , 'string' , 'Please select node attributes to control for' , 'fontweight' , 'bold' );
h.static2 = uicontrol( 'position' , [ 450 210 60 20 ] , 'style' , 'text' , 'string' , 'Choices' );
h.static3 = uicontrol( 'position' , [ 550 210 60 20 ] , 'style' , 'text' , 'string' , 'No. bins' );

h.saveButton = uicontrol( 'position' , [ 10 10 100 25 ] ,'style' , 'pushbutton' , 'string' , 'Save' );
set( h.saveButton , 'callback' , { @saveButton_Callback , handles , [ path file ] , t_data_as_matrix , t.Properties.RowNames , t.Properties.VariableNames , h.choicestable , h.binstable , h.dialog } );

h.resetButton = uicontrol( 'position' , [ 120 10 100 25 ] ,'style' , 'pushbutton' , 'string' , 'Reset' );
set( h.resetButton , 'callback' , { @resetButton_Callback , handles , h.choicestable , choice_data , h.binstable , best_bins } );

h.cancelButton = uicontrol( 'position' , [ 230 10 100 25 ] ,'style' , 'pushbutton' , 'string' , 'Cancel' );
set( h.cancelButton , 'callback' , { @cancelButton_Callback , handles , h.dialog } );

uiwait( h.dialog );


function saveButton_Callback( hObject, eventdata, handles , naf , t_data_matrix , t_attribute_names , t_node_names , choicestable , binstable , dialog )
% declare global variables used in this function
global node_attribute_matrix_struct;
global node_attribute_matrix_struct_set;

choicestable_data = get( choicestable , 'data' );
choices = cell2mat( choicestable_data( : , 1 ) );

all_num_bins = get( binstable , 'data' );

node_attribute_matrix_struct.naf = naf;
node_attribute_matrix_struct.data_matrix = t_data_matrix( find( choices ) , : );
node_attribute_matrix_struct.num_bins = all_num_bins( find( choices ) );
node_attribute_matrix_struct.node_names = transpose(t_node_names );
node_attribute_matrix_struct.attribute_names = t_attribute_names( find( choices ) );

node_attribute_matrix_struct_set = true;

delete( dialog );


function resetButton_Callback( hObject, eventdata, handles , choicestable , choice_data , binstable , best_bins )
set( choicestable , 'data' , choice_data )
set( binstable , 'data' , best_bins )


function cancelButton_Callback( hObject, eventdata, handles , dialog )

% declare global variables used in this function
global node_attribute_matrix_struct;
global node_attribute_matrix_struct_set;

node_attribute_matrix_struct = struct();
node_attribute_matrix_struct.naf = '';
node_attribute_matrix_struct.data_matrix = [];
node_attribute_matrix_struct.num_bins = [];
node_attribute_matrix_struct.node_names = {};
node_attribute_matrix_struct.attribute_names = {};

node_attribute_matrix_struct_set = false;

delete( dialog );

% *************************************************************************
% END ADDITIONAL GUI CODE
%**************************************************************************


% *************************************************************************
% CREATE FUNCTIONS (generated by GUIDE... listed in no particular order )
% *************************************************************************

% --- Executes during object creation, after setting all properties.
function toggle_pan_CreateFcn( hObject, eventdata, handles )
% hObject    handle to toggle_pan (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
pathstr = fileparts( which( 'genenet_toolbox' ) );
set( hObject , 'String' , [ '<html><img src="file:' pathstr '/icons/pan.png"/></html>' ] );

% --- Executes during object creation, after setting all properties.
function toggle_zoom_CreateFcn( hObject, eventdata, handles )
% hObject    handle to toggle_zoom (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
pathstr = fileparts( which( 'genenet_toolbox' ) );
set( hObject , 'String' , [ '<html><img src="file:' pathstr '/icons/zoom_in.png"/></html>' ] );

% --- Executes during object creation, after setting all properties.
function popupmenu_s_bb_comb_CreateFcn( hObject, eventdata, handles )
% hObject    handle to popupmenu_s_bb_comb (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end

% --- Executes during object creation, after setting all properties.
function edit_results_dir_CreateFcn( hObject, eventdata, handles )
% hObject    handle to edit_results_dir (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end

% --- Executes during object creation, after setting all properties.
function edit_results_tag_CreateFcn( hObject, eventdata, handles )
% hObject    handle to edit_results_tag (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject, 'BackgroundColor' , 'white' );
end

% --- Executes during object creation, after setting all properties.
function edit_backbone_file_CreateFcn( hObject, eventdata, handles )
% hObject    handle to edit_backbone_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get( hObject,'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end


% --- Executes during object creation, after setting all properties.
function edit_background_file_CreateFcn( hObject, eventdata, handles )
% hObject    handle to edit_background_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end


% --- Executes during object creation, after setting all properties.
function edit_network_file_CreateFcn( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end


% --- Executes during object creation, after setting all properties.
function edit_permutations_CreateFcn( hObject, eventdata, handles )
% hObject    handle to edit_permutations (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end


% --- Executes during object creation, after setting all properties.
function edit_switches_CreateFcn( hObject, eventdata, handles )
% hObject    handle to edit_switches (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end


% --- Executes during object creation, after setting all properties.
function edit_seed_file_CreateFcn( hObject, eventdata, handles )
% hObject    handle to edit_seed_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get( hObject , 'BackgroundColor' ) , get( 0 , 'defaultUicontrolBackgroundColor' ) )
    set( hObject , 'BackgroundColor' , 'white' );
end

% --- Executes during object creation, after setting all properties.
function popupmenu_perm_type_CreateFcn( hObject, eventdata, handles )
% hObject    handle to popupmenu_perm_type (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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

% --- Executes on button press in toggle_cancel.
function toggle_cancel_Callback( hObject, eventdata, handles ) %#ok<INUSD,DEFNU>
% hObject    handle to toggle_cancel (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% --- Executes on button press in checkbox_rm_bb_headers.
function checkbox_rm_bb_headers_Callback( hObject, eventdata, handles )
% hObject    handle to checkbox_rm_bb_headers (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_rm_bb_headers


% --- Executes on button press in checkbox_rm_bg_headers.
function checkbox_rm_bg_headers_Callback( hObject, eventdata, handles )
% hObject    handle to checkbox_rm_bg_headers (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_rm_bg_headers


% --- Executes on button press in checkbox_rm_nf_headers.
function checkbox_rm_nf_headers_Callback( hObject, eventdata, handles )
% hObject    handle to checkbox_rm_nf_headers (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_rm_nf_headers


% --- Executes on button press in checkbox_rm_sf_headers.
function checkbox_rm_sf_headers_Callback( hObject, eventdata, handles )
% hObject    handle to checkbox_rm_sf_headers (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_rm_sf_headers


% --- Executes on button press in checkbox_bb_bg_comb.
function checkbox_bb_bg_comb_Callback( hObject, eventdata, handles )
% hObject    handle to checkbox_bb_bg_comb (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_bb_bg_comb


% --- Executes on selection change in popupmenu_s_bb_comb.
function popupmenu_s_bb_comb_Callback( hObject, eventdata, handles )
% hObject    handle to popupmenu_s_bb_comb (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: contents = cellstr(get(hObject,'String' ) ) returns popupmenu_s_bb_comb contents as cell array
%        contents{get(hObject,'Value' )} returns selected item from popupmenu_s_bb_comb

function edit_network_file_Callback( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_network_file as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_network_file as a double

function edit_seed_file_Callback( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_network_file as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_network_file as a double


function edit_background_file_Callback( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_network_file as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_network_file as a double

function edit_backbone_file_Callback( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_network_file as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_network_file as a double


function edit_results_dir_Callback( hObject, eventdata, handles )
% hObject    handle to edit_file_name (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_file_name as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_file_name as a double

function edit_results_tag_Callback( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_network_file as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_network_file as a double

function checkbox_multiple_processors_Callback( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_network_file as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_network_file as a double



function static_analysis_Callback( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_network_file as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_network_file as a double

function static_progress_Callback( hObject, eventdata, handles )
% hObject    handle to edit_network_file (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_network_file as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_network_file as a double



% --- Executes on button press in checkbox_quickview.
function checkbox_quickview_Callback( hObject, eventdata, handles )
% hObject    handle to checkbox_quickview (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_quickview


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit_permutations.
function edit_permutations_ButtonDownFcn( hObject, eventdata, handles )
% hObject    handle to edit_permutations (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )


function edit_permutations_Callback( hObject, eventdata, handles )
% hObject    handle to edit_permutations (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_permutations as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_permutations as a double


% --- Executes on key press with focus on edit_switches and none of its controls.
function edit_permutations_KeyPressFcn( hObject, eventdata, handles )
% hObject    handle to edit_switches (see GCBO )
% eventdata  structure with the following fields (see UICONTROL )
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s ) that was pressed
%	Modifier: name(s ) of the modifier key(s ) (i.e., control, shift ) pressed
% handles    structure with handles and user data (see GUIDATA )


% --- Executes on key press with focus on edit_switches and none of its controls.
function edit_switches_KeyPressFcn( hObject, eventdata, handles )
% hObject    handle to edit_switches (see GCBO )
% eventdata  structure with the following fields (see UICONTROL )
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s ) that was pressed
%	Modifier: name(s ) of the modifier key(s ) (i.e., control, shift ) pressed
% handles    structure with handles and user data (see GUIDATA )


function edit_switches_Callback( hObject, eventdata, handles )
% hObject    handle to edit_switches (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hints: get(hObject,'String' ) returns contents of edit_switches as text
%        str2double(get(hObject,'String' ) ) returns contents of edit_switches as a double


% --- Executes on button press in checkbox_protect_permutation_step.
function checkbox_protect_permutation_step_Callback( hObject, eventdata, handles )
% hObject    handle to checkbox_protect_permutation_step (see GCBO )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA )

% Hint: get(hObject,'Value' ) returns toggle state of checkbox_protect_permutation_step


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
license_message = sprintf( 'GeneNet Toolbox. A flexible platform for the analysis of gene connectivity in biological networks.\nCopyright (C) 2014  Avigail Taylor.\n\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.\n\nYou can contact the author at avigail.taylor@dpag.ox.ac.uk' );

uiwait( msgbox( license_message ) );
