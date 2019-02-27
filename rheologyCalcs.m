function handles = rheologyCalcs(handles)
tic;
    uData = handles.output.UserData;
    
    %Waitbar
    %waitbar2a(handles.barMax + imIdx / length(images)/10, handles.wbOA);
    
    handles = make_MSD(handles);
    handles = creep_compliance(handles);
    uData = G_Star(uData);
    uData = G_Primes(uData);
    
    handles.output.UserData = uData;
toc;

function handles = make_MSD(handles)
    uData = handles.output.UserData;
    res = str2double(uData.metaData(1).Data.ImageResolutionX);
    
    for set = 1 : length(uData.tracked)
        uData.tracked{set,1}(1).MSD = ...
            (res.*nanmean(uData.tracked{set,1}(1).AvgPath,2)).^2;
    end

function handles = creep_compliance(handles)
%{
    Creep compliance J(t)
    Needs handles in/out for access to Temp & Radius Strings
    Used to derive G' & G''
%}
    uData = handles.output.UserData;
    T = str2double(handles.edit3.String) + 273.15; % Celcius to Kelvin
    prtclRad = str2double(handles.edit2.String) * 10^-6;
    Dim = 2;
    Kb = physconst('Boltzman');
    constCre = (3 * pi * prtclRad) / (Dim * Kb * T);
    for set = 1 : length(uData.tracked)
        waitbar2a(set / length(uData.tracked),'Evaluate J(t)');
        uData.tracked{set,1}(1).Creep = ...
            constCre .* uData.tracked{set}(1).MSD;      
    end
    
function uData = G_Star(uData)
%{
    G*(omega) is the complex frequency (fft) from J(t)
    fft is applied to J(t) in each set
%}
    for set = 1 : length(uData.tracked)
        waitbar2a(set / length(uData.tracked),['Evaluate G ', char(8432)]);
        uData.tracked{set}(1).G_Star = fft(uData.tracked{set}(1).Creep);
    end
    
function uData = G_Primes(uData)
    for set = 1 : length(uData.tracked)
        waitbar2a(set / length(uData.tracked),['Evaluate G', char(697)]);
        uData.tracked{set}(1).G_Prime = (uData.tracked{set}(1).G_Star);
    end
    
        
        