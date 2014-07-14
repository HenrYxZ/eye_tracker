function [ output ] = draw_circle( img, cx, cy, r )
%DRAW_CIRCLE Hacer un circulo verde en la imagen
%   Detailed explanation goes here

output = img;
for step = 0:0.01:2*pi
    x = cx + floor(r*cos(step));
    y = cy + floor(r*sin(step));
    output(y, x, 2) = 200;
    output(y, x, 1) = 200;
    output(y, x, 3) = 200;
end
% output(cy, cx, 3) = 200;
% output(cy+1, cx, 3) = 200;
% output(cy, cx+1, 3) = 200;
% output(cy+1, cx+1, 3) = 200;

end

