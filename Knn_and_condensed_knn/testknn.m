function testY=testknn(trainX, trainY, testX, k)
% Knn classification
% find the distance between vectors of testX and trainX
D  = pdist2(trainX, testX ,'euclidean');
% To find minimum k distances, sort D storing the existing indices in DIx.
% Each row i in D contains the distance between a vector in trainX to all
% other vectors in testX
%
[D_sorted, DIx] = sort(D, 1);
% NNDIx will hold the indices of k nearest neighbours
NNDIx = DIx(1:k, :);

trainYt = trainY';
% get the class based on the index from the training set
% The k nearest neigbours are stored in NN
NN = trainYt(NNDIx);

% Select the neighbour based on frequency
if k == 1
    testY = NN';
else    
    testY = (char(mode(double(NN))))';
end;    
