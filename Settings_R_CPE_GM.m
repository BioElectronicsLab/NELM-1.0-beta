%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is an example Setting for processing model RLC data with RL_CPE model %                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setting up the approximation process             %
% Here, the arrows that look like fish            %
%>---]}                                           %
% indicate lines that can be changed depending on %
% the matrix type, cell type, etc.                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Setting a description of the approximation parameters so as not to get confused later.
Settings_Description=['This is settings for the example RLC experiment'];
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
Is_Warming_Up=true;

if IsMatLab
    [~,N]=evalc('feature(''numcores'')');                                  % Setting the number of statistical tests, that is, the number of different starting points from which the approximation of each spectrum will begin
else
    N=12;
end;
N=1;
WUC=1;                                                                     % Setting how many times to increase the number of iterations during warming-up.
MaxIter=1000*3;
MaxFuncEvals=8000*3;
%>---]} Replacing the feedback resistance
R0=1e5;                                                                    %Setting the feedback resistance in Ohms, which is necessary for the correct calculation of the spectra, when time-domain impedance spectroscopy and Op-Amp ammeter are used.

options=optimset('fminsearch');                                            %Setting up the optimization process
options.TolFun=1e-318;                                                     %Setting Threshold of stoping optimization
options.TolX= 1e-318;
options.Display='off';                                                     %To reduce the load on the console, disable the output of notifications of the fminsearch routine
options.UseSingleN=false;
options.Homotopy_Steps=[0.33 0.66 1];
options.method = 'GM';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fill out essential data, if gradient methods are used %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options.NMGN_Display=false;
options.NMND_Display=false;
options.lambda_0=2;
options.causal=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options.rand_Amp=1;                                                        %Setting the strating point variation range for the Multistart Monte-Carlo calculations 
W_Type= 'unit';                                                            %Specify the data weighting method
options.eliminate_spectrum_outliers=0;                                     %Removing outliers from impidance data
options.export_to_ascii=true;                                              %For AF method of approximation, results are being exported into ascii
options.R0=R0;                                                             % Setting Op-Amp ammeter feed-back resistance if it was used for current response measurement.                                                             
options.Monte_Carlo_Mode='global';                                         %Chosing method for MC, can be 'global'-- using x0-space or local -- using the results of approximation of last measurement  

%Setting the frequency range
options.Frequency_Range.Freq_res=2;                                        %Setting the spectral resolution for time-domain impedance spectroscopy methods (i.e. the reciprosal data collecting time).
options.Frequency_Range.Freq_lim=40e3;                                     %Setting the upper limit frequency range for CNLS spectra processing.
options.Frequency_Range.S=round(20/options.Frequency_Range.Freq_res)+1;    %Setting the index (!) of the frequency, which corresponds to the lower limit of the spectrum frequency range used for CNLS. 
options.data_type='Y';                                                    %Setting the data type for processing ('Y' -- admittance, 'Z' -- impedance, 'abs_Y' -- magnitude of the admittance, 'abs_Z' -- magnitude of the impedance)
%Automatic batch initialization of Channels structure.
for j=1:Ch_Num
    Channels(j).Model=@M_R_CPE;                                            %Defining the basic model
    Channels(j).Model_Options.fix_pars=[];                             %Setting the parameters, which will be freezed during approximation.
    Channels(j).Model_Options.pars_to_be_fixed=[];                        %Setting the parameters, which will be freezed during approximation after warming-up mode.
    Channels(j).x0_init=[0 0 0];                                 %Setting up the starting point
    Channels(j).x0_space_origin=Channels(j).x0_init;                       %Setting up the universal starting point for the global Monte-Carlo mode.
    Info= Channels(j).Model( Channels(j).Model_Options);
    Channels(j).Model_Options.non_negative_pars=Info.non_negative_pars;%Obtaining indices of non-negative parameters of the main model.
end;
Picture=func2str(Channels(1).Model);
Time_Mode='exp_num_eq';                                                    %Setting the time display type: 'exp_num' -- display of the experiment number along the time axis, 'seconds' -- display of time in seconds, 'minutes' -- in minutes