%[x,y,v] = function hexpoints(nr, nc, l)   

%function hexpoints

%this will continue to run until it reaches the desired percentage
l=1;
nr = 10;
nc = 10;
percent = 80;
%amount = ((vesselnum)*((100-percent)/100));
track = 0;
largeCount = 1;
deletionPercent = 0;
%while track==0

%this makes it keep going until the number of vessels in one island is the
%same number as the percent entered
    
iNode=0;
x=zeros((nr+1)*(nc+1),1); %number of the nodes
y=x;
distarray=x;
vesselx = cell(1, (nr+1)*(nc+1));
vessely = cell(1, (nr+1)*(nc+1));
%the x-coordinates are stored in array x
%the y-coordinates are stored in array y
%store the nodes making up the vessel into the vessel matrix
node = []; %holds the x and y coordinates for each node

for j=0:nc
    for i=0:nr
        iNode=iNode+1;
        if rem(j,2)
            x(iNode)=floor(i/2)*3*l+rem(i,2)*2*l;
            node(iNode,1)=x(iNode);
        else
            x(iNode)=0.5*l+floor(i/2)*3*l+rem(i,2)*l;
            node(iNode,1)=x(iNode);
        end
        y(iNode)=j*0.5*sqrt(3)*l;
        node(iNode,2)=y(iNode);
        
        if isnan(x(iNode)) == 0 && isnan(y(iNode))== 0
%         fprintf('Node: %d \n', iNode)
%         fprintf('X-value: %.3f \n', x(iNode))
%         fprintf('Y-Value: %3f\n', y(iNode))
        inletdist = sqrt(((x(iNode)).^2)+((y(iNode)).^2));
        distarrayin(iNode) = inletdist;
        vesselx{iNode} = x(iNode);
        vessely{iNode} = y(iNode); 
        end
        
    end
end
sample = randperm(iNode, iNode);
%x(sample(1:floor(amount))) = NaN;
y(5) = NaN;

V=[];
for j=0:nc
    for i=0:nr
        iNode=(i+1)+j*(nr+1);
        if (rem(j,2)&& rem(i,2) && i<nr)|| ...exd
                (~rem(j,2)&& ~rem(i,2) && i<nr-1)
            V=[V;iNode,iNode+1]; %connects a node and the node beyond it
%              x(iNode) = NaN;
%              y(iNode) = NaN;
%              x(iNode+1) = NaN;
%              y(iNode+1) = NaN;
        end
        if j~=nc
            V=[V;iNode,iNode+nr+1];
        end
    end
end

  newvarray = [];
  checkarray = [];
     [length, width] = size(V);
     %this gets the size of the number of rows in the array
     
      vesselnum2 = length;
      newamount = floor(length*((100-percent)/100));
      %this calculates the amount that should be removed based on the
      %percent that was entered
      amtleft = length-newamount;
      %this gives the amount that we should have left afterwards
      %this gets the size of the number of rows in the vessel array
      I = randperm(vesselnum2,newamount);
         a = 1;
      while a < newamount
         V(I(a),:)=1;%this serves as a temporary placeholder for the ones that need to be taken out
%          x(a) = NaN;
%          y(a) = NaN;
         a = a + 1;
      end
     
      %this will remove a certain amount from random rows in the vessel
      %array and make that part blank
      [newlength, newwidth] = size(V);
      %this gets the new rowlength of the changed V array
       
       k = 1;
       j = 1;
       while k < newlength
          %if isnan(V(k,1))==1 && isnan(V(k,2))==1 %for the rows that are NaN
          %newvarray(j)=V(k);
          %this is when the vessel is still existing and connects between
          %the two nodes that are in it
          if V(k,:)~=1 
          newvarray(j,:) = V(k,:);
          checkarray(k)=1; %this records which vessels are still existing 
          j = j+1; 
          %the vessel does not exist anymore and it is recorded as
          %nonexisting in the checkarray
          else
              checkarray(k)= 0; %this records which vessels have been 
              %removed from the program
          end
          
%           if x(k)==1 && y(k)==1 && k<=441
%           x(k)=NaN;
%           y(k)=NaN;
%           end
          %this will create a new array with just the remaining value from
          %the array 
          
          k = k+1;
      end
      
   [val inletnode] = min(distarrayin);
  % fprintf('Inlet Node: %d \n', inletnode)
   
   [finalNodeArray,finalVesselArray] = getRidOfIslandsNew(node, newvarray);
   
   str=sprintf('Blood Vessels: Rows = %d Columns = %d Percent = %d', nr, nc, percent);
   title(str)                       
   xlabel('Vessel Column Number')    
   ylabel('Vessel Row Number')
   drawhex(finalNodeArray(:,1),finalNodeArray(:,2),finalVesselArray);
%    figure
%    drawhex(node(:,1),node(:,2),newvarray);
   %fprintf('Percent: %d \n', percent)
   %fprintf('Outlet Node: %d \n', iNode)
   [vl,vw] = size(finalVesselArray);
%    for x = 1:vl
%         fprintf('Vessel: %d %d \n',finalVesselArray(x,1),finalVesselArray(x,2)) 
%    end
   
   [finall,finalw] = size(finalVesselArray);
   if finall==amtleft
       track = 1;
   end
   fprintf('Trial %d \n', largeCount)
   largeCount = largeCount + 1;
%end
[a,b] = size(finalNodeArray);
for t = 1:a
        fprintf('Node: %d \n', t)
        fprintf('X-value: %.3f \n', finalNodeArray(t,1))
        fprintf('Y-Value: %3f\n', finalNodeArray(t,2))
end
   
   
   
   
   
