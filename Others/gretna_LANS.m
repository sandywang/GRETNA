function [Backbone] = gretna_LANS(A, Alpha, Type)

%==========================================================================
% This function is used to extract the backbone of weithed networks using a
% nonparametric method of locally adaptive network sparsification. Briefly,
% this method select those locally significant edges to form the backbone
% network which cannot be explained by random variation. Of note, this
% method need all weights non-negative. Therefore, a absolute operation is
% done in the following codes. If only positive weights are of special
% interest, replace all negative weights by zeros.
%
%
% Syntax: function [Backbone] = gretna_LANS(A, Alpha, Type)
%
% Inputs:
%         A:
%                The weighted network with the last dimension as subjects.
%         Alpha:
%                Significance level (typically 0.05).
%         Type:
%                'DIR/dir' for directed network;
%                'UND/und' for undirected network.
%
% Output
%         Backbone:
%                The backbone of weighted network, A.
%
% Reference:
% 1. Foti et al., 2011: Nonparametric Sparsification of Complex Multiscale
%    Networks. PLoS ONE.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

A = A - diag(diag(A));
A = abs(A);

N = length(A); % # of nodes

fract_wei = A./repmat(sum(A,2),1,N); % fractional edge weights

CumDF = zeros(N); % empirical cdf for the fractional edge weights at each node
Backbone = zeros(N);

for row = 1:N
    deg = length(find(fract_wei(row,:)));
    for clo = 1:N
        num = length(find(fract_wei(row,:) <= fract_wei(row,clo) & fract_wei(row,:) ~= 0));
        CumDF(row,clo) = num/deg; % For each edge, this gives the probability of choosing an edge at random of fractional weight less than or equal to fract_wei(row,clo)
        if (1 - CumDF(row,clo)) <= Alpha
          Backbone(row,clo) = 1;
        end
    end
end

if strcmpi(Type, 'und')
    Backbone = Backbone + Backbone';
    Backbone(Backbone ~= 0) = 1;
end

return