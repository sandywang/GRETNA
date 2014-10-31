function [Phi, NodeIndex]=gretna_rich_club(M, KThr)
%==========================================================================
% This function is used to calculate the rich club for a binary graph or 
% network G based on (Zhou and Mondragon, 2004; Colizza et al., 2006; 
% McAuley et al., 2007; Van den Heuvel and Sporns, 2011): 
%
%
% Syntax:  [Phi, NodeIndex]=gretna_rich_club(M, KThr)
%
% Input:
%        M:
%                The adjencent matrix of G.
%        KThr:
%                A threshold's vector of Degree. (A Vector, 1*N)
%
% Outputs:
%        Phi:
%                The rich-club coefficient.
%        NodeIndex:
%                The index of Kth nodes. (A Structure)
%
% Written by Wang Xindi, 20141027.
% sandywang.rest@gmail.com
%==========================================================================
N=size(M, 1);
M=abs(M);
M=M-diag(diag(M));
[AvgDeg, Deg]=gretna_node_degree(M);

Phi=zeros(1, numel(KThr));
NodeIndex.Rank=zeros(1, N);
for k=1:numel(KThr)
    Index=(Deg>KThr(k));
    NodeIndex.(sprintf('K%.4d', KThr(k)))=Index;
    NodeIndex.Rank(Index)=KThr(k);
    
    Nk=sum(Index);
    Mask=repmat(Index, [N, 1]);
    Mask=Mask.*(Mask');
    Edge=M.*Mask;
    Ek=sum(sum(Edge)); %This is 2*Ek
    Phi(1, k)=Ek/(Nk*(Nk-1));
end