% This function sounds off the alarm
function [ok] = Alarm(s, mute)
if nargin==1||mute==false 
 try
  [Alarm f0]=audioread('My_Alarm.mp3');
  sound(Alarm/5, f0);
  ok=true;
 catch
  ok=false;
 end;
end;    
disp(s);
end

