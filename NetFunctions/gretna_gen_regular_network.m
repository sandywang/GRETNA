function [lattice] = gretna_gen_regular_network(N,K)

%==========================================================================
% This funciton is used to generate a regular or lattice network with N nodes
% and K edges. The edges are embedded in the network along the diagonal in
% a circle manner.
%
%
% Syntax:  function [lattice] = gretna_gen_regular_network(N,K)
%
% Inputs:
%        N:
%            The number of nodes in the generated regular network.
%        K:
%            The number of edges in the generated regular network.
%
% Output:
%        lattice:
%            The generated regular network.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

K_max = N*(N-1)/2;

if K > K_max
    error('The number of edges, K exceeds the maximum possible edges')
end

lattice = zeros(N);
M = rem(K,N);
Ntime = (K-M)/N;

for i = 1:Ntime
    for j = 1:N
        if (j+i) <= N
            lattice(j,j+i) = 1;
        else
            lattice(j+i - N, j) = 1;
        end
    end
end

if M < (N-Ntime-1)
    for i = 1:M
        lattice(i,i+Ntime+1) = 1;
    end
else
    for i =1:(N-Ntime-1)
        lattice(i,i+Ntime+1) = 1;
    end
end

MM = M - (N-Ntime-1);
for i = 1:MM
    lattice(i,N-Ntime+i-1) = 1;
end

lattice = lattice + lattice';

return