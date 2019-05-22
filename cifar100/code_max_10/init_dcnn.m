function net = init_dcnn()

lr = [0.1 0] ;

% Define network
net.layers = {} ;

% Block 1
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(3,3,3,64, 'single'), []}}, ...
                           'learningRate', lr, ...
                           'stride', [1 1], ...
                           'pad', 1) ;
net.layers{end+1} = struct('type', 'bnorm', ...
                            'weights', {{ones(64, 1, 'single'), zeros(64, 1, 'single')}}, ...
                            'learningRate', [1 1 0.5], ...
                            'weightDecay', [0 0]) ;
net.layers{end+1} = struct('type', 'relu') ;


net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(3,3,64,64, 'single'), []}}, ...
                           'learningRate', lr, ...
                           'stride', [1 1], ...
                           'pad', 1) ;
net.layers{end+1} = struct('type', 'bnorm', ...
                            'weights', {{ones(64, 1, 'single'), zeros(64, 1, 'single')}}, ...
                            'learningRate', [1 1 0.5], ...
                            'weightDecay', [0 0]) ;
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', [2 2], ...
                           'pad', 0) ;

% Block 2
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(3,3,64,128, 'single'), []}}, ...
                           'learningRate', lr, ...
                           'stride', [1 1], ...
                           'pad', 1) ;
net.layers{end+1} = struct('type', 'bnorm', ...
                            'weights', {{ones(128, 1, 'single'), zeros(128, 1, 'single')}}, ...
                            'learningRate', [1 1 0.5], ...
                            'weightDecay', [0 0]) ;                       
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(3,3,128,128, 'single'), []}}, ...
                           'learningRate', lr, ...
                           'stride', 1, ...
                           'pad', 1) ;
net.layers{end+1} = struct('type', 'bnorm', ...
                            'weights', {{ones(128, 1, 'single'), zeros(128, 1, 'single')}}, ...
                            'learningRate', [1 1 0.5], ...
                            'weightDecay', [0 0]) ;
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', [2 2], ...
                           'pad', 0) ;

% Block 3
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(3,3,128,256, 'single'), []}}, ...
                           'learningRate', lr, ...
                           'stride', [1 1], ...
                           'pad', 1) ;
net.layers{end+1} = struct('type', 'bnorm', ...
                            'weights', {{ones(256, 1, 'single'), zeros(256, 1, 'single')}}, ...
                            'learningRate', [1 1 0.5], ...
                            'weightDecay', [0 0]) ;                       
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(3,3,256,256, 'single'), []}}, ...
                           'learningRate', lr, ...
                           'stride', [1 1], ...
                           'pad', 1) ;
net.layers{end+1} = struct('type', 'bnorm', ...
                            'weights', {{ones(256, 1, 'single'), zeros(256, 1, 'single')}}, ...
                            'learningRate', [1 1 0.5], ...
                            'weightDecay', [0 0]) ;                       
net.layers{end+1} = struct('type', 'relu') ;


net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', [2 2], ...
                           'pad', 0) ;

% Block 4 Fully connected
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(4,4,256,1024, 'single'), []}}, ...
                           'learningRate', lr, ...
                           'stride', 1, ...
                           'pad', 0) ;
                       
net.layers{end+1} = struct('type', 'relu') ;

% Block 5 dropout
net.layers{end+1} = struct('type', 'dropout', ...
                           'rate', 0.5) ;


% Block 6 Fully connected
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(1,1,1024,1024, 'single'), []}}, ...
                           'learningRate', 0.1*lr, ...
                           'stride', 1, ...
                           'pad', 0) ;                      
net.layers{end+1} = struct('type', 'relu') ;

% Block 7 dropout
net.layers{end+1} = struct('type', 'dropout', ...
                           'rate', 0.5) ;

% Block 8 Fully connected
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(1,1,1024,10, 'single'), []}}, ...
                           'learningRate', 0.1*lr, ...
                           'stride', 1, ...
                           'pad', 0) ;


% Loss layer
net.layers{end+1} = struct('type', 'softmaxloss') ;

% Meta parameters
net.meta.inputSize = [32 32 3] ;
net.meta.trainOpts.learningRate = [0.1*ones(1,25), 0.01*ones(1,75), 0.001*ones(1,50)] ;
net.meta.trainOpts.weightDecay = 0 ;
net.meta.trainOpts.batchSize = 100 ;
net.meta.trainOpts.numEpochs = numel(net.meta.trainOpts.learningRate) ;

% Fill in default values
net = vl_simplenn_tidy(net) ;


end