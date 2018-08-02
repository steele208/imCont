function output = readXML()
[xf, xD] = uigetfile('.xml');
tic;
tree = xmlread(strcat(xD, xf));
childNode = tree.getChildNodes;

childIdx = 1;
imNode = childNode.getFirstChild.item(childIdx);
while ~isempty(imNode)
    if ~strcmp(imNode.getTagName, 'Images')
        childIdx = childIdx + 2;
        imNode = childNode.getFirstChild.item(childIdx);
    else
        break;
    end
end
output = struct('Name', [], 'Data', []);
for idx = 1 : 2 : imNode.getLength - 1
    % ceil(idx/2)
    infoNode = imNode.item(idx).getChildNodes; % get specific image detail
    n = 1;
    node = infoNode.item(n); % get singular detail
    while ~isempty(node)
        name = char(node.getNodeName); 
        if strcmp(name, 'URL')
            output(ceil(idx/2)).Name = char(node.getTextContent);
        end
        output(ceil(idx/2)).Data.(name) = char(node.getTextContent);
        n = n + 2;
        node = infoNode.item(n);  
    end
end
toc;
end