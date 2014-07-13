function p = gretna_nextpow2(n)

%==========================================================================
% This function is used to calculate the smallest power of two that is 
% greater than or equal to n (> 0). 
%
% Syntax: function Result = gretna_nextpow2(n)
%
% Input:
%       n: 
%                 A positive integer.
%
% Output:
%       p:
%                 The returned power.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2010/08/16, Jinhui.Wang.1982@gmail.com
% Modified according to AFNI and REST packages.
%==========================================================================

if n < 16
    p = 2^nextpow2(n);
    return;
end

limit = nextpow2(n);            %n=134, limit=8
tbl = 2^(limit-1):2^limit;      %tbl =128, 129, ... , 256
tbl = tbl(tbl>=n);          %tbl =134, 135, ... , 256

for x=1:length(tbl)
    p = tbl(x);
    [f,E] = log2(p);
    if ~isempty(f) && f == 0.5   %Copy from nextpow2.m
        return;
    end
    if mod(p,3*5) == 0
        y = p/(3*5);
        [f,E] = log2(y);
        if ~isempty(f) && f == 0.5   %Copy from nextpow2.m
            return;
        end
    end
    if mod(p,3) == 0
        y = p/3;
        [f,E] = log2(y);
        if ~isempty(f) && f == 0.5   %Copy from nextpow2.m
            return;
        end
    end
    if mod(p,5) ==0
        y = p/5;
        [f,E] = log2(y);
        if ~isempty(f) && f == 0.5   %Copy from nextpow2.m
            return;
        end
    end
end

p = NaN;    % Should not reach, except when n=1

return