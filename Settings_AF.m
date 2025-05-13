 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is an example Setting for AF data filtering %                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setting up the approximation process             %
% Here, the arrows that look like fish            %
%>---]}                                           %
% indicate lines that can be changed depending on %
% the matrix type, cell type, etc.                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Setting a description of the approximation parameters so as not to get confused later
Settings_Description=['Adaptive filtering model'];
%Allowing the user to change  some of the settings.
SettingsTweaks.Can_Change_Ch_Num=true;
%>---]} Set the number of channels.
Ch_Num=1;
%Changing the settings if necessary after restarting the script from the GUI window
if isfield(SettingsTweaks,'Change_Ch_Num_to')
    Ch_Num=SettingsTweaks.Change_Ch_Num_to;
end;
%>---]} Selecting the measurement range for processing (this parameter can be changed in the GUI).
Start_From=0*Ch_Num+1;
Finish_At=10*Ch_Num+1;
%---->>>> Turn on/off the warming-up mode
Is_Warming_Up=false;

N=12;                                  
WAC=3;                                                                     %Setting how many times to increase the number of iterations during warming-up.
MaxIter=1000;
MaxFuncEvals=8000;
%>---]} Replacing the feedback resistance
R0=1e5*1.064;                                                               %Setting the feedback resistance in Ohms, which is necessary for the correct calculation of the spectra, when time-domain impedance spectroscopy and Op-Amp ammeter are used

options=optimset('fminsearch');                                            %Setting up the optimization process
options.TolFun=1e-318;                                                     %Setting Threshold of stoping optimization
options.TolX= 1e-318;
options.Display='off';                                                     %To reduce the load on the console, disable the output of notifications of the fminsearch routine
options.UseSingleN=false;
options.method = 'AF';
options.lambda_0=2;
W_Type= 'unit';                                                            %Specify the data weighting method
options.export_to_ascii=true;                                              %If true, filtreted data will be exported into ascii format automatically
options.eliminate_spectrum_outliers=0;
%Setting the frequency range
options.Frequency_Range.Freq_res=2;
options.Frequency_Range.Freq_lim=40e3;
options.Frequency_Range.S=round(10/options.Frequency_Range.Freq_res)+1;
options.R0=R0;
%Automatic batch initialization of Channels structure.
for j=1:Ch_Num
    Channels(j).Model_Options.Suppress_Diag=false;
    Channels(j).Model_Options.R0=R0;                                       %Setting the feedback resistance in options         
    Channels(j).Model_Options.fix_pars=[]; 
    Channels(j).Model_Options.Causal=true;      
    Channels(j).Model_Options.FIR_mode=false; 
    Channels(j).Model_Options.ell_n= 50;
    Channels(j).Model_Options.ell_d= 50;
    Channels(j).Model_Options.zero_fix= false;    
    Channels(j).Model_Options.f0=500e3;
    Channels(j).Model_Options.exact_Gram_Calc=true;
    Channels(j).Model=@M_AF;                                           % Setting the main model
    %Immittance compression method options(experimental)%%%%%%%%%%%%%%%%%%%
    Channels(j).Model_Options.Compression.On=false;
    Channels(j).Model_Options.Compression.A=1;
    Channels(j).Model_Options.Compression.B=20;
    Channels(j).x0_init=[6.2572e+12];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Info= Channels(j).Model( Channels(j).Model_Options);
    Channels(j).Model_Options.non_negative_pars=Info.non_negative_pars;    %Obtaining indices of non-negative parameters of the main model.
end;

Time_Mode='exp_num_eq';                                                    %Setting the time display type: 'exp_num' -- display of the experiment number along the time axis, 'seconds' -- display of time in seconds, 'minutes' -- in minutes
Picture='M_AF';


