%% Limpiar
clear all
close all

%% Abrir video de calibracion
mov=VideoReader('calib1.mpg');
vidFrames=read(mov);
nFrames=mov.NumberOfFrames;

%% Inicialización de variables de video de segmentacion
segm_video = false(mov.Height, mov.Width, nFrames);
calib_video = zeros(mov.Height, mov.Width, 3, nFrames, 'uint8');
calib_hist = zeros(mov.Height, mov.Width, 'uint32');

%% Segmentar pupila
% Tiempo estimado de demora 45 segundos
tic;
for i=1:nFrames
    current_frame = vidFrames(:,:,:,i);
    gray_img = rgb2gray(current_frame);
    bw3 = segment_calib(gray_img);
    segm_video(:,:,i) = bw3;
    % Obtener datos del circulo de la pupila
    % Se obtienen las componentes conexas de la imagen segmentada
    cc = bwconncomp(bw3, 4);
    % Datos básicos de estas componentes
    circledata = regionprops(cc, 'basic');
    % El centroide de un grupo de puntos se puede calcular facilmente como
    % las posiciones promedio en 'x' y en 'y'
    cx = floor(circledata.Centroid(1));
    cy = floor(circledata.Centroid(2));
    calib_hist(cy, cx) = calib_hist(cy, cx) + 1;
    radius = floor(sqrt(circledata.Area/pi));
    % Dibujar el circulo
    calib_video(:,:,:,i) = draw_circle(current_frame, cx, cy, radius);
end
toc;
%% Mostrar video
disp 'Este es el video del ojo en la calibracion'
implay(calib_video)
pause

%% Encontrar lugares en que se miró
close all
% Sacar puntos pequeños en donde no se miró mucho
bwcalib_coords = calib_hist > 6;
% Operacion Cerrar con cuadrado de 2x2
sesquare = strel('square', 2);
bwcalib_coords = imclose(bwcalib_coords, sesquare);
bwcalib_coords = bwareaopen(bwcalib_coords, 2);
% Obtener los objetos conexos
cc = bwconncomp(bwcalib_coords, 8);
% Obtener la imagen con los objetos conexos para comprobar
bwcalib_coords = false(size(calib_hist));
for i=1:cc.NumObjects
    bwcalib_coords(cc.PixelIdxList{i}) = true;
end
imshow(bwcalib_coords)
% Obtener propiedades básicas de cada punto
regsprops = regionprops(cc, 'basic');
% Se multiplica cada valor por dos ya que esta ventana es de 240x320
c1 = [int32(regsprops(1).Centroid(1)*2) int32(regsprops(1).Centroid(2)*2)];
c2 = [int32(regsprops(2).Centroid(1)*2) int32(regsprops(2).Centroid(2)*2)];
c3 = [int32(regsprops(3).Centroid(1)*2) int32(regsprops(3).Centroid(2)*2)];
c4 = [int32(regsprops(4).Centroid(1)*2) int32(regsprops(4).Centroid(2)*2)];
c5 = [int32(regsprops(5).Centroid(1)*2) int32(regsprops(5).Centroid(2)*2)];
c6 = [int32(regsprops(6).Centroid(1)*2) int32(regsprops(6).Centroid(2)*2)];
c7 = [int32(regsprops(7).Centroid(1)*2) int32(regsprops(7).Centroid(2)*2)];
c8 = [int32(regsprops(8).Centroid(1)*2) int32(regsprops(8).Centroid(2)*2)];
c9 = [int32(regsprops(9).Centroid(1)*2) int32(regsprops(9).Centroid(2)*2)];
% Estos puntos representan una matriz de 2x9 de calibración
calib = [c1; c2; c3; c4; c5; c6; c7; c8; c9];
calib = sort_calib_coords(calib);
pause
%% Abrir video del ojo en experimento
close all
mov=VideoReader('ojoII.mp4');
vidFrames=read(mov);
nFrames=mov.NumberOfFrames;

%% Inicialización de variables

segm_video = false(mov.Height, mov.Width, nFrames-109);
eye_video = zeros(mov.Height, mov.Width, 3, nFrames-109, 'uint8');
final_hist = zeros(mov.Height, mov.Width, 'uint32');
crosses_positions = zeros(2, nFrames-109, 'uint32');
radius_list = zeros(nFrames-109, 1, 'uint32');
log_file = fopen('log.txt', 'w');
% Las estrellas se obtuvieron de forma manual luego de ver que por
% centroides dan resultados muy distintos en x e y
S1 = [40, 38];
S2 = [40, 240];
S3 = [40, 426];
S4 = [320, 38];
S5 = [320, 240];
S6 = [320, 426];
S7 = [603, 38];
S8 = [603, 240];
S9 = [603, 426];
S = [S1; S2; S3; S4; S5; S6; S7; S8; S9];
%% Segmentacion frame por frame del experimento
% ver desde el frame 21 pues antes se ve la pestaña del ojo
% hasta el frame 1085 que es lo que dura el video visto
% Tiempo estimado de demora 20segs
tic;
for i=22:1085
    current_frame = vidFrames(:,:,:,i);
    gray_img = rgb2gray(current_frame);
    segm_img = segment_expr(gray_img);
    segm_video(:,:,i-21) = segm_img;
    % Obtener datos del circulo de la pupila
    cc = bwconncomp(segm_img, 8);
    circledata = regionprops(cc, 'basic');
    cx = floor(circledata.Centroid(1));
    cy = floor(circledata.Centroid(2));
    % Mapea el centro de pupila a la imagen que ve en una cruz, aun no la
    % dibuja solo obtiene la posicion
    cross_position = map_calib(cx, cy, calib, S);
    crosses_positions(:,i-21) = cross_position;
    % Agregar uno al cuadrado 2x2 que representa el centro en el histograma
    final_hist = fill_square(final_hist, cx, cy);
    radius = floor(sqrt(circledata.Area/pi));
    fprintf(log_file, 'In frame: %d, radius = %d and center is [%d, %d]\n', i-21, radius, cx, cy);
    radius_list(i-21) = radius;
    % Dibujar el circulo en el ojo
    eye_video(:,:,:,i-21) = draw_circle(current_frame, cx, cy, radius);
end
toc;
%% Video de segmentación
close all
disp 'Video de la segmentacion del ojo en experimento'
implay(segm_video)
pause
%% Video del ojo en experimento con circulo
close all
disp 'Video del ojo en experimento'
implay(eye_video)
pause
%% Cargar video de oficina
oficina=VideoReader('oficina.mp4');
oficinaFrames=read(oficina);
noficinaFrames=oficina.NumberOfFrames;

%% Dibujar la cruz en cada frame
ofi_video = zeros(oficina.Height, oficina.Width, 3, nFrames-109, 'uint8');
for i=1:nFrames-109
    current_ofi_img = oficinaFrames(:, :, :, i);
    cx = crosses_positions(1,i);
    cy = crosses_positions(2,i);
    if (cx == 0)
        cx = 1;
    end
    ofi_img = draw_circle(current_ofi_img, cx, cy, 50);
    ofi_video(:, :, :, i) = ofi_img;
end

%% Mostrar video de la oficina
close all
disp 'Video de la oficina'
implay(ofi_video)
pause

%% Mostrar histograma del experimento
close all
imshow(final_hist)
title('Histograma de centros del ojo')
pause

%% Mostrar grafico de radio en el tiempo
close all
plot(1:nFrames-109, radius_list)
title('Cambio del radio de la pupila en el tiempo')
xlabel('n° de Frame')
ylabel('radio de pupila en pixeles')
pause

%% Cerrar log
disp ('Ver log.txt para más info')
fclose(log_file);
