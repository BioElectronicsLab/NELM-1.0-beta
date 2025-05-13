function [Y, Time, f, W, V_os] = Get_FFT_Spectrum_from_wav(name, exp_num, options)
%This function extracts data from .i! file
Freq_res=options.Frequency_Range.Freq_res; %Getting frequency resolution from Settings
Freq_lim=options.Frequency_Range.Freq_lim; %Getting frequency limit from Settings
S=options.Frequency_Range.S; %Getting starting frequency number from Settings
R0=options.R0; 
if iscell(name)                                            
    data=audioread(char(name{exp_num}));           %Loading the data. The i!-file header will be written to the Par variable, the ADC output will be written to the data array, and each of the four columns on the right will correspond to a separate channel.
else
   data=audioread(name);
end;
Time=0;                                                       %Getting time
J=-data(:,2)/R0;                                                          %Getting data from the first channel, that is, the current response in ADC/Ohm codes
V=data(:,1)*50/(5e3+50);                                                   %Getting excitation voltage in the ADC codes
FJ=fft(J);                                                               %Calculating the Fourier transform of the input data
Fv=fft(V); 
f=Freq_res*S:Freq_res:Freq_lim;                                            %Constructing the frequency vector                                                           

Y=FJ(S:(Freq_lim/Freq_res))./Fv(S:(Freq_lim/Freq_res));                   %Calculating admittance
W=1;                                                                       %Setting the weight for the option w_type='unit'
V_os='Not avaliable';                                                      %Stating that disturbance voltage in the ADC codes is not available

end

