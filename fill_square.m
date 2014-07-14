function [output] = fill_square( img, cx, cy )
%FILL_SQUARE Summary of this function goes here
%   Detailed explanation goes here
output = img;
output(cy, cx) = img(cy, cx) + 1;
output(cy, cx+1) = img(cy, cx+1) + 1;
output(cy+1, cx) = img(cy+1, cx) + 1;
output(cy+1, cx+1) = img(cy+1, cx+1) + 1;
end

