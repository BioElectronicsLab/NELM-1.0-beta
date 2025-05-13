function [ D ] = lin_set_difference( A, N )
% This function is used in all of the models to find indeces of not fixed
% parameters
if ~isempty(A)
    B=zeros(1,N);
    B(A(1,:))=1;
    D=find(B==0);
else
    D=1:N;
end;
end

