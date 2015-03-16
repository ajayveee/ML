% Build a model:
[model] = load ( 'model.mat' );


% Initialize some things:
gt = csvread ( 'gt.csv' );

% start timer
t = cputime;

frameFormat = 'FRM%05d.png';
testFrameNums = 100:100:5000;
timeLimitSec = 60;
DistThreshold = 20;
FP = 0;
FN = 0;
TP = 0;
gt_numPositives = 0;

% Test on 50 test images:
for i = 1:50
    imNum = testFrameNums(i);
    f = imread(sprintf(frameFormat, imNum));
    gtFrmPos = gt((i-1)*50+1:(i*50), :); % only grab ith frame
    gtFrmPos(gtFrmPos(:,1)==-1, :) = []; % if no detections, remove those rows
    
    frameDets = where_am_i ( model, f);
    
    execTime = (cputime-t);
    if ( execTime > timeLimitSec )
        Precision = TP / (TP + FP);
        Recall = TP / (TP + FN);
        FScore = 2 * ((Precision*Recall)/(Precision+Recall));
        
        fprintf ( 'Precision = %d, Recall = %d, FScore = %d, Total TP = %d, Total FP = %d, Total FN = %d\n', ...
            Precision, Recall, FScore, TP, FP, FN);
        
        fprintf ( 'Test Time: %d\n', testTime);
        return;
    end
    
    distance = pdist2 ( gtFrmPos, frameDets );
        
    % Match GT locations to each of the detections from algorithm:
    CoveredGTLocations = false(size(gtFrmPos, 1), 1);
    % Match in a greedy fashion. So, sort first:
    [~, orderedInds] = sort(min(distance), 'ascend');   
    
    for j = orderedInds        
        % find the minimum
        [minDist, gtIndx] = min(distance(:, j));
        if (minDist > DistThreshold) || CoveredGTLocations(gtIndx)
            FP = FP + 1;
        else
            TP = TP + 1;
            CoveredGTLocations(gtIndx) = true;
            distance(gtIndx, :) = Inf;
        end
    end
    FN = FN + sum(~CoveredGTLocations);
end

% Print testing results:
testTime = cputime-t;
Precision = TP / (TP + FP);
Recall = TP / (TP + FN);
FScore = 2 * ((Precision*Recall)/(Precision+Recall));
fprintf ( 'Precision = %d, Recall = %d, FScore = %d, Total TP = %d, Total FP = %d, Total FN = %d\n', ...
    Precision, Recall, FScore, TP, FP, FN);

fprintf ( 'Test Time: %d\n', testTime);



