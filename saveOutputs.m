function saveOutputs(userData)
curFolder = pwd;
msgStem = 'Select Location to Save ';
msg{3} = 'Successfully Saved to:';

if userData.save
    doSave = 1;
else 
    doSave = 0;
end

while(doSave == 1)
    % Cancelling the save from the dialog box will cause a loop and the
    % save request to be asked again; if saving isn't selected then the 
    % while loop won't enter
        % images
        if userData.save == 3 || userData.save == 2
            msg{1} = strcat(msgStem, ' Graphs');
            hdl = makeDialog(msg{1});
            [file, path] = uiputfile('*.mat', 'Save Data to File');
            disp(file);
            saveErr = makeSave(userData, path, file); % Error, might be ignored 
        end
        
        % Data 
        if userData.save == 3 || userData.save == 1
            cd(curFolder);
            msg{1} = strcat(msgStem, ' Data');
            hdl = makeDialog(msg{1});
            [file, path] = uiputfile('*.mat', 'Save Data to File');
            saveErr = makeSave(userData, path, file); % Error, might be ignored 
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
   
function errorFlag = makeSave(uRhe_Out, path, file)
    if any(~file) || any(~path) || isempty(uRhe_Out)
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
        save(strcat(path,file), 'uRhe_Out', '-v7.3');
        errorFlag = 0;
    end
    
function hdl = makeDialog(msg)
hdl = dialog('Position', [0 500 300 100], 'Name', 'Saving');
uicontrol('Parent', hdl, 'Style', 'text',...
    'Position',[0 -5 300 90],...
    'String', msg);