function [images] = assignMeta(userData)
    % userData from previous loading routines should already contain meta
    % data and image data:
    images = userData.imData;
    meta = userData.metaData;
    
    
    strSize = length(images(1).Name);
    
    for imIdx = 1 : length(images)
        clc;
        fprintf("Loading Images \t\t[100%%]\n");
        fprintf("Adjusting Constrast \t[100%%]\n");
        fprintf("Evaluating Metadata \t[%d%%]\n", round(imIdx / length(images) * 100));
        
        metaIdx = ceil(strfind([meta.Name], images(imIdx).Name) / strSize);
        images(imIdx).Meta = meta(metaIdx).Data;
        
        if imIdx == 1 || images(imIdx).Set ~= setNum
            setNum = images(imIdx).Set;
            setIdx = imIdx;
            t0 = images(setIdx).Meta.AbsTime;
            t0 = datetime(t0(1:end-6), 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS');
            t0.Format = 'hh:mm:ss.SSS';
        end

        if imIdx == setIdx
            images(imIdx).Meta.RelTime = 0;
        else
            imTime = images(imIdx).Meta.AbsTime(1:end-6);
            
            if ~contains(imTime, '.')
            imTime = strcat(imTime,'.000');
            end
            
            imTime = datetime(imTime, 'InputFormat',...
                'yyyy-MM-dd''T''HH:mm:ss.SSS');
            imTime.Format = 'hh:mm:ss.SSS';
            relTime = second(imTime) - second(t0);
            images(imIdx).Meta.RelTime = relTime;
        end
    end