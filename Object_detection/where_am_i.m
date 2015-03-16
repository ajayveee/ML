function pos =  where_am_i(model, image)
model = model.model;
bg = model.bg;
f= image;

[bg]=round(rgb2hsv(bg));
[givenImg]=round(rgb2hsv(f));
Out = bitxor(bg,givenImg);
Out=rgb2gray(Out);

binaryImage = im2bw(Out);

filteredImage=medfilt2(binaryImage,[5 5]);
filteredImage = imdilate(filteredImage, strel('octagon', 9));
%  imshow(FilteredImage);
 [L, num]=bwlabel(filteredImage);
 STATS=regionprops(L,'all');

 removed=0;
 %Remove the noisy regions
for i=1:num
    dd=STATS(i).Area;
    if (dd < 10)
        L(L==i)=0;
        removed = removed + 1;
        num=num-1;
    else
    end
end
[L2, ~]=bwlabel(L);
STATS=regionprops(L2,'Centroid');
flippedPos = cat(1, STATS.Centroid);

if (size(flippedPos, 1) ~= 0)
pos = flippedPos(:, 2);
pos = [pos flippedPos(:, 1)];
else
    pos= [-1 -1];
end;
% imshow(f); hold on;
% for i=1:size(flippedPos, 1)
%     plot(flippedPos(i,1), flippedPos(i,2), 'r.', 'MarkerSize',20);
% end;

end