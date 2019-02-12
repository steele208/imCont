function saveOutputs(userData)
curFolder = pwd;
msgStem = 'Select Location to Save ';
msg{3} = 'Successfully Saved to:';
%Enums
DATA = 1;
GRAPH = 2;
if userData.save
    doSave = 1;
else 
    doSave = 0;
end

while(doSave == 1)
    % Cancelling the save from the dialog box will cause a loop and the
    % save request to be asked again; if saving isn't selected then the 
    % while loop won't enter

        % Data 
        if userData.save == 3 || userData.save == 1
            cd(curFolder);
            msg{1} = strcat(msgStem, ' Data');
            hdl = makeDialog(msg{1});
            [file, path] = uiputfile('*.mat', 'Save Data to File');
            saveErr = makeSave(DATA, userData, path, file); % Error, might be ignored 
        end
        
        % images
        if userData.save == 3 || userData.save == 2
            msg{1} = strcat(msgStem, ' Graphs');
            hdl = makeDialog(msg{1});
            [file, path] = uiputfile('*.png', 'Save Graph to File');
            disp(file);
            saveErr = makeSave(GRAPH, userData, path, file); % Error, might be ignored 
        end
        if ~saveErr
            msg{4} = strcat(path, file);
            uicontrol('Parent', hdl, 'Style', 'text',...
                'Position',[0 -5 300 90],...
                'String', msg);
            doSave = 0;
        elseif saveErr == 2
            doSave = 0;
        end
end
if exist('hdl', 'var')
    delete(hdl);
end
   
function errorFlag = makeSave(TYPE, uRhe_Out, path, file)
    if isempty(uRhe_Out) || ~isfield(uRhe_Out, 'figure')
        warndlg('No data found for save','WARNING');
        errorFlag = 2;
        return
    end
   
    if any(~file) || any(~path)
        answer = questdlg('Save Failed, Try again?');
        switch answer 
            case 'Yes'
                errorFlag = 1;
            case 'No'
                errorFlag = 2;
            case 'Cancel' 
                errorFlag = 2;
        end
    else
        switch TYPE
            case 1
                uRhe = uRhe_Out;
                uRhe.figure = [];
                save(strcat(path,file), 'uRhe', '-v7.3');
                errorFlag = 0;
            case 2
                for fig = 1 : numel(uRhe_Out.figure)
                    figLoc = uRhe_Out.figure{fig};
                    filename = strcat(path,file);
                    if fig > 1
                        % append filename
                        filename = insertBefore(filename...
                            ,'.png',strcat('_',num2str(fig)));
                    end
                    print(figLoc, filename, '-dpng')
                end   
                errorFlag = 0;
        end 
        
    end
    
function hdl = makeDialog(msg)
hdl = dialog('Position', [0 500 300 100], 'Name', 'Saving');
uicontrol('Parent', hdl, 'Style', 'text',...
    'Position',[0 -5 300 90],...
    'String', msg);