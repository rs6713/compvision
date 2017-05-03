function pt = detect_pt(I, thresh, radius, k, method)

switch method
    case {'harris'}
       pt = harris_corner(I, thresh, radius, k);
    case {'matlab_harris'}
       pt = detectHarrisFeatures(I);
       pt = pt.Location;
    case {'matlab_BRISK'}
       pt = detectBRISKFeatures(I);
       pt = pt.Location;
    case {'matlab_FAST'}
       pt = detectFASTFeatures(I);
       pt = pt.Location;
    case {'matlab_MSER'}
       pt = detectMSERFeatures(I);
       pt = pt.Location;
    case {'matlab_SURF'}
       pt = detectSURFFeatures(I);
%        pt = pt.Location;
    otherwise
        error('Unexpected type in detect_pt')

end