function [ CI ] = Get_CNLS_stat( Model, f, pars, Model_Options, S, p)
%Routine for CNLS-fit confidence intervals calculation.
%Inspired by 
%Hanson, Stephen Jose. "Confidence intervals for nonlinear regression: A BASIC program." 
%Behavior Research Methods & Instrumentation 10, no. 3 (1978): 437-441.
%and by
%Ivchenko G.I. and Medvedev Yu. I.,  "Introduction to statistics" (in Russian) 2010.
N=length(f);
K=length(pars);
Model_Options.get_J=true;
[~, Jacobian]=Model(f,pars,Model_Options);
if isempty(Jacobian)
    CI=NaN*ones(size(pars.'));
    return;
end;
Q=[real(Jacobian); imag(Jacobian)];
R_diag=diag((Q'*Q)^-1);
%warning('Not tuned p is used in the Get_CNLS_stat.m')
p=p^(1/K); 
t=tinv((p+1)/2, N-K);
CI=t*S*sqrt(R_diag*N/(N-K));
end

