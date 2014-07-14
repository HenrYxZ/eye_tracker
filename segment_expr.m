function [ segm_img ] = segment_expr( img )
%SEGMENT_EXPR Summary of this function goes here
%   Se estimó a mano un radio promedio de 70 pixeles

% Se podría mejorar esto usando otsu?
threshold = 45;
bw = img < threshold;
% Quitar arbitrariamente un marco exterior de la imagen
% en este caso el 20%
[M, N] = size(img);
corte = ceil(0.15*min(M, N));
bw(1:corte, 1:N) = false;
bw(1:M, 1:corte) = false;
bw(1:M, N-corte:N) = false;
bw(M-corte:M, 1:N) = false;
% Usar apertura de area 8000 ya que se estimo un radio 70 luego el area
% en la forma pi*r^2
open_area = 8000;
bw2 = bwareaopen(bw, open_area);
% Usar dilatación y erosión con un elemento de disco
% eye_radius = 70;
% elemento_estructural = strel('disk', eye_radius);
% dil = imdilate(bw2, elemento_estructural);
% ero = imerode(dil, elemento_estructural);
% segm_img = ero;
segm_img = bw2;
end

