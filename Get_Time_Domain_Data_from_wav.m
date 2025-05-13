function [J,V, Time, f0, V_os,E]  = Get_Time_Domain_Data_from_wav(name,Misc)
%This function for reading excitation voltage and current responce, which
%were recorded into wav file.
if iscell(name)
    [data, f0]=audioread(char(name{exp_num}));                             %Loading the wav file. Variable f0 is very essential!
else
    [data, f0]=audioread(name);
end;
Time=0;                                                                    %Getting time (Stub) 
E=0;                                                                       %Getting noise reference data (Stub)
J=data(:,2);                                                               %Getting data from the first channel, that is, the current response in ADC/Ohm codes
V=data(:,1);                                                               %Getting excitation voltage in the ADC codes
V_os='Not avaliable';
end

