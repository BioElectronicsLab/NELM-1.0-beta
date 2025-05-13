function [J, V, f, idx] = Remove_Spectral_AF(J, V, f, Y_abs, S)
% This function is used to remove spectral outliers during AF method
%f=Freq_res*S:Freq_res:Freq_lim;
FJ=fft(J);
FV=fft(V);
plot(abs(FJ));
idx=NumRawSolve([diff(Y_abs);0], -1);
%hold on; plot(Y_abs);stem(idx, max(Y_abs)*ones(size(idx))); 
%drawnow; pause;
L=50;
N=1;
if ~isempty(idx)
    for j=idx'
        from=j-L;
        to=j+L;
        if from<1
            from=1;
        end;
        if to>length(Y_abs)
            to=length(Y_abs);
        end;
        [~, max_idx(N)]=max(Y_abs(from:to));
        max_idx(N)=max_idx(N)+from-1;
        N=N+1;
    end;
    idx_buf=max_idx;
    for j=1:100
        idx_buf=[idx_buf max_idx+j max_idx-j];
    end;
    idx=idx_buf+S;
    FJ=Reject_Frequencies(FJ, idx);
    FV=Reject_Frequencies(FV, idx);
  %  plot(abs(FJ)); drawnow; hold off; pause;
    J=ifft(FJ);
    V=ifft(FV);
    frequencies_to_be_removed=(idx-1)*mean(diff(f));                                   %TODO remove stub *2
    idx=find(ismember(f,frequencies_to_be_removed));
    f(idx)=[];
end;
end

