%%Series RLC
clear all;
syms R L C W alpha tau iw;
Y=exp(iw*tau)/(R+iw*L+1/(iw*C));
Make_Model(Y, iw, 'M_RLC_rl', tau, 0);

%%Series RL-CPE
clear all;
syms R L C W alpha tau iw;
Y=exp(iw*tau)/(R+iw*L+1/(W*iw^alpha));
Make_Model(Y, iw, 'M_RL_CPE_rl', tau, 0);

%%Fricke
clear all;
syms R L C W alpha tau iw R_leak;
Z=R+1/(W*iw^alpha);
Y=1/Z+1/R_leak;
Y=exp(iw*tau)/(1/Y+iw*L);
Make_Model(Y, iw, 'M_Fricke_Morse_rl', tau, 0);

%%Lapique
clear all;
syms R L C W alpha tau iw R_leak;
Y=1/R_leak+(W*iw^alpha);
Z=1/Y+R+iw*L;
Y=exp(iw*tau)/(Z);
Make_Model(Y, iw, 'M_Lapique_rl', tau, 0);

%%Randles
clear all;
syms R_p L C W alpha tau iw R_s;
Z=R_p+1/(W*iw^alpha);
Y=iw*C+1/Z;
Z=1/Y+R_s+iw*L;
Y=exp(iw*tau)/(Z);
vars=symvar(Y); idx=find(vars==tau);
Make_Model(Y, iw, 'M_Randles_rl', tau, 0);
%% M_Bridge_rl
clear
syms W1 A1 W2 A2 R3 R4 R5 iw L tau
z1=1./(W1*(iw).^A1);
z2=1./(W2*(iw).^A2);
z3=R3;
z4=R4;
z5=R5;
Z=(z1.*z2.*z3 + z1.*z2.*z4 + z1.*z2.*z5 + z1.*z3.*z4 + z1.*z4.*z5 + z2.*z3.*z5 + z2.*z4.*z5 + z3.*z4.*z5)./...
   (z1.*z3 + z1.*z4 + z2.*z3 + z1.*z5 + z2.*z4 + z2.*z5 + z3.*z4 + z3.*z5);
Y=1./Z;
Z=1/Y+iw*L;
Y=exp(iw*tau)/(Z);
vars=symvar(Y); idx=find(vars==tau);
Make_Model(Y, iw, 'M_Bridge_rl', tau, 0);
%% Multiple_R_CPE_rl
clear
syms R1 W1 A1 R2 W2 A2 iw L tau
any_sign_pars=[];
Y_1 = 1./(R1+1./W1./(iw).^A1);
Y_2 = 1./(R2+1./W2./(iw).^A2);
Y=Y_1+Y_2;
Z=1/Y+iw*L;
Y=exp(iw*tau)/(Z);
vars=symvar(Y); idx=find(vars==tau);
Make_Model(Y, iw, 'M_Multiple_R_CPE_rl', tau, 0);
%% Cole_Cole_FM_rl
clear
syms R A R_1 f iw L tau
Z=R*(1+1./(iw*tau).^A);
Y=1./Z+1/R_1;
Z=1/Y+iw*L;
Y=exp(iw*tau)/(Z);
vars=symvar(Y); idx=find(vars==tau);
Make_Model(Y, iw, 'M_Cole_Cole_FM_rl', tau, 0);