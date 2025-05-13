%This script was used to generate models. To obtain models with delay (tau)
%and L as artifacts of mesuring set up please refer to extended model pack
%% RLC
clear
syms R L C f ;
Y_input = 1/(R+1i*2*pi*f*L+1/(1i*2*pi*f*C));
any_sign_pars=[];
Make_Model(Y_input, f, 'RLC', any_sign_pars)
%% RL_CPE
clear
syms L R W A f
any_sign_pars=[];
Y_input = 1./(R+1i*2*pi*f*L+1./W./(1i*2*pi*f).^A);
Make_Model(Y_input, f, 'RL_CPE', any_sign_pars)
%% R_CPE
clear
syms R W A f
any_sign_pars=[];
Y_input = 1./(R+1./W./(1i*2*pi*f).^A);
Make_Model(Y_input, f, 'R_CPE', any_sign_pars)
%% Bridge
clear
syms W1 A1 W2 A2 R3 R4 R5 f
w=2*pi*f;
z1=1./(W1*(1i*w).^A1);
z2=1./(W2*(1i*w).^A2);
z3=R3;
z4=R4;
z5=R5;
Z=(z1.*z2.*z3 + z1.*z2.*z4 + z1.*z2.*z5 + z1.*z3.*z4 + z1.*z4.*z5 + z2.*z3.*z5 + z2.*z4.*z5 + z3.*z4.*z5)./...
   (z1.*z3 + z1.*z4 + z2.*z3 + z1.*z5 + z2.*z4 + z2.*z5 + z3.*z4 + z3.*z5);
Y_input=1./Z;
any_sign_pars=[];
Make_Model(Y_input, f, 'Bridge', any_sign_pars)
%% R_CPE_R_leak
clear
syms R W A R_l f
iw=2*pi*f*1i;
Z=R+1./(W*iw.^A);
Y_input=1./Z+1/R_l;
any_sign_pars=[];
Make_Model(Y_input, f, 'R_CPE_R_leak', any_sign_pars)
%% Lapicque
clear
syms R W A R_1 f
iw=2*pi*f*1i;
Y=1./R+W*iw.^A;
Y_input=1./(1./Y+R_1);
any_sign_pars=[];
Make_Model(Y_input, f, 'Lapique', any_sign_pars)
%% Multiple_R_CPE
clear
syms R1 W1 A1 R2 W2 A2 f
any_sign_pars=[];
Y_1 = 1./(R1+1./W1./(1i*2*pi*f).^A1);
Y_2 = 1./(R2+1./W2./(1i*2*pi*f).^A2);
Y_input=Y_1+Y_2;
Make_Model(Y_input, f, 'Multiple_R_CPE', any_sign_pars)
%% Randles
clear
syms R W A R1 C f
iw=2*pi*f*1i;
Z=R+1./(W*iw.^A);
Y=1./Z+(1i*2*pi*f*C);
Z=R1+1./Y;
Y_input=1./Z;
any_sign_pars=[];
Make_Model(Y_input, f, 'Randles', any_sign_pars)
%% Cole_Cole_FM
clear
syms R A R_1 f tau
iw=2*pi*f*1i;
Z=R*(1+1./(iw*tau).^A);
Y_input=1./Z+1/R_1;
any_sign_pars=[];
Make_Model(Y_input, f, 'Cole_Cole_FM', any_sign_pars)