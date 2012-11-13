function varargout = volumesCompare(varargin)
% VOLUMESCOMPARE MATLAB code for volumesCompare.fig
%      VOLUMESCOMPARE, by itself, creates a new VOLUMESCOMPARE or raises the existing
%      singleton*.
%
%      H = VOLUMESCOMPARE returns the handle to a new VOLUMESCOMPARE or the handle to
%      the existing singleton*.
%
%      VOLUMESCOMPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOLUMESCOMPARE.M with the given input arguments.
%
%      VOLUMESCOMPARE('Property','Value',...) creates a new VOLUMESCOMPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before volumesCompare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to volumesCompare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help volumesCompare

% Last Modified by GUIDE v2.5 23-Jul-2012 11:15:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @volumesCompare_OpeningFcn, ...
                   'gui_OutputFcn',  @volumesCompare_OutputFcn, ...
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


% --- Executes just before volumesCompare is made visible.
function volumesCompare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to volumesCompare (see VARARGIN)

% Choose default command line output for volumesCompare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
if (length(varargin) <=0)
    error('Input volume has not been specified.');
end;
volume_real  = varargin{1};
volume_recon = varargin{2};
figTitle = varargin{3};
if (ndims(volume_real) ~= 3 && ndims(volume_recon) ~= 3)
    error('Input volumes must have 3.');
end;
handles.volume_real = volume_real;
handles.volume_recon = volume_recon;

handles.axis_equal = 0;
handles.color_mode = 1;

% set main wnd title
set(gcf, 'Name', figTitle)

% init 3D pointer
vol_sz = size(volume_real); 
pointer3dt = floor(vol_sz/2)+1;
handles.pointer3dt = pointer3dt;
handles.vol_sz = vol_sz;

axes(handles.voxel_real)
volume_real(volume_real==0)=NaN;
% LO.SD(1:10,1:20,1:20)=NaN;
[Nx,Ny,Nz] = size(volume_real);
cmap = jet(32);
PATCH_3Darray(volume_real,1:Nx,1:Ny,1:Nz,cmap,'col');


axes(handles.voxel_recon)
volume_recon(volume_recon==0)=NaN;
% LO.SD(1:10,1:20,1:20)=NaN;
[Nx,Ny,Nz] = size(volume_recon);
cmap = jet(32);
PATCH_3Darray(volume_recon,1:Nx,1:Ny,1:Nz,cmap,'col');
% rotate3d on;



plot3slices(hObject, handles);
guidata(hObject, handles);

% UIWAIT makes volumesCompare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = volumesCompare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function [sp1,sp2,sp3] = plot3slices(hObject, handles)
% pointer3d     3D coordinates in volume matrix (integers)

handles.pointer3dt;
% size(handles.volume);
value3dt = handles.volume_real(handles.pointer3dt(1), handles.pointer3dt(2), handles.pointer3dt(3));

text_str = [{['X:' int2str(handles.pointer3dt(3))]},...
            {['Y:' int2str(handles.pointer3dt(2))]},...
            {['Z:' int2str(handles.pointer3dt(1))]},...
            {['Value:' num2str(value3dt)]}];
% set(handles.pointer3d_info, 'String', text_str,'FontSize',10);


sliceXY_real = squeeze(handles.volume_real(:,:,handles.pointer3dt(3),:));
sliceYZ = squeeze(handles.volume_real(handles.pointer3dt(1),:,:,:));
sliceXZ_real = squeeze(handles.volume_real(:,handles.pointer3dt(2),:,:));

max_xyz = max([ max(sliceXY_real(:)) max(sliceYZ(:)) max(sliceXZ_real(:)) ]);
min_xyz = min([ min(sliceXY_real(:)) min(sliceYZ(:)) min(sliceXZ_real(:)) ]);
clims = [ min_xyz max_xyz ];
sliceYZ_real = squeeze(permute(sliceYZ, [2 1 3]));

axes(handles.XY_slice_real);
%colorbar;
imagesc(sliceXY_real);
title('Slice XY');
ylabel('Y');xlabel('X');
line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume_real,1)]);
line([0 size(handles.volume_real,2)], [handles.pointer3dt(1) handles.pointer3dt(1)]);
% set(allchild(gca),'ButtonDownFcn',@XY_slice_real_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','volumesCompare(''XY_slice_real_ButtonDownFcn'',gca,[],guidata(gcbo))');
set(allchild(gca),'Clipping','on');
set(gca,'HandleVisibility','Off')

axes(handles.XZ_slice_real);
imagesc(sliceXZ_real);
title('Slice XZ');
ylabel('Z');xlabel('X');
line([handles.pointer3dt(3) handles.pointer3dt(3)], [0 size(handles.volume_real,1)]);
line([0 size(handles.volume_real,3)], [handles.pointer3dt(1) handles.pointer3dt(1)]);
%set(allchild(gca),'ButtonDownFcn',@Subplot2_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','volumesCompare(''XZ_slice_real_ButtonDownFcn'',gca,[],guidata(gcbo))');

axes(handles.YZ_slice_real);
imagesc(sliceYZ_real);
title('Slice YZ');
ylabel('Z');xlabel('Y');
line([0 size(handles.volume_real,2)], [handles.pointer3dt(3) handles.pointer3dt(3)]);
line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume_real,3)]);
%set(allchild(gca),'ButtonDownFcn',@Subplot3_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','volumesCompare(''YZ_slice_real_ButtonDownFcn'',gca,[],guidata(gcbo))');

sliceXY_recon = squeeze(handles.volume_recon(:,:,handles.pointer3dt(3),:));
sliceYZ = squeeze(handles.volume_recon(handles.pointer3dt(1),:,:,:));
sliceXZ_recon = squeeze(handles.volume_recon(:,handles.pointer3dt(2),:,:));

max_xyz = max([ max(sliceXY_real(:)) max(sliceYZ(:)) max(sliceXZ_real(:)) ]);
min_xyz = min([ min(sliceXY_real(:)) min(sliceYZ(:)) min(sliceXZ_real(:)) ]);
clims = [ min_xyz max_xyz ];
sliceYZ_recon = squeeze(permute(sliceYZ, [2 1 3]));

axes(handles.XY_slice_recon);
%colorbar;
imagesc(sliceXY_recon);
title('Slice XY');
ylabel('Y');xlabel('X');
line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume_recon,1)]);
line([0 size(handles.volume_recon,2)], [handles.pointer3dt(1) handles.pointer3dt(1)]);
% set(allchild(gca),'ButtonDownFcn',@XY_slice_real_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','volumesCompare(''XY_slice_real_ButtonDownFcn'',gca,[],guidata(gcbo))');

axes(handles.XZ_slice_recon);
imagesc(sliceXZ_recon);
title('Slice XZ');
ylabel('Z');xlabel('X');
line([handles.pointer3dt(3) handles.pointer3dt(3)], [0 size(handles.volume_recon,1)]);
line([0 size(handles.volume_recon,3)], [handles.pointer3dt(1) handles.pointer3dt(1)]);
%set(allchild(gca),'ButtonDownFcn',@Subplot2_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','volumesCompare(''XZ_slice_real_ButtonDownFcn'',gca,[],guidata(gcbo))');

axes(handles.YZ_slice_recon);
imagesc(sliceYZ_recon);
title('Slice YZ');
ylabel('Z');xlabel('Y');
line([0 size(handles.volume_recon,2)], [handles.pointer3dt(3) handles.pointer3dt(3)]);
line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume_recon,3)]);
%set(allchild(gca),'ButtonDownFcn',@Subplot3_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','volumesCompare(''YZ_slice_real_ButtonDownFcn'',gca,[],guidata(gcbo))');

axes(handles.XY_slices)
cla
mm_real = max(max(sliceXY_real));
mm_recon = max(max(sliceXY_recon));
plot(sliceXY_real(handles.pointer3dt(1),:)/mm_real,'b-');hold on
plot(sliceXY_recon(handles.pointer3dt(1),:)/mm_recon,'b--')
plot(sliceXY_real(:,handles.pointer3dt(2))/mm_real,'r-')
plot(sliceXY_recon(:,handles.pointer3dt(2))/mm_recon,'r--')

axes(handles.XZ_slices)
cla
mm_real = max(max(sliceXZ_real));
mm_recon = max(max(sliceXZ_recon));
plot(sliceXZ_real(handles.pointer3dt(1),:)/mm_real,'b-');hold on
plot(sliceXZ_recon(handles.pointer3dt(1),:)/mm_recon,'b--')
plot(sliceXZ_real(:,handles.pointer3dt(3))/mm_real,'r-')
plot(sliceXZ_recon(:,handles.pointer3dt(3))/mm_recon,'r--')

axes(handles.YZ_slices)
cla
mm_real = max(max(sliceYZ_real));
mm_recon = max(max(sliceYZ_recon));
plot(sliceYZ_real(handles.pointer3dt(2),:)/mm_real,'b-');hold on
plot(sliceYZ_recon(handles.pointer3dt(2),:)/mm_recon,'b--')
plot(sliceYZ_real(:,handles.pointer3dt(3))/mm_real,'r-')
plot(sliceYZ_recon(:,handles.pointer3dt(3))/mm_recon,'r--')





guidata(hObject, handles);



function pointer3d_out = clipointer3d(pointer3d_in,vol_size)
pointer3d_out = pointer3d_in;
for p_id=1:3
    if (pointer3d_in(p_id) > vol_size(p_id))
        pointer3d_out(p_id) = vol_size(p_id);
    end;
    if (pointer3d_in(p_id) < 1)
        pointer3d_out(p_id) = 1;
    end;
end;


% --- Executes on mouse press over axes background.
function XY_slice_real_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to XY_slice_real (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt=get(gca,'currentpoint');
xpos=round(pt(1,2)); ypos=round(pt(1,1));
zpos = handles.pointer3dt(3);
handles.pointer3dt = [xpos ypos zpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 1;
% Update handles structure
guidata(hObject, handles);


% --- Executes on mouse press over axes background.
function XZ_slice_real_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to XZ_slice_real (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt=get(gca,'currentpoint');
xpos=round(pt(1,2)); zpos=round(pt(1,1));
ypos = handles.pointer3dt(2);
handles.pointer3dt = [xpos ypos zpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 2;
% Update handles structure
guidata(hObject, handles);


% --- Executes on mouse press over axes background.
function YZ_slice_real_ButtonDownFcn(hObject, eventdata, handles)
pt=get(gca,'currentpoint');
zpos=round(pt(1,2)); ypos=round(pt(1,1));
xpos = handles.pointer3dt(1);
disp([xpos ypos zpos])
handles.pointer3dt = [xpos ypos zpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 3;
% Update handles structure
guidata(hObject, handles);