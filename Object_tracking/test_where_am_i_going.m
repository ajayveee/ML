
%% Initialization
% Points awarded for each object located in each frame (25,000 max):
points = 0;
% Name format for reading frame images:
frameFormat = 'Frames/FRM%05d.jpg';
% Read the ground truth file:
load('GT.mat');

%% Run Tracking
% Start timer:
fprintf('\n\n Starting Timer and Tracking \n\n');
t = cputime;   
    
% Loop through each object and track it through the video:
for iObj = 3:3
    
    % 0. Read the position on the first frame based on ground truth
    init_pos = GT(iObj, 1);
    % <Convert struct to (x, y) row vector>:
    init_pos = [init_pos.x, init_pos.y]; 
    
    % 1. Initialize model based on object's location in the first image:
    f = imread(sprintf(frameFormat, 1));
    [model] = init_model(init_pos, f);
            
    % 2. Run tracking on the remaining frames of the video [NOTE:
    % processing every 2 frames]:
    for iFrame = 2:2:100
        f = imread(sprintf(frameFormat, iFrame));
        [pos, model] = where_am_i_going(model, f);
        
        % Check if predicted location is within 50px of ground truth:
        gt_pos = GT(iObj, iFrame);
        % <Again, convert struct to (x, y) row vector>:
        gt_pos = [gt_pos.x, gt_pos.y]; 
        
        dist_error = norm(pos - gt_pos);        
        if (dist_error <= 50)
            points = points + 1;
        end
    end
    
    elaptime = cputime - t;
    fprintf ('object[%d], frame[%d] - points[%d] - time[%d sec]\n', ...
        iObj, iFrame, points, floor(elaptime));
    
    % 3. Check if time limit reached (7 minutes):
    if (elaptime > 420) 
        fprintf ( '\n\n\t Time Limit Was Reached! \n');
        return;
    end
end

