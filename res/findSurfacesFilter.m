function [BW_out,properties] = findSurfacesFilter(BW_in,pixelMin,eccentricityLimit)

BW_out = bwareafilt(BW_in, 15000);

% Filter image based on image properties.
BW_out = bwpropfilt(BW_out, 'Area', [pixelMin + eps(pixelMin), Inf]);
BW_out = imfill(BW_out, 'holes');
BW_out = bwpropfilt(BW_out, 'Eccentricity', [-Inf, eccentricityLimit - eps(eccentricityLimit)]);
% Get properties.
properties = regionprops(BW_out, {'Area', 'Eccentricity'});

end
