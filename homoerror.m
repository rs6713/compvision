function err = homoerror( orig, predict)
    err=0;
    
    err=sum( sqrt(sum((orig-predict).^2,2)),1)/length(orig);
end