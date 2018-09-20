function images = masking(images, minSize)


for i = 1 : length(images)
    clc;
    fprintf("Loading Images \t\t[100%%]\n");
    fprintf("Adjusting Constrast \t[100%%]\n");
    fprintf("Evaluating Metadata \t[100%%]\n");
    fprintf("Mask Images \t\t[%d%%]", round(i/length(images) * 100));
    
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
