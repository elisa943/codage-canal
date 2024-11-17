function y=canal(x,p)
    n=length(x);
    r=-2*(rand(1,n)<=p)+1;
    y=real(x).*r+imag(x);
end