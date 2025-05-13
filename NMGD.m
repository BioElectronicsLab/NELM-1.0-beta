function [ x, Res, flag, info ] = NMGD(x0, f, Y_exp, model, model_options, options, W_type)
Y_exp=ToCol(Y_exp);
Target=@(x)(Residual_LMS(f, Y_exp, model, model_options, W_type, x));
if options.Use_NM                                                            
    [x, Res, flag, info]=fminsearch(Target,x0,options);                 
    info.algorithm= 'Nelder-Mead+Gauss-Newton';
else 
    x=x0
end;
if options.NMGN_Display
    plot(Y_exp,'sg'); hold on;
    plot(model(f,x,model_options),'sr'); hold off;
    disp('Nelder-Mead stage complete! Press any key');
    pause;
end;

finding=true;
Xs=[];
tic;
time_out=false;
while finding
    if toc/60>2
        time_out=true;
        break;
    end;
    Xs=[Xs; x];
    model_options.get_analytical_J = true;
    [Y_m, Jacobian]=model(f,x,model_options);
    if ~all(~isnan(Jacobian(:)))
        break;
    end;
    tol=options.GN_tol;
    Y_m=ToCol(Y_m);
    %May be Jacobial should be converted to column-type
    F=Y_m-Y_exp;
    compass=real(Jacobian'*F);
    lambda=options.lambda_0;
    
    while lambda>tol                                                     
        x_buf=x;
        x=x-lambda*compass.';       
        if Target(x)>=Target(x_buf)
            x=x_buf;
            lambda=lambda/2;
            if options.NMGD_Display
                lambda
            end;
            finding=false;
        else
            finding=true;
            Res=Target(x);
            lambda=options.lambda_0;
            if options.NMGD_Display
                plot(Y_exp,'sg'); hold on;
                plot(model(f,x,model_options),'sr'); hold off;
                drawnow;
            end;
            break;
        end;
    end;
end;
if options.NMGD_Display
    Grad=real(Jacobian'*F);
    disp(['Final Jacobian rank is ' num2str(rank(Jacobian)) ', gradient norm is ' num2str(norm(Grad))]); pause;
end;
Res=Target(x);
if ~options.Use_NM
    flag=1;
    info.iterations=0;
    info.funcCount=0;
    info.algorithm= 'Nelder Mead with gradient descent';
    info.message='Ok!';
end;
if time_out
    flag=0;
    info.iterations=0;
    info.funcCount=0;
    info.algorithm= 'Nelder Mead with gradient descent';
    
    info.message='Time out stop';
end;
end

