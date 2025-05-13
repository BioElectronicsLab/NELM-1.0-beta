%The routine for universal LMS-residual calculating
function Error = Residual_LMS(f, Y_exp, model, model_options, w_type,  par,misc)
if nargin==6
    misc.data_type='Y';
else
    if ~isfield(misc, 'data_type')
        misc.data_type='Y';
    end;
end;
Y_m=model(f,par, model_options);                                           %Equivalent scheme immittance calculating
Y_m=Y_m(:);
Y_exp=Y_exp(:);
switch misc.data_type
    case 'Y'
        Theory=Y_m;
        Experiment=Y_exp;
    case 'abs_Y'
        Theory=abs(Y_m);
        Experiment=abs(Y_exp);
    case 'real_Y'
        Theory=real(Y_m);
        Experiment=real(Y_exp);  
    case 'imag_Y'
        Theory=imag(Y_m);
        Experiment=imag(Y_exp);         
    case 'Z'
        Theory=1./Y_m;
        Experiment=1./Y_exp;
    case 'abs_Z'
        Theory=1./abs(Y_m);
        Experiment=1./abs(Y_exp);
    case 'real_Z'
        Theory=real(1./Y_m);
        Experiment=real(1./Y_exp);  
    case 'imag_Z'
        Theory=imag(1./Y_m);
        Experiment=imag(1./Y_exp); 
    case 'angle_Y'                                                         %The phase of the impedance is differ from admittance phase only by sign
        Theory=angle(Y_m);
        Experiment=angle(Y_exp);        
    otherwise
        error('Unknown data type in Residual_LMS in misc structure.')
end;

E=Theory-Experiment;                                                       %Calculating the difference between them. ' does Hermitian conjugation, and .' simply transposes
switch w_type                                                              %Calculating the residual depending on the w_type switch
            case 'unit'
                Error=abs(E).^2;
            case 'inverse_modulus'
                Error=abs(E).^2./abs(Experiment).^2;
            case 'proportional'
                Error=abs(real(E)./real(Experiment)+...
                                             imag(E)./imag(Experiment)).^2;
            case 'custom'
                W=misc.W;
                Error=abs(E).^2.*W;
            otherwise
end
if isfield(misc,'mean_error')
    if misc.mean_error
        Error=mean(Error);
    end
else
   Error=mean(Error); 
end
end

