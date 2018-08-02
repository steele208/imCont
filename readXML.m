function output = readXML()
[xf, xD] = uigetfile('.xml'); % Find file
tic; % timing 
tree = xmlread(strcat(xD, xf)); % Read file
childNode = tree.getChildNodes; % First set of children
output = struct('Name', [], 'Data', []); % Initialise output structure

%% Cycle through first level children to find 'Images'
    
% 'Images' Tag is always the second last
imNode = childNode.getFirstChild.getLastChild.getPreviousSibling;

for idx = 1 : 2 : imNode.getLength - 1
    % ceil(idx/2) will recover normal counting from '#text' node skipping
    infoNode = imNode.item(idx).getChildNodes; % get specific image detail
    n = 1;
    node = infoNode.item(n); % get singular detail
    while ~isempty(node) % loop through all details
        name = char(node.getNodeName); 
        if strcmp(name, 'URL')
            output(ceil(idx/2)).Name = char(node.getTextContent);
        end
        output(ceil(idx/2)).Data.(name) = char(node.getTextContent);
        n = n + 2; % jump in 2's to avoid '#text'
        node = infoNode.item(n); % next item
    end
end
toc;
end