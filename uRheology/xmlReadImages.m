function outStruct = xmlReadImages(xmlFile, xmlDir)
    tic;
    tree = xmlread(strcat(xmlDir,xmlFile));
    xmlStruct = parseChildren(tree);
    toc;
    outStruct = xmlStruct.Data.Data;
end

%% Local Function to 'Recurse' over children
function children = parseChildren(theNode)
    
    if theNode.hasChildNodes
        childNode = theNode.getChildNodes;
        numChildNodes = childNode.getLength;
        
        children = struct('Name', [], 'Data', []);
        
        upCount = 0;
        for count = 1 : numChildNodes
            theChild = childNode.item(count - 1);
            tmpStruct = makeStructFromNode(theChild);
            if isstruct(tmpStruct)
                children(count - upCount) = tmpStruct;
            else
                upCount = upCount + 1;
            end
        end 
    end
end

%% Local Function to unpack nodes into struct
function nodeStruct = makeStructFromNode(theNode)
    goodNode = checkNode(theNode);
    if goodNode
        nodeStruct = struct('Name', char(theNode.getNodeName), 'Data', '');
        if (theNode.getFirstChild == theNode.getLastChild) 
            % lowest level, save data
            nodeStruct.Data = char(theNode.getTextContent);
        else
            % recurse through children 
            nodeStruct.Data = parseChildren(theNode);
        end
    else
        % Not a "goodNode"
        nodeStruct = 0;
    end
end    
 
%% Local Function to skip past all non-image info branches
function flag = checkNode(theNode)
    % Initialise ENUM style flags. 
    PASS = 1;
    FAIL = 0;
    
    if ~(strcmp(theNode.getNodeName, 'EvaluationInputData') || ...
            strcmp(theNode.getNodeName, 'Images'))
        % Not the two top levels, could be lower in correct tree
        
        if strcmp(theNode.getNodeName, 'Image')
            % Specific image in Images tree 
            flag = PASS;  
            
        elseif strcmp(theNode.getParentNode, '[Image: null]')
            % unpacking specific image in Images tree
            
            if strcmp(theNode.getNodeName, '#text')
                % Ignore empty "#text" entries
                flag = FAIL;  
            else
                flag = PASS;
            end
            
        else
            % Not within the Images Tree
            flag = FAIL;
        end    
    else
        % Image data or start of tree
        flag = PASS;
    end
end
