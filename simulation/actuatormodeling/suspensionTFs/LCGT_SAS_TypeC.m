function LCGT_SAS_TypeC();
%LCGT-SAS model (Type-C)
g=9.8;

%Seismic raw data
n=160;
fp=fopen('../Noises/kamiokaNoisy.txt','r');
[Data,count]=fscanf(fp,'%f',[2,n]);
fclose(fp);
for I=1:n
    x(I)=Data(1,I);
    y(I)=Data(2,I);
end
%Interpolation of data
N=10000;
for I=1:N
    freq(I)=I/N*100;
end
    seismic=interp1(x,y,freq);

figure(10)
loglog(freq,seismic)

% Stage0
w0=2*pi*5; %2->5
m0=200; %200
Q0=3;
k0=m0*w0^2;

% Stage1
w1=2*pi*4.5; %2->4.5
m1=m0;
Q1=3;
k1=m1*w1^2;

% Stage2
w2=2*pi*4; %4
m2=m0;
Q2=3;
k2=m2*w2^2;

% MB
w3=sqrt(g/0.03); %0.03
m3=1;
Q3=1000;
k3=m3*w3^2;

% IM
w4=sqrt(g/0.25);
m4=0.71;
Q4=1000;
k4=m4*w4^2;

C=sqrt(m4*k4)/0.5

% TM
w5=sqrt(g/0.25);
m5=0.47;
Q5=1000;
k5=m5*w5^2;

%Equation of motion
for I=1:N
    w=2*pi*freq(I);
    M=[
    -m0*w^2 + K(m0,k0,w,Q0) + K(m1,k1,w,Q1), -K(m1,k1,w,Q1), 0, 0, 0, 0
    -K(m1,k1,w,Q1), -m1*w^2 + K(m1,k1,w,Q1) + K(m2,k2,w,Q2), -K(m2,k2,w,Q2), 0, 0, 0
    0, -K(m2,k2,w,Q2), -m2*w^2 + K(m2,k2,w,Q2) + K(m3,k3,w,Q3) + K(m4,k4,w,Q4), -K(m3,k3,w,Q3), -K(m4,k4,w,Q4), 0
    0, 0, -K(m3,k3,w,Q3), -m3*w^2 + K(m3,k3,w,Q3) + C*1i*w, -C*1i*w, 0
    0, 0, -K(m4,k4,w,Q4), -C*1i*w, -m4*w^2 + K(m4,k4,w,Q4) + K(m5,k5,w,Q5) + C*1i*w, -K(m5,k5,w,Q5)
    0, 0, 0, 0, -K(m5,k5,w,Q5), -m5*w^2 + K(m5,k5,w,Q5)
    ];
    Xg=[K(m0,k0,w,Q0);0;0;0;0;0];
    X=M \ Xg;
    X2(I)=X(3);
    X5(I)=X(6);
    Gnd(I)=seismic(I);
    Disp(I)=seismic(I)*abs(X(6));
end

%Integration
Xi_X=0;
Xi_V=0;
Xrms(N)=0;
Vrms(N)=0;
for I=1:N-1
    if isnan(Disp(N-I+1)) | isnan(Disp(N-I))
        continue;
    end
    Xi_X=Xi_X+(Disp(N-I+1)^2 + Disp(N-I)^2)/2*(freq(N-I+1)-freq(N-I));
    Xi_V=Xi_V+((Disp(N-I+1)*2*pi*freq(N-I+1))^2 + (Disp(N-I)*2*pi*freq(N-I))^2)/2*(freq(N-I+1)-freq(N-I));
    Xrms(N-I)=sqrt(Xi_X);
    Vrms(N-I)=sqrt(Xi_V);
end

Xrms(5)*1e6 % [micron] @0.01Hz
Xrms(50)*1e6 % [micron] @0.1Hz
Vrms(5)*1e6 % [micron/s] @0.01Hz 
Vrms(50)*1e6 % [micron/s] @0.1Hz

figure();
subplot(2,2,2), loglog(freq,abs(X5),freq,abs(X2)), xlabel('Frequency [Hz]'), ylabel('Amplitude'), grid on, grid minor,
 axis([0.01, 20, 0.001, 10]), set(gca,'ytick',[0.001 0.01 0.1 1 10]);
 legend('X6/Xg','X2/Xg');
subplot(2,2,4), semilogx(freq,angle(X5)*180/pi,freq,angle(X2)*180/pi),
 xlabel('Frequency [Hz]'), ylabel('Phase [deg]'), grid on, grid minor, axis([0.01, 20, -180, 180]),
 set(gca,'ytick',[-180 -120 -60 0 60 120 180]);
subplot(2,2,[1 3]), loglog(freq,Gnd,freq,Disp,'r',freq,Xrms,':m',freq,Vrms,':g'), xlabel('Frequency [Hz]'), ylabel('Displacement [m/rtHz]'),
 grid on, grid minor, axis([0.01, 20, 1e-22, 0.0001]), set(gca,'ytick',[1e-22 1e-20 1e-18 1e-16 1e-14 1e-12 1e-10 1e-8 1e-6 1e-4]);
 legend('Ground','Testmass','RMS [m]','RMS [m/s]');

dlmwrite('TypeC_seismic_TF.txt',[freq;abs(X5);angle(X5)*180/pi]', '\t'); 

end

function a =  K(m,k,w,Q);
    a = k - i*w/Q*sqrt(k/m);
end