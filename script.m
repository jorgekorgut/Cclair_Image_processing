close all;
clear all;
%% 
addpath res;
addpath Output;
addpath 'Cclair 1';
addpath 'Cclair 2';
%% Variables

flowerEccentricity = 0.85;
pixelMinFlowers = 100;

pixelMinBourgeon = 50;
bourgeonEccentricity = 0.95; 

pixelMinBranche = 1000;
brancheEccentricity = 1;

inputFolder = 'Cclair 1';
outputFolder = 'Output';

nImagesVisualisation = 9;

%% the folder threatment
result = imageFolderThreatment(inputFolder,outputFolder,pixelMinFlowers,flowerEccentricity,pixelMinBourgeon,bourgeonEccentricity,pixelMinBranche,brancheEccentricity);

valueFlower = horzcat(result.flowerNumber);
areaValueBourgeons = horzcat(result.sumAreaBourgeons);
valueBranch = horzcat(result.branchNumber);
directories = vertcat(result.fileName);

% Visualisation of the data
% nIndice = 1:length(valueFlower);
% figure(1);
% subplot(2,2,1);
% stem(nIndice, areaValueBourgeons);
% subplot(2,2,2);
% stem(nIndice, valueFlower);
% subplot(2,2,3);
% stem(nIndice, valueBranche);
% subplot(2,2,4);
% scatter(valueFlower,areaValueBourgeons);

%% statistic treatment

% We normalize and organize data for a cluster threatment with differents weights.
valuesColumn = [2*normalize(valueFlower,'range');1*normalize(areaValueBourgeons,'range');0.5*normalize(valueBranch,'range')]';

% Clustering data.
Z = linkage(valuesColumn,'ward');

% We impose 3 different population in our data set.
T = cluster(Z,'Maxclust',3);

% Data separation in their clusters
nIndice = 1:length(T);
clustered = cell(3,1);
for K = 1 : 3
  clustered{K} = nIndice( T == K );
end

% Representation of data classification with its dendogram.
% Each point is representated by an image.
figure(3);
subplot(3,1,1);
dendrogram(Z);
title('Dendrogramme de la methode de clusterisation Ward');
xlabel('observations');
ylabel('similarite');
subplot(3,1,2);
gscatter(valuesColumn(:,1),valuesColumn(:,2),T);
title('Nuage de points representant les fleurs et les bourgeons')
ylabel('bourgeons');
xlabel('flowers');
subplot(3,1,3);
gscatter(valuesColumn(:,1),valuesColumn(:,3),T);
title('Nuage de points representant les fleurs et les branches')
ylabel('branches');
xlabel('flowers');

%% image visualisation
% We show an arbitray number of image from different classifications.

imageList = cell(nImagesVisualisation,3);
for imageWindow=1:3
    figure(100+imageWindow);
    flowers = cell2mat(clustered(imageWindow));
    for i=1:nImagesVisualisation
        if(i>length(flowers))
            continue;
        end
        imtemp = imread(directories(flowers(i),:));
        imageList{imageWindow,i} = imtemp;
    end
    montage(imageList(imageWindow,:));
    title(imageWindow);
end

%% Visualising particular images

% %Observation number of an image.
% imageNumber1 = 25; 
% imageNumber2 = 55;

% imtemp1 = imread(directories(imageNumber1,:));
% imtemp2 = imread(directories(imageNumber2,:));
% figure(2000);
% imshowpair(imtemp1,imtemp2,'montage');

%% Test

% RGB = imread(directories(24,:));
% 
% RGBReduced = imreducehaze(RGB, 'Method', 'approxdcp', 'ContrastEnhancement', 'none');
% binaryFlowerOutput = flowerThresholdHSV(RGBReduced);
% binaryFlowerOutput2 = findSurfacesFilter(binaryFlowerOutput,100,0.9);
% 
%  [T,~] = graythresh(RGBReduced(:,:,3));
% ImgOtsu = im2double(RGBReduced(:,:,3));
% ImgOtsu = (ImgOtsu > T);
% imgBinaireOtsuBranches = imbinarize(im2uint8(ImgOtsu));
% 
% imgBinaireOtsuBranches = (imgBinaireOtsuBranches>binaryFlowerOutput);
% 
% 
% imgBinaireOtsuBranches = findSurfacesFilter(imgBinaireOtsuBranches,100,0.9);
% 
% imshowpair(RGBReduced,binaryFlowerOutput2,'blend','scaling','joint');
%title('Résultat de l''algoritme manuel de comptage de fleurs appliqué à une seule image.','FontSize',15);

% figure(2001);
% subplot(2,1,1);
% imhist(RGB(:,:,3));
% title('Histogramme du sous espace bleu de l''image AVANT le debroumage');
% ylabel('nombre de pixels');
% 
% subplot(2,1,2);
% imhist(RGBReduced(:,:,3));
% title('Histogramme du sous espace bleu de l''image APRES le debroumage');
% ylabel('nombre de pixels');



