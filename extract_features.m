%
function ft = extract_features(I, x, y, bins)

ft = zeros(size(x,1),bins);
for i = 1:size(x, 1)
    xi = x(i);
    yi = y(i);
    if (xi > 16) & (xi < size(I, 1) - 16) ...
     & (yi > 16) & (yi < size(I, 2) - 16)
        %disp([i, yi, xi]);
        patch = I(xi-15:xi+16, yi-15:yi+16);

        ft(i, :) = histcounts(patch, 0:256/bins:256);
    else
        %disp([i, yi, xi]);
    end
end
%ft( ~any(ft, 2), :) = [];

end