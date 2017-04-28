
function oImageCoords= autocollect(images, threshold, noPts)
    noImages=size(images,4);
    imageCoords=zeros(noImages*noPts,2);
    for i=1:noImages
        
        img=squeeze(mean(squeeze(images(:,:,:,i)),3));
        [x,y]=harris_corner(img,threshold);
        imageCoords(i:noImages:(noPts*noImages),1)=x(1:noPts);
        imageCoords(i:noImages:(noPts*noImages),2)=y(1:noPts);
    end
    imageCoords
    %%%%%%%%%%%%%%%FAKE VALS
    totalPts=size(imageCoords,1);
    noPtsPerImg=totalPts/noImages;
    oImageCoords=zeros(noImages, noPtsPerImg,2);
    for idx= 1: noImages
        oImageCoords(idx,:,:)= imageCoords([idx:noImages:totalPts],:);
    end
end