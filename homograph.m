%Takes input two lists corresponding coordinates
function h= homograph(image1, image2)
    image1;
    image2;
    a=zeros(length(image1)*2,9);
    for pt=1:length(image1)
        xa=image1(pt,1);
        xb=image2(pt,1);
        ya=image1(pt,2);
        yb=image2(pt,2);
        
        a((pt-1)*2+1,:)=[-xb,-yb,-1,0,0,0,xa*xb,xa*yb,xa];
        a((pt-1)*2+2,:)=[0,0,0,-xb,-yb,-1,ya*xb,ya*yb,ya];
    end
    a
    b=a.'*a;
    [u,s,v]=svd(b);
    realh=(v(1:9,9)/v(9,9));%v(1:9,9)/v(9,9);
    
    h=reshape(realh,3,3);%[realh(1:3).';realh(4:6).';realh(7:9).']
    
    
end