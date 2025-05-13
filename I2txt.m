function [Par data ] = I2txt( file_name, L, Is_need_time, Misc )
%Function for reading files in i! format.

input=fopen(file_name); %Opening the file and getting its handle
Par.sign=fread(input,[1:2],'*char'); %Reading the signature
Par.version1=fread(input,[1],'int16'); %Reading the major version number
Par.version2=fread(input,[1],'int16');  %Reading the additional version number
fread(input,[2],'uint8'); %Stub, skip two bytes when reading the file.
Par.freq=fread(input,[1],'double'); %Reading the sampling frequency in kHz
Par.K(1)=fread(input,[1],'uint8'); %Reading  the gain factors for each channel
Par.K(2)=fread(input,[1],'uint8');
Par.K(3)=fread(input,[1],'uint8');
Par.K(4)=fread(input,[1],'uint8');
Par.time.year=fread(input,[1],'uint16');  %Reading  the system time of data recording
Par.time.mounth=fread(input,[1],'uint16');
Par.time.day_of_week=fread(input,[1],'uint16');
Par.time.day=fread(input,[1],'uint16');
Par.time.hour=fread(input,[1],'uint16');
Par.time.minute=fread(input,[1],'uint16');
Par.time.second=fread(input,[1],'uint16');
Par.time.millisecond=fread(input,[1],'uint16');
Par.tic=fread(input,[1],'uint32'); %Read the time from the beginning of the OS start in ms
if Par.sign~='I!' %Checking that the file was opened in the correct format
    data=0; 
    'The file is not in i! format!'
else
 input=fopen(file_name); 
 data=fread(input,1024,'int16');
 data=fread(input,[4,L],'int16');
 data=data';
 preprocessing='';                                                      %Some preprocessing can be also done

 switch preprocessing
     case 'noise'
         load('Noise.mat');                                                %Synthetic noise addition
         data(:,1)=data(:,1)+1500*Noise(:,Misc); 
         warning('Noise is added in I2txt!!!')
     case 'noise+filt'
         load('Noise.mat');                                                %Synthetic noise addition
         x=Noise(:,Misc);
         x= TR_FFT_LPF(x, 6);
         x=x/std(x);
         std(x)
         data(:,1)=data(:,1)+200*x; 
         warning('Noise is added in I2txt!!!');         
     case 'capacitor';         
 end;

 if Is_need_time                                                           %If in need of a time column, then adding it
  t=(0:1:length(data(:,1))-1)/Par.freq/1e3;
  data=horzcat(t',data);
 end;
end;
fclose all;
end

