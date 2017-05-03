function [matched_1, matched_2] = match_features(pt1, pt2, ft1, ft2, choose, method)

switch method
    case {'knn'}
       [matched_1, matched_2] = match_features_knn(pt1, pt2, ft1, ft2, choose);
    case {'matlab'}
        [matched_1, matched_2] = match_features_matlab(pt1, pt2, ft1, ft2);
    otherwise
        error('Unexpected type in match_features')
end