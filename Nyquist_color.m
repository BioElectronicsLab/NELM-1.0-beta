function  Nyquist_color(f, Y )
x=real(Y(end:-1:1));
y=imag(Y(end:-1:1));
cm = colormap('jet');  

y(end) = NaN;                                                 
c = flipud(f);                                                
patch(x,y, c, 'EdgeColor','interp','LineWidth',5);
cb=colorbar;
%cb.Label.String='test';

yl=ylabel(cb,'Frequency (Hz)','FontSize',16,'Rotation',270);
yl.VerticalAlignment='bottom';
% cb.Label.Position(1)=0;
% cb.Label.Position(2)=1;
end

