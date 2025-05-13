function [J,V, Time, f0, V_os,E]  = Get_Time_Domain_Data_from_mat(name,Misc)
%This function for reading excitation voltage and current responce, which
%were recorded into MAT file.
load(name);
ok=true;

missing='';
if ~exist('Time')
    missing=[missing ' Time,'];
    ok=false;
end;
if ~exist('J')
    missing=[missing ' Y,'];
    ok=false;
end;
if ~exist('V')
    missing=[missing ' f,'];
    ok=false;
end;
if ~exist('E')
    missing=[missing ' E,'];
    ok=false;
end;
if ~exist('f0')
    missing=[missing ' W,'];
    ok=false;
end;
if ~exist('V_os')
    missing=[missing ' V_os,'];
    ok=false;
end;
if ~ok
    error(['Hm... it seems you load bad mat-file' name...
        '. I can''t find variables '  missing 'in it =(']);
end;

end

