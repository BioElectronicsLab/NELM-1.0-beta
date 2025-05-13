function [Y, Time, f, W, V_os] = Get_FFT_Spectrum(name, exp_num, options)
%This function extracts data from .i! file
Freq_res=options.Frequency_Range.Freq_res; %Getting frequency resolution from Settings
Freq_lim=options.Frequency_Range.Freq_lim; %Getting frequency limit from Settings
S=options.Frequency_Range.S; %Getting starting frequency number from Settings
R0=options.R0; 
if iscell(name)                                            
    [Par, data]=I2txt(char(name{exp_num}),250000,true, exp_num);           %Loading the data. The i!-file header will be written to the Par variable, the ADC output will be written to the data array, and each of the four columns on the right will correspond to a separate channel.
else
    [Par, data]=I2txt(name,250000,true, exp_num);
end;
Time=(Par.tic)/1000;                                                       %Getting time
J=-data(:,2)/R0;                                                          %Getting data from the first channel, that is, the current response in ADC/Ohm codes
x2=data(:,3);                                                              %Getting data from  the second channel, that is, the external offset in the ADC codes
V=data(:,5)*50/(5e3+50);                                                   %Getting excitation voltage in the ADC codes
V_os=mean(x2)*3/8000;                                                      %Finding the average value of the voltage offset (usually not used in experiments with cells)
FJ=fft(J);                                                               %Calculating the Fourier transform of the input data
FV=fft(V); 
f=Freq_res*S:Freq_res:Freq_lim;                                            %Constructing the frequency vector                                                           

Y=FJ(S:(Freq_lim/Freq_res))./FV(S:(Freq_lim/Freq_res));                   %Calculating admittance
W=abs(FV(S:(Freq_lim/Freq_res)));                                          %Calculating the square of the modulus of the Fourier transform of the excitation voltage, that is, the weight for the option w_type='Voltage'

end

