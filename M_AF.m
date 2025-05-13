function [Y, W ] = M_AF( f, w, model_options)
%This is our old adaptive filtering model, which uses ell_n past excitation
%voltage samples, ell_n future excitation voltage samples, and ell_d past
%current response samples.
if nargin==1
 Model_Options=f;
else
 Model_Options=model_options;   
end; 
%Initialization
if ~isfield(Model_Options,'Compression')
 Model_Options.Compression.On=false;
end;

%Main code
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
    Y.non_fix_pars_idx=1:Pars_N;
    return;
end;

ell_n=Model_Options.ell_n;
ell_d=Model_Options.ell_d;
Pars_N=2*ell_n+1+ell_d;
R0=Model_Options.R0;

f0=w(end);                                                                 %Recalling sampling rate from weight coefficient variable.
%w(end)=[];

n=w(1:2*ell_n+1);
d=w(2*ell_n+2:2*ell_n+1+ell_d);
N=0;

for j=-ell_n:ell_n
    N=n(ell_n+1+j)*exp(2*pi*1i *f/f0*(j))+N;
end;
D=1;
if ell_d>0
    for j=1:ell_d;
        D=-d(j)*exp(-2*pi*1i *f/f0*(ell_d-j+1))+D;
    end;
    Y=((-((N./D)/R0/(50/(5e3+50)))));                                          %Magic numbers 50 and 5e3 are divider resistors, which are used for excitation voltage attenuation.
    W=abs(D);
else
    Y=-N/R0/(50/(5e3+50));   
    W=ones(size(f));
end;
%plot(f, W); pause;

if Model_Options.Compression.On                                                  %Use immittance compression approach (experimental) 
 A=Model_Options.Compression.A;
 B=Model_Options.Compression.B;
 Y=A*Y./(1-B*Y);
end;

if isfield(Model_Options,'get_J')
 if Model_Options.get_J
     W=[];
 end;
end;
end

