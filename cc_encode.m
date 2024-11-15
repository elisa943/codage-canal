function c=cc_encode(u,trellis)
    n=length(u);
    m=4;
    c=zeros(1,2*n+m);
    etat=0;
    for i=0:n-1
        sortie=int2bit(trellis.nextStates(etat+1,u(i+1)+1).',2);
        c(2*i+1)=sortie(1);
        c(2*(i+1))=sortie(2);
        etat=trellis.outputs(etat+1,u(i+1)+1);
    end
    for j=n:n+1
        sortie=int2bit(trellis.nextStates(etat+1,1),2);
        c(2*i+1)=sortie(1);
        c(2*(i+1))=sortie(2);
        etat=trellis.outputs(etat+1,1);
    end
end