function c=cc_encode(u,trellis)
    % Paramètres 
    K = length(u);
    ns = log2(trellis.numOutputSymbols);
    m = log2(trellis.numStates);
    L = K + m;
    c = zeros(1,ns*L);
    etat = 0;
    for i=0:K-1
        sortie=int2bit(trellis.outputs(etat+1,u(i+1)+1).',2);
        c(2*i+1)=sortie(1);
        c(2*(i+1))=sortie(2);
        etat=trellis.nextStates(etat+1,u(i+1)+1);
    end
    for j=K:K+2
        sortie=int2bit(trellis.nextStates(etat+1,1),2);
        c(2*j+1)=sortie(1);
        c(2*(j+1))=sortie(2);
        etat=trellis.outputs(etat+1,1);
    end
end