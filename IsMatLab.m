function Ans = IsMatLab
 if ~exist('OCTAVE_VERSION','builtin')
     Ans=true;
 else
     Ans=false;
end