function Lc=demod_BPSK(y)
    constellation_coor=zeros(2,2);
    for k=1:2
        constellation_coor(1,k)=real(exp((2*pi*(k-1)/2)*1i));
        constellation_coor(2,k)=imag(exp((2*pi*(k-1)/2)*1i));
    end

    n=length(y);
    y_coor=zeros(2,n);
    Lc=zeros(1,n);
    for i=1:n
        y_coor(1,i)=real(y(i));
        y_coor(2,i)=imag(y(i));
    end
    for i=1:n
        minimum=norm(y_coor(:,i)-constellation_coor(:,1));
        indice=1;
        if (norm(y_coor(:,i)-constellation_coor(:,2))<minimum)
            minimum=norm(y_coor(:,i)-constellation_coor(:,2));
            indice=2;
        end
        Lc(i)=indice-1;
    end
end