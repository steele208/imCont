function handles = rheologyCalcs(handles)
    handles = make_MSD(handles);
    handles = creep_compliance(handles);
    handles = G_Star(handles);
    handles = G_Primes(handles);


function handles = make_MSD(handles)
    uData = handles.output.UserData;
    res = str2double(uData.metaData(1).Data.ImageResolutionX);
    
    for set = 1 : length(uData.tracked)
        waitbar2a(set / length(uData.tracked) * 0.5,...
            handles.wbCur,'Evaluate J(t)');
        waitbar2a(handles.barMax + set / length(uData.tracked) * 0.025,...
            handles.wbOA);
        uData.tracked{set,1}(1).MSD = ...
            (res.*nanmean(uData.tracked{set,1}(1).AvgPath,2)).^2;
    end
    handles.barMax = handles.barMax + 0.025;
    handles.output.UserData = uData;
    
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
        waitbar2a(0.5 + set / length(uData.tracked) * 0.5,...
            handles.wbCur, 'Evaluate J(t)');
        waitbar2a(handles.barMax + set / length(uData.tracked) * 0.025,...
            handles.wbOA);
        uData.tracked{set,1}(1).Creep = ...
            constCre .* uData.tracked{set}(1).MSD;      
    end
    handles.barMax = handles.barMax + 0.025;
    handles.output.UserData = uData;
    
function handles = G_Star(handles)
%{
    G*(omega) is the complex frequency (fft) from J(t)
    fft is applied to J(t) in each set
%}
    uData = handles.output.UserData;
    for set = 1 : length(uData.tracked)
        waitbar2a(set / length(uData.tracked),...
            handles.wbCur, ['Evaluate G ', char(8432)]);
        waitbar2a(handles.barMax + set / length(uData.tracked) * 0.025,...
            handles.wbOA);
        uData.tracked{set}(1).G_Star = fft(uData.tracked{set}(1).Creep);
    end
    handles.barMax = handles.barMax + 0.025;
    handles.output.UserData = uData;
    
function handles = G_Primes(handles)
    uData = handles.output.UserData;
    for set = 1 : length(uData.tracked)
        waitbar2a(set / length(uData.tracked),...
            handles.wbCur, ['Evaluate G', char(697), '& G',char(697),char(697)]);
        waitbar2a(handles.barMax + set / length(uData.tracked) * 0.025,...
            handles.wbOA);
        uData.tracked{set}(1).G_Prime = real(uData.tracked{set}(1).G_Star);
        uData.tracked{set}(1).G_DblPrime = imag(uData.tracked{set}(1).G_Star);
    end
    handles.barMax = handles.barMax + 0.025;
    handles.output.UserData = uData;
    
        
        