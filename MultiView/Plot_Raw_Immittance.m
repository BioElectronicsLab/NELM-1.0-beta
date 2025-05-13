function [  ] = Plot_Raw_Immittance(name, exp_num, Get_Spectrum_Func, R0,...
                                Plot_Type, IsZ, Ch_Num, MultiWin)                                                                 
 Freq_res=2;
 Freq_lim=40000;
 S=10;


for j=1:Ch_Num
 [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num-1+j,...
                                                S, Freq_res,Freq_lim,R0 );
 if IsZ
  Immittance=1./Y;
 else
  Immittance=Y;
 end;
 switch Plot_Type
 case 'Locus'
  if MultiWin
   subplot(1, Ch_Num, j); 
   plot(Immittance); 
  else
   plot(Immittance);    
   hold on;
  end;    
  if IsZ
   xlabel('Re Z, \Omega', 'FontSize',20);
   ylabel('Im Z, \Omega', 'FontSize',20);
  else
   xlabel('Re Y, S', 'FontSize',20);
   ylabel('Im Y, S', 'FontSize',20);
  end;
 case 'Bode'
 if MultiWin
  subplot(2, Ch_Num, j);    
  plot(f, abs(Immittance));
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('|Z|, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('|Y|, S', 'FontSize',20);
  end;
  hold on;
  subplot(2, Ch_Num, j+Ch_Num);
  plot(f, angle(Immittance));
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('arg Z, rad', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('arg Y, rad', 'FontSize',20);
  end;
 else
  subplot(2, 1, 1);    
  plot(f, abs(Immittance)); 
  hold on; 
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('|Z|, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('|Y|, S', 'FontSize',20);
  end;
  subplot(2, 1, 2);
  plot(f, angle(Immittance));
  hold on;

  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('arg Z, rad', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('arg Y, rad', 'FontSize',20);
  end;
 end; 
 case 'ReIm'
 if MultiWin
  subplot(2, Ch_Num, j);    
  plot(f, real(Immittance)); 
  hold on;  
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Re Z, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Re Y, S', 'FontSize',20);
  end;
  subplot(2, Ch_Num, j+Ch_Num);
  plot(f, imag(Immittance));
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Im Z, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Im Y, S', 'FontSize',20);
  end;
 else
  subplot(2, 1, 1);    
  plot(f, real(Immittance));
  hold on;
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Re Z, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Re Y, S', 'FontSize',20);
  end;  
  subplot(2, 1, 2);
  plot(f, imag(Immittance));
  hold on;
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Im Z, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Im Y, S', 'FontSize',20);
  end;
 end; 
 otherwise
 end;
end; 
hold off;



end

