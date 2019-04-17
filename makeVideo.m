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
        
        subplot(1,2,1);
        imshowpair(imData(start).Mask, imData(im).Mask);     
        Frame = getframe(gcf);
        writeVideo(outputVideo,Frame)
    end

    close(outputVideo)
    fprintf("Video Written\n");
    
    %Return to original location
    cd(workDir)
end