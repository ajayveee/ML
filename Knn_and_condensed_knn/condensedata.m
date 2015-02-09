function condensedIdx = condensedata(trainX, trainY)
% Condense the training sample trainX
% Random vector to randomize the sample selection
RV = randperm(size(trainX, 1));
% RV = [1:size(trainX,1)];
SSx = trainX(RV(1), :);
SSy = trainY(RV(1));
condensedIdx = RV(1);
k = 1;
remTrainX = [trainX (1:size(trainY,1))'];
remTrainX(RV(1),:)=[];
remTrainY = trainY;
remTrainY(RV(1),:)=[];
transferOccurred = true;
while(transferOccurred)
       
    resulty = testknn(SSx, SSy, remTrainX(:,1:16), k);
    % if incorrectly classified with the subset in hand, add to subset
    % and reclassify
    if(nnz(resulty - remTrainY) == 0)
        transferOccurred = false;
        break;
    end;
    % select a random incorrect classified sample
    % IdxIncorrect - this is the indices of incorrectly classified
    % samples.
    IdxIncorrect = find(resulty - remTrainY);
   % pick an index from IdxIncorrect and add it to SSx and SSy
   indexToPick =1;
   SSx = [SSx; remTrainX(IdxIncorrect(indexToPick), 1:16)];
   SSy = [SSy; remTrainY(IdxIncorrect(indexToPick), :)];
   condensedIdx = [condensedIdx ; remTrainX(IdxIncorrect(indexToPick), 17)];   
   remTrainX(IdxIncorrect(indexToPick), :)=[];
   remTrainY(IdxIncorrect(indexToPick), :)=[];
end;