function userData = path_detection(userData)
for set = 1 : length(userData.tracked)
    skipped = [];
    for prtcl = 1 : numel(userData.tracked{set,1})
        % Per particle
        userData.tracked{set,1}(prtcl).AbsTime(1) = 0;
        userData.tracked{set,1}(prtcl).Displacement(1) = 0;
        userData.tracked{set,1}(prtcl).Position(1,3) = 0;
        if prtcl == 1
            userData.tracked{set,1}(1).AvgPath = ...
            userData.tracked{set,1}(1).Position(:,3);
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
        % pad master path for mean path calculation
            if length(userData.tracked{set,1}(prtcl).Time) < ...
                    length(userData.tracked{set,1}(1).AvgPath)
                pad = length(userData.tracked{set,1}(1).AvgPath);
                userData.tracked{set,1}(prtcl).Position(pad,3) = 0;
            elseif length(userData.tracked{set,1}(prtcl).Time) > ...
                    length(userData.tracked{set,1}(1).AvgPath)
                pad = length(userData.tracked{set,1}(prtcl).Time);
                userData.tracked{set,1}(1).AvgPath(pad,1) = 0;
            end
            userData.tracked{set,1}(1).AvgPath = ...
                userData.tracked{set,1}(1).AvgPath + ...
                userData.tracked{set,1}(prtcl).Position(:,3);
        end
        % division for avg path
        userData.tracked{set,1}(1).AvgPath = ...
            userData.tracked{set,1}(1).AvgPath ./ ...
            size(userData.tracked{set,1}(prtcl).Position,1);
    end
    userData.tracked{set,1}(skipped) = [];
end