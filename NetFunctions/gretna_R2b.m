function [A, rthr] = gretna_R2b(W, type, thr)

%==========================================================================
% This function is used to threshold a weighted matrix into a binary
% matrix by retaining those elements with the highest absolute connectivity
% strength.
%
%
% Syntax: function [A, rthr] = gretna_R2b (W, type, thr)
%
% Inputs:
%         W:
%                 The symmetric weighted matrix.
%         type:
%                 'r' for correlation threshold;
%                 's' for sparsity threshold;
%                 'k' for edge threshold;
%         thr:
%                 Correlation value if 'r';
%                 Sparsity value    if 's';
%                 Number of edges   if 'k';
%
% Outputs:
%         A:
%               The resulting binary matrix.
%         rthr:
%               The corresponding correlation value used to threshold the
%               weighted network at "thr" under "type".
%
% Yong HE, BIC,MNI, McGill 2006/09/12
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

N = length(W);
W = abs(W);
W = W - diag(diag(W)); % removing the self-correlation
A = zeros(N);

if type == 's'
    if thr > 1 || thr <= 0
        error('0 < thr <= 1');
    end
    sparsity = thr;
    K = ceil(sparsity*N*(N-1));
    
    if mod(K,2) ~= 0
        K = K + 1;
    end
end

if type == 'k'
    if thr < 1 || thr > (N)*(N-1)/2,
        error(' 1 <= thr <= N*(N-1)/2');
    end
    K = 2*thr;
end

if type == 's' || type == 'k',
    Wvec = reshape(W, N*N,1);
    Wvec = sort(Wvec,'descend');
    rthr = Wvec((K));
else
    rthr = thr;
end

if rthr == 0
    A(W > rthr) = 1;
    warning('The non-zero mimimum in the matrix is larger than that determined by the specificed parameter!')
else
    A(W >= rthr) = 1;
end

return
