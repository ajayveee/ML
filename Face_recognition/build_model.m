function [ model ] = build_model( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sprintf('Hi');
images = [];
for s = 1:7
    for i = 1:6
        fileName = sprintf ( 'train/subject%d/%d.gif', s, i );
%         display('Processing file ', fileName);
        imgMatrix = imread ( fileName );
        [m,n] = size(imgMatrix);
        imgVector = reshape(imgMatrix', m*n, 1);
        images = [images imgVector];
    end;
end;
% get the mean image
meanImg = mean(images, 2);
% meanImg = reshape(meanImg, n, m);
% intImg  = uint8(meanImg);
% imshow( intImg');
% subtract mean from each image vector

 normalizedImages = zeros(size(images));
 for i = 1 : size(images, 2)
     normalizedImages(:,i) = (double(images(:, i)) - meanImg);
 end;
%  showImg(normalizedImages,m,n);
% cov()
L = normalizedImages' * normalizedImages;
[V, D] = eig(L);
significantEigVectors = [];

% for i = 1 : size(D, 2)
%     if (D(i,i)> 1 )
%         significantEigVectors = [ significantEigVectors V(:, i) ];
%     end;  
% end;
[sorted, I] = sort(diag(D)','descend');
significantEigVectors = V(:, I);
% selecting top k eigen vectors
k = 12;
significantEigVectors = significantEigVectors(:,1:k);


eigenFaces = normalizedImages * significantEigVectors;

% Projection of training images onto eigenFace space
projectedImages = eigenFaces' * normalizedImages;
model.projectedImages = projectedImages;
model.meanImg = meanImg;
model.eigenFaces = eigenFaces;
% showImg(eigenFaces, m, n);
%saveEigenFaces(eigenFaces,m,n);
end
function showImg(doubleImages,m, n)
imshow(uint8(reshape(doubleImages(:,1), n, m))', []);
end
function saveEigenFaces(eigenFaces,m,n)
folderToWrite= datestr(now, 'yymmddHHMMSS');
mkdir('eigenFaces', folderToWrite);
for i = 1 : size(eigenFaces, 2)
    fileName = sprintf('%s/%d.gif', strcat('eigenFaces/',folderToWrite),i);
    imwrite(uint8(reshape(eigenFaces(:,i), n, m))', fileName);
end;
end

