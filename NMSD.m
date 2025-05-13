function [ x, Res, flag, info ] = NMSD(x0, f, Y_exp, model, model_options, options, W_type)
%Function for the CNLS processing using the Nelder-Mead method at first, and
%damped Gauss-Newton method at second.
tol=options.GN_tol;
Y_exp=Y_exp(:);
Target=@(x)(Residual_LMS(f, Y_exp, model, model_options, W_type, x,options));
if options.Use_NM
    [x, Res, flag, info]=fminsearch(Target,x0,options);
    info.algorithm= 'Nelder-Mead+Gauss-Newton';
else
    x=x0;
end;
if options.NMGN_Display
    Y_m=model(f,x,model_options);
    Plot_immittance_multi_data(f, Y_exp, Y_m, options)
    disp('Nelder-Mead stage complete! Press any key');
    disp(['Residual before steepest descent search ',num2str(Target(x))]);
    pause;
end;

finding=true;
Xs=[];
tic;
time_out=false;
while finding
    if toc/60>2                                                            %Stoping optimization after 2 minutes time-out
        time_out=true;
        break;
    end;
    Xs=[Xs; x];
    model_options.get_J = true;
    [Y_m, Jacobian]=model(f,x,model_options);
    if ~all(~isnan(Jacobian(:)))
        break;
    end;
    Y_m=Y_m(:);
    %May be Jacobial should be converted to column-type
    switch options.data_type
        case 'Y'
            F=Y_m-Y_exp;
        case 'abs_Y'
            F=abs(Y_m)-abs(Y_exp);
            inv_abs_Y=1./abs(Y_m);
            Jacobian=real(Jacobian)+imag(Jacobian);
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*inv_abs_Y;
            end;
        case 'real_Y'                                                      %Under test
            F=real(Y_m)-real(Y_exp);
            Jacobian=real(Jacobian); 
        case 'imag_Y'                                                      %Under test
            F=imag(Y_m)-imag(Y_exp);
            Jacobian=imag(Jacobian); 
        case 'angle_Y'                                                     %Under test
            F=angle(Y_m)-angle(Y_exp);
            inv_abs_Y2=1./abs(Y_m).^2;
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=( imag(Jacobian(:,j)).*real(Y_m)-...
                                real(Jacobian(:,j)).*imag(Y_m))...
                                          .*inv_abs_Y2;
            end;            
        case 'Z'
            F=1./Y_m-1./Y_exp;
            neg_inv_Y2=-1./Y_m.^2;
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*neg_inv_Y2;
            end;
        case 'abs_Z'
            F=abs(1./Y_m)-abs(1./Y_exp);
            neg_inv_abs_Y3=-1./abs(Y_m).^3;
            Jacobian=real(Jacobian)+imag(Jacobian);
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*neg_inv_abs_Y3;
            end;
        case 'real_Z'                                                      %Under test
            F=real(1./Y_m)-real(1./Y_exp);
            neg_inv_Y2=-1./Y_m.^2;
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*neg_inv_Y2;
            end;
            Jacobian=real(Jacobian); 
        case 'imag_Z'                                                      %Under test
            F=imag(1./Y_m)-imag(1./Y_exp);
            neg_inv_Y2=-1./Y_m.^2;
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*neg_inv_Y2;
            end;
            Jacobian=imag(Jacobian);            
        otherwise
            error('Unknown data type in Residual_LMS in misc structure.')
    end;
    compass=real(Jacobian'*F).';                  
    lambda=0.01/max(abs(compass./x));                                      %Trying to set maximum variation of vectors' parameters to 1% to prevent minimum over-jumping and convergence fault.
    if Target(x-lambda*compass)<=Target(x)                                 %If new step is good then continue
        x=x-lambda*compass;
    else
        finding=false;
    end;
    
    if options.NMGN_Display
      Plot_immittance_multi_data(f, Y_exp, Y_m, options);
    end;

end;
% if lambda<=tol
%     x=x_buf;
% end;
% if ~all(~isnan(Jacobian(:)))
%     break;
% end;
if options.NMGN_Display
    Grad=real(Jacobian'*F);
    disp(['Residual after Gauss-Newton search ',num2str(Target(x))]);
    disp(['Final Jacobian rank is ' num2str(rank(Jacobian)) ', gradient norm is ' num2str(norm(Grad))]); pause;
end;
Res=Target(x);
if ~options.Use_NM
    flag=1;
    info.iterations=0;
    info.funcCount=0;
    info.algorithm= 'Gauss-Newton with Nelder-Mead';

    info.message='Ok!';
end;
if time_out
    flag=0;
    info.iterations=0;
    info.funcCount=0;
    info.algorithm= 'Gauss-Newton with Nelder-Mead';

    info.message='Time out stop';
end;
end
%For future
%     [U,S,V]=svd(Q);
%     S=diag(S);
%     b=U'*b;
%     for j=1:length(S)
%         if abs(S(j))>tol
%             compass(j)=b(j)/S(j);
%         else
%             compass(j)=0;
%         end;
%     end;
%    compass=(V*compass.').';