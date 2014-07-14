function [ mapped_center ] = map_calib( cx, cy, calib, S)
%MAP_CALIB Mapea un centro segun la calibracion obtenida
%   Detailed explanation goes here

% Valores por defecto
l1 = 1;
l2 = 0;
triangle = [1, 2, 3];
[l1, l2, triangle] = find_triangle(cx, cy, calib);
l3 = 1 - l1 - l2;
map_a = S(triangle(1), :);
map_b = S(triangle(2), :);
map_c = S(triangle(3), :);
% Interpolacion por coordenadas baricentricas
attention_center_x = floor(map_a(1)*l1 + map_b(1)*l2 + map_c(1)*l3);
attention_center_y = floor(map_a(2)*l1 + map_b(2)*l2 + map_c(2)*l3);
mapped_center = [attention_center_x, attention_center_y];

end

