function [LarComSize Lp] = gretna_robustness_weight(W, n)

%==========================================================================
% This function is used to assess the resilience of a weight network G to
% random errors and targeted attacks. For random errors, nodes are deleted
% randomly 10 times and the mean of resultant values are outputed. NOTE,
% the calculation of largest component size is based on MatlabBGL toolbox.
%
%
% Syntax: function [LarComSize Lp] = gretna_robustness(W)
%
% Input:
%     W:
%                   The adjacency matrix of G (N*N, symmetric).
%
%     n:
%                   The number of random deletion of nodes.
% Outputs:
%     LarComSize:
%                   The largest component size of network G as a function
%                   of proportion of removed nodes in network G.
%     Lp:
%                   The shortest path length of network G as a function
%                   of proportion of removed nodes in network G.
%
% References:
% 1. Achard et al. (2006): A Resilient, Low-Frequency, Small-World Human
%    Brain Functional Network with Highly Connected Association Cortical
%    Hubs. The Journal of Neuroscienc.
% 2. He et al. (2008): Structural Insights into Aberrant Topological
%    Patterns of Large-Scale Cortical Networks in Alzheimer¡¯s Disease. The
%    Journal of Neuroscienc.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/03/09, Jinhui.Wang.1982@gmail.com
%==========================================================================

W = W - diag(diag(W));
W = abs(W);

% target attack: nodes with the highest degree are deleted from the network
fprintf('Calculate largest component size and shortest path length when target attack. \n');

Net1 = W;
Deg = sum(Net1);

% initial LarComSize of Net1
[~, sizes] = components(sparse(Net1));
LarComSize.targetattack = max(sizes);
% initial Lp of Net1
[averlp, ~] = gretna_node_shortestpathlength_weight(Net1);
Lp.targetattack = averlp;

while max(sizes) > 1
    index = find(Deg == max(Deg));
    Net1(index(1),:) = [];
    Net1(:,index(1)) = [];
    Deg = sum(Net1);
    
    [~, sizes] = components(sparse(Net1));
    LarComSize.targetattack = [LarComSize.targetattack max(sizes)];
    
    [averlp, ~] = gretna_node_shortestpathlength_weight(Net1);
    Lp.targetattack = [Lp.targetattack averlp];
end

LarComSize.targetattack(end) = [];
Lp.targetattack(end) = [];

% random attack: nodes are deleted from the network randomly
fprintf('Calculate largest component size and shortest path length when random attack. \n');

for i = 1:n
    Net2 = W;
    N = length(Net2);
    
    % initial LarComSize of Net2
    [~, sizes] = components(sparse(Net2));
    tem_LarComSize.randomattack{i,1} = max(sizes);
    % initial Lp of Net2
    [averlp, ~] = gretna_node_shortestpathlength_weight(Net2);
    tem_Lp.randomattack{i,1} = averlp;
    
    while max(sizes) > 1
        % delete a node and its connections at random
        index = randperm(N);
        Net2(index(1),:) = [];
        Net2(:,index(1)) = [];
        
        N = length(Net2);
        
        [~, sizes] = components(sparse(Net2));
        tem_LarComSize.randomattack{i,1} = [tem_LarComSize.randomattack{i,1} max(sizes)];
        
        [averlp, ~] = gretna_node_shortestpathlength_weight(Net2);
        tem_Lp.randomattack{i,1} = [tem_Lp.randomattack{i,1} averlp];
    end
    tem_LarComSize.randomattack{i,1}(end) = [];
    tem_Lp.randomattack{i,1}(end) = [];
end

times = zeros(n,1);

for i = 1:n
    times(i) = length(tem_Lp.randomattack{i,1});
end

lowlim = min(times);

for i = 1:n
    tem_LarComSize.randomattack{i,1} = tem_LarComSize.randomattack{i,1}(1:lowlim);
    tem_Lp.randomattack{i,1} = tem_Lp.randomattack{i,1}(1:lowlim);
end

LarComSize.randomattack = mean(cell2mat(tem_LarComSize.randomattack));
Lp.randomattack         = mean(cell2mat(tem_Lp.randomattack));

return