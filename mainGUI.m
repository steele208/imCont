function varargout = mainGUI(varargin)
% MAINGUI MATLAB code for mainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainGUI

% Last Modified by GUIDE v2.5 20-Sep-2018 16:11:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mainGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mainGUI is made visible.
function mainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainGUI (see VARARGIN)

% Choose default command line output for mainGUI
handles.output = hObject;

%start paralell pool for asynchronus working
%handles.pool = gcp; 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in metaData_Menu.
function metaData_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to metaData_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns metaData_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from metaData_Menu


% --- Executes during object creation, after setting all properties.
function metaData_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to metaData_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in loadImage_Menu.
function loadImage_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to loadImage_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns loadImage_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from loadImage_Menu


% --- Executes during object creation, after setting all properties.
function loadImage_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadImage_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in saveImage_Menu.
function saveImage_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to saveImage_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns saveImage_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from saveImage_Menu


% --- Executes during object creation, after setting all properties.
function saveImage_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saveImage_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in video_Menu.
function video_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to video_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns video_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from video_Menu


% --- Executes during object creation, after setting all properties.
function video_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to video_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(hObject, eventdata, handles);

% --- Executes on button press in contButton.
function contButton_Callback(hObject, eventdata, handles)
% hObject    handle to contButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch handles.loadFiles.Value
    case 1
        if loadFiles(handles)
            return;
        end
    case 0
        if loadStruct(handles)
            return;
        end
end
if strcmp(handles.output.UserData.imageType, 'new')
    msg = {'Loading MetaData','May take some minutes!'};
    usageMsg = makeDialog(msg);
    
    switch handles.loadXML.Value
        case 1
            % Load .xml
            [xmlFile, xmlPath] = uigetfile('.xml');
            xmlLocation = strcat(xmlPath, xmlFile);
            handles.output.UserData.xmlLocation = xmlLocation;
            handles.output.UserData.metaData = readXML(xmlLocation);
        case 0
            % Assume that metadata is already incorporated in .mat
            fprintf("Meta included");
            pause(1);
    end
else
    msg = {'Loading Pre-processed Data','May take some minutes!'};
    usageMsg = makeDialog(msg);
end
handles.output.UserData.save = saveState(handles); 
delete(usageMsg);
if strcmp(handles.output.UserData.imageType,'new')
    handles.output.UserData = tracking(handles.output.UserData);
end
%pause(0.1);
handles.output.UserData = path_detection(handles.output.UserData);
graph_results(handles.output.UserData);
saveOutputs(handles.output.UserData); % Enter saving routines



function saveFlag = saveState(handles)
% Determine a save state for a later function. 
%   3) All     ->  Data & graphs
%   2) Im      ->  Graphs, just paths etc.
%   1) Out     ->  All data, inc. images & trcking
%   0) None    ->  Don't save anything
    if handles.saveIm.Value && handles.saveTrack.Value
        saveFlag = 3;
    elseif handles.saveIm.Value
        saveFlag = 2;
    elseif handles.saveTrack.Value
        saveFlag = 1;
    else 
        saveFlag = 0;
    end

    function flag = loadFiles(handles)
    msg = {'1) Select image files'; '2) Select metadata in chosen format'};
    usageMsg = makeDialog(msg);
    % load .tiff files, will require metadata to be added
    handles.output.UserData.imData = imageLoad(handles.optionMenu.Value);
    delete(usageMsg);
    handles.output.UserData.imageType = 'new';
    if ~isstruct(handles.output.UserData.imData)
        flag = 1;
    end
        
        function flag = loadStruct(handles)
    msgOld = {'Select image files'; '   (These should include metadata)'};
    loadMsg = 'Loading - Please wait some seconds...';
    usageMsg = makeDialog(msgOld);
    % Load pre-run .mat - should include metadata
    [imFile, imPath] = uigetfile('.mat');
    delete(usageMsg);
    if any(imFile == 0) || any(imPath == 0)
        flag = 1;
        return
    end
    loadMsg = makeDialog(loadMsg);
    pause(0.0001);
    handles.output.UserData = load(strcat(imPath, imFile));
    %{
    if isstruct(handles.output.UserData.imData)
        f = fields(handles.output.UserData.imData);
        handles.output.UserData.imData = handles.output.UserData.imData.(f{1});
    end
    %}
    delete(loadMsg);
    if length(fields(handles.output.UserData)) == 1
        f = fields(handles.output.UserData);
        handles.output.UserData = handles.output.UserData.(f{1});
    end
    if isfield(handles.output.UserData, 'metaData') && ~handles.loadXML.Value
        handles.output.UserData.imageType = 'old';
    else
        handles.output.UserData.imageType = 'new';
    end

function d = makeDialog(msg)
d = dialog('Position', [0 500 250 50], 'Name', 'Loading');
uicontrol('Parent', d, 'Style', 'text',...
    'Position',[0 -5 245 45],...
    'String', msg);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(handles.figure1);





% --- Executes on button press in loadFiles.
function loadFiles_Callback(hObject, eventdata, handles)
% hObject    handle to loadFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadFiles
set(handles.loadFiles, 'Value', 1);
set(handles.loadStruct, 'Value', 0);
set(handles.loadXML, 'Value', 1);
set(handles.loadMAT, 'Value', 0);
saveTrack_Callback(hObject, eventdata, handles)
set(handles.loadXML, 'Enable', 'off');
set(handles.loadMAT, 'Enable', 'off');

% --- Executes on button press in loadStruct.
function loadStruct_Callback(hObject, eventdata, handles)
% hObject    handle to loadStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadStruct
set(handles.loadFiles, 'Value', 0);
set(handles.loadStruct, 'Value', 1);
set(handles.loadXML, 'Enable', 'on');
set(handles.loadMAT, 'Enable', 'on');

% --- Executes on button press in loadXML.
function loadXML_Callback(hObject, eventdata, handles)
% hObject    handle to loadXML (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadXML
set(handles.loadXML, 'Value', 1);
set(handles.loadMAT, 'Value', 0);

% --- Executes on button press in loadMAT.
function loadMAT_Callback(hObject, eventdata, handles)
% hObject    handle to loadMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadMAT
set(handles.loadXML, 'Value', 0);
set(handles.loadMAT, 'Value', 1);

% --- Executes on button press in videoAll.
function videoAll_Callback(hObject, eventdata, handles)
% hObject    handle to videoAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of videoAll
set(handles.videoNo, 'Value', 0);
set(handles.videoAll, 'Value', 1);
set(handles.videoSelect, 'Value', 0);

% --- Executes on button press in videoNo.
function videoNo_Callback(hObject, eventdata, handles)
% hObject    handle to videoNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of videoNo
set(handles.videoNo, 'Value', 1);
set(handles.videoAll, 'Value', 0);
set(handles.videoSelect, 'Value', 0);

% --- Executes on button press in saveIm.
function saveIm_Callback(hObject, eventdata, handles)
% hObject    handle to saveIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveIm
set(handles.saveNo, 'Value', 0);
set(handles.saveIm, 'Value', hObject.Value);


% --- Executes on button press in saveNo.
function saveNo_Callback(hObject, eventdata, handles)
% hObject    handle to saveNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveNo
set(handles.saveNo, 'Value', 1);
set(handles.saveIm, 'Value', 0);
set(handles.saveTrack, 'Value', 0);

% --- Executes on button press in saveTrack.
function saveTrack_Callback(hObject, eventdata, handles)
% hObject    handle to saveTrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveTrack
set(handles.saveNo, 'Value', 0);
set(handles.saveTrack, 'Value', hObject.Value);

% --- Executes on button press in videoSelect.
function videoSelect_Callback(hObject, eventdata, handles)
% hObject    handle to videoSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of videoSelect
set(handles.videoNo, 'Value', 0);
set(handles.videoAll, 'Value', 0);
set(handles.videoSelect, 'Value', 1);


% --- Executes on selection change in optionMenu.
function optionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to optionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns optionMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from optionMenu
switch(get(handles.optionMenu, 'Value'))
    case 1
        set(handles.uipanel10, 'Visible', 'off');
        
    case 2
        set(handles.uipanel10, 'Visible', 'on');
        
end


% --- Executes during object creation, after setting all properties.
function optionMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13


% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
