function hexpointsdeletionupdated(nr, nc, percent)   

%function hexpoints
%nr is number of rows, nc is number of columns, percent is the percent
%this will continue to run until it reaches the desired percentage
l=1;
%nr = 10;
%nc = 10;
%percent = 75;
%amount = ((vesselnum)*((100-percent)/100));
track = 0;
largeCount = 1;
deletionPercent = 100;
deletionNumber = 1;
%this makes it keep going until the number of vessels in one island is the
%same number as the percent entered
iNode=0;
x=zeros((nr+1)*(nc+1),1); %number of the nodes
y=x;
distarray=x;
vesselx = cell(1, (nr+1)*(nc+1));
vessely = cell(1, (nr+1)*(nc+1));
node = []; %holds the x and y coordinates for each node
newVessel = [];
newNode = [];
tempNode = [];
tempVessel = [];
time = [];

tic
tStart = tic;
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
        inletdist = sqrt(((x(iNode)).^2)+((y(iNode)).^2));
        distarrayin(iNode) = inletdist;
        vesselx{iNode} = x(iNode);
        vessely{iNode} = y(iNode); 
        end
        
    end
end
[nodel,nodew] = size(node);
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
        end
        if j~=nc
            V=[V;iNode,iNode+nr+1];
        end
    end
end

[vessl,vessw] = size(V);
%original one before deletions
for t = 1:vessl
%     newVessel(t,1)=V(t,1);
%     newVessel(t,2)=V(t,2);
    tempVessel(t,1)=V(t,1);
    tempVessel(t,2)=V(t,2);
end
for t = 1:nodel
%     newNode(t,1)=node(t,1);
%     newNode(t,2)=node(t,2);
    tempNode(t,1) = node(t,1);
    tempNode(t,2) = node(t,2);
end
%this should set these arrays equal to the original array that was made

a = 1;
  newvarray = [];
  checkarray = [];
     [length, width] = size(V);
     %this gets the size of the number of rows in the array
     
      vesselnum2 = length;
      newamount = floor(length*((100-percent)/100));
      %amount to be removed
      removeAmount = floor(length*((100-deletionPercent)/100));
      %this calculates the amount that should be removed based on the
      %percent that was entered
      amtleft = length-newamount; %target goal
      amtleft2 = length-removeAmount;
      %this gives the amount that we should have left afterwards
      %this gets the size of the number of rows in the vessel array
      %delete one vessel at a time
      I = randperm(vesselnum2,vesselnum2);
         %a = 1;
      %while a < deletionNumber
      overallCount = 1;
%while the desired amounhas not been reached yet
while track==0
        IDtoRem=randi(size(tempVessel,1));
          tempVessel(IDtoRem,:)=1;%this serves as a temporary placeholder for the ones that need to be taken out
      newvarray = [];
      %every time that the loop iterates, newvarray will become smaller so
      %the empty array will have to be initialized again every time
      %this will remove a certain amount from random rows in the vessel
      %array and make that part blank
      [newlength, newwidth] = size(tempVessel);
      %this gets the new rowlength of the changed V array
       k = 1;
       j = 1;
       while k < newlength
          %only add the row when both of the elements are not 1
          if ~(tempVessel(k,1)==1 && tempVessel(k,2)==1) 
          newvarray(j,:) = tempVessel(k,:);
          checkarray(k)=1; %this records which vessels are still existing 
          j = j+1; 
          %the vessel does not exist anymore and it is recorded as
          %nonexisting in the checkarray
          else
              checkarray(k)= 0; %this records which vessels have been 
              %removed from the program
          end
          
          k = k+1;
      end
      
   [val inletnode] = min(distarrayin);
  % fprintf('Inlet Node: %d \n', inletnode)
   
  %this will get rid of the extra islands
   [finalNodeArray,finalVesselArray] = getRidOfIslandsNew(tempNode, newvarray);
%    figure
%    drawhex(node(:,1),node(:,2),newvarray);
   %fprintf('Percent: %d \n', percent)
   %fprintf('Outlet Node: %d \n', iNode)
   [vl,vw] = size(finalVesselArray);
%    for x = 1:vl
%         fprintf('Vessel: %d %d \n',finalVesselArray(x,1),finalVesselArray(x,2)) 
%    end
   [finalnl,finalnw] = size(finalNodeArray);
   [finall,finalw] = size(finalVesselArray);
   %gets it within a certain range (can replace with a percentage range)
   tempNode = [];
   tempVessel = [];
   %have to set the arrays back to empty since they will get smaller with
   %each iteration 
   for x = 1:finalnl
         tempNode(x,1)=finalNodeArray(x,1);
         tempNode(x,2)=finalNodeArray(x,2);
   end
   for x = 1:finall
        tempVessel(x,1)=finalVesselArray(x,1);
        tempVessel(x,2)=finalVesselArray(x,2);
   end
  [finaltl,finaltw] = size(tempNode);
   [finalttl,finalttw] = size(tempVessel); 
    [finalttl, amtleft ]
   if finalttl>amtleft 
       newNode = [];
       newVessel = [];
        for t = 1:finaltl
            newNode(t,1)=tempNode(t,1);
            newNode(t,2)=tempNode(t,2);
        end
        for v = 1:finalttl
            newVessel(v,1)=tempVessel(v,1);
            newVessel(v,2)=tempVessel(v,2);
        end
        a = a + 1;
        %only when it is still fine will you take out the next one
%    end
   else
   %when the temporary final array falls below the target, then start again
   %from a little bit higher and delete again
%    if finalttl < amtleft
       tempNode = [];
       tempVessel = [];
       [nNode1,nNodew] = size(newNode);
       [nVess1,nVessw] = size(newVessel);
        %for t = 1:finaltl
        for t = 1:nNode1
            tempNode(t,1)=newNode(t,1);
            tempNode(t,2)=newNode(t,2);
        end
        %for v = 1:finalttl
        for v = 1:nVess1
            tempVessel(v,1)=newVessel(v,1);
            tempVessel(v,2)=newVessel(v,2);
        end
   end
   %otherwise, when the finall is more than the target the while loops will
   %continue to run and delete
   timeVal = toc(tStart);
   time(overallCount) = timeVal;
   deleteCount = newamount - abs(amtleft-finall);
   
   %perc = (abs(amtleft-finall)/newamount)*100;
   perc = (deleteCount/newamount)*100;
   percentArray(overallCount)=perc;
   overallCount = overallCount+1;
   
   %fprintf('Trial %d - %d\n', largeCount,(size(V,1)- finalttl)/(size(V,1)-amtleft))
   fprintf('Trial %d\n', largeCount)
   largeCount = largeCount + 1;
   deletionPercent = deletionPercent - 0.05;
   deletionNumber = deletionNumber + 1;
%    figure
%     drawhex(tempNode(:,1),tempNode(:,2),tempVessel)
%    
%    pause()
   %temp is the one that has been changed essentially
   [finaltl,finaltw] = size(newNode);
   [finalttl,finalttw] = size(newVessel); 
   
   [finalttl, amtleft ,size(tempVessel,1)]
  %when the current amount is within range stop the loop
  if abs(amtleft-finalttl)<round(0.02*vessl) %&& finalttl>=amtleft
       track = 1;
  else
      tempNode=newNode;
      tempVessel=newVessel;
       %break
   end
%    if amtleft==finalttl                    
%        track = 1;
%    end
%   
end
toc
 str=sprintf('Blood Vessels: Rows = %d Columns = %d Percent = %d', nr, nc, percent);
   title(str)                       
   xlabel('Vessel Column Number')    
   ylabel('Vessel Row Number')
   drawhex(tempNode(:,1),tempNode(:,2),tempVessel);  
%    figure
%    hold on
%    [time1,time2] = size(time);
%    %for t = 1:time
%    plot(time,percentArray)
%    xlabel('Time in Seconds')
%    ylabel('Percent')
[a,b] = size(finalNodeArray);

   
   
   
   
