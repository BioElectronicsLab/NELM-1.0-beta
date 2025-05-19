function [ G ] = Simple_DRT( f, Y, tau, stabilizer )
%Very simple approach to evaluate distribution of the relaxation times (DRT).
%Here f -- frequence vector, Y -- immittance, tau -- distribution times,
%which should be tested, stabilizer -- factor for stabilization of the
%ill-posed DRT decomposition.
iw=2*pi*1i*f(:);
Q=[];
for j=1:length(tau) 
    Q=[Q 1./(1+tau(j)*iw)];
end;
Q=[real(Q); imag(Q)];
RHS=[real(Y); imag(Y)];
%A=(Q'*Q)^-1*Q'*RHS;
[U, S, V]=svd(Q,'econ');
S=diag(S);
idx=find(S<stabilizer*S(1));
S(idx)=Inf;
G=V*((U'*RHS)./S);
plot(tau,G)


end

