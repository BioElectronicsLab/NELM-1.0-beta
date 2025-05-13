Memo={'Welcome to NELM!'
    'This is software for impedance analysis. Version 1.0 beta'
      'Main programmer: Daniil D. Stupin'
      'Main coder: Natalia A. Boitsova'
      'Beta testers:  Anna A. Abelit, Natalia A. Boitsova'
      'This is freeware program'
      'To contact us write to BioElectronicsLaboratory@gmail.com'
      'Visit our YouTube channel https://www.youtube.com/@BioElectronicsLab'
      'Our Cults3D page https://cults3d.com/en/users/BioElectronicsLab/3d-models'
      'GitHub link https://github.com/BioElectronicsLab'
      'Happy spectra fitting! ;-)'
      };
 [R C]=size(Memo);
 for j=1:R
     s=char(char(Memo{j}));
     for k=1:length(s)
         clc;
         for l=1:j-1
             disp(Memo{l});
         end;
         disp(s(1:k));
         pause(0.02);
     end;
 end;