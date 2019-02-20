function images = assignMeta(handles) %%%
    %%% userData = handles.output.UserData;
    % userData from previous loading routines should already contain meta
    % data and image data:
    userData = handles.output.UserData;
    images = userData.imData;
    meta = userData.metaData;
    metaStr = [meta.Name];
    
    for imIdx = 1 : length(images)
        %%%waitbar2a(0.2 + imIdx / length(images)/10, handles.wbOA);
        %%%waitbar2a(imIdx / length(images), handles.wbCur,'Evaluate Metadata');
        
        nameIdx = strfind(metaStr, images(imIdx).Name);
        metaIdx = numel(strfind(metaStr(1:nameIdx), '.tiff')) + 1;
        images(imIdx).Meta = meta(metaIdx).Data;
        
        t = dTime(imIdx, images);
        
        if imIdx == 1 || images(imIdx).Set ~= images(imIdx-1).Set
            t0 = t;
            images(imIdx).Meta.RelTime = 0;
        else
            imTime = t;
            relTime = 3600*(hour(imTime) - hour(t0)) +...
                60*(minute(imTime) - minute(t0)) +...
                (second(imTime) - second(t0));
            images(imIdx).Meta.RelTime = relTime;
        end
    end
    
function t = dTime(setIdx, images)
        t = images(setIdx).Meta.AbsTime;
        % has 3 digits of millisec
        if strcmp(t(end-9), '.')
            t = datetime(t(1:end-6), 'InputFormat',...
                'yyyy-MM-dd''T''HH:mm:ss.SSS');
        % has less than 3 digits of millisec
        elseif contains(t, '.')
            tZone = find(t == '+');
            mSec = find(t == '.');
            t = t(1:mSec+(tZone - mSec));
            t(end:23) = '0';
            t = datetime(t, 'InputFormat',...
                'yyyy-MM-dd''T''HH:mm:ss.SSS');
        % has no millisec
        else
            t(end-5:end-2) = '.000';
            t = datetime(t(1:end-2), 'InputFormat',...
                'yyyy-MM-dd''T''HH:mm:ss.SSS');
        end
        t.Format = 'hh:mm:ss.SSS';