function [ Y ] = AF_Old_Time_Model( f, w, model_options)
if nargin==1
 Model_Options=f;
else
 Model_Options=model_options;   
end; 
non_negative_pars=[];
if nargin<=1
    ell_n=Model_Options.ell_n;
    ell_d=Model_Options.ell_d;
    Pars_N=2*ell_n+1+ell_d;
    Y.non_negative_pars=non_negative_pars;
    N=1;
    for j=-ell_n:ell_n
        Y.Elements_names(N)={['n_' num2str(j)]};
        N=N+1;
    end;
    for j=0:ell_d-1
        Y.Elements_names(N)={['d_' num2str(ell_d-j)]};
        N=N+1;
    end;
    Y.Elements_Num=Pars_N;
    return;
end;

ell_n=Model_Options.ell_n;
ell_d=Model_Options.ell_d;
Pars_N=2*ell_n+1+ell_d;
R0=Model_Options.R0;

f0=Model_Options.f0;
n=w(1:2*ell_n+1);
d=w(end-ell_d+1:end);
N=0;


for j=-ell_n:ell_n
    N=n(ell_n+1+j)*exp(2*pi*1i *f/f0*(j))+N;
end;
D=1;
for j=1:ell_d;
    D=-d(j)*exp(-2*pi*1i *f/f0*(ell_d-j+1))+D;
end;

Y=((-((N./D)/R0/(50/(5e3+50)))));


end

