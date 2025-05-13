function [Y, Time, f, W, V_os] = Get_Spectrum_ascii( name, exp_num,...
                                                S, Freq_res,Freq_lim, R0 )
[Par data]=I2txt(strcat(name,'\data', int2str(exp_num-1),'.i!'),250000,true);

Time=(Par.tic)/1000;
%t=data(:,1);                                                              
x1=-data(:,2)/R0;                                                        
x2=data(:,3);                                                              
v=data(:,5)*50/(5e3+50);                                                   
V_os(exp_num)=mean(x2)*3/8000;                                            
f=Freq_res*S:Freq_res:Freq_lim;       
data=load([name, '\Lotus',num2str(exp_num-1),...
                         '_ord=75_zero_mean_fold_Period_div_and_V.dat' ]);                                                                                                     
Y=data(S:(Freq_lim/Freq_res),1)+1i*data(S:(Freq_lim/Freq_res),2)                               ;                   
W=1;                                                                       
V_os='Not avaliable'; 

end

