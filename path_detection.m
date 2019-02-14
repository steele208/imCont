function handles = path_detection(handles)
userData = handles.output.UserData;
wbRatio = length(userData.tracked)+1;
for set = 1 : length(userData.tracked)
    skipped = [];
    for prtcl = 1 : numel(userData.tracked{set,1})
        %
        waitbar2a((set/3)*prtcl/numel(userData.tracked{set,1}),...
            handles.wbCur, 'Path Detection');
        
        waitbar2a(0.8+(set+prtcl/numel(userData.tracked{set,1}))/...
            wbRatio * 0.2...
            ,handles.wbOA); 
        
        % Per particle
        userData.tracked{set,1}(prtcl).AbsTime(1) = 0;
        userData.tracked{set,1}(prtcl).Displacement(1) = 0;
        userData.tracked{set,1}(prtcl).Position(1,3) = 0;
        if prtcl == 1
            userData.tracked{set,1}(1).AvgPath = ...
                userData.tracked{set,1}(1).Position(:,3);
        
            userData.tracked{set,1}(1).AvgTime = ...
                userData.tracked{set,1}(1).Time;
        end
        if length(userData.tracked{set,1}(prtcl).Time) < 2
            skipped(end + 1) = prtcl; %#ok<AGROW>
            continue
        end
        for pth = 2 : size(userData.tracked{set,1}(prtcl).Position,1)
            % find squared difference / path movement
            d = sqrt(...
                (userData.tracked{set,1}(prtcl).Position(pth,1) - ...
                userData.tracked{set,1}(prtcl).Position(pth-1,1))^2 ...
              + (userData.tracked{set,1}(prtcl).Position(pth,2) - ...
              userData.tracked{set,1}(prtcl).Position(pth-1,2))^2);
            % Absolute path length
            userData.tracked{set,1}(prtcl).Position(pth,3) = ...
                d + userData.tracked{set,1}(prtcl).Position(pth-1,3);
            % Sum of displacement
            userData.tracked{set,1}(prtcl).Displacement(1) = ...
                d + userData.tracked{set,1}(prtcl).Displacement(1);
            % time as absolute
            userData.tracked{set,1}(prtcl).AbsTime(pth) = ...
                userData.tracked{set,1}(prtcl).Time(pth) - ...
                userData.tracked{set,1}(prtcl).Time(1); 

        end
        
        % pad master path for mean path calculation
        % Grouped as matrix, mean path is calculated at time of graphing
        % using nanmean(M,2) for row-wise mean.
        if length(userData.tracked{set,1}(prtcl).Time) < ...
                length(userData.tracked{set,1}(1).AvgPath)
            len = length(userData.tracked{set,1}(prtcl).Time);
            pad = size(userData.tracked{set,1}(1).AvgPath,1);
            userData.tracked{set,1}(prtcl).Position(len:pad,3) = NaN;
        elseif length(userData.tracked{set,1}(prtcl).Time) > ...
                length(userData.tracked{set,1}(1).AvgPath)
            len = size(userData.tracked{set,1}(1).AvgPath,1);
            pad = length(userData.tracked{set,1}(prtcl).Time);
            userData.tracked{set,1}(1).AvgPath(len:pad,1) = NaN;
        end
        userData.tracked{set,1}(1).AvgPath(:,end+1) = ...
            userData.tracked{set,1}(prtcl).Position(:,3);
        
        if length(userData.tracked{set,1}(prtcl).Time) < ...
                length(userData.tracked{set,1}(1).AvgTime)
            len = length(userData.tracked{set,1}(prtcl).Time);
            pad = size(userData.tracked{set,1}(1).AvgTime,1);
            userData.tracked{set,1}(prtcl).Time(len:pad,1) = NaN;
        elseif length(userData.tracked{set,1}(prtcl).Time) > ...
                length(userData.tracked{set,1}(1).AvgTime)
            len = size(userData.tracked{set,1}(1).AvgTime,1);
            pad = length(userData.tracked{set,1}(prtcl).Time);
            userData.tracked{set,1}(1).AvgTime(len:pad,1) = NaN;
        end
        userData.tracked{set,1}(1).AvgTime(:,end+1) = ...
            userData.tracked{set,1}(prtcl).Time;
        
    end
    userData.tracked{set,1}(skipped) = [];
    userData.tracked{set,1}(1).AvgPath(:,1) = [];
    userData.tracked{set,1}(1).AvgTime(:,1) = [];
end
handles.output.UserData = userData;