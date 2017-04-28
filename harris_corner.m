
function [x, y] = harris_corner(I, thresh)

I = double(I);
I = (I - min(min(I))) / (max(max(I)) - min(min(I)));
I = I - 0.5;
imwrite_normalized(I, './out/q12_1_orig.png')

%Approximate derivation
derivative_filter = [-1 0 1];
blur_filter = [0.03 0.105 0.222 0.286 0.222 0.105 0.03];

Ix = conv2(derivative_filter, [1], I, 'same');
imwrite_normalized(Ix, './out/q12_2_Ix.png')

Iy = conv2([1], derivative_filter, I, 'same');
imwrite_normalized(Iy, './out/q12_3_Iy.png')

%lambda1 * lambda2 - k (lambda1 + lambda2)²
k = 0.04;
Ix2 = conv2(blur_filter, blur_filter, Ix.*Ix, 'same');
imwrite_normalized(Ix2, './out/q12_4_Ix2_blur.png')
Iy2 = conv2(blur_filter, blur_filter, Iy.*Iy, 'same');
imwrite_normalized(Iy2, './out/q12_4_Iy2_blur.png')
Ixy = conv2(blur_filter, blur_filter, Ix.*Iy, 'same');
imwrite_normalized(Ixy, './out/q12_4_Ixy_blur.png')

Mc = Ix2 .* Iy2 - Ixy .* Ixy - k * (Ix2 + Iy2).^2;

imwrite_normalized(Mc, './out/q12_5_Mc.png')

%Nonmaximum supression
%Used parts from http://web.engr.illinois.edu/~slazebni/spring16/harris.m
cim = Mc;
radius = 3;

sze = 2*radius+1;
mx = ordfilt2(cim,sze^2,ones(sze));
imwrite_normalized(mx, './out/q12_6_Max.png');
cim = (cim==mx)&(cim>thresh);

[x,y] = find(cim);

imshow(normalize_img(I))
hold on
plot(y,x,'ys')
saveas(gcf, './out/q12_6_Out.png')

end