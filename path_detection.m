function userData = path_detection(userData)
for set = 1 : length(userData.tracked)
    skipped = [];
    for prtcl = 1 : numel(userData.tracked{1,1})
        %% Per particle
        userData.tracked{set,1}(prtcl).Displacement(1) = 0;
        userData.tracked{set,1}(prtcl).Position(1,3) = 0;
        if length(userData.tracked{set,1}(prtcl).Time) < 2
            skipped(end + 1) = prtcl; %#ok<AGROW>
            continue
        end
        for pth = 2 : size(userData.tracked{set,1}(prtcl).Position,1)
        d = sqrt(...
            (userData.tracked{set,1}(prtcl).Position(pth,1) - userData.tracked{set,1}(prtcl).Position(pth-1,1))^2 ...
          + (userData.tracked{set,1}(prtcl).Position(pth,2) - userData.tracked{set,1}(prtcl).Position(pth-1,2))^2);
        userData.tracked{set,1}(prtcl).Position(pth,3) = d + userData.tracked{set,1}(prtcl).Position(pth-1,3);
        userData.tracked{set,1}(prtcl).Displacement(1) = d + userData.tracked{set,1}(prtcl).Displacement(1);
        userData.tracked{set,1}(prtcl).FinalTime(1) = userData.tracked{set,1}(prtcl).Time(end);
        end
    end
    userData.tracked{set,1}(skipped) = [];
end
pause(1);