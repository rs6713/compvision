%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Final Year Machine Learning for Computer Vision CW 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Notes
%Matlab uses 1-indexing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;
imgDir = 'imgsreal/';
close ALL;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Import all images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgList = dir([imgDir, '*.jpg']);%[imgDir, '*.png']
n = length(imgList);

%% Allocate memory
info = imfinfo([imgDir, imgList(1).name]);
images = zeros(info.Height, info.Width, 3, 2, 'uint8');%2 SHOULD BE N

%% read images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ARTIFICIAL IMAGE NO REDUCE
for i = 1:n%2 SHOULD BE N
    images(:,:,:,i) = imread([imgDir, imgList(i).name]);
end

%pos   = [120 248;195 246;195 312;120 312];
%color = {'red','white','green','magenta'};
%RGB = insertMarker(RGB,pos,'x','color',color,'size',10);
%[x,y]=ginput(1);
noImages=size(images,4);
oImageCoords2=manualcollect(images, imgDir, imgList)
oImageCoords=zeros(2,17,2);
for i= 1:size(oImageCoords,1)
    for u=1:size(oImageCoords,2)
      oImageCoords(i,u,:)=[(700*i)+50*u, 860];  
    end
end

%oImageCoords=autocollect(images,0.002,16)%threshold, noPts
%Display Images and get coords of all clicks
%{
figure;
title(sprintf('Images from %s dataset.',imgDir));
for L= 1: size(images,4) %length(tree.leaf)
	subplot(1,5,L);
	imshow(imgList(L).name);
	title(sprintf('Image %i',L));
end
[x,y]=ginput;

imageCoords=[x,y];
%}

%totalPts=size(oImageCoords,2);
noPtsPerImg=size(oImageCoords,2);%totalPts/noImages;
%{
oImageCoords=zeros(noImages, noPtsPerImg,2);
for idx= 1: noImages
    oImageCoords(idx,:,:)= imageCoords([idx:noImages:totalPts],:);
end
%}

%homograph=(noImages-1,
%Homography matrix estimation
for img=1:noImages-1
    homoshow=homograph(squeeze(oImageCoords(img,:,:)),squeeze(oImageCoords(img+1,:,:)));
    %{
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
    %}
end

%%Plot present and next dots on same img

tit=sprintf('Images with next(blue) and current coords (green) from %s dataset.',imgDir);
figure('name',tit,'numbertitle','off')
for img=1:noImages-1
    currimgcoords(:,:)=squeeze(oImageCoords(img,:,:))
    nextimgcoords(:,:)=squeeze(oImageCoords(img+1,:,:))
    subplot(1,2,img);
    imshow(imgList(img).name);
    hold on;
    for pt=1:size(currimgcoords,1)
        plot(currimgcoords(pt,1),currimgcoords(pt,2),'g.','MarkerSize',10)
        text(currimgcoords(pt,1),currimgcoords(pt,2),int2str(pt),'Color','red')
        plot(nextimgcoords(pt,1),nextimgcoords(pt,2),'b.','MarkerSize',10)
        text(nextimgcoords(pt,1),nextimgcoords(pt,2),int2str(pt),'Color','red')
    end
    title(sprintf('Image %i',img));
end

%Fundamental matrix estimation
for img=1:noImages-1
    F = estimateFundamentalMatrix(squeeze(oImageCoords(img,:,:)),squeeze(oImageCoords(img+1,:,:)))
end

calcimgcoords=zeros(noPtsPerImg,2);
pastimgcoords=zeros(noPtsPerImg,2);
%Calculate inverse coordinates from homography matrix
for img=1:noImages-1
    pastimgcoords(:,:)=squeeze(oImageCoords(img,:,:))
    calcimgcoords(:,:)=reverseproject(squeeze(oImageCoords(img+1,:,:)),homoshow) 
    %{
    res=zeros(noPtsPerImg,2);
    for pt=1:noPtsPerImg
        pastimgcoords(pt,:)=squeeze(oImageCoords(img-1,pt,:));
        currentimgcoords(pt,:)=squeeze(oImageCoords(img,pt,:));
        temp=[squeeze(oImageCoords(img,pt,:)).',1]*inv(homoshow);
        temp=temp/temp(3);
        res(pt,:)=temp(1:2);
    end
    %}
end


%Calculate error HA
homoerror( calcimgcoords, pastimgcoords)

%Calculate epipolar line on image given fundamental matrix between two
%matrices
lines = epipolarLine(F,squeeze(oImageCoords(img,:,:)));
%figure;
%A * x + B * y + C = 0.

tit='Epipolar lines obtained from first image coords';
figure('name',tit,'numbertitle','off')
imshow(imgList(2).name);
hold on;
for L= 1: size(lines,1) %length(tree.leaf)
    [0,-1*lines(L,3)/lines(L,2),info.Width, info.Width*-1*lines(L,1)/lines(L,2)];
    plot([0,info.Width],[-1*lines(L,3)/lines(L,2), info.Width*-1*lines(L,1)/lines(L,2)],'Color','r','LineWidth',2);
end
hold off;


[f,inliers] = estimateFundamentalMatrix(squeeze(oImageCoords(img,:,:)),squeeze(oImageCoords(img+1,:,:)),'NumTrials',4000);
figure;
subplot(121);
I=imread(imgList(2).name);
imshow(I);
title('Inliers and Epipolar Lines in First Image'); hold on;
plot(squeeze(oImageCoords(img,inliers,1)),squeeze(oImageCoords(img,inliers,2)),'go')
epiLines = epipolarLine(f',squeeze(oImageCoords(img+1,inliers,:)));
points = lineToBorderPoints(epiLines,size(I));
line(points(:,[1,3])',points(:,[2,4])');

%Question 2 1b
tit=sprintf('Images with correct(blue) and predicted orig coords (green), old(red) from %s dataset.',imgDir);
figure('name',tit,'numbertitle','off')
%figure;
%title(sprintf('Images with correct(blue) and predicted orig coords (green) from %s dataset.',imgDir));

for img=1:noImages-1
    homoshow=homograph(squeeze(oImageCoords(img,:,:)),squeeze(oImageCoords(img+1,:,:)));
    pastimgcoords(:,:)=squeeze(oImageCoords(img+1,:,:))
    calcimgcoords(:,:)=reverseproject(squeeze(oImageCoords(img,:,:)),homoshow) 
    
    subplot(1,2,img);
    imshow(imgList(img).name);
    
    hold on;
    for pt=1:size(calcimgcoords,1)
        plot(calcimgcoords(pt,1),calcimgcoords(pt,2),'g.','MarkerSize',10);
        text(calcimgcoords(pt,1),calcimgcoords(pt,2),int2str(pt),'Color','red');
        plot(pastimgcoords(pt,1),pastimgcoords(pt,2),'b.','MarkerSize',10);
        text(pastimgcoords(pt,1),pastimgcoords(pt,2),int2str(pt),'Color','red');

    end
    title(sprintf('Image %i',img));
    hold off;
    trans=zeros(2);
    ang=0;
    scale=0;
    [trans, ang, scale] = analyse(homoshow)
end


    
    %{
    res=zeros(noPtsPerImg,2);
    for pt=1:noPtsPerImg
        pastimgcoords(pt,:)=squeeze(oImageCoords(img-1,pt,:));
        currentimgcoords(pt,:)=squeeze(oImageCoords(img,pt,:));
        temp=[squeeze(oImageCoords(img,pt,:)).',1]*inv(homoshow);
        temp=temp/temp(3);
        res(pt,:)=temp(1:2);
    end
    %}

%Manual














    

