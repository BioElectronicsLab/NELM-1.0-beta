function G = Gram_Matrix( x,y, xy, total_col, Rs, R, Cs, C, exact)
% This function produces Gram matrtix for AF method of approximation
N=length(xy);
G=zeros(R, C);
idx=[];
for k=1:C
    G(:,k)=xy(mod((1:R)+Rs-(k+Cs),N)+1);
end;
disp(idx);
if exact
    X=zeros(total_col,R);
    Y=zeros(total_col,C);
    for k=1:R
        X(:,k)=x(mod((1:total_col)+(N-total_col)+k+Rs-3,N)+1);
    end;
    for k=1:C
        Y(:,k)=y(mod((1:total_col)+(N-total_col)+k+Cs-3,N)+1);
    end;
    G=G-X'*Y;
end;

end


