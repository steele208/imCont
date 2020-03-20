function userData = graph_results(handles)
%{
 Needs:
   - Mean/nanmean per point
   - Mean per set subplot/single axis
%}
userData = handles.output.UserData;
msg = 'Producing graphs (';
switch handles.radiobutton12.Value
    case 0 % Don't display graphs
        vis = 'off';
        msg = strcat(msg, 'not visible)');
    case 1
        vis = 'on';
        msg = strcat(msg, 'visible)');
end



handles.text20.String = msg;
% Assuming that all images are at the same resolution:
res = str2double(userData.metaData(1).Data.ImageResolutionX);
userData.figure = [];

for set = 1 : length(userData.tracked)
    userData.figure{end+1} = figure(set+1);
    userData.figure{end}.Visible = vis;
    accept = userData.calcs.MSD{set, 2} > 50;
    %{
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
    
    hold on
 
    for i = 1 : length(userData.tracked{set,1})
        if all(size(userData.tracked{set,1}(1).AvgTime(:,i)) ==...
                size(nanmean(userData.tracked{set,1}(1).AvgPath2,2))) &&...
                ~any(isnan(userData.tracked{set,1}(1).AvgTime(:,i)))
            t = i;
            
            continue
        end
    end
 %}
    subplot(2, 1, 1);
    if any(isnan(userData.calcs.G_Prime{set}))
        text(0.3, 0.5, 'Processing Error','FontSize', 30)
    else
        
        plot(userData.meanTime(accept), userData.calcs.G_Prime{set}(accept));
        hold on;
        plot(userData.meanTime(accept), userData.calcs.G_DblPrime{set}(accept));
        legend('G Prime','G Double Prime');
        ylabel('Log_{10} G*');
        xlabel('Time (ms)');
    end
    subplot(2, 1, 2);
    plot(userData.meanTime(accept), res .* userData.calcs.MSD{set}(accept));
    ylabel('Distance Travelled (m)');
    xlabel('Time (ms)');
    title('Mean Squared Particle Displacement');
end

userData.figure{end+1} = figure(1);
userData.figure{end}.Visible = vis;
hold on;
for set = 1 : length(userData.tracked)
    n = size(userData.calcs.G_Prime{set},2);
    plot(userData.meanTime(1:n), res .* userData.calcs.MSD{set});
    title({'Mean Squared Particle Displacement',...
        'Gel Concentrations  1% to 8%'}, 'FontSize', 14);
    ylabel('Distance Travelled (m)');
    xlabel('Time (ms)');
    
   % tMax = ceil(max(nanmean(userData.tracked{set,1}(1).AvgTime,2))/5)*5;
   % axis([0 tMax 0 inf])
    % Legend ...!? %
end

