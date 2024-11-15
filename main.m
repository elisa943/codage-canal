% Clean 
clear; close all; clc

u=[1 1 0 1 0];
trellis=poly2trellis(3,[7,5],7);
c=cc_encode(u,trellis);
y=(c*2)-1;
dc=viterbi_decode(y,trellis);
%graph(1,1,:)=[0 20];
%graph(1,2,:)=[graph(1,1,1)+poids(y,trellis.outputs(1,1)) 1];
%graph(3,2,:)=[graph(1,1,1)+poids(y,trellis.outputs(1,2)) 1];