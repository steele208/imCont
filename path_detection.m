function handles = path_detection(handles)
userData = handles.output.UserData;
    %wbRatio = length(userData.tracked)+1;
    setTSteps = zeros(1,length(userData.tracked));
for set = 1 : length(userData.tracked)
    skipped = [];
    for prtcl = 1 : numel(userData.tracked{set})
        
        % Per particle
        userData.tracked{set}(prtcl).Displacement(1) = 0;
        userData.tracked{set}(prtcl).Position(1,3) = 0;

        if length(userData.tracked{set}(prtcl).Time) <= 3%5
            skipped(end + 1) = prtcl; %#ok<AGROW>
            continue
        end
        
        % Mean time step calculation per particle
        userData.tracked{set}(prtcl).meanTStep = ...
            mean(userData.tracked{set}(prtcl).Time);
        userData.tracked{set}(prtcl).stdTstep = ...
            std(userData.tracked{set}(prtcl).Time);
        
        for pth = 2 : size(userData.tracked{set}(prtcl).Position,1)
            % find squared difference / path movement
            d = sqrt(...
                (userData.tracked{set}(prtcl).Position(pth,1) - ...
                userData.tracked{set}(prtcl).Position(pth-1,1))^2 ...
              + (userData.tracked{set}(prtcl).Position(pth,2) - ...
              userData.tracked{set}(prtcl).Position(pth-1,2))^2);
          
            % Absolute path length
            userData.tracked{set}(prtcl).Position(pth,3) = ...
                d + userData.tracked{set}(prtcl).Position(pth-1,3);
            
            % Sum of displacement
            userData.tracked{set}(prtcl).Displacement(1) = ...
                d + userData.tracked{set}(prtcl).Displacement(1);

        end
        
        % Mean timestep calculation per set
        userData.tracked{set}(1).TimeStep = ...
            mean([userData.tracked{set}.meanTStep]);
        setTSteps(set) = userData.tracked{set}(1).TimeStep;
    end
    
    userData.tracked{set}(skipped) = [];
    res = str2double(userData.metaData(1).Data.ImageResolutionX);
    userData.tracked{set,1}(1).MSD = ...
        (res.*nanmean(userData.tracked{set,1}(1).AvgPath,2)).^2;
end
userData.TimeStep = mean(setTSteps);
handles.barMax = handles.barMax + 0.2;



handles.output.UserData = userData;