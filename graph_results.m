function graph_results(userData)
%{
% Needs:
%   - Mean/nanmean per point
%   - Mean per set subplot/single axis
%}


% Assuming that all images are at the same resolution:
res = userData.metaData(1).Data.ImageResolutionX;
res = str2double(res);

for set = 1 : length(userData.tracked)
    figure(set)
    
    for pth = 1 : length(userData.tracked{set,1})
        ax1 = subplot(2, 1, 1);
        hold on
        plot(userData.tracked{set,1}(pth).AbsTime,...
            res.*userData.tracked{set,1}(pth).Position...
            (1:length(userData.tracked{set,1}(pth).AbsTime),3));
        ylabel('Distance Travelled (m)');
        xlabel('Time (ms)');
        title('Particle Displacement Due To Brownian Motion');
    end
    ax2 = subplot(2, 1, 2);
    hold on
    plot(userData.tracked{set,1}(1).AbsTime,...
        res.*nanmean(userData.tracked{set,1}(1).AvgPath,2));
    linkaxes([ax1, ax2], 'xy');
end