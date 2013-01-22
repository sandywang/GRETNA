function [Ci Q] = gretna_modularity_Danon(A)

%==========================================================================
% This function is used to calculate the modular architecture for a binary
% or weighted graph or network G based on a greedy agglomerative method
% (Danon et al., 2006).
%
%
% Syntax:  function [Ci Q] = gretna_modularity_Danon(A)
%
% Input:
%        A:
%                The adjencent matrix of G.
%
% Outputs:
%        Ci:
%                N*1 cell (n = # of modules) with each cell containing the
%                indices of those nodes belonging to it.
%        Q:
%                Modularity value of the given partition.
%
% Siqi WANG, NKLCNL, BNU, BeiJing, 2012/11/20, wsqsirius@gmail.com
%==========================================================================

% Set initial communities with one node per community
tmp_com = (1:length(A))';

% Initialise best community to current value
Ci = tmp_com;

% Compute initial community matrix
numCom = length(unique(Ci));
e = zeros(numCom);
m = 0;
for i=1:length(A)
    for j=i:length(A)
        if A(i,j) ~= 0
            ic = Ci(i);
            jc = Ci(j);
            if ic == jc
                e(ic,ic) = e(ic,ic) + A(i,j);
            else
                e(ic,jc) = e(ic,jc) + (0.5 * A(i,j));
                e(jc,ic) = e(ic,jc);
            end
            m = m + A(i,j);
        end
    end
end

e = e / m;

ls = sum(e,2);
cs = sum(e,1);

tmp_Q = trace(e) - sum(sum(e^2));
Q = tmp_Q;

while length(e) > 1
    loop_best_dQp = -inf;
    can_merge = false;
    for i=1:length(e)
        for j=i+1:length(e)
            if e(i,j) > 0
                dQ = 2 * (e(i,j) - ls(i)*cs(j));
                dQp = max(dQ/ls(i),dQ/cs(j));
                if dQp > loop_best_dQp
                    loop_best_dQp = dQp;
                    saved_dQ = dQ;
                    best_pair = [i,j];
                    can_merge = true;
                end
            end
        end
    end
    
    if ~can_merge
        disp('There is no community!')
        break;
    end
    
    best_pair = sort(best_pair);
    
    for i = 1:length(tmp_com)
        if tmp_com(i) == best_pair(2)
            tmp_com(i) = best_pair(1);
        elseif tmp_com(i) > best_pair(2)
            tmp_com(i) = tmp_com(i) - 1;
        end
    end
    
    e(best_pair(1),:) = e(best_pair(1),:) + e(best_pair(2),:);
    e(:,best_pair(1)) = e(:,best_pair(1)) + e(:,best_pair(2));
    e(best_pair(2),:) = [];
    e(:,best_pair(2)) = [];
    ls(best_pair(1)) = ls(best_pair(1)) + ls(best_pair(2));
    cs(best_pair(1)) = cs(best_pair(1)) + cs(best_pair(2));
    ls(best_pair(2)) = [];
    cs(best_pair(2)) = [];
    
    tmp_Q = tmp_Q + saved_dQ;
    
    if tmp_Q > Q
        Q = tmp_Q;
        Ci = tmp_com;
    end
end

ModStr = cell(max(Ci),1);
for i = 1:max(Ci)
    ModStr{i,1} = find(Ci == i);
end
Ci = ModStr;
clear ModStr

return
