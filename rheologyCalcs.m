function handles = rheologyCalcs(handles)
    uData = handles.output.UserData;
    %Waitbar
    uData = creep_compliance(uData);

function uData = creep_compliance(uData)
    
    prtclRad = str2double(handles.edit2.String) * 10^-6;
    Dim = 2;
    Kb = physconst('Boltzman');
    T = 25; % Assumed to be 25deg celcius for experiments
    constCre = (3 * pi * prtclRad) / (Dim * Kb * T);
    for set = 1 : length(userData.tracked)
        uData.tracked{set,1}(1).Creep = ...
            constCre .* uData.tracked{set}(1).MSD;      
    end