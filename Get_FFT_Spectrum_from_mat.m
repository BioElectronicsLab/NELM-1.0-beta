function [Y, Time, f, W, V_os] = Get_FFT_Spectrum_from_mat( name, exp_num, options)
%Initialization
if ~isfield(options,'Compression')
 options.Compression.On=false;
end;
%Main code
if iscell(name)                                            
    name=char(name{exp_num});
end;
load(name);
ok=true;
Freq_res=options.Frequency_Range.Freq_res; %Getting frequency resolution from Settings
Freq_lim=options.Frequency_Range.Freq_lim; %Getting frequency limit from Settings
S=options.Frequency_Range.S; %Getting starting frequency number from Settings
R0=options.R0; 
missing='';
if ~exist('Time')
    missing=[missing ' Time,'];
    ok=false;
end;
if ~exist('J')
    missing=[missing ' Y,'];
    ok=false;
end;
if ~exist('V')
    missing=[missing ' f,'];
    ok=false;
end;
if ~exist('E')
    missing=[missing ' E,'];
    ok=false;
end;
if ~exist('f0')
    missing=[missing ' W,'];
    ok=false;
end;
if ~exist('V_os')
    missing=[missing ' V_os,'];
    ok=false;
end;
if ~ok
    error(['Hm... it seems you load bad mat-file' name...
        '. I can''t find variables '  missing 'in it =(']);
end;
                                                      %Getting time
J=-J/R0;                                                          %Getting data from the first channel, that is, the current response in ADC/Ohm codes                                                              %Getting data from  the second channel, that is, the external offset in the ADC codes
V=V*50/(5e3+50);                                                   %Getting excitation voltage in the ADC codes
V_os=mean(V_os)*3/8000;                                                      %Finding the average value of the voltage offset (usually not used in experiments with cells)
FJ=fft(J);                                                               %Calculating the Fourier transform of the input data
Fv=fft(V); 
f=Freq_res*S:Freq_res:Freq_lim;                                            %Constructing the frequency vector                                                           

Y=FJ(S:(Freq_lim/Freq_res))./Fv(S:(Freq_lim/Freq_res));                   %Calculating admittance
W=abs(Fv(S:(Freq_lim/Freq_res)));                                          %Calculating the square of the modulus of the Fourier transform of the excitation voltage, that is, the weight for the option w_type='Voltage'

if options.Compression.On                                                  %Use immittance compression approach (experimental) 
 A=options.Compression.A;
 B=options.Compression.B;
 Y=A*Y./(1-B*Y);
end;
end



