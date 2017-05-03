function [ft, pt] = describe_pt(I, pt, bins, matlab_method,method)

switch method
    case {'hist'}
       [ft, pt] = describe_pt_hist(I, pt, bins);
    case {'matlab'}
        if strcmp(matlab_method,'hist')
            [ft, pt] = describe_pt_hist(I, pt, bins);
        else
            [ft, pt] = extractFeatures(I, pt, 'method', matlab_method);
        end
    otherwise
        error('Unexpected type in describe_pt')
end