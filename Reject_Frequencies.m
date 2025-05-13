function F = Reject_Frequencies(Fx, rejected_frequencies )
% This function is used to reject frequences with outliers
 N=length(Fx);
 F=Fx;
 F(rejected_frequencies)=0;
 F(N-rejected_frequencies+2)=0;
end

