function x=mod_BPSK(c)
    constellation=zeros(1,2);
    for k=1:2
        constellation(k)=exp((2*pi*(k-1)/2)*1i);
    end
    nb=length(c);
    x=zeros(1,nb);
    for k=1:nb
        x(k)=constellation(c(k)+1);
    end
end