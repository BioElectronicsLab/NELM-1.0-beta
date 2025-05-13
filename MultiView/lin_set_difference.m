function [ D ] = lin_set_difference( A, N )
 B=zeros(1,N);
 B(A)=1;
 D=find(B==0);
end

