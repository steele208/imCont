function imInfo = removeVolatile(imInfo)
%{
% Cross Reference and Remove Volitile Particles
%     Does the corner reference (+/- 1) appear in the next image? 
%     1 : length - 1
%}
for imIdx = 1 : length(imInfo)
    clc;
    fprintf("Loading Images \t\t[100%%]\n");
    fprintf("Adjusting Constrast \t[100%%]\n");
    fprintf("Evaluating Metadata \t[100%%]\n");
    fprintf("Mask Images \t\t[100%%]\n");
    fprintf("Detect Particles \t[%d%%]", round(imIdx/length(imInfo)*100));
    
    xyThr = 1; % Accepted number of pixels moved between frames;
    
    X = 1; % Enum for readability
    Y = 2; % Enum for readability
    for curCorner = 1 : length(imInfo(imIdx).trkInfo.Corners)
        x = imInfo(imIdx).trkInfo.Corners{curCorner}(X);
        y = imInfo(imIdx).trkInfo.Corners{curCorner}(Y);
        
        if imIdx < length(imInfo)
            for futCorner = 1 : length(imInfo(imIdx + 1).trkInfo.Corners)
                x2 = imInfo(imIdx).trkInfo.Corners{futCorner}(X);
                y2 = imInfo(imIdx).trkInfo.Corners{futCorner}(Y);
                if x2 > x - xyThr && x2 < x + xyThr && ...
                    y2 > y - xyThr &&  y2 < y + xyThr
                
                    imInfo(imIdx).trkInfo.Corners{curCorner, 2} = 1;
                    break;
                end
            end
        end
        if imIdx > 1
            for prevCorner = 1 : length(imInfo(imIdx - 1).trkInfo.Corners)
                x2 = imInfo(imIdx).trkInfo.Corners{prevCorner}(X);
                y2 = imInfo(imIdx).trkInfo.Corners{prevCorner}(Y);
                if x2 > x - xyThr && x2 < x + xyThr && ...
                    y2 > y - xyThr &&  y2 < y + xyThr

                    imInfo(imIdx).trkInfo.Corners{curCorner, 2} = 1;
                    break;
                else 
                    imInfo(imIdx).trkInfo.Corners{curCorner, 2} = 0;
                end
            end
        end
    end
 end

%{
    % Does the corner reference (+/- 1) appear in the previous image?
    % 2 : length
    
    for curCorner = 1 : length(imageInfo{imIdx, PART_INFO}.Corners)
        for prevCorner = 1 : length(imageInfo{imIdx - 1, PART_INFO}.Corners)
            if imageInfo{imIdx, PART_INFO}.Corners{curCorner}(1) >=...
                    imageInfo{imIdx - 1, PART_INFO}.Corners{prevCorner}(1) - 1 ...
                    && imageInfo{imIdx, PART_INFO}.Corners{curCorner}(1) <=...
                    imageInfo{imIdx - 1, PART_INFO}.Corners{prevCorner}(1) + 1 ...        
                    && imageInfo{imIdx, PART_INFO}.Corners{curCorner}(2) >=...
                    imageInfo{imIdx - 1, PART_INFO}.Corners{prevCorner}(2) - 1 ...
                    && imageInfo{imIdx, PART_INFO}.Corners{curCorner}(2) <=...
                    imageInfo{imIdx - 1, PART_INFO}.Corners{prevCorner}(2) + 1

                imageInfo{imIdx, PART_INFO}.Corners{curCorner, 2} = 1;
                break;
            else 
                imageInfo{imIdx, PART_INFO}.Corners{curCorner, 2} = 0;
            end
        end
    end
end    
%}
maxTracked = 0;
% Remove all points that aren't consistent b/w images
 for imIdx = 1 : length(imInfo)
    %{
     for crnr = 1 : length(imageInfo{imIdx, PART_INFO}.Corners)
        index = cellfun(@(x) x==0, imageInfo{imIdx,PART_INFO}.Corners(:,2),...
            'UniformOutput', 1);
        imageInfo{imIdx,PART_INFO}.Corners(find(index),:) = []; %#ok<FNDSB>
        %}
        if length(imInfo(imIdx).trkInfo.Corners) > maxTracked
            maxTracked = length(imInfo(imIdx).trkInfo.Corners);
        end
    %end
 end
    