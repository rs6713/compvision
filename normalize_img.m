function img = normalize_img(i)
img = double(i);
img = (img - min(min(img))) / (max(max(img)) - min(min(img)));

end