function handles = imageLoad(handles)
    options = handles.radiobutton13.Value;
    % get n files (GUI) 
    % Catch the UI being cancelled
    %%
    fname = handles.output.UserData.filename;
    fpath = handles.output.UserData.filepath;
    %%
    % Setup strorage srtuctures for filenames and images
    N = numel(fname);
    im = struct('Name', fname', 'ID', cell(N,1), 'Set', cell(N,1), ...
        'Image', cell(N,1), 'Mask', cell(N,1), 'Meta', cell(N,1));
    curSet = 1;
    setSize = 0;
    biggestSet = 0;
    for i = 1 : numel(fname)     
        msg = {'Loading Images','Processing contrast per Set'};
        handles.text20.String = msg;
        waitbar2a(i/numel(fname), handles.wbCur, 'Loading Images');
        waitbar2a(i/numel(fname)*0.15, handles.wbOA);
        
        
        % determine file linkings from name 
        ID = regexp(im(i).Name, 'r\d+c\d+f\d+', 'match');
        im(i).ID = ID{1};
        
        if i > 1 && ~strcmp(im(i).ID, im(i-1).ID)
            % increase set number for new set
            curSet = curSet + 1;
            if setSize > biggestSet
                biggestSet = setSize;
            end
            setSize = 0;
        end
        setSize = setSize + 1;
        im(i).Set = curSet;
        
        % Determine contrast using first image of a set
        if i == 1 || (i > 1 && ~strcmp(im(i).ID, im(i-1).ID))
			im(i).Image = imread(strcat(fpath, im(i).Name));
			im(i).Image = uint8(im(i).Image ./ 256);
			% GUI for setting contrast levels
            output = new_cTool(im(i).Image, options); 
			UserData = output.UserData;
            if isfield(UserData,'movDist')
                handles.output.UserData.movDist = UserData.movDist;
            end
			delete(output);
			
			if UserData.Continue
				% Load and adjust image 1
				im(i).Image = imadjust(im(i).Image, ...
                    [UserData.Floor UserData.Roof]); 
			end
		elseif UserData.Continue
			% Load and adjust set of images.
			im(i).Image = imread(strcat(fpath, im(i).Name));
			im(i).Image = uint8(im(i).Image ./ 256);
			im(i).Image = imadjust(im(i).Image, ...
                [UserData.Floor UserData.Roof]); 
        end
    end
    handles.output.UserData.imData = im;
    handles.output.UserData.setLength = biggestSet;
end
