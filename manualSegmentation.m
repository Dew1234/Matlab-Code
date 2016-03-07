function varargout = manualSegmentation(varargin)
% manualSegmentation uses mh_VascularAnalysis output to show the 
%   gray scale and binary images and help user to modify the binary image.
%   developed by Mohammad Haft-Javaherian (~mh973)
 
% MANUALSEGMENTATION MATLAB code for manualSegmentation.fig
%      MANUALSEGMENTATION, by itself, creates a new MANUALSEGMENTATION or raises the existing
%      singleton*.
%
%      H = MANUALSEGMENTATION returns the handle to a new MANUALSEGMENTATION or the handle to
%      the existing singleton*.
%
%      MANUALSEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALSEGMENTATION.M with the given input arguments.
%
%      MANUALSEGMENTATION('Property','Value',...) creates a new MANUALSEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualSegmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualSegmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
 
% Edit the above text to modify the response to help manualSegmentation
 
% Last Modified by :
% 	GUIDE v2.5 15-Jun-2015 18:46:36
% 	mh973 15-Jun-2015 18:46:36
 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualSegmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @manualSegmentation_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
 
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
 
 
% --- Executes just before manualSegmentation is made visible.
function manualSegmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualSegmentation (see VARARGIN)
 
% Choose default command line output for manualSegmentation
handles.output = hObject;
 
% Load the variables from the analysis.mat file, which is an output of 
%    mh_VascularAnalysis
file=struct;
[file.fileName,file.Path]=uigetfile('*.mat','Choose mat file');
load(strcat(file.Path,file.fileName),'im');
load(strcat(file.Path,file.fileName),'V');
load(strcat(file.Path,file.fileName),'Skel');
handles.im=im;
handles.V=V;
handles.Skel=Skel;
handles.file=file;
allString='All       ';
set(handles.popupmenuVesselNo,'String', ...
    [allString(1:size(num2str((1:size(Skel,2))'),2)); ...
    num2str((1:size(Skel,2))')])
set(handles.popupmenuVesselNo,'Value',1)
 
% set the initial values of variables
handles.stackID=1; % the z plain id
handles.VesselNo=0; % the vessel no. of interest. (0 means All)
handles.xMin=1; % the limits of plot(xMin,xMax, yMin,yMax)
handles.yMin=1;
handles.zoomRatio=1.0; % the zoom ratio
[handles.yMax,handles.xMax,~]=size(V);
handles.activeClick=0; % if the GUI record the click
handles.imageProp.MinBright=0; %limits of contrast (min and maxBright) 
handles.imageProp.MaxBright=round(prctile(im(:),95)); % adjust based on data
set(handles.sliderMaxBright,'Value',handles.imageProp.MaxBright);
set(handles.textMaxBright,'String',strcat('Max. Brightness= ',...
    num2str(handles.imageProp.MaxBright))); % update the slider and label
handles.zoomChanged=false; 
 
plotBoth(handles)
 
% Update handles structure
guidata(hObject, handles);
 
% UIWAIT makes manualSegmentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 
 
% --- Outputs from this function are returned to the command line.
function varargout = manualSegmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Get default command line output from handles structure
varargout{1} = handles.output;
 
 
function plotBoth(handles)
% assign a local variable to image data and Skeleton
im=handles.im;
V=handles.V;
Skel=handles.Skel;
   
axes(handles.axes1) % make the axes 1 the current axes 
 
% plot the gray and B/W images in limits defined before.
imagesc(handles.xMin:handles.xMax,handles.yMin:handles.yMax, ...
    im(handles.yMin:handles.yMax,handles.xMin:handles.xMax, ...
    handles.stackID),[handles.imageProp.MinBright, ...
    handles.imageProp.MaxBright]);
axis tight equal ij
colormap('gray')
 
hold on
% Plots the centerline of the selected vessel: red dot for points in the 
%   plan of interest and blue for out of plane
if handles.VesselNo~=0
    for i=1:length(Skel{1,handles.VesselNo}(:,1))
        if Skel{1,handles.VesselNo}(i,3)==handles.stackID
            centeLineColor='.r';
        else
            centeLineColor='.b';
        end
        plot(Skel{1,handles.VesselNo}(i,2), ...
            Skel{1,handles.VesselNo}(i,1),centeLineColor)
    end
end
hold off
 
% plot the B/W image in the same limits
axes(handles.axes2)
handles.axes1=imagesc(handles.xMin:handles.xMax, ...
    handles.yMin:handles.yMax,V(handles.yMin:handles.yMax, ...
    handles.xMin:handles.xMax,handles.stackID));
axis tight equal ij
colormap('gray')
xlim([handles.xMin handles.xMax])
ylim([handles.yMin handles.yMax])
 
% Updates the Z id label
set(handles.textStackID,'String',strcat('Stack ID in Z= ', ...
    num2str(handles.stackID)))
 
 
% --- Executes on slider movement.
function sliderMinBright_Callback(hObject, eventdata, handles)
% this function updates the value of minBright as well as steps and limits
%   of min and maxBright sliders 
% hObject    handle to sliderMinBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=round(get(hObject,'Value'));
hObject.Value=value;
handles.imageProp.MinBright=value;
set(handles.sliderMaxBright,'Min',value+1);
handles.textMinBright.String=strcat('Min. Brightness= ',...
    num2str(value));
step=1/(get(hObject,'Max')-get(hObject,'Min'));
set(hObject,'SliderStep',[step,10*step]);
step=1/(get(handles.sliderMaxBright,'Max')- ...
    get(handles.sliderMaxBright,'Min'));
set(handles.sliderMaxBright,'SliderStep',[step,10*step]);
 
% Renew the plot
plotBoth(handles)
 
guidata(hObject, handles);
 
 
 
 
% --- Executes during object creation, after setting all properties.
function sliderMinBright_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMinBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on slider movement.
function sliderMaxBright_Callback(hObject, eventdata, handles)
% This function updates the value of maxBright as well as steps and limits
%   of min and maxBright sliders 
% hObject    handle to sliderMaxBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=round(get(hObject,'Value'));
set(hObject,'Value',value);
handles.imageProp.MaxBright=value;
set(handles.sliderMinBright,'Max',value-1);
set(handles.textMaxBright,'String',strcat('Max. Brightness= ',...
    num2str(value)));
step=1/(get(hObject,'Max')-get(hObject,'Min'));
set(hObject,'SliderStep',[step,10*step]);
step=1/(get(handles.sliderMinBright,'Max')- ...
    get(handles.sliderMinBright,'Min'));
set(handles.sliderMinBright,'SliderStep',[step,10*step]);
 
% renew the plot
plotBoth(handles)
 
guidata(hObject, handles);
 
 
 
% --- Executes during object creation, after setting all properties.
function sliderMaxBright_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMaxBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% Moves the plots in the Z direction
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%   VerticalScrollCount: signed integer indicating direction and number of clicks
%   VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
handles.stackID=max(1,handles.stackID+eventdata.VerticalScrollCount);
handles.stackID=min(handles.stackID,size(handles.V,3));
 
plotBoth(handles)
 
guidata(hObject, handles);
 
 
% --- Executes on selection change in popupmenuVesselNo.
function popupmenuVesselNo_Callback(hObject, eventdata, handles)
% Changes the vessel of interest (vessel 0 means all)
% hObject    handle to popupmenuVesselNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuVesselNo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuVesselNo
 
handles.VesselNo=get(hObject,'Value')-1;
handles=changeZoomVessel(handles);
handles.sliderZoom.Value=1.0;
handles.zoomRatio=1.0;
handles.textZoom.String=strcat('Zoom= ',num2str(handles.zoomRatio), 'x');
plotBoth(handles)
guidata(hObject, handles);
 
% --- Executes on slider movement.
function sliderZoom_Callback(hObject, eventdata, handles)
% Changes the zoom ratio
% hObject    handle to sliderZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.zoomRatio=get(hObject,'Value');
handles.textZoom.String=strcat('Zoom= ',num2str(handles.zoomRatio), 'x');
handles=changeZoomVessel(handles);
handles.zoomChanged=true;
plotBoth(handles)
guidata(hObject, handles);
 
function handles=changeZoomVessel(handles)
% this function defienes the limits of figures besed on the centerline
%   information as well as the zoom ratio.
 
V=handles.V;
Skel=handles.Skel;
 
if handles.VesselNo==0
    handles.xMin=1;
    handles.yMin=1;
    [handles.yMax,handles.xMax,~]=size(V);
    handles.stackID=1;
else
    xMin=min(Skel{1,handles.VesselNo}(:,2));
    yMin=min(Skel{1,handles.VesselNo}(:,1));
    xMax=max(Skel{1,handles.VesselNo}(:,2));
    yMax=max(Skel{1,handles.VesselNo}(:,1));
    xRange=xMax-xMin;
    yRange=yMax-yMin;
    handles.xMin=max(1,round(xMin-1/handles.zoomRatio*xRange));
    handles.yMin=max(1,round(yMin-1/handles.zoomRatio*yRange));
    handles.xMax=min(size(V,2),round(xMax+1/handles.zoomRatio*xRange));
    handles.yMax=min(size(V,2),round(yMax+1/handles.zoomRatio*yRange));
    if handles.zoomChanged
        handles.zoomChanged=false;
    else 
        handles.stackID=min(Skel{1,handles.VesselNo}(:,3));
    end
end 
 
% In case all the nodes are in a same vertical or horizontal line 
if handles.xMax==handles.xMin
    handles.xMax=handles.xMax+1;
end
if handles.yMax==handles.yMin
    handles.yMax=handles.yMax+1;
end



 
 
 
 
% --- Executes during object creation, after setting all properties.
function popupmenuVesselNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuVesselNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
 
 
% --- Executes during object creation, after setting all properties.
function sliderZoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
 
% --- Executes on button press in togglebuttonActiveClick.
function togglebuttonActiveClick_Callback(hObject, eventdata, handles)
% Changes the mode of clicking between active and not active
% hObject    handle to togglebuttonActiveClick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hint: get(hObject,'Value') returns toggle state of togglebuttonActiveClick
handles.activeClick=get(hObject,'Value');
 
% Goes to the point recording function
while get(hObject,'Value')
    handles=guidata(hObject);
    handles=activeClicking(handles);
    guidata(hObject, handles);
end

 
function handles=activeClicking(handles)
% Records the clicking points and change the color to the counterpart color

if get(handles.checkboxMultiClick,'Value') % several click and then apply
   [x,y]=getline();
else % one click each time
   [x,y]=ginput(1);
end
x=round(x);
y=round(y);
if get(handles.togglebuttonActiveClick,'Value')
for i=1:length(x) % apply the points if they are in boundary
   if x(i)>=handles.xMin && x(i)<=handles.xMax && ...
           y(i)>=handles.yMin && y(i)<=handles.yMax
       handles.V(y(i),x(i),handles.stackID)= ...
           ~handles.V(y(i),x(i),handles.stackID);
       if i>1
           l=max(abs(x(i)-x(i-1)),abs(y(i)-y(i-1)));
           for j=1:l-1
               xx=round(x(i-1)+j/l*(x(i)-x(i-1)));
               yy=round(y(i-1)+j/l*(y(i)-y(i-1)));
               handles.V(yy,xx,handles.stackID)= ...
                    ~handles.V(yy,xx,handles.stackID);
           end
       end

   end
end
end
plotBoth(handles)
   
 
 
 
% --- Executes on button press in pushbuttonSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% Saves the modified V (B/W image)
% hObject    handle to pushbuttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
V=handles.V;
save(strcat(handles.file.Path,handles.file.fileName),'V','-append')
 
 
% --- Executes on slider movement.
function sliderXoff_Callback(hObject, eventdata, handles)
% Move the images in X direction
% hObject    handle to sliderXoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.xMin=handles.xMin+get(hObject,'Value');
handles.xMax=handles.xMax+get(hObject,'Value');
guidata(hObject, handles);
plotBoth(handles)
 
 
% --- Executes during object creation, after setting all properties.
function sliderXoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderXoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on slider movement.
function sliderYoff_Callback(hObject, eventdata, handles)
% Moves the images in Y direction
% hObject    handle to sliderYoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 
handles.yMin=handles.yMin+get(hObject,'Value');
handles.yMax=handles.yMax+get(hObject,'Value');
guidata(hObject, handles);
plotBoth(handles)
 
% --- Executes during object creation, after setting all properties.
function sliderYoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderYoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on button press in checkboxMultiClick.
function checkboxMultiClick_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxMultiClick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hint: get(hObject,'Value') returns toggle state of checkboxMultiClick
