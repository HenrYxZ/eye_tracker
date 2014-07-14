function [ output_img ] = draw_cross( img, cross_pos )
%DRAW_CROSS Summary of this function goes here
%   Detailed explanation goes here
if(cross_pos(1) < 0)
    sprintf( 'Negative cross position at [%d %d]', cross_pos(1), cross_pos(2))
    cross_pos(1) = 1;
end
if(cross_pos(2) < 0)
    sprintf( 'Negative cross position at [%d %d]', cross_pos(1), cross_pos(2))
    cross_pos(2) = 1;
end
output_img = img;
output_img(cross_pos(2)-3:cross_pos(2)+3, cross_pos(1), 3) = 200;
output_img(cross_pos(2)-3:cross_pos(2)+3, cross_pos(1), 2) = 10;
output_img(cross_pos(2)-3:cross_pos(2)+3, cross_pos(1), 1) = 10;
output_img(cross_pos(2), cross_pos(1)-3:cross_pos(1)+3, 3) = 200;
output_img(cross_pos(2), cross_pos(1)-3:cross_pos(1)+3, 2) = 10;
output_img(cross_pos(2), cross_pos(1)-3:cross_pos(1)+3, 1) = 10;

end

