function [matched_1, matched_2] = get_matching_SURF(I1, I2)

match_method = 'matlab';
thresh = -1;
radius = -1;
k = -1; 
bins = -1;

dct_method = {'matlab_SURF'};
ft_method = {'matlab'};
ft_mat_meth = {'SURF'};

dct_method = char(dct_method);
ft_method  = char(ft_method);
ft_mat_meth = char(ft_mat_meth);

pt1 = detect_pt(I1, thresh, radius, k, dct_method);
pt2 = detect_pt(I2, thresh, radius, k, dct_method);


[ft1, pt1] = describe_pt(I1, pt1, bins, ft_mat_meth, ft_method);
[ft2, pt2] = describe_pt(I2, pt2, bins, ft_mat_meth, ft_method);

[matched_1, matched_2] = match_features(pt1, pt2, ft1, ft2, 1, match_method);

end
