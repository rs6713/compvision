%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Final Year Machine Learning for Computer Vision CW 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Notes
%Matlab uses 1-indexing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;
imgDir = 'tsukuba/';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Import all images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgList = dir([imgDir, '*.ppm']);%[imgDir, '*.png']
n = length(imgList);

%% Allocate memory
info = imfinfo([imgDir, imgList(1).name]);
images = zeros(info.Height, info.Width, 3, 2, 'uint8');%2 SHOULD BE N

%% read images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ARTIFICIAL IMAGE NO REDUCE
for i = 1:3:5%2 SHOULD BE N
    images(:,:,:,(i-1)/3+1) = imread([imgDir, imgList(i).name]);
end

%pos   = [120 248;195 246;195 312;120 312];
%color = {'red','white','green','magenta'};
%RGB = insertMarker(RGB,pos,'x','color',color,'size',10);
%[x,y]=ginput(1);

%Display Images and get coords of all clicks
figure;
title(sprintf('Images from %s dataset.',imgDir));
for L= 1: size(images,4) %length(tree.leaf)
	subplot(1,5,L);
	imshow(imgList(L).name);
	title(sprintf('Image %i',L));
end
[x,y]=ginput;

imageCoords=[x,y];

imageCoords=[253.905405405405,99.5270270270271;241.797297297297,97.7972972972973;297.148648648649,104.716216216216;283.310810810811,109.905405405405;245.256756756757,135.851351351351;229.689189189189,141.040540540541;285.040540540541,139.310810810811;272.932432432433,141.040540540541;217.581081081081,156.608108108108;200.283783783784,158.337837837838;305.797297297297,180.824324324324;288.500000000000,187.743243243243;366.337837837838,192.932432432433;359.418918918919,189.472972972973;369.797297297297,230.986486486487;359.418918918919,234.445945945946;336.932432432433,234.445945945946;328.283783783784,232.716216216216;99.9594594594594,255.202702702703;89.5810810810812,256.932432432433;234.878378378378,258.662162162162;226.229729729730,256.932432432433;182.986486486486,186.013513513514;169.148648648649,187.743243243243;155.310810810811,70.1216216216217;150.121621621622,73.5810810810812;42.8783783783783,47.6351351351352;48.0675675675677,56.2837837837839;30.7702702702702,38.9864864864866;23.8513513513515,38.9864864864866;167.418918918919,26.8783783783784;160.500000000000,30.3378378378378;312.716216216216,52.8243243243244;314.445945945946,54.5540540540541];


noImages=size(images,4);
totalPts=size(imageCoords,1);
noPtsPerImg=totalPts/noImages;
oImageCoords=zeros(noImages, noPtsPerImg,2);
for idx= 1: noImages
    oImageCoords(idx,:,:)= imageCoords([idx:noImages:totalPts],:);
end

%Homography matrix estimation
for img=1:noImages-1
    a=zeros(noPtsPerImg*2,9);
    for pt=1:noPtsPerImg
        xa=oImageCoords(img,pt,1);
        xb=oImageCoords(img+1,pt,1);
        ya=oImageCoords(img,pt,2);
        yb=oImageCoords(img+1,pt,2);
        
        a((pt-1)*2+1,:)=[-xb,-yb,-1,0,0,0,xa*xb,xa*yb,xa];
        a((pt-1)*2+2,:)=[0,0,0,-xb,-yb,-1,ya*xb,ya*yb,ya];
    end
    b=a.'*a;
    [u,s,v]=svd(b);
    h=v(1:9,1)/v(9,1);
    realh=[h(1:3).';h(4:6).';h(7:9).'];
end


%Fundamental matrix estimation
squeeze(oImageCoords(img,:,:))
for img=1:noImages-1
    F = estimateFundamentalMatrix(squeeze(oImageCoords(img,:,:)),squeeze(oImageCoords(img+1,:,:)))
end


%Calculate inverse coordinates from homography matrix
for img=2:noImages
    res=zeros(noPtsPerImg,2);
    for pt=1:noPtsPerImg
        pastimgcoords=squeeze(oImageCoords(img-1,pt,:))
        currentimgcoords=squeeze(oImageCoords(img,pt,:))
        temp=[squeeze(oImageCoords(img,pt,:)).',1]*inv(realh);
        temp=temp/temp(3)
        res(pt,:)=temp(1:2)
    end
end

%Calculate error HA

%Calculate epipolar line on image given fundamental matrix between two
%matrices
lines = epipolarLine(F,squeeze(oImageCoords(img,:,:)));
figure;
%A * x + B * y + C = 0.
title('Epipolar lines obtained from first image coords');
imshow(imgList(2).name);
hold on;
info.Width
info.Height
for L= 1: size(lines,1) %length(tree.leaf)
    [0,-1*lines(L,3)/lines(L,2),info.Width, info.Width*-1*lines(L,1)/lines(L,2)]
    plot([0,info.Width],[-1*lines(L,3)/lines(L,2), info.Width*-1*lines(L,1)/lines(L,2)],'Color','r','LineWidth',2)
end
hold off;



    

