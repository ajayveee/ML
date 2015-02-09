
clc;
clear;
fileId = fopen('letter-recognition.data');
numOfRows = 15000;
totalRows = 20000;
formatSpec='%c%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
% read csv
fileId = fopen('letter-recognition.data');
formatSpec='%c%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
data = textscan(fileId, formatSpec,'delimiter',',','CollectOutput',true);
dataY = data{1,1};
dataX = data{1,2};
% training data
trainX = dataX(1:15000, :);
trainY = dataY(1:15000);
% test data
testX = dataX(15001:20000, :);
testY = dataY(15001:20000);

fclose(fileId);

% sub sampling training data
opFid=fopen(strcat('hw1_op_',datestr(clock,'yymmdd_HHMMSS'),'.txt'),'a+');
subsamplesizes = [100 1000 2000 5000 10000 15000];
kvalues = [1 3 5 7 9];

for subsampleSize = subsamplesizes
    RV = randperm(subsampleSize);
    subsampleTrainX = trainX(RV, :);
    subsampleTrainY = trainY(RV);
    
    tic;
    condensedIdx = condensedata(subsampleTrainX, subsampleTrainY);
    time_for_condense=toc;
    condensedTrainX = subsampleTrainX(condensedIdx, :);
    condensedTrainY = subsampleTrainY(condensedIdx);
    
    for k = kvalues
        
        % profile on;
        tic;
        resultY = testknn(subsampleTrainX, subsampleTrainY, testX, k);
        time_taken =toc;
        testSize = size(testY);
        testSize = testSize(1);
        negativesSize = nnz(resultY - testY);
        
        fprintf(opFid,'knn,%d,%d,%.2f,%.2f,%d,%d\r\n',k,subsampleSize,time_taken,((testSize - negativesSize)*100/testSize),(testSize-negativesSize),negativesSize);
        % fprintf('Count of test data incorrectly classified : %d\n', negativesSize)
        % fprintf('Accuracy :%.2f\n', (testSize - negativesSize)*100/testSize)
        % fprintf('True +ves :%d, True -ves: %d\n', (testSize-negativesSize), negativesSize)
        % fprintf('Time: %f\n', time_taken)
        
        
        % fprintf('\nCondensing\n----------\nsize(trainX): %d \nsize(condensed): %d', size(subsampleTrainX,1), size(condensedIdx,1))
        % resulty = testknn(condensedTrainX, condensedTrainY, subsampleTrainX, k);
        % fprintf('\nVerify consistency\n------------\nCount of training data incorrectly classified : %d', nnz(resulty - subsampleTrainY))
        tic;
        resultY = testknn(condensedTrainX, condensedTrainY, testX, k);
        time_taken =toc;
        negativesSize = nnz(resultY - testY);
        fprintf(opFid,'Condensedknn,%d,%d,%.2f,%.2f,%d,%d,%.2f\r\n',k,size(condensedIdx,1),time_taken,((testSize - negativesSize)*100/testSize),(testSize-negativesSize),negativesSize, time_for_condense);
        
    end;
end;
fclose(opFid);

% ixnz=find(resultY - testY);
% [resultY(ixnz) testY(ixnz)]
% profile off;
% profile viewer;


