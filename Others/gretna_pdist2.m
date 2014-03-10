function D=gretna_pdist2(xyz, XYZ)

xyz=repmat(xyz, [size(XYZ, 1), 1]);
D=sqrt(sum((xyz-XYZ).^2, 2))';