function [pos, model] = where_am_i_going( model, test_im)
%% INPUT:
%   model     ~ Struct containing anything (& everything) useful for you
%                   to track the target object.
%   test_im   ~ The RGB image, not a path for which to read it from.
%
%% OUTPUT:
%   pos       ~ (x, y) row vector of the center of the target object.
%   model     ~ Struct containing anything (& everything) useful for you
%                   to track the target object.
%
 load('GT.mat');
f=rgb2gray(test_im);
range = 20;
pos(1) = model.prev_pos(1);
pos(2) = model.prev_pos(2);
section = f(uint16(pos(2) - range : pos(2) + range), uint16(pos(1) - range : pos(1) + range));
bwsection = ~im2bw(section);
filledImg = imfill(bwsection, 'holes');
cc = bwconncomp(filledImg);
stats = regionprops(cc, 'Area','Centroid');
[~, idx] = sort([stats.Area] ,'descend');
stats = stats(idx(1));
centroid = stats.Centroid;

% pad the centroid to adjust for cropped section

centroid(1)= centroid(1) + uint16(pos(1) - range);
centroid(2)= centroid(2) + uint16(pos(2) - range);
% imshow(f); hold on;
%  plot(centroid(1), centroid(2), 'y*', 'MarkerSize', 5);
%  gt = GT(3, 2);
%  plot(gt.x, gt.y, 'g*', 'MarkerSize', 5);
 
 model.prev_pos(1) = centroid(1);
 model.prev_pos(2) = centroid(2);
% <<Sample code is not (really) updating the model. Though,
% you may wish to do so..>>
pos(1) = centroid(1);
pos(2) = centroid(2);
end

