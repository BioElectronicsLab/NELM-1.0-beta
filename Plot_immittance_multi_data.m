function Plot_immittance_multi_data(f, Y_exp, Y_m, options)
%Procedure for immittance multi representation plotting
if ~isfield(options,'data_type')
    warning('Options.data_type is not defined!');
    options.data_type='Y';
end;
switch options.data_type
    case 'Y'
        plot(Y_exp,'sg'); hold on; plot(Y_m,'sr'); hold off;
        xlabel('Real part of the admittance (S)','FontSize',15);
        ylabel('Imaginary part of the admittance (S)','FontSize',15);
    case 'abs_Y'
        plot(f, abs(Y_exp),'sg'); hold on; plot(f, abs(Y_m),'sr'); hold off;
        xlabel('Frequency (Hz)','FontSize',15);
        ylabel('Magnitude of the admittance (S)','FontSize',15);
    case 'real_Y'
        plot(f, real(Y_exp),'sg'); hold on; plot(f, real(Y_m),'sr'); hold off;
        xlabel('Frequency (Hz)','FontSize',15);
        ylabel('Real part of the admittance (S)','FontSize',15);
    case 'imag_Y'
        plot(f, imag(Y_exp),'sg'); hold on; plot(f, imag(Y_m),'sr'); hold off;
        xlabel('Frequency (Hz)','FontSize',15);
        ylabel('Imaginary part of the admittance (S)','FontSize',15); 
    case 'angle_Y'
        plot(f, angle(Y_exp),'sg'); hold on; plot(f, angle(Y_m),'sr'); hold off;
        xlabel('Frequency (Hz)','FontSize',15);
        ylabel('Phase of the admittance (rad)','FontSize',15);        
    case 'Z'
        plot(1./Y_exp,'sg'); hold on; plot(1./Y_m,'sr'); hold off;
        xlabel('Real part of the impedance (\Omega)','FontSize',15);
        ylabel('Imaginary part of the impedance (\Omega)','FontSize',15);
    case 'abs_Z'
        plot(f, abs(1./Y_exp),'sg'); hold on; plot(f, abs(1./Y_m),'sr'); hold off;
        xlabel('Frequency (Hz)','FontSize',15);
        ylabel('Magnitude of the impedance (\Omega)','FontSize',15);
    case 'real_Z'
        plot(f, real(1./Y_exp),'sg'); hold on; plot(f, real(1./Y_m),'sr'); hold off;
        xlabel('Frequency (Hz)','FontSize',15);
        ylabel('Real part of the impedance (\Omega)','FontSize',15); 
    case 'imag_Z'
        plot(f, imag(1./Y_exp),'sg'); hold on; plot(f, imag(1./Y_m),'sr'); hold off;
        xlabel('Frequency (Hz)','FontSize',15);
        ylabel('Imaginary part of the impedance (\Omega)','FontSize',15); 
        
    otherwise
        warning(['Unknown data type ' options.data_type]);
        plot(Y_exp,'sg'); hold on; plot(Y_m,'sr'); hold off;
        xlabel('Real part of the admittance (S)','FontSize',15);
        ylabel('Imaginary part of the admittance (S)','FontSize',15);
end;
set(gca, 'FontSize',12);
lh=legend('Experiment', 'Approximation');
if IsMatLab
 lh.FontSize=12;
end;
drawnow;
end
