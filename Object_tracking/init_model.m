function [model] = init_model ( init_pos, test_im )
%% INPUT:
%   init_pos ~ (x, y) row vector of the center of the target object.
%   test_im  ~ The RGB image, not a path for which to read it from.
% 
%% OUTPUT: 
%   model     ~ Struct containing anything (& everything) useful for you
%                   to track the target object.
%
    f= rgb2gray(test_im);
    model.init_pos = init_pos;
    model.prev_pos = init_pos;
    model.patch = f(uint16(init_pos(2)-10 : init_pos(2)+10), uint16(init_pos(1)-10 : init_pos(1)+10));
%     imshow(model.patch);
%     sprintf('hi');
end
