function [Par data ] = I2txt( file_name, L, Is_need_time )

input=fopen(file_name); 
Par.sign=fread(input,[1:2],'*char'); 
Par.version1=fread(input,[1],'int16'); 
Par.version2=fread(input,[1],'int16'); 
fread(input,[2],'uint8'); 
Par.freq=fread(input,[1],'double'); 
Par.K(1)=fread(input,[1],'uint8'); 
Par.K(2)=fread(input,[1],'uint8');
Par.K(3)=fread(input,[1],'uint8');
Par.K(4)=fread(input,[1],'uint8');
Par.time.year=fread(input,[1],'uint16');  
Par.time.mounth=fread(input,[1],'uint16');
Par.time.day_of_week=fread(input,[1],'uint16');
Par.time.day=fread(input,[1],'uint16');
Par.time.hour=fread(input,[1],'uint16');
Par.time.minute=fread(input,[1],'uint16');
Par.time.second=fread(input,[1],'uint16');
Par.time.millisecond=fread(input,[1],'uint16');
Par.tic=fread(input,[1],'uint32'); 
if Par.sign~='I!' 
    data=0; 
    'Not i! file'
else
 input=fopen(file_name); %Òğşê. 
 data=fread(input,1024,'int16');
 data=fread(input,[4,L],'int16'); 
 data=data';
 if Is_need_time 
  t=(0:1:length(data(:,1))-1)/Par.freq/1e3;
  data=horzcat(t',data);
 end;
end;
fclose all;
end

