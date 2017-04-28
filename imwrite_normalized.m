function imwrite_normalized(i, path)
img = double(i);
img = (img - min(min(img))) / (max(max(img)) - min(min(img)));
imwrite( img, path);

end