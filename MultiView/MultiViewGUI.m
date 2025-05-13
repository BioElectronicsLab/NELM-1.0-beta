function varargout = MultiViewGUI(varargin)
% MULTIVIEWGUI MATLAB code for MultiViewGUI.fig
%      MULTIVIEWGUI, by itself, creates a new MULTIVIEWGUI or raises the existing
%      singleton*.
%
%      H = MULTIVIEWGUI returns the handle to a new MULTIVIEWGUI or the handle to
%      the existing singleton*.
%
%      MULTIVIEWGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIVIEWGUI.M with the given input arguments.
%
%      MULTIVIEWGUI('Property','Value',...) creates a new MULTIVIEWGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MultiViewGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MultiViewGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MultiViewGUI

% Last Modified by GUIDE v2.5 09-Jan-2024 07:41:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MultiViewGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MultiViewGUI_OutputFcn, ...
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


     
            
% --- Executes just before MultiViewGUI is made visible.
function MultiViewGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MultiViewGUI (see VARARGIN)

% Choose default command line output for MultiViewGUI
handles.output = hObject;
handles.IsDataLoaded=false;
handles.IsRawLoaded=false;
handles.IsCNLSLoaded=false;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MultiViewGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MultiViewGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Ok!');


% --------------------------------------------------------------------
function OpenData_Callback(hObject, eventdata, handles)
% hObject    handle to OpenData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.name = uigetdir('F:\TeleMed A\',...                
     'Ok, which data we want to see?'); 
if handles.name~=0
 handles.TotalFilesNum=length(dir([handles.name '\*.i!']));
 handles.Exp_Num_Static.String=['from ' num2str(floor(handles.TotalFilesNum/handles.Ch_Num_Pop.Value))];
 handles.exp_num=1;
 handles.IsDataLoaded=true;
 guidata(hObject, handles);
 GUI_Plot_Raw(handles);
end; 

% --- Executes on slider movement.
function ExpNumSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ExpNumSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
% handles.exp_num=round(handles.ExpNumSlider.Value);
% guidata(hObject, handles);                                               
% GUI_Plot_Raw(handles);
handles.ExpNumSlider.Max=100;
handles.ExpNumSlider.SliderStep(1)=1;
handles.ExpNumSlider.SliderStep(2)=0.5;
disp(num2str(handles.ExpNumSlider.Value));
function ExpNumSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExpNumSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(handles.my_message);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.my_message='Hi!';
guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Y, Time, f, W, V_os] = Get_FFT_Spectrum( handles.name, 1,...
                                                10, 2,40e3, 1e6 );
plot(Y);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% subplot(1,2,1);
% plot(1:10);
% subplot(1,2,2);
% plot(1:3:10);
disp(My_Func('ok!'));
% --- Executes on selection change in MultiWinPop.
function MultiWinPop_Callback(hObject, eventdata, handles)
% hObject    handle to MultiWinPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MultiWinPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MultiWinPop
GUI_Plot_Raw(handles);

% --- Executes during object creation, after setting all properties.
function MultiWinPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MultiWinPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ImmittanceTypePop.
function ImmittanceTypePop_Callback(hObject, eventdata, handles)
% hObject    handle to ImmittanceTypePop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImmittanceTypePop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImmittanceTypePop
handles.HoldAxisButton.Value=0;
GUI_Plot_Raw(handles);
% --- Executes during object creation, after setting all properties.
function ImmittanceTypePop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImmittanceTypePop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ImmittancePlotTypePop.
function ImmittancePlotTypePop_Callback(hObject, eventdata, handles)
% hObject    handle to ImmittancePlotTypePop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImmittancePlotTypePop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImmittancePlotTypePop
handles.HoldAxisButton.Value=0;
GUI_Plot_Raw(handles);

% --- Executes during object creation, after setting all properties.
function ImmittancePlotTypePop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImmittancePlotTypePop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Af_or_FFT.
function Af_or_FFT_Callback(hObject, eventdata, handles)
% hObject    handle to Af_or_FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Af_or_FFT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Af_or_FFT
handles.HoldAxisButton.Value=0;
GUI_Plot_Raw(handles);
function [out]=My_Func(inp)
out=inp;


function GUI_Plot_Raw(h)
if ~h.IsDataLoaded
    return;
end;
subplot(1,1,1);
switch h.Af_or_FFT.Value
case 1
 Get_Spectrum_Func=@Get_Spectrum_ascii;  
case 2
 Get_Spectrum_Func=@Get_FFT_Spectrum;   
otherwise
end;

% switch h.MultiWinPop.Value
% case 1
%  Ch_Num=1;
%  MultiWin=0;
% case 2
%  Ch_Num=2;
%  MultiWin=1;   
% case 3
%  Ch_Num=2;
%  MultiWin=0;   
% otherwise
% end;

Ch_Num=h.Ch_Num_Pop.Value;
MultiWin= mod(h.WindowTypeChkBox.Value+1, 2);
switch h.ImmittancePlotTypePop.Value
case 1
 Plot_Type='Locus';
case 2
 Plot_Type='Bode';  
case 3
 Plot_Type='ReIm'; 
otherwise
end;

switch h.ImmittanceTypePop.Value
case 1
 IsZ=0;
case 2
 IsZ=1;
otherwise
end;
R0=str2num(h.NormalizeEdit.String);
%exp_num=floor(h.exp_num/Ch_Num)+1;
overlap='off';
if h.IsRawLoaded
 Plot_Raw_Immittance(h.name, h.exp_num, Get_Spectrum_Func, R0,...
                                Plot_Type, IsZ, Ch_Num, MultiWin);
 overlap='on';                           
end;
if h.IsCNLSLoaded
 Plot_Model_Immittance(h.Channels, h.exp_num,...
                                Plot_Type, IsZ, Ch_Num, MultiWin,overlap);                                 
end;
 Ch_Num=h.Ch_Num_Pop.Value;

 if h.ImmittancePlotTypePop.Value==1    
 Rows_Num=1;                                                                
 else                                                                       
  Rows_Num=2;                                    
 end;
 if h.WindowTypeChkBox.Value==0
  Columns_Num=Ch_Num;
 else
  Columns_Num=1;   
 end;
 for j=1:Rows_Num*Columns_Num
  subplot(Rows_Num, Columns_Num, j);
  grid on;
  if h.HoldAxisButton.Value==1
   axis(h.axis(j,:));
  end; 
 end;
%  if h.HoldAxisButton.Value==1
%   
%    for j=1:Ch_Num
%     subplot(1, Ch_Num, j); 
%     axis(h.axis(j,:));
%    end;
%   else
%    for j=1:2*Ch_Num
%     subplot(2, Ch_Num, j); 
%     axis(h.axis(j,:));
%    end; 
%  end;
% end;
% 
%   if h.ImmittancePlotTypePop.Value==1   
%    for j=1:Ch_Num
%     subplot(1, Ch_Num, j); 
%     grid on;
%    end;
%   else
%    for j=1:2*Ch_Num
%     subplot(2, Ch_Num, j); 
%     grid on;
%    end; 
 %end;

function Af_or_FFT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Af_or_FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');


 
end


% --- Executes on button press in WindowTypeChkBox.
function WindowTypeChkBox_Callback(hObject, eventdata, handles)
% hObject    handle to WindowTypeChkBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WindowTypeChkBox
handles.HoldAxisButton.Value=0;
GUI_Plot_Raw(handles);
% --- Executes on selection change in Ch_Num_Pop.
function Ch_Num_Pop_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_Num_Pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Ch_Num_Pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Ch_Num_Pop
% handles.ExpNumSlider.Max=round(handles.TotalFilesNum/handles.Ch_Num_Pop.Value);
% handles.ExpNumSlider.SliderStep(1)=1/(handles.TotalFilesNum/handles.Ch_Num_Pop.Value);
handles.exp_num=handles.Ch_Num_Pop.Value*floor(handles.exp_num/handles.Ch_Num_Pop.Value);
% if handles.exp_num==0
%     handles.exp_num=1;
% end;
handles.HoldAxisButton.Value=0;
GUI_Plot_Raw(handles);
% --- Executes during object creation, after setting all properties.
function Ch_Num_Pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_Num_Pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Exp_Num_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Exp_Num_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Exp_Num_Edit as text
%        str2double(get(hObject,'String')) returns contents of Exp_Num_Edit as a double
try 
Change_exp_num=str2num(handles.Exp_Num_Edit.String);
if handles.IsDataLoaded
 if Change_exp_num<=handles.TotalFilesNum && Change_exp_num>1
  handles.exp_num=Change_exp_num;
  guidata(hObject, handles); 
  handles.Exp_Num_Edit.String=num2str(handles.exp_num);
  GUI_Plot_Raw(handles);
 else
  hadles.Exp_Num_Edit.String=num2str(handles.exp_num);   
 end;
end;
catch
 hadles.Exp_Num_Edit.String=num2str(handles.exp_num);      
end;
% --- Executes during object creation, after setting all properties.
function Exp_Num_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Exp_Num_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.IsDataLoaded
 if (handles.exp_num-handles.Ch_Num_Pop.Value )>=1
  handles.exp_num=handles.exp_num-handles.Ch_Num_Pop.Value;
  guidata(hObject, handles);  
  handles.Exp_Num_Edit.String=num2str(handles.exp_num);
  GUI_Plot_Raw(handles);
 end;
end;
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.IsDataLoaded
 if (handles.exp_num+handles.Ch_Num_Pop.Value )<=handles.TotalFilesNum
  handles.exp_num=handles.exp_num+handles.Ch_Num_Pop.Value;
  guidata(hObject, handles); 
  handles.Exp_Num_Edit.String=num2str(handles.exp_num);
  GUI_Plot_Raw(handles);
 end;
end;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.name = uigetdir('F:\TeleMed A\',...              
     'Ok, which data we want to see?'); 
if handles.name~=0
 handles.TotalFilesNum=length(dir([handles.name '\*.i!']));
 handles.Exp_Num_Static.String=['of ' num2str(floor(handles.TotalFilesNum/handles.Ch_Num_Pop.Value))];
 handles.exp_num=1;
 handles.IsDataLoaded=true;
 handles.IsRawLoaded=true;
 guidata(hObject, handles);
 GUI_Plot_Raw(handles);
end; 


function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[CNLS_name path] = uigetfile('F:\TeleMed A\',...                
     'Ok, which data we want to see?');

if CNLS_name~=0
 load([path '\' CNLS_name]);
 if ~exist('name')                                                         %For older versions compatibility
     name=path;
 end;
 handles.name=name;
 Sync_CNLS_and_Data_Finished=false;
 while ~Sync_CNLS_and_Data_Finished
     if length(dir([handles.name '\*.i!']))~=0
         handles.IsRawLoaded=true;
         Sync_CNLS_and_Data_Finished=true;
     else
         answer = questdlg(['I can''t founded raw data files at directory ' name '.Do you want to set directory with raw data manually?'] , ...
             'Hmmm...', ...
             'Yes','No','No');
         if strcmp(answer, 'Yes')==1
             handles.name = uigetdir('F:\TeleMed A\',...                
                 'Show me the directory with data, please');
             if handles.name==0
                 warning('Ok... ok... You can load raw data later by pressing ^ button...');
                 hadnles.IsRawLoaded=false;
                 Sync_CNLS_and_Data_Finished=true;
             end;
         else
             warning('Ok... ok... You can load raw data later by pressing ^ button...');
             handles.IsRawLoaded=false;
             Sync_CNLS_and_Data_Finished=true;
         end;
     end;
 end;
 if handles.IsRawLoaded
  handles.TotalFilesNum=length(dir([handles.name '\*.i!']));
  handles.Exp_Num_Static.String=['of ' num2str(floor(handles.TotalFilesNum/handles.Ch_Num_Pop.Value))];
  handles.exp_num=1;
 else
  handles.TotalFilesNum=length(Start:Finish);
  handles.Exp_Num_Static.String=['of ' num2str(floor(handles.TotalFilesNum/handles.Ch_Num_Pop.Value))];
  handles.exp_num=1;     
 end;
 
  handles.IsDataLoaded=true;
  handles.IsCNLSLoaded=true;
  handles.Channels=Channels;
 handles.NormalizeEdit.String=num2str(R0);
 
 
 guidata(hObject, handles);
 GUI_Plot_Raw(handles);
end; 


% --- Executes on button press in HoldAxisButton.
function HoldAxisButton_Callback(hObject, eventdata, handles)
% hObject    handle to HoldAxisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HoldAxisButton
 Ch_Num=handles.Ch_Num_Pop.Value;
 if handles.ImmittancePlotTypePop.Value==1                                       
  Rows_Num=1;                                                                
 else                                                                       
  Rows_Num=2;                                                               
 if handles.WindowTypeChkBox.Value==0
  Columns_Num=Ch_Num;
 else
  Columns_Num=1;   
 end;
 for j=1:Rows_Num*Columns_Num
  subplot(Rows_Num, Columns_Num, j);
  handles.axis(j,:)=axis;
 end;
guidata(hObject, handles);



function NormalizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NormalizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NormalizeEdit as text
%        str2double(get(hObject,'String')) returns contents of NormalizeEdit as a double


% --- Executes during object creation, after setting all properties.
function NormalizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NormalizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlayButton.
function PlayButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlayButton
 if handles.IsDataLoaded
  while (handles.exp_num+handles.Ch_Num_Pop.Value )<=handles.TotalFilesNum
   if ~handles.PlayButton.Value
   % handles.PlayButton.String=char(hex2dec('FB01'));%'?';   
    break;  
   else
  %  handles.PlayButton.String='??';         
   end;
   handles.exp_num=handles.exp_num+handles.Ch_Num_Pop.Value;
   guidata(hObject, handles); 
   handles.Exp_Num_Edit.String=num2str(handles.exp_num);
   pause(0.0);
   GUI_Plot_Raw(handles);
   drawnow;
 end;
end;
