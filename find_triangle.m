function [ l1, l2, triangle] = find_triangle( cx, cy, points )
%FIND_TRIANGLE Encuentra el triangulo en el que se encuentra el punto
%   Devuelve las coords baricentricas del punto junto con los indices de 
%   los vertices del
%   triangulo al que pertenece en un arreglo de 3 y orientacion
%   antihoraria

% Mientras cx sea mayor llegar a la minima cota mayor

max_x = 4; 
if(points(max_x,1)+3 < cx)
    max_x = 7;
end
max_y = 1;
if(points(max_x-3+1,2)+3 < cy)
    max_y = 2;
end

x1 = points(max_x-3+max_y-1,1);
y1 = points(max_x-3+max_y-1,2);
x2 = points(max_x-3+max_y,1);
y2 = points(max_x-3+max_y,2);
x3 = points(max_x+max_y-1,1);
y3 = points(max_x+max_y-1,2);
x4 = points(max_x+max_y,1);
y4 = points(max_x+max_y,2);

% Usar coords baricentricas para saber en donde está
l1_1 = (y2 - y3)*(cx - x3) + (x3 - x2)*(cy - y3);
det = (y2 - y3)*(x1 - x3) + (x3 - x2)*(y1 - y3);
l1 = double(l1_1)/double(det);
l2_1 = (y3 - y1)*(cx - x3) + (x1 - x3)*(cy - y3);
l2 = double(l2_1)/double(det);
l3 = 1 - l1 - l2;
if ((l1 > 0) && (l3 > 0) && (l2>0))
    triangle = [max_x-3+max_y-1, max_x-3+max_y, max_x+max_y-1];
else
    triangle = [max_x-3+max_y, max_x+max_y, max_x+max_y-1];
    newx1 = x2;
    newy1 = y2;
    newx2 = x4;
    newy2 = y4;
    l1_1 = (newy2 - y3)*(cx - x3) + (x3 - newx2)*(cy - y3);
    det = (newy2 - y3)*(newx1 - x3) + (x3 - newx2)*(newy1 - y3);
    l1 = double(l1_1)/double(det);
    l2_1 = (y3 - newy1)*(cx - x3) + (newx1 - x3)*(cy - y3);
    l2 = double(l2_1)/double(det);

end

