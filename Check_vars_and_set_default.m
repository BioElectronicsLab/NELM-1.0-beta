% This piece of code is used to ensure compatibility between different versions
chk_vars_error_=false;
if ~isfield(options, 'rand_Amp')
    options.rand_Amp=1;
end;
if ~isfield(options, 'Monte_Carlo_Mode')
    options.Monte_Carlo_Mode='local';
else
    if strcmp(options.Monte_Carlo_Mode,'global')
        if ~isfield(Channels(Ch), 'x0_space_origin')
            disp('Hey, x0_space_origin is not defined! Set it in Settings file as Channels(Ch).x0_space_origin=[...]');
            chk_vars_error_=true;
        end;
    end;
end;
if ~isfield(options, 'data_type')
    options.data_type='Y';
end;
for Ch_=1:Ch_Num
    if ~isfield(Channels(Ch_).Model_Options,'pars_to_be_fixed')
        Channels(Ch_).Model_Options.pars_to_be_fixed=[];
    end;
    if isfield(Channels(Ch_).Model_Options,'fix_pars')
        [row_count,~]=size(Channels(Ch_).Model_Options.fix_pars);
        if row_count==1
            Channels(Ch_).Model_Options.pars_to_be_fixed=...
                       Channels(Ch_).Model_Options.fix_pars;
            Channels(Ch_).Model_Options.fix_pars=[];
            Channels(Ch_).Model_Options.Message_from_NELM='I have modify the Model_Options field for compatibility with current NELM version) ';
        end;
    else
        Channels(Ch_).Model_Options.fix_pars=[];
    end;
end;
clear Ch_;
