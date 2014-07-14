function [ output_calib ] = sort_calib_coords( calib )
%SORT_CALIB_COORDS Ordena los puntos de calibracion para que queden de
%menos y a más.
%   Detailed explanation goes here
output_calib = calib;
for i=1:3:9
    % Si el siguiente tiene menos 'y' lo subo
    for j=0:1
        while(output_calib(i+j+1, 2) < output_calib(i+j,2))
            aux = output_calib(i+j,:);
            output_calib(i+j,:) = output_calib(i+j+1,:);
            output_calib(i+j+1,:) = aux;

            if (j == 2)
                j = 0;
            end
        end
    end
end

end

