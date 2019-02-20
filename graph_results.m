function userData = graph_results(userData)
%{
% Needs:
%   - Mean/nanmean per point
%   - Mean per set subplot/single axis
%}


% Assuming that all images are at the same resolution:
res = userData.metaData(1).Data.ImageResolutionX;
res = str2double(res);
userData.figure = [];
for set = 1 : length(userData.tracked)
    userData.figure{end+1} = figure(set+1);
    
    for pth = 1 : length(userData.tracked{set,1})
        subplot(2, 1, 1);
        hold on
        plot(userData.tracked{set,1}(pth).AbsTime,...
            res.*userData.tracked{set,1}(pth).Position...
            (1:length(userData.tracked{set,1}(pth).AbsTime),3));
        ylabel('Distance Travelled (m)');
        xlabel('Time (ms)');
        title({'Particle Displacement Due To Brownian Motion',...
            strcat(' - Set: ', num2str(set))});
    end
    subplot(2, 1, 2);
    hold on
    for i = 1 : length(userData.tracked{set,1})
        if all(size(userData.tracked{set,1}(1).AvgTime(:,i)) ==...
                size(nanmean(userData.tracked{set,1}(1).AvgPath,2))) &&...
                ~any(isnan(userData.tracked{set,1}(1).AvgTime(:,i)))
            t = i;
            
            continue
        end
    end
 
    plot(userData.tracked{set,1}(1).AvgTime(:,t),...
        (res.*nanmean(userData.tracked{set,1}(1).AvgPath,2)).^2);
    ylabel('Distance Travelled (m)');
    xlabel('Time (ms)');
    title('Mean Squared Particle Displacement');
end
userData.figure{end+1} = figure(1);
hold on;
for set = 1 : length(userData.tracked)
    if set == 15 || set == 17
        continue;
    end
    plot(nanmean(userData.tracked{set,1}(1).AvgTime,2),...
        (res.*nanmean(userData.tracked{set,1}(1).AvgPath,2)).^2);
    title({'Mean Squared Particle Displacement','Gel Concentrations  1% to 8%'},...
    'FontSize', 14);
    ylabel('Distance Travelled (m)');
    xlabel('Time (ms)');
    axis([0 180 0 inf])
    % Legend ...!? %
end

