function [images] = assignMeta(userData)
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
    end