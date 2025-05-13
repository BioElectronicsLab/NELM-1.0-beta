function [J,V, Time, f0, V_os,E]  = I2mat(file_name, misc)
%This is the function, that parsing our home-made format i! into the
%MatLab's variables. 
exp_num=misc;
[Par data]=I2txt(file_name,250000,false,exp_num);
f0=Par.freq*1e3;                                                           %Very important variable for adaptive filtering
Time=(Par.tic)/1000;                                                       %Time is also stored in our i!-file 
%We have used L-Crad E20-10 ADC (L-Card, Russia), which
%has four channels. Thus, we typically record not only 
V=data(:,4); % excitation voltage and
J=data(:,1); % current response
%but also
V_os=data(:,2); % offset voltage
E=data(:,3);    % External noise 

end