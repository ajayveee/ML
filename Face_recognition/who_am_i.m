function [ id ] = who_am_i( model, test_img )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[m,n] = size(test_img);
imgVector = reshape(test_img', m*n, 1);
normalizedImg = double(imgVector) - model.meanImg;
projectedTestImg = model.eigenFaces' * normalizedImg;
%tiledProjTestImg = repmat(projectedTestImg, [1 size(model.projectedImages, 2)]);
%[D, I] = pdist2(model.projectedImages, tiledProjTestImg, 'euclidean', 'Smallest', 1);
distance = [];
for i = 1 : size(model.projectedImages, 2)
    distance = [distance norm(projectedTestImg - model.projectedImages(:, i))^2];
end;
[D, I] = min(distance);  
% display(I);
id = floor((I(1)-1)/6) + 1;
end

