function results = imageThreatment(im,pixelMinFlower,flowerEccentricity,pixelMinBourgeon,bourgeonEccentricity,pixelMinBranche,brancheEccentricity)
%--------------------------------------------------------------------------
tic
% reading the image
RGB = im;
%% Flowers
% Search for flowers in the image.

% How does reducedHaze work?

%   Estimate the atmospheric light L using a dark channel prior.
%   Estimate the transmission map T.
%   Refine the estimated transmission map.
%   Restore the image.
%   Perform optional contrast enhancement.

%[Source] https://fr.mathworks.com/help/images/ref/imreducehaze.html

reducedHazeRGB = imreducehaze(RGB, 'Method', 'approxdcp', 'ContrastEnhancement', 'none');

%OTSU
% [T,~] = graythresh(reducedHazeRGB(:,:,3));
% ImgOtsu = im2double(reducedHazeRGB(:,:,3));
% ImgOtsu = (ImgOtsu > T);
% binaryFlowers = imbinarize(im2uint8(ImgOtsu));

binaryFlowers = flowerThresholdHSV(reducedHazeRGB);

% Selecting the regions and filtering by its eccentricity and area
% - more than pixelsMin variable to be counted as a flower
% - less than eccentricityLimit to eliminate branches from the image

[binaryFlowerOutput,propertiesFlower] = findSurfacesFilter(binaryFlowers,pixelMinFlower,flowerEccentricity);

% We calculate the average of closed surfaces in the binaryImage for stimate a number of flowers in
% the image.
% Reason? 
%   - eliminate the effect of distance (images closest to the tree are going to have bigger regions, so a bigger average of surfaces and finaly a fewer number of flowers)
areaFlowers=horzcat(propertiesFlower.Area);
sumAreaFlower = sum(areaFlowers);
averageFlowers = sumAreaFlower/length(areaFlowers);

% The variable result is affected.
results.flowerNumber = sumAreaFlower/averageFlowers;
results.bwFlowers = binaryFlowerOutput;
%% bourgeons
% search for bourgeons in the image.

binaryBourgeons = bourgeonThresholdHSV(reducedHazeRGB);

% Selecting the regions and filtering by its eccentricity and area
[binaryBourgeonOutput,propertiesBourgeons] = findSurfacesFilter(binaryBourgeons,pixelMinBourgeon,bourgeonEccentricity);

areaBourgeons=horzcat(propertiesBourgeons.Area);
sumAreaBourgeons = sum(areaBourgeons);

%affectation of variables
results.bwBourgeons = binaryBourgeonOutput;
results.sumAreaBourgeons = sumAreaBourgeons;

%% branches
% Search for branches in the image

hsv = rgb2hsv(reducedHazeRGB);

% OTSU search for 2 different groups in the image.
% notice that we are just using the h channel.

% How does OTSU work ?

[T,~] = graythresh(hsv(:,:,1));
ImgOtsu = im2double(hsv(:,:,1));
ImgOtsu = (ImgOtsu > T);
imgBinaireOtsuBranches = imbinarize(im2uint8(ImgOtsu));

%Eliminate the flowers from the binary image
imgBinaireOtsuBranches = (imgBinaireOtsuBranches>binaryFlowerOutput);

imgBinaireOtsuFiltered = findSurfacesFilter(imgBinaireOtsuBranches,pixelMinBranche,brancheEccentricity);

branchNumber = sum(imgBinaireOtsuFiltered(:));
results.branchNumber = branchNumber;
toc
%--------------------------------------------------------------------------
