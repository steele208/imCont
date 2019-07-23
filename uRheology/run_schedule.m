function run_schedule(handles)
    switch handles.loadFiles.Value
        case 1 % New Data
            handles = isNew(handles);
        case 0 % Load Data
            handles = isLoad(handles);
    end

% MATHS on MSD
handles = rheologyCalcs(handles);
handles.output.UserData = graph_results(handles);
handles.output.UserData.save = saveState(handles); 
saveOutputs(handles); % Enter saving routines

function handles = isNew(handles)
% Determine location of images and xml
        handles = findFiles(handles);
        % error catching
        if handles.output.UserData.findFFlag
            return;
        end
        handles = findXML(handles);
        if handles.output.UserData.findXFlag
            return;
        end
        %load images
        handles.barMax = 0.3;
        handles = imageLoad(handles);
        %load metadata
        msg = {'Loading MetaData','May take some minutes!'};
        handles.text20.String = msg;
        pause(0.001);
        handles.output.UserData.metaData = ...
            readXML(handles.output.UserData.xmlLocation);
        handles = masking(handles);
        handles = assignMeta(handles);
        handles = create_time(handles);
        %handles = tracking(handles);
        handles = Data_build(handles);
        handles = MSD(handles);
        %handles = path_detection(handles);
        
function handles = isLoad(handles)

    handles.barMax = 0.6;
    switch handles.loadXML.Value
            case 0 % Load Data as is
                msg = {'Loading Pre-processed Data','May take some minutes!'};
                handles.text20.String = msg;
                handles = findStruct(handles);
                if handles.output.UserData.loadSFlag
                    return;
                end
                handles = loadStruct(handles);
                if ~isfield(handles.output.UserData, 'calcs') 
                    handles = MSD(handles);
                end
                %handles = path_detection(handles);
            case 1 % change associated meta
                handles = findStruct(handles);
                if handles.output.UserData.loadSFlag
                    return;
                end
                handles = findXML(handles);
                if handles.output.UserData.findXFlag
                    return;
                end
                % load data
                handles = loadStruct(handles);
                %load metadata
                msg = {'Loading MetaData','May take some minutes!'};
                handles.text20.String = msg;
                handles.output.UserData.metaData = ...
                    readXML(handles.output.UserData.xmlLocation);
                handles.output.UserData = tracking(handles);
                %handles = path_detection(handles);
                if ~isfield(handles.output.UserData, 'calcs') 
                    handles = MSD(handles);
                end
    end
    
function handles = findXML(handles)
    msgOld = 'Select Meta Data (.xml)';
    handles.text20.String = msgOld;
    if isfield(handles.output.UserData, 'xmlLocation')
        [xmlFile, xmlPath] = uigetfile('.xml',...
            'path', handles.output.UserData.xmlLocation);
    elseif isfield(handles.output.UserData, 'filepath')
        [xmlFile, xmlPath] = uigetfile('.xml',...
            'path', handles.output.UserData.filepath);
    else
        [xmlFile, xmlPath] = uigetfile('.xml');
    end
    xmlLocation = strcat(xmlPath, xmlFile);
    if any(xmlLocation == 0)
        handles.output.UserData.findXFlag = 1;
        return
    end
    handles.output.UserData.xmlLocation = xmlLocation;
    handles.output.UserData.findXFlag = 0;
    
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

function handles = findFiles(handles)
    msg = {'1) Select image files'; '2) Select metadata in chosen format'};
    handles.text20.String = msg;
    % load .tiff files, will require metadata to be added
    % Do actual image load after determining meta location
    [filename, filepath] = uigetfile({'*.tiff'},'Select images to load',...
    'MultiSelect', 'on');
    if ~iscell(filename) || ~ischar(filepath) || ~any(filepath)
        handles.output.UserData.findFFlag = 1;
        return;
    end
    handles.output.UserData.filename = filename;
    handles.output.UserData.filepath = filepath;
    handles.output.UserData.findFFlag = 0;
 
function handles = findStruct(handles)
    msgOld = 'Select Analysed Data (.mat)';
    handles.text20.String = msgOld;
    % Load pre-run .mat - should include metadata
    [imFile, imPath] = uigetfile('.mat');
    if any(imFile == 0) || any(imPath == 0)
        handles.output.UserData.loadSFlag = 1;
        return
    end
    handles.output.UserData.filename = imFile;
    handles.output.UserData.filepath = imPath;
    handles.output.UserData.loadSFlag = 0;
    
function handles = loadStruct(handles)
    loadMsg = {'- Please wait -','Loading Data May Take Some Minutes...'};
    handles.text20.String = loadMsg;
    imPath = handles.output.UserData.filepath;
    imFile = handles.output.UserData.filename;
    tic;
    handles.output.UserData = load(strcat(imPath, imFile));
    toc;
    if length(fields(handles.output.UserData)) == 1
        f = fields(handles.output.UserData);
        handles.output.UserData = handles.output.UserData.(f{1});
    end
