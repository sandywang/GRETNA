function [PC] = gretna_parcoeff(A, module)

%==========================================================================
% This function is used to calculate the participant coefficient of each
% node based on the identified modular structure.
%
%
% Syntax: function [PC] = gretna_parcoeff(A, module)
%
% Inputs:
%         A:
%               The connectivity matrix.
%         module:
%               The modular structure of A
%               (e.g., the 10 nodes network A has 3 modules, module1 includes
%               node 1, 2 and 3; module2 includes node 4, 7 and 8; and the
%               last module3 includes node 5, 6, 9 and 10,then 
%               module = {[1 2 3], [4 7 8], [5 6 9 10]}).
%
% Output:
%      PC.original:
%            Vector of original participant coefficients.
%      PC.normalized:
%            Vector of normalized participant coefficients by max participant
%            coefficient of a modular structure with n modules.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

A = A - diag(diag(A));
A = abs(A);

N = length(A);
num_mod = length(module);
withinmod = zeros(num_mod,1);

ver_deg = sum(A);


for ver = 1:N
    if ver_deg(ver) == 0
        PC.original(ver) = 0;
    else
        for i = 1:num_mod
            withinmod(i) = sum(A(ver,module{i}));
        end
        withinmod = (withinmod./ver_deg(ver)).^2;
        PC.original(ver) = 1 - sum(withinmod);
    end
end

if num_mod ~= 1
    PC_max = (num_mod - 1)/num_mod;
    PC.normalized = PC.original/PC_max; % The normaized PC value ensure the comparability between subjects since the possible different number of modules
else
    PC.normalized = PC.original;
end

return