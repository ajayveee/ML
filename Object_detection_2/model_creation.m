
bg = imread('bgs/bg_mask.jpg');
model.bgMasked = bg;
save('model.mat', 'model');