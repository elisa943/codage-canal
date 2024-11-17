% Clean 
clear; close all; clc

% Rapport signal a bruit
eb_n0_dB = -2:0.5:8;
eb_n0 = 10.^(eb_n0_dB/10);
sigma2 = 1./(eb_n0);
Th = qfunc(sqrt(2*eb_n0));

%Construction des trellis
trell=poly2trellis(3,[7,5],7);
%trell=cat(2,trell,poly2trellis(3,[5,7]));
%trell=cat(2,trell,poly2trellis(4,[13,15]));
%trell=cat(2,trell,poly2trellis(3,[133,171]));

taux=zeros(4,length(sigma2));
for j=1:1 %4
    for k=1:length(sigma2)
        nb_errors=0;
        sigma=sigma2(k);
        w=0;
        while nb_errors<100
            u=randi([0 1],1,1024);
            
            %Encodeur C
            trellis=trell(j);
            c=cc_encode(u,trellis);
            
            %BPSK
            x=mod_BPSK(c);
            
            %Canal
            p=exp(-1/(2*sigma))/(sqrt(2*pi*sigma));
            y=canal(x,p);
            
            %Demod PSK
            Lc=demod_BPSK(y);
            
            %Decodeur de C
            d=(Lc*-2)+1;
            uf=viterbi_decode(d,trellis);
            nb_errors=nb_errors+sum(abs(uf(1:length(u))-u));
            w=w+1;
        end
        disp(k);
        taux(j,k)=nb_errors/(w*length(u));
    end
end

figure;
semilogy(eb_n0_dB,taux(1,:));
hold;
%semilogy(eb_n0_dB,taux(2,:));
%semilogy(eb_n0_dB,taux(3,:));
%semilogy(eb_n0_dB,taux(4,:));
semilogy(eb_n0_dB,Th);
%legend("(2,3)","(5,7)","(13,15)","(133,171)","Theorique")