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
        % index representation of frame
        tIdx = userData.tracked{set}(prtcl).timeID;
        % Cycle through the length of each recorded particle
        for time = 1 : length(userData.tracked{set}(prtcl).Time)
            % skip particle sets with less than 5 recorded movements
            if length(userData.tracked{set}(prtcl).Time) < 5
                % By the nature of it, it's easier to have this expand
                % instead of calculating in another loop
                skipped(end + 1) = prtcl; %#ok<AGROW>
                break;
            end
            % displacement = [x_n(t) - x_n(0)]^2
            disp = (norm(userData.tracked{set}(prtcl).Position(time,:)) - ...
                norm(userData.tracked{set}(prtcl).Position(1,:)))^2;
            % record displacement in large matrix (sized to allow all
            % particles to be tracked for all time)
            MSDSpace(prtcl, tIdx(time)) = disp;
        end
    end
    % delete empty rows of MSD Space
    MSDSpace(skipped,:) = [];
    % shift all particles to start from the first index (where 0
    % displacement is found at index 1)
    for i = 1 : size(MSDSpace, 1)
        while MSDSpace(i, 1) ~= 0
            % -ve to move left
            MSDSpace(i,:) = circshift(MSDSpace(i, :), -1);
        end
    end
    % shorten the MSD space to remove all trailing NaN columns (leave NaN
    % columns within data)
    filter = all(isnan(MSDSpace));
    for i = size(MSDSpace, 2) : -1 : 1
        % filter is zero for MSDSpace is not NaN. Break to avoid editing
        % any extra data if NaN columns appear within data.
        if filter == 0 
            MSD = MSDSpace(:, 1:i);
            break;
        end
        if filter(i) == 0
            MSD = MSDSpace(:, 1:i);
            break;
        end
    end
    
    % MSD{set, 2} contains the number of particles detected at each time
    % point. Usefull for restricting the length of MSD to something usefull
    % i.e. MSD for >50 particles
    userData.calcs.MSD{set,2} = sum(~isnan(MSD));
    userData.calcs.MSD_data{set,1} = MSD;
    userData.calcs.MSD{set,1} = nanmean(MSD);
end
% save output in handles struct
handles.output.UserData = userData;
