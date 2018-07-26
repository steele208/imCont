function imageInfo = tracking(images, varargin)
%% Find All Particles
% enum references for cell contents
if isempty(varargin)
    minSize = 7;
else
    % Advanced Option
    minSize = varargin{1};
end

IMAGES = 1;
PART_INFO = 2;
FINAL_DATA = 3;

imageInfo = images;
for i = 1 : length(images)
    clc;
    fprintf("Loading Images \t\t[100%%]\n");
    fprintf("Adjusting Constrast \t[100%%]\n");
    fprintf("Loading Times \t\t[100%%]\n");
    fprintf("Detect Particles \t[%d%%]", round(i/length(images)*60));
    
    % bw threshold mask
    imageInfo(i).Mask = imbinarize(images(i).Image, 0.25); 
    %remove small particles
    imageInfo(i).Mask = bwareaopen(imageInfo(i).Mask, minSize); 
    % apply mask
    imageInfo(i).Image = images(i).Image .* uint8(imageInfo(i).Mask); 
    % particle information
    imageInfo(i).trkInfo = bwconncomp(imageInfo(i).Mask, 8); 
    
    for pIdx = 1 : length(imageInfo(i).trkInfo.PixelIdxList) % change to (x,y)
        [y, x] = ind2sub([1080 1080], imageInfo(i).trkInfo.PixelIdxList{pIdx});
        imageInfo(i).trkInfo.PixelIdxList{pIdx} = [x y];
        imageInfo(i).trkInfo.Corners{pIdx, 1} = [min(x) - 2, min(y) - 1,... 
            max(x) - min(x) + 3, max(y) - min(y) + 2]; % Rectangle Information
        imageInfo(i).trkInfo.Corners{pIdx, 2} = 0; % bool value for future use
    end 
end

%% Cross Reference and Remove Volitile Particles
    % Does the corner reference (+/- 1) appear in the next image? 
    % 1 : length - 1

for imIdx = 1 : length(images) - 1
    clc;
    fprintf("Loading Images \t\t[100%%]\n");
    fprintf("Adjusting Constrast \t[100%%]\n");
    fprintf("Loading Times \t\t[100%%]\n");
    fprintf("Detect Particles \t[%d%%]", round(imIdx/length(images)*20) + 60);
    
    for curCorner = 1 : length(imageInfo{imIdx, PART_INFO}.Corners)
        for futCorner = 1 : length(imageInfo{imIdx + 1, PART_INFO}.Corners)
            if imageInfo{imIdx, PART_INFO}.Corners{curCorner}(1) >=...
                    imageInfo{imIdx + 1, PART_INFO}.Corners{futCorner}(1) - 1 ...
                    && imageInfo{imIdx, PART_INFO}.Corners{curCorner}(1) <=...
                    imageInfo{imIdx + 1, PART_INFO}.Corners{futCorner}(1) + 1 ...
                    && imageInfo{imIdx, PART_INFO}.Corners{curCorner}(2) >=...
                    imageInfo{imIdx + 1, PART_INFO}.Corners{futCorner}(2) - 1 ...
                    && imageInfo{imIdx, PART_INFO}.Corners{curCorner}(2) <=...
                    imageInfo{imIdx + 1, PART_INFO}.Corners{futCorner}(2) + 1

                imageInfo{imIdx, PART_INFO}.Corners{curCorner, 2} = 1;
            end
        end
    end
 end


    % Does the corner reference (+/- 1) appear in the previous image?
    % 2 : length
for imIdx = 2 : length(images)
    clc;
    fprintf("Loading Images \t\t[100%%]\n");
    fprintf("Adjusting Contrast \t[100%%]\n");
    fprintf("Loading Times \t\t[100%%]\n");
    fprintf("Detect Particles \t[%d%%]", round(imIdx/length(images)*20) + 80);
    
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

maxTracked = 0;
% Remove all points that aren't consistent b/w images
 for imIdx = 1 : length(images)
    %{
     for crnr = 1 : length(imageInfo{imIdx, PART_INFO}.Corners)
        index = cellfun(@(x) x==0, imageInfo{imIdx,PART_INFO}.Corners(:,2),...
            'UniformOutput', 1);
        imageInfo{imIdx,PART_INFO}.Corners(find(index),:) = []; %#ok<FNDSB>
        %}
        if length(imageInfo{imIdx,PART_INFO}.Corners) > maxTracked
            maxTracked = length(imageInfo{imIdx,PART_INFO}.Corners);
        end
    %end
 end
    
%% Evaluate Particle Displacements

UID = 1; %Unique particle ID, will be newly added for inconsistent frames
particles = cell(maxTracked,1);
particles{UID}.position(1,1:2) = imageInfo{1,PART_INFO}.Corners{1}(1:2); %initialise struct
%particles{1}.position(1,3) = 0; %initialise struct
particles{UID}.time{1} = 0; %initialise struct
particles{UID}.relativeTime = imageInfo{1,IMAGES}.relativeTime;
particles{UID}.set(1) = imageInfo{1,IMAGES}.set;
particles{UID}.name = imageInfo{1,IMAGES}.name;
added = 0; %flag 

for im = 1 : length(images)
    clc;
    fprintf("Loading Images \t\t[100%%]\n");
    fprintf("Adjusting Constrast \t[100%%]\n");
    fprintf("Loading Times \t\t[100%%]\n");
    fprintf("Detect Particles \t[100%%]\n");
    fprintf("Track Particles \t[%d%%]", round(im/length(images)*100));
    
    for prtcl = 1 : length(imageInfo{im,PART_INFO}.Corners)
        for tracked = 1 : UID
            if particles{tracked}.position(end,1) >= ... % Check correlation
                    imageInfo{im,PART_INFO}.Corners{prtcl}(1) - 1 ...
                    && particles{tracked}.position(end,1) <= ...
                    imageInfo{im,PART_INFO}.Corners{prtcl}(1) + 1 ...
                    && particles{tracked}.position(end,2) >= ...
                    imageInfo{im,PART_INFO}.Corners{prtcl}(2) - 1 ...
                    && particles{tracked}.position(end,2) <= ...
                    imageInfo{im,PART_INFO}.Corners{prtcl}(2) + 1
                    
                if particles{tracked}.set == imageInfo{im, IMAGES}.set
                    particles{tracked}.position(end + 1,1:2) = ...
                        imageInfo{im,PART_INFO}.Corners{prtcl}(1:2); % grab position 
                    %particles{tracked}.position(end,2) = 0; %initalisation for further use
                    particles{tracked}.time{end + 1,1} = imageInfo{im,IMAGES}.relativeTime - ...
                        particles{tracked}.relativeTime;
                    added = 1;
                else
                    added = 0;
                end
                break;
            end
        end
        if ~added % if flagged as un-associated, make new UID & add
            UID = UID + 1;
            particles{UID}.position(1,1:2) = imageInfo{im,PART_INFO}.Corners{prtcl}(1:2);
            %particles{UID}.position(1,2) = 0;
            particles{UID}.relativeTime = imageInfo{im,IMAGES}.relativeTime;
            particles{UID}.time{1,1} = 0;
            particles{UID}.set(1) = imageInfo{im,IMAGES}.set;
            particles{UID}.name = imageInfo{im,IMAGES}.name;
        end
        added = 0; %reset flag for next interaction
    end
end

maxLength = cell(1,particles{end}.set);
for i = 1 : particles{end}.set
    maxLength{i}.size = 0;
    maxLength{i}.particle = 0;
end
for tracked = 1 : UID 
    if maxLength{particles{tracked}.set}.size < length(particles{tracked}.position)
        maxLength{particles{tracked}.set}.size = length(particles{tracked}.position);
        maxLength{particles{tracked}.set}.particle = tracked;
        maxLength{particles{tracked}.set}.name = particles{tracked}.name;
    end
end
imageInfo{1,FINAL_DATA} = particles; % package particle info into exported cell structure
imageInfo{2,FINAL_DATA} = maxLength;