function [J, V, f, idx] = Remove_Spectral_Outliers_for_imitance(J, V, f, N)
% This function is used to remove spectral outliers for immitance
%f=Freq_res*S:Freq_res:Freq_lim; 
FJ=fft(J);
FV=fft(V);
idx = [];
max_idx = f(end)/mean(diff(f));
[~, idx]=sort(abs(FJ(1:max_idx)), 'descend');
idx = idx(1:N);
%plot(abs(FJ)); hold on;
FJ=Reject_Frequencies(FJ, idx);
FV=Reject_Frequencies(FV, idx);
%plot(abs(FJ)); hold off; pause;
J=ifft(FJ);
V=ifft(FV);
frequencies_to_be_removed=(idx-1)*mean(diff(f));                                   %TODO remove stub *2
idx=find(ismember(f,frequencies_to_be_removed));
f(idx)=[];
end

