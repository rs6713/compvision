function prevCoords= reverseproject(coords, homograph)
    prevCoords=zeros(size(coords,1),2);
    for pt=1:size(coords,1)
        [coords(pt,:),1]
        inv(homograph)
        temp=[coords(pt,:),1]*inv(homograph);
        temp=temp/temp(3);
        prevCoords(pt,:)=temp(1:2);
    end
end