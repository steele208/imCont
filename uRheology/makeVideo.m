function makeVideo(file, saveDir, imData, start, leng)
    
% Write product back to a video  
    fprintf('Begin Video Write\n');
%Enter directory where the video is to be saved 
    workDir = pwd;
    cd(saveDir)
%Settings for video writter
    outputVideo = VideoWriter(fullfile(saveDir, file));
    outputVideo.FrameRate = 25;
    open(outputVideo)
%Loop through the rendered frames and write into a video
    figure('visible', 'off');

    for im = start : start + (leng - 1)
        clc;
        fprintf("Making Video \t[%d%%]\n", round(((im - start) / leng) * 100));
        
        imshowpair(imData(start).Mask, imData(im).Mask);     
        Frame = getframe(gcf);
        writeVideo(outputVideo,Frame)
    end
    %{
    for particle = 1 : length(imInfo{1,3})
            if length(imInfo{1,PART_INFO}{particle}.time) < 2
                continue;
            end
            hold on;
            plot(imInfo{1,PART_INFO}{particle}.position(:,1),...
                imInfo{1,PART_INFO}{particle}.position(:,2),'b-');
            
    end
    for i = 1 : 15
        Frame = getframe(gcf);
        writeVideo(outputVideo,Frame)
    end
    hold off;
    %}
    close(outputVideo)
    fprintf("Video Written\n");
    
    %Return to original location
    cd(workDir)
end