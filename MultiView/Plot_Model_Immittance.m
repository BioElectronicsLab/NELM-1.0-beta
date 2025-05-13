function [  ] = Plot_Model_Immittance(Channels, exp_num,...
                                Plot_Type, IsZ, Ch_Num, MultiWin, overlap)                                                                 
 Freq_res=2;
 Freq_lim=40000;
 S=10;

f=S:Freq_res:Freq_lim;
TrueCh_Num=length(Channels);
for j=1:Ch_Num
 Ch=mod(exp_num-1+j+1,TrueCh_Num)+1; 
 line=find(Channels(Ch).exp_nums==exp_num+j-1);
 if isempty(line)
     continue;
 end;
 par=Channels(Ch).Best(line,1:end-2)   ;
 Model=Channels(Ch).Model;
 if isfield(Channels(Ch), 'Model_Options')
  Y=Model(f,par,Channels(Ch).Model_Options);
 else
  Y=Model(f,par);   
 end;
 if IsZ
  Immittance=1./Y;
 else
  Immittance=Y;
 end;
 switch Plot_Type
 case 'Locus'
  if MultiWin
   subplot(1, Ch_Num, j); 
   eval(['hold ' overlap]);
   plot(Immittance,'sr'); 
  else
   eval(['hold ' overlap]);
   plot(Immittance,'sr');    

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
  eval(['hold ' overlap]);
  plot(f, abs(Immittance),'LineWidth',2);
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('|Z|, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('|Y|, S', 'FontSize',20);
  end;
  subplot(2, Ch_Num, j+Ch_Num);  
  eval(['hold ' overlap]);
  plot(f, angle(Immittance),'LineWidth',2);
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('arg Z, rad', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('arg Y, rad', 'FontSize',20);
  end;
 else
  subplot(2, 1, 1);  
  eval(['hold ' overlap]);
  plot(f, abs(Immittance),'LineWidth',2); 
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('|Z|, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('|Y|, S', 'FontSize',20);
  end;
  subplot(2, 1, 2);
 eval(['hold ' overlap]);
  plot(f, angle(Immittance),'LineWidth',2);
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
  eval(['hold ' overlap]);     
  plot(f, real(Immittance),'LineWidth',2); 

  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Re Z, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Re Y, S', 'FontSize',20);
  end;
  subplot(2, Ch_Num, j+Ch_Num);
  eval(['hold ' overlap]);
  plot(f, imag(Immittance),'LineWidth',2);
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Im Z, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Im Y, S', 'FontSize',20);
  end;
 else
  subplot(2, 1, 1);    
  plot(f, real(Immittance),'LineWidth',2);
  eval(['hold ' overlap]);
  if IsZ
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Re Z, \Omega', 'FontSize',20);
  else
   xlabel('Frequency, Hz', 'FontSize',20);
   ylabel('Re Y, S', 'FontSize',20);
  end;  
  subplot(2, 1, 2); 
  eval(['hold ' overlap]);
  plot(f, imag(Immittance),'LineWidth',2);

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

