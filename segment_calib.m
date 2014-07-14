function [ segm_img ] = segment_calib( img )
%SEGMENT_CALIB Funcion para segmentar la calibracion
%   Detailed explanation goes here

% Usar un threshold para tomar lo mas oscuro
threshold = 26;
bw = img < threshold;
% Quitar arbitrariamente un marco exterior de la imagen
[M, N] = size(img);
corte = ceil(0.15*min(M, N));
bw(1:corte, 1:N) = false;
bw(1:M, 1:corte) = false;
bw(1:M, N-corte:N) = false;
bw(M-corte:M, 1:N) = false;
% Usar apertura de area 2500
open_area = 2500;
bw2 = bwareaopen(bw, open_area);
% Usar dilatacion y erosion con un elemento de disco
eye_radius = 42;
elemento_estructural = strel('disk', eye_radius);
dil = imdilate(bw2, elemento_estructural);
ero = imerode(dil, elemento_estructural);
segm_img = ero;

end

