function pos =  where_am_i(model, image)
model = model.model;
bg = model.bgMasked;
fOrig= image;

f = rgb2hsv(fOrig);
f = f(:, :, 2);
f = imadjust(f);
b=im2bw(bg);
maskedImg = im2bw(f).*b;
maskedImg = imfill(maskedImg);
%, strel('disk', 3))
filledMImg = imfill(maskedImg);

cc = bwconncomp(filledMImg);
stats = regionprops(cc, 'Area','Centroid','PixelIdxList');
[~, idx] = sort([stats.Area] ,'descend');
stats = stats(idx(1:50));
centroids = cat(1, stats.Centroid);

if (size(centroids, 1) ~= 0)
pos = centroids(:, 2);
pos = [pos centroids(:, 1)];
else
    pos= [-1 -1];
end;
% imshow(f); hold on;
% for i=1:size(flippedPos, 1)
%     plot(flippedPos(i,1), flippedPos(i,2), 'r.', 'MarkerSize',20);
% end;

end