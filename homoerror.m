function err = homoerror( orig, predict)
    err=0;
    
    err=sum(((orig-predict).^2),2);
end