function [ score ] = KK_score( f, Immittance )
%Simple Kramers-Kronig test
%Here score is the residual between actual immittance imaginary part and
%immittance imaginary part reconstructed from real part by Kramers-Kronig
%relations.
f=f(:); 
Immittance=Immittance(:);
R=real(Immittance);
I=imag(Immittance);

L=length(Immittance);
for j=3:L-2
      F=f(1:j-1);
      KK(j,1)=trapz(F,R(1:j-1)./(F.^2-f(j)^2));
      F=f(j+1:L);
      KK(j,1)=KK(j,1)+trapz(F,R(j+1:L)./(F.^2-f(j)^2));
end;

KK=2*f(1:L-2)/pi.*KK;
I=I(1:L-2);
plot(KK); hold on; plot(I); hold off;

score=mean((KK-I).^2);
end

