function [matched_1, matched_2] = match_features_matlab(pt1, pt2, ft1, ft2)

[idxs, metric] = matchFeatures(ft1, ft2);

pt1_matched = pt1(idxs(:,1),:);
pt2_matched = pt2(idxs(:,2),:);

matched_1 = pt1_matched;
matched_2 = pt2_matched;
