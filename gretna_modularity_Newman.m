function [CommunityIndex Q] = gretna_modularity_Newman(M)
%==========================================================================
% This function is used to calculate the modularity for a binary or weighted
% graph or network G based on a spectral optimization algorithm(Newman,2006).
%
%
% Syntax:  function [CommunityIndex Q] = gretna_modularity_Newman(M)
%
% Input:
%        M:
%                The adjencent matrix of G.
%
% Outputs:
%        CommunityIndex:
%                The communities (listed for each node).
%        Q:
%                Modularity value of the given partition.
%
% Siqi   WANG, NKLCNL, BNU, BeiJing, 2012/11/20, wsqsirius@gmail.com
%==========================================================================

        
N=size(M,1);
K=sum(M);       %K is the degree of each nodes(strength for weighted matrix) 
m=sum(M(:));  %m is the number of edges by 2
B=M-(K'*K)/m;   %B is Modularity Matrix
CommunityIndex=ones(N,1);
numModule=1;
isSplit=[1 0];
Bsub=B;         %Bsub is used for the subdivision after the first split
Nsub=N;
ind=1:N;
while isSplit(1)
    [V,D]=eig(Bsub);
    [~, n1]=max(diag(D));
    v1=V(:,n1);
    S=ones(Nsub,1);
    S(v1<0)=-1;
    dQ=(S')*Bsub*S; 
    if dQ>1e-10
        Bsub=Bsub-diag(diag(Bsub));
        Sit=S;
        indSub=ones(Nsub,1);
        Qit=zeros(size(indSub,1),1);
        while any(indSub)
            for i=1:Nsub
                Sit(i)=-Sit(i);
                Qit(i)=(Sit')*Bsub*Sit;
                Sit(i)=-Sit(i);
            end         
            [Qmax imax]=max(Qit.*indSub);
            Sit(imax)=-Sit(imax);
            indSub(imax)=nan;
            if Qmax>dQ
                dQ=Qmax;
                S=Sit;
            end
        end
        
        if abs(sum(S))==Nsub
            isSplit(1)=[];
        else
            CommunityIndex(ind(S==1))=isSplit(1);
            numModule=numModule+1;
            CommunityIndex(ind(S==-1))=numModule;
            isSplit=[numModule isSplit];
        end
        
    else
        isSplit(1)=[];
    end
    
    ind=find(CommunityIndex==isSplit(1));
    bsub=B(ind,ind);
    Bsub=bsub-diag(sum(bsub));
    Nsub=length(ind);
end

S=CommunityIndex(:,ones(1,N));
Q=~(S-S.').*B/m;
Q=sum(Q(:));
            
        
        
    
    
    


