function [matched_1, matched_2] = match_features(pt1, pt2, ft1, ft2)

%nn_ft = knnsearch(ft2, ft1);
%nn_ft = knnsearch(pt2, pt1);
%pt2_matched = pt2(nn_ft,:);

[idxs, metric] = matchFeatures(ft1, ft2);
% metric_sort = sort(metric, 'descend');
% mask = metric > metric_sort(10);
% idxs = idxs(mask,:);
pt1_matched = pt1(idxs(:,1),:);
pt2_matched = pt2(idxs(:,2),:);

dist = mean((pt1_matched - pt2_matched).^2, 2);
dist_median = median(dist);

matched_1 = pt1_matched;
matched_2 = pt2_matched;

% matched_1 = pt1_matched(dist < dist_median, :);
% matched_2 = pt2_matched(dist < dist_median, :);
