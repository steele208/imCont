function imOut = imageLoad(options)
    warning('off', 'Images:initSize:adjustingMag');
    % get n files (GUI)
    
    %figure('Visible','on'); 
    % Catch the UI being cancelled
    [fname, imgSrc] = uigetfile({'*.tiff'}, 'Select images to load',...
        'MultiSelect', 'on');
    if ~ischar(fname) && ~iscell(fname)
        imOut = 0;
        return;
    end
    
    fprintf("Loading Images\n");
    % Setup strorage srtuctures for filenames and images
    N = numel(fname);
    im = struct('Name', fname', 'ID', cell(N,1), 'Set', cell(N,1), ...
        'Image', cell(N,1), 'Mask', cell(N,1), 'Meta', cell(N,1));
    curSet = 1;
    for i = 1 : N
        clc;
        fprintf("Loading Images \t\t[%d%%]\n", round(i/numel(fname)*100));
        
        % determine file linkings from name 
        ID = regexp(im(i).Name, 'r\d+c\d+f\d+', 'match');
        im(i).ID = ID{1};
        
        if i > 1 && ~strcmp(im(i).ID, im(i-1).ID)
            % increase set number for new set
            curSet = curSet + 1;
        end
        im(i).Set = curSet;
        
        % Determine contrast using first image of a set
        if i == 1 || (i > 1 && ~strcmp(im(i).ID, im(i-1).ID))
			im(i).Image = imread(strcat(imgSrc, im(i).Name));
			im(i).Image = uint8(im(i).Image ./ 256);
			% GUI for setting contrast levels
            output = new_cTool(im(i).Image, options); 
			UserData = output.UserData;
			delete(output);
			
			if UserData.Continue
				% Load and adjust image 1
				im(i).Image = imadjust(im(i).Image, ...
                    [UserData.Floor UserData.Roof]); 
			end
		elseif UserData.Continue
			% Load and adjust set of images.
			im(i).Image = imread(strcat(imgSrc, im(i).Name));
			im(i).Image = uint8(im(i).Image ./ 256);
			im(i).Image = imadjust(im(i).Image, ...
                [UserData.Floor UserData.Roof]); 
        end
    end
    imOut = im;
end
