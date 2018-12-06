function userData = path_detection(userData)

for prtcl = 1 : numel(userData.tracked{1,1})
    %% Per particle
    userData.tracked{1,1}(prtcl).Path(1) = 0;
    for pth = 2 : length(userData.tracked{1,1}(1).Position)
    d = sqrt(...
        (userData.tracked{1,1}(1).Position(pth,1) - userData.tracked{1,1}(1).Position(pth-1,1))^2 ...
      + (userData.tracked{1,1}(1).Position(pth,2) - userData.tracked{1,1}(1).Position(pth-1,2))^2);
    userData.tracked{1,1}(1).Path(pth,1) = d + userData.tracked{1,1}(1).Path(pth-1,1);
    end
end