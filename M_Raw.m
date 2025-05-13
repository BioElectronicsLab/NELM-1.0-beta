function [ Y, Jacobian ] = M_Raw( f, w, model_options)
%This function acts as a model for raw spectra analysis
if nargin==1
 Model_Options=f;
else
 Model_Options=model_options;   
end; 
non_negative_pars=[];
if nargin<=1
    Y.non_negative_pars=non_negative_pars;
    Y.Elements_names='NA';
    Y.Elements_Num=1;
    return;
end;

Y=w;
if isfield(Model_Options,'get_J')
 if Model_Options.get_J
     Jacobian=[];
 end;
end;

end

