function [ par ] = Get_full_pars(var, fix)
c=[var fix];
[~, idx]=sort(c(1,:));
par=c(2:end,idx);


end

