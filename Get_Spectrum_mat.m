function [Y, Time, f, W, V_os] = Get_Spectrum_mat( name, exp_num, options)
%This is a function for loading admittance from mat-files.                 
%To use this file-format you should to store your data in the following variables
%
%Time   (s)    -- time, when the spectrum was recorded
%  f    (Hz)   -- frequencies at which spectrum was recorded
%  Y    (S)    -- admittance spectrum (complex values)
%  W    (a.u.) -- weight for CNLS processing
%  V_os (V)    -- offset voltage (experimental)
if iscell(name)
    name=char(name{exp_num});
    load(name);
else
    load(name);
end;
ok=true;

missing='';
if ~exist('Time')
    missing=[missing ' Time,'];
    ok=false;
end;
if ~exist('Y')
    missing=[missing ' Y,'];
    ok=false;
end;
if ~exist('f')
    missing=[missing ' f,'];
    ok=false;
end;
if ~exist('W')
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
data(:,1)=f;
data(:,2)=real(Y);
data(:,3)=imag(Y);
data=Table_cut(data, options);                                             %Using nested function table cut
f=data(:,1);                                                               %Getting frequency vector
Y=data(:,2)+1i*data(:,3);                                                  %Getting admittance

function [data_cut] = Table_cut(data, options)
        Freq_lim=options.Frequency_Range.Freq_lim;                         %Getting frequency resolution from Settings
        Freq_res=options.Frequency_Range.Freq_res;                         %Getting frequency limit from Settings
        Freq_S=(options.Frequency_Range.S+1)*Freq_res;                     %Getting starting frequency from Settings
        [~,idx_S]=min(abs(data(:,1)-Freq_S));                              %Finding start of the required interval
        [~,idx_lim]=min(abs(data(:,1)-Freq_lim));                          %Finding end of the required interval
        data_cut=data(idx_S:idx_lim,:);                                    %Extracting data in the required interval
    end
end

