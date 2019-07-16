function handles = create_time(handles)
userData = handles.output.UserData;

offset = 0;
timeVec = NaN(userData.setLength , userData.imData(end).Set);
for img = 1 : length(userData.imData)
    % Modify index to map img as 1:n per set
    if img > 1 && userData.imData(img - 1).Set ~= userData.imData(img).Set 

        offset = img - 1; % -1 sets the new img number as 1 (MATLAB 1 indexes)
    end
    timeVec(img - offset, userData.imData(img).Set) = userData.imData(img).Meta.RelTime;
end

%% Time correlation #1 - Mean comparisson
handles.output.UserData.meanTime = nanmean(timeVec, 2);
    %use interp to compare and allign data to a specific time.. may cause
    %many to one mapping..? 
