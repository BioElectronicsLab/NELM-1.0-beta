function [Y, Time, f, W, V_os] = Get_FFT_Spectrum( name, exp_num,...
                                                S, Freq_res,Freq_lim, R0 )
[Par data]=I2txt(strcat(name,'\data', int2str(exp_num-1),'.i!'),250000,true);

Time=(Par.tic)/1000;
%t=data(:,1);                                                             
x1=-data(:,2)/R0;                                                           
x2=data(:,3);                                                             
v=data(:,5)*50/(5e3+50);                                                   
V_os(exp_num)=mean(x2)*3/8000;                                             

Fx1=fft(x1);                                                             

Fv=fft(v); 
f=Freq_res*S:Freq_res:Freq_lim;                                            
Y=Fx1(S:(Freq_lim/Freq_res))./Fv(S:(Freq_lim/Freq_res));                   
W=abs(Fv(S:(Freq_lim/Freq_res)));                                          
 

end

