function handles = tracking(handles)
userData = handles.output.UserData;
%% Find All Particles
if ~isfield(userData, 'movDist')
    movDist = 5;
else
    movDist = userData.movDist;
end

%% Evaluate Particle Displacements -> Expanding UID massively, consider rehaul.
X = 1; % Enum for readability
Y = 2; % Enum for readability
imageInfo = handles.output.UserData.imData;
for im = 1 : length(imageInfo)
    msg = {'Tracking particle movement over time',...
        'Correlating particles between frames'};
    handles.text20.String = msg;
    waitbar2a(im/length(imageInfo), handles.wbCur, 'Track Particles');
    waitbar2a(handles.barMax + im/length(imageInfo)/10, handles.wbOA);    
    
    % Seperate by image sets, avoid trying to track between inconsistent
    % image sets
    if im == 1
        particles = struct( 'Name',imageInfo(1).Name,...
            'Position', imageInfo(1).trkInfo.Corners{1}(X:Y),...
            'Time',imageInfo(1).Meta.RelTime,... 
            'lastPos', imageInfo(1).trkInfo.Corners{1}(X:Y));
    elseif imageInfo(im).Set ~= imageInfo(im - 1).Set
        particles = struct( 'Name',imageInfo(im).Name,...
            'Position', imageInfo(im).trkInfo.Corners{1}(X:Y),...
            'Time',imageInfo(im).Meta.RelTime,... 
            'lastPos', imageInfo(im).trkInfo.Corners{1}(X:Y));
    end
    
    for prtcl = 1 : length(imageInfo(im).trkInfo.Corners)
            % For image #1, all particles will need to be added as new
            if im == 1
                if prtcl == 1
                    added = 1;
                else
                    added = 0;
                end
            else
                prtclLoc = imageInfo(im).trkInfo.Corners{prtcl}(1:2);
                % find the first corresponding last location that fit's all
                % on dimension 2, i.e. fits with x & y coord. 
                prtclIdx = find(all(vertcat(particles.lastPos) >= ...
                    prtclLoc - movDist & vertcat(particles.lastPos) <= ...
                    prtclLoc + movDist, 2),1);

                % If a corresponding particle is found, add it to tracked
                % stem, else add a new particle
                if prtclIdx
                    if all(particles(prtclIdx).Position(end,1:2) == ...
                            imageInfo(im).trkInfo.Corners{prtcl}(X:Y)) ...
                            && particles(prtclIdx).Time(end,1) == ...
                            imageInfo(im).Meta.RelTime
                        added = 1;
                    else
                        particles(prtclIdx).Position(end + 1,1:2) = ...
                            imageInfo(im).trkInfo.Corners{prtcl}(X:Y); 
                        particles(prtclIdx).lastPos = ...
                            imageInfo(im).trkInfo.Corners{prtcl}(X:Y);
                        particles(prtclIdx).Time(end + 1,1) = ...
                            imageInfo(im).Meta.RelTime;
                        added = 1;
                    end
                else
                    added = 0;
                end
            end
 
        if ~added % if flagged as un-associated, make new particle stem
            particles(end + 1).Name = imageInfo(im).Name; %#ok<AGROW> % pre-allocation may not be feasable
            particles(end).Position(1,1:2) = imageInfo(im).trkInfo.Corners{prtcl}(1:2);
            particles(end).Time = imageInfo(im).Meta.RelTime;            
            particles(end).lastPos = imageInfo(im).trkInfo.Corners{prtcl}(X:Y);
        end
    end
    % Save 'particles' tracking data into userData struct for each image
    userData.tracked{imageInfo(im).Set,1} = particles;
end
handles.barMax = handles.barMax + 0.1;
%% All outputs exported via userData struct
handles.output.UserData.imData = imageInfo;
handles.output.UserData.tracked = userData.tracked;
