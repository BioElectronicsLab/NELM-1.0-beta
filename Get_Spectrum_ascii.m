function [Y, Time, f, W, V_os] = Get_Spectrum_ascii( name, exp_num, options)
%This function extracts data from ascii files
if iscell(name)
    data=load(char(name{exp_num}));                                        %Loading data from the ascii file
else
    data=load(name);
end;
Time=0;                                                                    %Setting time
data=Table_cut(data, options);                                             %Using nested function table cut
f=data(:,1);                                                               %Getting frequency vector
Y=data(:,2)+1i*data(:,3);                                                  %Getting admittance
%W=1;                                                                   %Setting the weight for the option w_type='unit'
if length(data(1,:))==4
    W=data(:,4);                                                           %Loading the weigth data
else
    W=1;                                                                   %Setting the weight for the option w_type='unit'
end;
V_os='Not avaliable';                                                      %Stating that disturbance voltage in the ADC codes is not available

function [data_cut] = Table_cut(data, options)
        Freq_lim=options.Frequency_Range.Freq_lim;                         %Getting frequency resolution from Settings
        Freq_res=options.Frequency_Range.Freq_res;                         %Getting frequency limit from Settings
        Freq_S=(options.Frequency_Range.S)*Freq_res;                       %Getting starting frequency from Settings
        [~,idx_S]=min(abs(data(:,1)-Freq_S));                              %Finding start of the required interval
        [~,idx_lim]=min(abs(data(:,1)-Freq_lim));                          %Finding end of the required interval
        data_cut=data(idx_S:idx_lim,:);                                    %Extracting data in the required interval
    end
end

