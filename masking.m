function images = masking(handles, images, minSize)

for i = 1 : length(images)
    waitbar2a(i/length(images), handles.wbCur, 'Mask Images');
    waitbar2a(0.3 + i/length(images)/5, handles.wbOA);
    
    % bw threshold mask
    images(i).Mask = imbinarize(images(i).Image, 0.25); 
    %remove small particles
    images(i).Mask = bwareaopen(images(i).Mask, minSize); 
    % apply mask
    images(i).Image = images(i).Image .* uint8(images(i).Mask); 
    % particle information
    images(i).trkInfo = bwconncomp(images(i).Mask, 8); 
    
    for pIdx = 1 : length(images(i).trkInfo.PixelIdxList) % change to (x,y)
        [y, x] = ind2sub([1080 1080], images(i).trkInfo.PixelIdxList{pIdx});
        images(i).trkInfo.PixelIdxList{pIdx} = [x y];
        images(i).trkInfo.Corners{pIdx, 1} = [min(x) - 2, min(y) - 1,... 
            max(x) - min(x) + 3, max(y) - min(y) + 2]; % Rectangle Information
        images(i).trkInfo.Corners{pIdx, 2} = 0; % bool value for future use
    end 
end
