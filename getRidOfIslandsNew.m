%same as the old file, except that length is represent with [x,y] =
%size(Variable)
function [newNode, finalNewVessel] = getRidOfIslandsNew(nodearray, vesselarray)
[nlength,nwidth] = size(nodearray);
nodelength = nlength;
adjacent = zeros(nodelength,nodelength);
[vl,vw] = size(vesselarray);
vessellength = vl;
%this puts all the 1's into the adjacent array
for x = 1:vessellength
    row = vesselarray(x,1);
    col = vesselarray(x,2);
    if row~=0 && col~=0
        adjacent(row,col)=1;
        adjacent(col,row)=1;  
    end
end
newVessel = [];
newNode = [];
tempNode = [];
tempVessel = [];
% for t = 1:nodelength
%     newNode(t)=nodearray(t);
%     tempNode(t) = nodearray(t);
% end
% for v = 1:vessellength
%     newVessel(t)=vesselarray(t);
%     tempVessel(t)=vesselarray(t);
% end
passednode = zeros(nodelength,1);
toPassNode = [];
%Here, put the ones that are in the same island into the passnode array
count = 1;
count2 = 1;
tag = 0; %checks for whether one is found in the row or not
tag1 = 0;
remaining = [];
%this is to check for the remaining zeros in the passed node for a new
%island
islandcount = 1;
[passedlength,passedwidth] = size(passednode);
toPassNode=1;
count=1;
%as long as all of the elements in passednode are not all 1, keep running
while sum(passednode)~=passedlength
%this runs through the adjacent array to mark the islands, and each pass 
%through it is able to mark one island
  %this indicates the row number 
    a = toPassNode(count);
    if passednode(a)~=1
        for b = 1:nodelength
            %topassnode(count)=adjacent(b,a) 
            %when it is for other individual islands  
            %count5 = 2; %move this to somewhere else?
             %changed from is a==check
          if adjacent(a,b)==1
             %&& IS NOT IN THE ORIGINAL PASSNODE 
             if passednode(b)~=1
                 toPassNode=[toPassNode;b];
             end
             adjacent(a,b)=islandcount + 1;
             adjacent(b,a)=islandcount + 1;
             %put in the marker to indicate which island it is in
          end
        end
        passednode(a)=1;
    end
    %this gets the ones that are still 0 in the toPassNode array after the
    %adjacent matrix has been gone through
    if length(toPassNode)==count && sum(passednode)~=passedlength
        nodeID=1:length(passednode);
        remaining=nodeID(passednode==0);
        islandcount = islandcount + 1;
        toPassNode = remaining(1);
        count=0;
    end
    count = count + 1;
end

%end

%this should count the number of vessels in each island       

islandFinal = zeros(islandcount,1);
for x = 1:islandcount
    
    for a = 1:nodelength
        for b = 1:nodelength
            if adjacent(a,b)==x+1    
                islandFinal(x,1) = islandFinal(x,1)+1; 
            end
        end
    end
    
end

[M,I] = max(islandFinal);
%this gets the index of the largest island
largestIsland = I;
finalIslandNum = I+1;

%toRemoveVessel = zeros(nodelength*nodelength,1);
toRemoveVessel = ones(vessellength,1);
toRemoveNode = ones(nodelength,1);
newnodearray = [];
newNodeID = [];

%get the arrays with the final nodes and vessels for the main island
newcount = 1;

%for creating the toRemoveVessel array by assigning the vessels that will
%be removed a value of 1
for t = 1:vessellength
    if vesselarray(t,1)~=0&&vesselarray(t,2)~=0
    
        if adjacent(vesselarray(t,1),vesselarray(t,2))==finalIslandNum
           toRemoveVessel(t)=0;
        end    
    end
end

newVessel = vesselarray(~toRemoveVessel,:);
[newvl, newvw] = size(newVessel);
%or is it vesselarray(~toRemoveVessel,:)?
%for creating the toRemoveNode array by putting zeros for the node numbers
%that will be kept
for x = 1:newvl %LOOK AT THE METHOD FOR THIS
     toRemoveNode(newVessel(x,1))=0;
     toRemoveNode(newVessel(x,2))=0;            
end

newNode = nodearray(~toRemoveNode,:);
[removel,removew] = size(toRemoveNode);     
%this makes the newNodeID array           
count6 = 1;
for t = 1:removel
    if toRemoveNode(t)==0
        newNodeID(t) = count6;
        count6 = count6 + 1;
    else
        newNodeID(t)=0;
    end
end

oddCount = 1;
evenCount = 2;
finalNewVessel = zeros(newvl,2);
%[vLength,vWidth] = size(newVessel);
%this is for updating the newVesselArray with more updated node numbers
for y = 1:newvl
    finalNewVessel(y,1) = newNodeID(newVessel(y,1));
    finalNewVessel(y,2) = newNodeID(newVessel(y,2));
end






