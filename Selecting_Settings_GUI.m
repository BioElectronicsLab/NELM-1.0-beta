function varargout = Selecting_Settings_GUI(varargin)
%This is a semi-automatic created m-file for GUI choosing settings.
%It has a lot of automatically generated comments.


% SELECTING_SETTINGS_GUI MATLAB code for Selecting_Settings_GUI.fig
%      SELECTING_SETTINGS_GUI, by itself, creates a new SELECTING_SETTINGS_GUI or raises the existing
%      singleton*.
%
%      H = SELECTING_SETTINGS_GUI returns the handle to a new SELECTING_SETTINGS_GUI or the handle to
%      the existing singleton*.
%
%      SELECTING_SETTINGS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTING_SETTINGS_GUI.M with the given input arguments.
%
%      SELECTING_SETTINGS_GUI('Property','Value',...) creates a new SELECTING_SETTINGS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Selecting_Settings_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Selecting_Settings_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Selecting_Settings_GUI

% Last Modified by GUIDE v2.5 18-Dec-2023 01:38:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Selecting_Settings_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Selecting_Settings_GUI_OutputFcn, ...
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


% --- Executes just before Selecting_Settings_GUI is made visible.
function Selecting_Settings_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Selecting_Settings_GUI (see VARARGIN)

% Choose default command line output for Selecting_Settings_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Selecting_Settings_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Selecting_Settings_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

Files=dir('Settings_*.m');
FilesBoxData = {};
for j=1:length(Files)
 FilesBoxData=[FilesBoxData, Files(j).name]   ;
end;
set(handles.FilesBox, 'String', FilesBoxData);
set(handles.FilesBox, 'Value', 1);
s=char(FilesBoxData(1));
run(s);
if exist('Settings_Description') 
 [wrappedtext,position] = textwrap(handles.My_Edit,{Settings_Description},32);
 Settings_Description;
 set(handles.My_Edit, 'String', wrappedtext);
else
  set(handles.My_Edit, 'String', 'No description found');   
end;
%s=s(length('Settings_')+1:end-2);
%func_name=func2str(Channels(end).Model);
if ~exist('Picture')
    Picture='No_Scheme';
end;
if length(dir(['Scheme Images\' Picture '.jpg']))~=0
    Im=imread(['Scheme Images\' Picture '.jpg']);
    imshow(Im);
else
 Im=imread(['Scheme Images\No_Scheme.jpg']);
 imshow(Im);
end;
% if exist('Get_Spectrum_Func, @Get_FFT_Spectrum')
%  set(handles.GetSpectrumFuncEdit,'Enable','on');     
%  if isequal(Get_Spectrum_Func, @Get_FFT_Spectrum)
%   set(handles.GetSpectrumFuncEdit,'Value',2);
%  elseif isequal(Get_Spectrum_Func, @Get_Spectrum_ascii)
%   set(handles.GetSpectrumFuncEdit,'Value',1);    
%  else
%   s=functions(Get_Spectrum_Func);
%   GetSpectrumFuncList=get(handles.GetSpectrumFuncEdit,'String');
%   GetSpectrumFuncList(end+1)=s.function;
%   set(handles.GetSpectrumFuncEdit,'Value',3);
%  end;
% else
%   set(handles.GetSpectrumFuncEdit,'Enable','off');    
%   set(handles.GetSpectrumFuncEdit,'Value',2);  
% end;
set(handles.ChNumEdit, 'String',num2str(Ch_Num));

set(handles.StartValueEdit, 'String',num2str((Start_From-1)/Ch_Num));
set(handles.FinishValueEdit, 'String',num2str((Finish_At-1)/Ch_Num));
if Is_Warming_Up
 set(handles.WACheckBox, 'Value',1);
else
 set(handles.WACheckBox, 'Value',0);    
end;
if exist('SettingsTweaks')
 if SettingsTweaks.Can_Change_Ch_Num
  set(handles.ChNumEdit,'Enable', 'on');
 else
  set(handles.ChNumEdit,'Enable', 'off');   
 end;
else
 set(handles.ChNumEdit,'Enable', 'off');    
end;

function My_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to My_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of My_Edit as text
%        str2double(get(hObject,'String')) returns contents of My_Edit as a double


% --- Executes during object creation, after setting all properties.
function My_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to My_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%
% Loading settings  %
%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FileNames=handles.FilesBox.String;
Value=handles.FilesBox.Value;
s=FileNames(Value);
SettingsTweaks.Change_Ch_Num_to=str2num(get(handles.ChNumEdit, 'String'));
run(char(s));
%Save Settings*.m' into Settings.mat as Lines variable
fid=fopen(char(s));
N_=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    N_=N_+1;
    Setting_file_body{N_}=[tline];
end
Setting_file_body=Setting_file_body';
fclose(fid);
clear N_;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Start_From=str2num(get(handles.StartValueEdit, 'String'))*Ch_Num+1;
Finish_At=str2num(get(handles.FinishValueEdit, 'String'))*Ch_Num+1;
if get(handles.WACheckBox,'Value')==1
 Is_Warming_Up=true;
else
 Is_Warming_Up=false;
end;
% switch get(handles.GetSpectrumFuncEdit,'Value')
%  case 2
%   Get_Spectrum_Func=@Get_FFT_Spectrum;
%  case 1  
%   Get_Spectrum_Func=@Get_Spectrum_ascii;     
%  otherwise
% end;
clear FileNames Value s eventdata hObject handles;
save('Settings.mat');
ok=true;
assignin('base','ok_', ok);
closereq(); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choosing the file with settings %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FilesBox_Callback(hObject, eventdata, handles)
% hObject    handle to FilesBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilesBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilesBox


% --- Executes during object creation, after setting all properties.
clc;
FilesBoxData = get(handles.FilesBox,'String');
s=char(FilesBoxData(eventdata.Source.Value));
run(s);
if exist('Settings_Description') 
 [wrappedtext,position] = textwrap(handles.My_Edit,{Settings_Description},32);
 Settings_Description;
 set(handles.My_Edit, 'String', wrappedtext);
else
  set(handles.My_Edit, 'String', 'No description found');   
end;
if ~exist('Picture')
    Picture='No_Scheme';
end;
if length(dir(['Scheme Images\' Picture '.jpg']))~=0
    Im=imread(['Scheme Images\' Picture '.jpg']);
    imshow(Im);
else
 Im=imread(['Scheme Images\No_Scheme.jpg']);
 imshow(Im);
end;
set(handles.ChNumEdit, 'String',num2str(Ch_Num));
set(handles.StartValueEdit, 'String',num2str((Start_From-1)/Ch_Num));
set(handles.FinishValueEdit, 'String',num2str((Finish_At-1)/Ch_Num));
if Is_Warming_Up
 set(handles.WACheckBox, 'Value',1);
else
 set(handles.WACheckBox, 'Value',0);    
end;
if exist('SettingsTweaks')
 if SettingsTweaks.Can_Change_Ch_Num
  set(handles.ChNumEdit,'Enable', 'on');
 else
  set(handles.ChNumEdit,'Enable', 'off');   
 end;
else
 set(handles.ChNumEdit,'Enable', 'off');    
end;
% if exist('Get_Spectrum_Func')
%  set(handles.GetSpectrumFuncEdit,'Enable','on');     
%  if isequal(Get_Spectrum_Func, @Get_FFT_Spectrum)
%   set(handles.GetSpectrumFuncEdit,'Value',2);
%  elseif isequal(Get_Spectrum_Func, @Get_Spectrum_ascii)
%   set(handles.GetSpectrumFuncEdit,'Value',1);    
%  else
%   s=functions(Get_Spectrum_Func);
%   GetSpectrumFuncList=get(handles.GetSpectrumFuncEdit,'String');
%   GetSpectrumFuncList(end+1)=s.function;
%   set(handles.GetSpectrumFuncEdit,'Value',3);
%  end;
% else
%   set(handles.GetSpectrumFuncEdit,'Enable','off');    
%   set(handles.GetSpectrumFuncEdit,'Value',2);  
% end;

function FilesBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilesBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq(); 


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%A=1;
%assignin('base','trig', A);
% Hint: delete(hObject) closes the figure
delete(hObject);



function ChNumEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ChNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChNumEdit as text
%        str2double(get(hObject,'String')) returns contents of ChNumEdit as a double


% --- Executes during object creation, after setting all properties.
function ChNumEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StartValueEdit_Callback(hObject, eventdata, handles)
% hObject    handle to StartValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartValueEdit as text
%        str2double(get(hObject,'String')) returns contents of StartValueEdit as a double


% --- Executes during object creation, after setting all properties.
function StartValueEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FinishValueEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FinishValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FinishValueEdit as text
%        str2double(get(hObject,'String')) returns contents of FinishValueEdit as a double


% --- Executes during object creation, after setting all properties.
function FinishValueEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FinishValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in WAButton.
function WAButton_Callback(hObject, eventdata, handles)
% hObject    handle to WAButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WAButton


% --- Executes on button press in WACheckBox.
function WACheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to WACheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WACheckBox


% --- Executes on selection change in GetSpectrumFuncEdit.
function GetSpectrumFuncEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GetSpectrumFuncEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns GetSpectrumFuncEdit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GetSpectrumFuncEdit


% --- Executes during object creation, after setting all properties.
function GetSpectrumFuncEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GetSpectrumFuncEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
