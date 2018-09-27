function saveOutputs(userData)
curFolder = pwd;
msgStem = 'Select Location to Save ';
msg{3} = 'Successfully Saved to:';

if userData.Save
    doSave = 1;
else 
    doSave = 0;
end

while(doSave == 1)
    % Cancelling the save from the dialog box will cause a loop and the
    % save request to be asked again; if saving isn't selected then the 
    % while loop won't enter
        % images
        if userData.Save == 3 || userData.Save == 2
            msg{1} = strcat(msgStem, ' Images');
            hdl = makeDialog(msg{1});
            [file, path] = uiputfile('*.mat', 'Save Data to File');
            
            doSave = makeSave(userData, path); % Error, might be ignored 
            
            if ~doSave    
            msg{4} = strcat(path, file);
            uicontrol('Parent', hdl, 'Style', 'text',...
                'Position',[0 -5 300 90],...
                'String', msg);
            end
        end
        
        % Data 
        if userData.Save == 3 || userData.Save == 1
            cd(curFolder);
            msg{1} = strcat(msgStem, ' Data Outputs');
            hdl2 = makeDialog(msg{1});
            [file, path] = uiputfile('*.mat', 'Save Data to File');

            if makeSave(userData.Data, path)
                answer = questdlg('Save Failed, Try again?');
                switch answer 
                    case 'Yes'
                        doSave = 1;
                    case 'No'
                        doSave = 0;
                    case 'Cancel' 
                        doSave = 0;
                end
            else
                msg{4} = strcat(path, file);
                uicontrol('Parent', hdl2, 'Style', 'text',...
                    'Position',[0 -5 300 90],...
                    'String', msg);
                doSave = 0;
            end
        end
end
delete(hdl);
   
function errorFlag = makeSave(variable, path)
    if path == 0 
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
        save(path, variable, '-v7.3');
        errorFlag = 0;
    end
    
function hdl = makeDialog(msg)
hdl = dialog('Position', [0 500 300 100], 'Name', 'Saving');
uicontrol('Parent', hdl, 'Style', 'text',...
    'Position',[0 -5 300 90],...
    'String', msg);