function [  ] = Plot_Check_Func(name, exp_num, Get_Spectrum_Func, Model,...
    Result_Best, Model_Options, ...
    options, Version)
%if nargin==5
W_type='unit';
if nargin==8
    Freq_res=2;
    Freq_lim=40000;
    S=10;
else
    Freq_res=options.Frequency_Range.Freq_res;
    Freq_lim=options.Frequency_Range.Freq_lim;
    S=options.Frequency_Range.S;
end;
[Y_exp, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );

if nargin==5
    x=Result_Best(exp_num,:);
    fix_pars_data=[];
else
    x=Result_Best;

end;
Y_m=Model(f,x,Model_Options);

Plot_immittance_multi_data(f, Y_exp, Y_m, options);
legend('Experiment',['Approximation (Error=' num2str(sqrt(Residual_LMS(f, Y_exp, Model, Model_Options, W_type, x))) ')' ] );
grid on;
drawnow ;
s='';
title(['Channel ' num2str(exp_num)]);





end

