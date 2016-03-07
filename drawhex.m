function drawhex(x,y,V)

%plot(x,y,'*r')
%this is the portion that helps to plot the different points

% hFig = figure(1);
% set(hFig,'Position',[x y 40 40])
for i=1:size(V,1)
    %this goes on for the size of V
    
    plot([x(V(i,1)),x(V(i,2))],[y(V(i,1)),y(V(i,2))],'b')
    hold on
    %this plots the two points together
    %this portion plots only the components of x and y that have the index
    %that is present within V
    %connects the points [x(V(i,1)),y(V(i,1))] and [x(V(i,2)),y(V(i,2))]
    %together
end
hold off