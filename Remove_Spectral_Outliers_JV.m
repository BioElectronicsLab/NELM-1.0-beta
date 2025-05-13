function [J, V, f, idx] = Remove_Spectral_Outliers_JV(J, V, f, threshold)
% This function is used to remove spectral outliers from J and v
FJ=fft(J);
FV=fft(V);
if threshold=='3sigma'
    threshold=0.1*std(abs(FJ));
    %plot(abs(FJ)); hold on;
    idx=find( abs( abs(FJ)-mean(abs(FJ)) )>threshold );
    FJ=Reject_Frequencies(FJ, idx);
    FV=Reject_Frequencies(FV, idx);
   % plot(abs(FJ)); hold off; drawnow; pause;
    J=ifft(FJ);
    V=ifft(FV);
    frequencies_to_be_removed=(idx-1)*2;                                   
    idx=find(ismember(f,frequencies_to_be_removed));
    f(idx)=[];
else
    
end;

end

