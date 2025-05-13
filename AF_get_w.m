function [ w, sigma ] = AF_get_w_UC( V, J, Model_Options )

ell_d=Model_Options.ell_d;
ell_n=Model_Options.ell_n;
%The LMS problem solution is defined via large Toeplitz matices 
%multiplication, which can be accelerated using FFT convolution theorem.
%However, FFT is working with circular convolution, which, strictly speaking,
%is not for real causal systems. For this reason, we have modified the FFT
%convolution method by substracting the overlaped Toeplitz matrix column
%tails. The variable total_cols defines how many data points we should omit
%for preventing circular overlapping.
                                                 
Y0Hz=0;%mean(J)/mean(V);

total_cols=max(ell_n,ell_d);     
% Offset calibration
% J=J+2*TR_FFT_LPF(J,80);
% V=V+2*TR_FFT_LPF(V,80);
FV=fft(V-mean(V));
FJ=fft(J-mean(J));


%FFT correlation/convolution evaluation
Fvv=FV.*conj(FV);
Fjj=FJ.*conj(FJ);
Fvj=FV.*conj(FJ);
Fjv=FJ.*conj(FV);
vv=ifft(Fvv);
vj=ifft(Fvj);
jv=ifft(Fjv);
jj=ifft(Fjj);
% Setting exact convolution calculation or approximated without tails
%omitting
exact=Model_Options.exact_Gram_Calc;

%Calculating matrix for normal equations
VV=Gram_Matrix(V,V, vv, total_cols, total_cols-ell_n+1, ell_n+1, total_cols-ell_n+1, ell_n+1,exact);
VJ=Gram_Matrix(V,J, vj, total_cols, total_cols-ell_n+1, ell_n+1, total_cols-ell_d+1, ell_d+1,exact);
JV=Gram_Matrix(J,V, jv, total_cols, total_cols-ell_d+1, ell_d+1, total_cols-ell_n+1, ell_n+1,exact);
JJ=Gram_Matrix(J,J, jj, total_cols, total_cols-ell_d+1, ell_d+1, total_cols-ell_d+1, ell_d+1,exact);

Q=[VV, VJ; JV JJ];
RHS=Q(1:end-1,end);
Q(:,end)=[];
Q(end,:)=[];
solver='eig';
if ~isfield(Model_Options,'Suppress_Diag');
    Model_Options.Suppress_Diag=false;
end;
if ~isfield(Model_Options,'zero_fix');
    Model_Options.zero_fix=false;
end;
if Model_Options.Suppress_Diag
    if ~isfield(Model_Options,'Noise_Level');
        Model_Options.Noise_Level=0;
    end;
    eps2=Model_Options.Noise_Level;
    Y_exp=Model_Options.Y_exp;
    f=Model_Options.f;
    options=optimset('fminsearch');                                            %Setting up the optimization process
    options.TolFun=1e-3;                                                     %Setting Threshold of stoping optimization
    options.TolX= 1e-3;
    options.Display='off';
    Target=@(x)(Spectral_Error(Q, RHS, x, f, Y_exp));
    %eps2=J'*J-J'*circshift(J,1);
    eps2=fminsearch(Target,eps2,options);
    Q=Q-diag([zeros(ell_n+1,1); eps2*ones(ell_d,1)]);
else
    eps2=0;
end;
w=Solve_normal_equations(Q,RHS,solver);
w=[w(1:ell_n+1); zeros(ell_n,1);w(ell_n+2:ell_n+1+ell_d); eps2/length(J)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%% ROUTINES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function Error=Spectral_Error(Q, RHS, eps2, f, Y_exp)
        Q=Q-diag([zeros(ell_n+1,1); eps2*ones(ell_d,1)]);
        w=Solve_normal_equations(Q,RHS,solver);
        w=[w(1:ell_n+1); zeros(ell_n,1);w(ell_n+2:end)];
        Y_m= M_AF( f, w, Model_Options);
        Error=sum(abs(Y_m(:)-Y_exp(:)).^2);
    end

    function w=Solve_normal_equations(Q, RHS, solver)
        if Model_Options.zero_fix
            Scale=(2*ell_n+1+ell_d)*max(abs(Q(:)));
            C=Scale*[ones(1, ell_n+1) -Y0Hz*ones(1,ell_d)];
            RHS=[RHS; Scale*Y0Hz];
            Q=[Q, C'; C, 0];
        end;
        switch solver
            case 'native'
                w=Q^-1*RHS;
            case 'eig'
                [V lambda]=eig(Q);
                lambda=diag(lambda);
                w=(V'*RHS)./lambda;
                %   idx=find(abs(lambda)<=threshold);
                w=V*w;
        end;
        %keyboard
        if Model_Options.zero_fix
            w=w(1:end-1);
        end;
    end
end



