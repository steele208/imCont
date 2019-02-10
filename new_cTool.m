function varargout = new_cTool(varargin)
% NEW_CTOOL MATLAB code for new_cTool.fig
%      NEW_CTOOL, by itself, creates a new NEW_CTOOL or raises the existing
%      singleton*.
%
%      H = NEW_CTOOL returns the handle to a new NEW_CTOOL or the handle to
%      the existing singleton*.
%
%      NEW_CTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEW_CTOOL.M with the given input arguments.
%
%      NEW_CTOOL('Property','Value',...) creates a new NEW_CTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before new_cTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to new_cTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help new_cTool

% Last Modified by GUIDE v2.5 11-Jul-2018 12:03:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @new_cTool_OpeningFcn, ...
                   'gui_OutputFcn',  @new_cTool_OutputFcn, ...
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


% --- Executes just before new_cTool is made visible.
function new_cTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to new_cTool (see VARARGIN)

% Choose default command line output for new_cTool
handles.output = hObject;
handles.output.UserData = struct();
handles.image = varargin{1}; 
axes(handles.axes1);
imshow(handles.image);
axes(handles.axes2);
histogram(handles.axes1.Children.CData, 'Normalization', 'Probability');
makeLine(handles, 'Floor Line', 0);
makeLine(handles, 'Roof Line', 255);
if varargin{2} == 1 % Standard options; Advanced allows normal operation
    histButton_Callback(hObject, eventdata, handles);
    submitButton_Callback(hObject, eventdata, handles)
end

% Update handles structure
guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = new_cTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isempty(fieldnames(handles.output.UserData))
    uiwait(handles.figure1);
end
varargout{1} = handles.output;
uiresume(handles.figure1);


% --- Executes on slider movement.
function floorSlide_Callback(hObject, eventdata, handles)
% hObject    handle to floorSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    curLim = get(handles.axes1, 'CLim');
    floor = round(get(hObject, 'Value'));
    roof = curLim(2);
    if floor >= roof
        floor = roof - 1;
        set(handles.floorSlide, 'Value', floor);
    end
    midPoint = round((roof - floor)/2) + floor;
    set(handles.midSlide, 'Value', midPoint);
    set(handles.axes1, 'CLim', [floor, roof]);
    set(handles.floorStr, 'String', ...
            strcat('Contrast Floor: ', num2str(floor)));
    set(handles.midStr, 'String', ...
        strcat('Contrast Centre: ', num2str(midPoint)));
    makeLine(handles, 'Floor Line', floor);
  
% --- Executes during object creation, after setting all properties.
function floorSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to floorSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function roofSlide_Callback(hObject, eventdata, handles)
    % Max Slider
% hObject    handle to roofSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    curLim = get(handles.axes1, 'CLim');
    roof = round(get(hObject, 'Value'));
    floor = curLim(1);
    if roof <= floor
        roof = floor + 1;
        set(handles.roofSlide, 'Value', roof);
    end
    midPoint = round((roof - floor)/2) + floor;
    
    set(handles.midSlide, 'Value', midPoint);
    set(handles.axes1, 'CLim', [floor, roof]);
    set(handles.roofStr, 'String', ...
            strcat('Contrast Roof: ', num2str(roof)));
    set(handles.midStr, 'String', ...
        strcat('Contrast Centre: ', num2str(midPoint)));
    
    makeLine(handles, 'Roof Line', roof);

% --- Executes during object creation, after setting all properties.
function roofSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roofSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in submitButton.
function submitButton_Callback(hObject, eventdata, handles)
% hObject    handle to submitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
out = get(handles.axes1, 'CLim');
handles.output.UserData.Continue = 1;
handles.output.UserData.Roof = out(2)/256;
handles.output.UserData.Floor = out(1)/256;
new_cTool_OutputFcn(hObject, eventdata, handles); 
% Closes visibile GUI but keeps data handles intact
set(handles.figure1, 'Visible', 'off');

% --- Executes on button press in skipButton.
function skipButton_Callback(hObject, eventdata, handles)
% hObject    handle to skipButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.UserData.Continue = 0;
new_cTool_OutputFcn(hObject, eventdata, handles);
% Closes visibile GUI but keeps data handles intact
set(handles.figure1, 'Visible', 'off');

% --- Executes on slider movement.
function midSlide_Callback(hObject, eventdata, handles)
% hObject    handle to midSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 curPos = get(handles.axes1, 'CLim');    
    floor = curPos(1);
    roof = curPos(2);
    midSpace = round((roof - floor)/2);
    curMid = midSpace + floor;
    newMid = round(get(hObject, 'Value'));
    change = abs(curMid - newMid);
    % Check that new mid value won't push min/max out of bounds
    if newMid < curMid
        roof = roof - change;
        floor = floor - change;
        if floor < 0                      
            roof = roof + change;
            floor = floor + change;
            newMid = newMid + change;
        end
    elseif newMid > curMid
        roof = roof + change;
        floor = floor + change;
        if roof > 255
            roof = roof - change;
            floor = floor - change;
            newMid = newMid - change;
        end
    end
    set(handles.midSlide, 'Value', newMid);
    set(handles.axes1, 'CLim', [floor, roof]);
    set(handles.roofSlide, 'Value', roof);
    set(handles.floorSlide, 'Value', floor);
    set(handles.roofStr, 'String', ...
        strcat('Contrast Roof: ', num2str(roof)));
    set(handles.floorStr, 'String', ...
        strcat('Contrast Floor: ', num2str(floor)));
    set(handles.midStr, 'String', ...
        strcat('Contrast Centre: ', num2str(newMid)));
    makeLine(handles, 'Floor Line', floor);
    makeLine(handles, 'Roof Line', roof);
    

% --- Executes during object creation, after setting all properties.
function midSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to midSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object deletion, before destroying properties.
function roofSlide_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to roofSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resetCLim = [0 255];
set(handles.roofSlide, 'Value', resetCLim(2));
set(handles.roofStr, 'String', 'Contrast Roof: 255');
set(handles.floorSlide, 'Value', resetCLim(1));
set(handles.floorStr, 'String', 'Contrast Floor: 0');
set(handles.midSlide, 'Value', 127);
set(handles.midStr, 'String', 'Contrast Centre: 127');
set(handles.axes1, 'CLim', resetCLim);
makeLine(handles, 'Floor Line', 0);
makeLine(handles, 'Roof Line', 255);


% --- Executes on button press in histButton.
function histButton_Callback(hObject, eventdata, handles)
% hObject    handle to histButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
H = histogram(handles.axes1.Children.CData, 'BinEdges', 1:256, ...
    'Normalization', 'CumCount');
histVal = H.Values;
%thresh = 0.99999 * numel(find(handles.axes1.Children.CData==1));
%thresh = 0.999 * numel(handles.axes1.Children.CData);
thresh = 0.999 * nnz(handles.axes1.Children.CData);
floor = find(histVal > thresh, 1);
roof = floor + 2;
mid = floor + 1;

histogram(handles.axes1.Children.CData, 'BinEdges', 1:256, ...
    'Normalization', 'Probability');
set(handles.axes1, 'CLim', [floor, roof]);
makeLine(handles, 'Roof Line', roof);
set(handles.roofSlide, 'Value', roof);
set(handles.roofStr, 'String', ...
        strcat('Contrast Roof: ', num2str(roof)));
    
set(handles.midSlide, 'Value', mid);
set(handles.midStr, 'String', ...
        strcat('Contrast Centre: ', num2str(mid)));
    
makeLine(handles, 'Floor Line', floor);
set(handles.floorSlide, 'Value', floor);
set(handles.floorStr, 'String', ...
        strcat('Contrast Floor: ', num2str(floor)));

function makeLine(handles, lineTag, value)
    delete(findobj(handles.axes2.Children, 'Tag', lineTag));
    y = handles.axes2.YLim;
    x = [value value];
    l = line(x,y);
    l.Color = [1 0 0];
    l.Tag = lineTag;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);
