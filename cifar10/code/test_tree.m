% testing the tree
clear;
% generate the tree
setup;
addpath(genpath('/data/roy77/DNN/matconvnet'));
addpath(genpath('../../common'));
%testing tree current road block is saving and loading nodes

load '../dataset/cifar_10_imdb.mat';

top_node = node;
top_node.id = 1;
netPath = '../output/tree_1';

top_node.labelsTransform = loadlt(fullfile(netPath,sprintf('%d',top_node.id),'labelsTransform.mat'));

index = find(ismember(cifar_10_imdb.images.labels, top_node.labelsTransform(:,1)));
 
set = cifar_10_imdb.images.set(1, index);

im_all = cifar_10_imdb.images.data(:,:,:,index);

labels_all = cifar_10_imdb.images.labels(1,index);

% % Training Accuracy

im = im_all(:,:,:,find(set(1,:) == 3));
labels = labels_all(1, find(set(1,:) == 3));
prediction = zeros(1,numel(labels));
error = zeros(25,1);


for epoch = 250:10:250
    recursive_add_children_epoch(top_node,netPath, epoch)
    opts = top_node.opts;
    prediction = zeros(1,numel(labels));
    
    for i = 1 : numel(labels)
        if ~mod(i,100)
            fprintf('Epoch %d/250 : %d \n', epoch, i);
        end            
        net = top_node.net;
        net.layers(end)=[];
        res = [];
        dzdy = [];
        im_2 = im(:,:,:,i);
        res = vl_simplenn(net, im_2, dzdy, res, ...
            'accumulate', false, ...
            'mode', 'test', ...
            'conserveMemory', opts.conserveMemory, ...
            'backPropDepth', opts.backPropDepth, ...
            'sync', opts.sync, ...
            'cudnn', opts.cudnn, ...
            'parameterServer', [], ...
            'holdOn', false);
        x = squeeze(res(end).x);
        [~,index] = max(x);
        next_node = top_node.children{index};
        if (isempty(next_node.net))
            prediction(1,i) = top_node.labelsTransform(top_node.labelsTransform(:,2)==index,1);
        else
            net = next_node.net;
            net.layers(end) = [];
            res = [];
            dzdy = [];
            im_2 = im(:,:,:,i);
            res = vl_simplenn(net, im_2, dzdy, res, ...
                'accumulate', false, ...
                'mode', 'test', ...
                'conserveMemory', opts.conserveMemory, ...
                'backPropDepth', opts.backPropDepth, ...
                'sync', opts.sync, ...
                'cudnn', opts.cudnn, ...
                'parameterServer', [], ...
                'holdOn', false);
            
            x = squeeze(res(end).x);
            [~,index_2] = max(x);
            prediction(1,i) = next_node.labelsTransform(next_node.labelsTransform(:,2)==index_2,1);
        end
        
    end
    
    err = ~bsxfun(@eq, prediction, labels) ;
    error(epoch/10) = sum(err)/numel(err);
    fprintf('Epoch %d/250    Error: %.4f \n', epoch,error(epoch/10));
end

save('../output/tree_1/testing_error.mat', 'error');


