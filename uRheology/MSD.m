function handles = MSD(handles) 
% Variable initialisation
userData = handles.output.UserData;
    


for set = 1 : length(userData.tracked)
    
    skipped = [];
    numPrtcls = length(userData.tracked{set});
    % Generate NaN-space for particles "MSD Space" per set
    MSDSpace = NaN(numPrtcls, length(userData.meanTime));

% Populate MSD Space
    for prtcl = 1 : numPrtcls
    % Will need to skip particles / deal with inconsistent numbers of tracked??
        tIdx = userData.tracked{set}(prtcl).timeID;
        %timeSpace = interp1(userData.meanTime, userData.meanTime, ...
        %    userData.tracked{set}(prtcl).Time, 'next');
        for time = 1 : length(userData.tracked{set}(prtcl).Time)

            if length(userData.tracked{set}(prtcl).Time) < 5
                skipped(end + 1) = prtcl; %#ok<AGROW>
                break;
            end
            %{
            tIdx = userData.meanTime == timeSpace(time);
            if ~isnan(MSDSpace(prtcl, tIdx))
                tIdx = tIdx + 1;
            end
            %}
            disp = (norm(userData.tracked{set}(prtcl).Position(time,:)) - ...
                norm(userData.tracked{set}(prtcl).Position(1,:)))^2;
            MSDSpace(prtcl, tIdx(time)) = disp;

        end
    end
    % NEED TO DELETE SKIPPED 
    MSDSpace(skipped,:) = [];
    %[~, cycle] = ind2sub([122 200], find(MSDSpace == 0));
    %cycle = cycle - 1;
    for i = 1 : size(MSDSpace, 1)
        while MSDSpace(i, 1) ~= 0
            MSDSpace(i,:) = circshift(MSDSpace(i, :), -1);
        end
    end
    filter = all(isnan(MSDSpace));
    for i = size(MSDSpace, 2) : -1 : 1
        if filter(i) == 0
            MSD = MSDSpace(:, 1:i-1);
            break;
        end
    end
    setMSD = nanmean(MSD,1);
    userData.MSD{set,1} = setMSD;
    userData.MSD_data{set,1} = MSD;
end

