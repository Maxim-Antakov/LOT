function varargout = mainGUI(varargin)
% MAINGUI MATLAB code for mainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainGUI

% Last Modified by GUIDE v2.5 15-Jul-2012 16:27:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mainGUI_OutputFcn, ...
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

global CA LO SO PST_list


% --- Executes just before mainGUI is made visible.
function mainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
global CA LO SO PST_list
load d_dkt.mat
PST_list = dkt;
size(PST_list)
set(handles.tgl1D,'Value',0);
set(handles.tgl2D,'Value',1)
set(handles.tgl1D,'BackgroundColor',[0.8 0.8 0.8]);
set(handles.tgl2D,'BackgroundColor',[0.3 0.3 0.3]);
set(handles.pan1D, 'Visible','off');
set(handles.pan2D, 'Visible','on');

CA.M = str2double(get(handles.ed_M, 'String'));
CA.N = str2double(get(handles.ed_N, 'String'));
strs = get(handles.ed_Type, 'String');
CA.PSTT = strs{get(handles.ed_Type, 'Value')};
switch CA.PSTT
    case 'P'
        tt = -11;
    case 'D'
        tt = -14;
    case 'S'
        tt = -10;
end
handles.PossiblePST = getPossibleCA(CA.M, CA.N, tt);
if isempty(handles.PossiblePST)
    set(handles.list_Possible_CA,'Value',1);
    set(handles.list_Possible_CA,'String','No such CA');
else
    set(handles.list_Possible_CA,'Value',1);
    set(handles.list_Possible_CA,'String',{handles.PossiblePST.str});
end
CA.VKLR = handles.PossiblePST(1).vklr;
CA.VKLR2= handles.PossiblePST(1).vklr2;

% Choose default command line output for mainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tgl2D.
function tgl2D_Callback(hObject, eventdata, handles)
set(handles.tgl1D,'Value',0);
set(handles.tgl2D,'Value',1)
set(handles.tgl1D,'BackgroundColor',[0.8 0.8 0.8]);
set(handles.tgl2D,'BackgroundColor',[0.3 0.3 0.3]);
set(handles.pan1D, 'Visible','off');
set(handles.pan2D, 'Visible','on');

% --- Executes on button press in tgl1D.
function tgl1D_Callback(hObject, eventdata, handles)
set(handles.tgl1D,'Value',1);
set(handles.tgl2D,'Value',0);
set(handles.tgl1D,'BackgroundColor',[0.3 0.3 0.3]);
set(handles.tgl2D,'BackgroundColor',[0.8 0.8 0.8]);
set(handles.pan1D, 'Visible','on');
set(handles.pan2D, 'Visible','off');


function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_M_Callback(hObject, ~, handles)
global CA
CA.M = str2double(get(handles.ed_M, 'String'));
CA.N = str2double(get(handles.ed_N, 'String'));
strs = get(handles.ed_Type, 'String');
CA.PSTT = strs{get(handles.ed_Type, 'Value')};
switch CA.PSTT
    case 'P'
        tt = -11;
    case 'D'
        tt = -14;
    case 'S'
        tt = -10;
end
handles.PossiblePST = getPossibleCA(CA.M, CA.N, tt);
if isempty(handles.PossiblePST)
    set(handles.list_Possible_CA,'Value',1);
    set(handles.list_Possible_CA,'String','No such CA');
else
    set(handles.list_Possible_CA,'Value',1);
    set(handles.list_Possible_CA,'String',{handles.PossiblePST.str});
end
CA.VKLR = handles.PossiblePST(1).vklr;
CA.VKLR2= handles.PossiblePST(1).vklr2;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ed_M_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_N_Callback(hObject, ~, handles)
global CA
CA.M = str2double(get(handles.ed_M, 'String'));
CA.N = str2double(get(handles.ed_N, 'String'));
strs = get(handles.ed_Type, 'String');
CA.PSTT = strs{get(handles.ed_Type, 'Value')};
switch CA.PSTT
    case 'P'
        tt = -11;
    case 'D'
        tt = -14;
    case 'S'
        tt = -10;
end
handles.PossiblePST = getPossibleCA(CA.M, CA.N, tt);
if isempty(handles.PossiblePST)
    set(handles.list_Possible_CA,'Value',1);
    set(handles.list_Possible_CA,'String','No such CA');
else
    set(handles.list_Possible_CA,'Value',1);
    set(handles.list_Possible_CA,'String',{handles.PossiblePST.str});
end
CA.VKLR = handles.PossiblePST(1).vklr;
CA.VKLR2= handles.PossiblePST(1).vklr2;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ed_N_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in unnn.
function ed_Type_Callback(hObject, eventdata, handles)
global CA
CA.M = str2double(get(handles.ed_M, 'String'));
CA.N = str2double(get(handles.ed_N, 'String'));
strs = get(handles.ed_Type, 'String');
CA.PSTT = strs{get(handles.ed_Type, 'Value')};
switch CA.PSTT
    case 'P'
        tt = -11;
    case 'D'
        tt = -14;
    case 'S'
        tt = -10;
end
handles.PossiblePST = getPossibleCA(CA.M, CA.N, tt);
if isempty(handles.PossiblePST)
    set(handles.list_Possible_CA,'Value',1);
    set(handles.list_Possible_CA,'String','No such CA');
else
    set(handles.list_Possible_CA,'Value',1);
    set(handles.list_Possible_CA,'String',{handles.PossiblePST.str});
end
CA.VKLR = handles.PossiblePST(1).vklr;
CA.VKLR2= handles.PossiblePST(1).vklr2;

guidata(hObject, handles);


function ed_Type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function unnn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unnn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_Possible_CA.
function list_Possible_CA_Callback(hObject, ~, handles)
global CA 
n = get(hObject,'Value');
CA.VKLR = handles.PossiblePST(n).vklr;
CA.VKLR2= handles.PossiblePST(n).vklr2;


% --- Executes during object creation, after setting all properties.
function list_Possible_CA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_Possible_CA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_CA_ASX_Callback(hObject, eventdata, handles)
% hObject    handle to ed_CA_ASX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_CA_ASX as text
%        str2double(get(hObject,'String')) returns contents of ed_CA_ASX as a double


% --- Executes during object creation, after setting all properties.
function ed_CA_ASX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_CA_ASX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_CA_ASY_Callback(hObject, eventdata, handles)
% hObject    handle to ed_CA_ASY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_CA_ASY as text
%        str2double(get(hObject,'String')) returns contents of ed_CA_ASY as a double


% --- Executes during object creation, after setting all properties.
function ed_CA_ASY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_CA_ASY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_CA_DX_Callback(hObject, eventdata, handles)
% hObject    handle to ed_CA_DX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_CA_DX as text
%        str2double(get(hObject,'String')) returns contents of ed_CA_DX as a double


% --- Executes during object creation, after setting all properties.
function ed_CA_DX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_CA_DX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_CA_DY_Callback(hObject, eventdata, handles)
% hObject    handle to ed_CA_DY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_CA_DY as text
%        str2double(get(hObject,'String')) returns contents of ed_CA_DY as a double


% --- Executes during object creation, after setting all properties.
function ed_CA_DY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_CA_DY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_CA_DX0_Callback(hObject, eventdata, handles)
% hObject    handle to ed_CA_DX0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_CA_DX0 as text
%        str2double(get(hObject,'String')) returns contents of ed_CA_DX0 as a double


% --- Executes during object creation, after setting all properties.
function ed_CA_DX0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_CA_DX0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_CA_DY0_Callback(hObject, eventdata, handles)
% hObject    handle to ed_CA_DY0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_CA_DY0 as text
%        str2double(get(hObject,'String')) returns contents of ed_CA_DY0 as a double


% --- Executes during object creation, after setting all properties.
function ed_CA_DY0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_CA_DY0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function ed_CA_HL_Callback(hObject, eventdata, handles)
% hObject    handle to ed_CA_HL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_CA_HL as text
%        str2double(get(hObject,'String')) returns contents of ed_CA_HL as a double


% --- Executes during object creation, after setting all properties.
function ed_CA_HL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_CA_HL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_Create_CA.
function btn_Create_CA_Callback(~, ~, handles)
global CA
CA.ASX = str2double(get(handles.ed_CA_ASX,'String'));
CA.ASY = str2double(get(handles.ed_CA_ASY,'String'));
CA.DX = str2double(get(handles.ed_CA_DX,'String'));
CA.DY = str2double(get(handles.ed_CA_DY,'String'));
CA.DX0 = str2double(get(handles.ed_CA_DX0,'String'));
CA.DY0 = str2double(get(handles.ed_CA_DY0,'String'));
CA.HL = str2double(get(handles.ed_CA_HL,'String'));
createAperture;

function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_RASP_Callback(hObject, eventdata, handles)
% hObject    handle to ed_RASP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_RASP as text
%        str2double(get(hObject,'String')) returns contents of ed_RASP as a double


% --- Executes during object creation, after setting all properties.
function ed_RASP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_RASP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_select_LO.
function btn_select_LO_Callback(hObject, eventdata, handles)
global LO CA
LO.ID = get(handles.ed_LO_Type,'Value');
LO.NPL = str2double(get(handles.ed_NPL,'String'));
CA.RASP = str2double(get(handles.ed_RASP,'String'));
createSourceImage;


function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ed_LO_Type.
function ed_LO_Type_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function ed_LO_Type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_NPL_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function ed_NPL_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_Show_CA.
function btn_Show_CA_Callback(hObject, eventdata, handles)
createAperture;
showAperture(2,'Aperture');

% --- Executes on button press in btn_show_LO.
function btn_show_LO_Callback(hObject, eventdata, handles)
global LO CA
LO.ID = get(handles.ed_LO_Type,'Value');
LO.NPL = str2double(get(handles.ed_NPL,'String'));
CA.RASP = str2double(get(handles.ed_RASP,'String'));
createSourceImage;
SliceBrowser(LO.SD,'Luminophore concentration');


% --- Executes on selection change in ed_Act_Type.
function ed_Act_Type_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Act_Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ed_Act_Type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ed_Act_Type


% --- Executes during object creation, after setting all properties.
function ed_Act_Type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_Act_Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_I0_Callback(hObject, eventdata, handles)
% hObject    handle to ed_I0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_I0 as text
%        str2double(get(hObject,'String')) returns contents of ed_I0 as a double


% --- Executes during object creation, after setting all properties.
function ed_I0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_I0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_MU_Callback(hObject, eventdata, handles)
% hObject    handle to ed_MU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_MU as text
%        str2double(get(hObject,'String')) returns contents of ed_MU as a double


% --- Executes during object creation, after setting all properties.
function ed_MU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_MU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_beta_Callback(hObject, eventdata, handles)
% hObject    handle to ed_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_beta as text
%        str2double(get(hObject,'String')) returns contents of ed_beta as a double


% --- Executes during object creation, after setting all properties.
function ed_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_select_ALD.
function btn_select_ALD_Callback(hObject, eventdata, handles)
global SO
SO.I0 = str2double(get(handles.ed_I0,'String'));
SO.MU = str2double(get(handles.ed_MU,'String'));
SO.beta = str2double(get(handles.ed_beta,'String'));
SO.Act_Type = str2double(get(handles.ed_Act_Type,'String'));
activate;


% --- Executes on button press in btn_show_ALD.
function btn_show_ALD_Callback(hObject, eventdata, handles)
global SO
SO.I0 = str2double(get(handles.ed_I0,'String'));
SO.MU = str2double(get(handles.ed_MU,'String'));
SO.beta = str2double(get(handles.ed_beta,'String'));
SO.Act_Type = get(handles.ed_Act_Type,'Value');
activate;
SliceBrowser(SO.SD,'Luminophore activity');


% --- Executes on button press in btn_runCompensation.
function btn_runCompensation_Callback(hObject, eventdata, handles)
global RI
str = get(handles.ed_comp,'String');
compType = str{get(handles.ed_comp,'Value')};
CRI = compensate(RI,compType);
SliceBrowser(CRI, 'Luminophore activity reconstructed and compensated');

% --- Executes on button press in btn_run_simulation.
function btn_run_simulation_Callback(hObject, eventdata, handles)
global CA SO RI
global Kleshe
CA.JMU = 0;
Kleshe = createKleshe;
CA.JMU  = 1;

%TODO: make simulation of 1-D scheme
multiWaitbar('Z scan',0, 'Color', [0.6 0.2 0.2])
RI = zeros(SO.NPL,CA.N,CA.M);
for i = 1:SO.NPL
    multiWaitbar('Z scan',i/SO.NPL)
    multiWaitbar('Y scan',0, 'Color', [0.2 0.2 0.6])
    for m = 1:CA.M
        multiWaitbar('Y scan',m/CA.M);
        tempSO = zeros(size(squeeze(SO.SD(i,:,:))));
        tempSO((CA.RASP*(m-1)+1):CA.RASP*m,:) = SO.SD(i,(CA.RASP*(m-1)+1):CA.RASP*m,:);
        tempDET = getDetector2(tempSO,SO.Z(i));
        tempRI = restore(tempDET);
        RI(i,m,:) = tempRI(m,:);
    end
    multiWaitbar( 'Y scan', 'Close' )
end
multiWaitbar( 'Z scan', 'Close' )
SliceBrowser(RI, 'Luminophore activity reconstructed');


% --- Executes on selection change in ed_comp.
function ed_comp_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function ed_comp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_show_Result.
function btn_show_Result_Callback(hObject, eventdata, handles)
global RI
SliceBrowser(RI, 'Luminophore activity reconstructed');