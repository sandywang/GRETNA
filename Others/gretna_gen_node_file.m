function C = gretna_gen_node_file(NodePos, NodeColor, NodeSize, NodeLabel, OutputFile)
%==========================================================================
% This function is used to generate a node file OutputFile.node for
% BrainNet Viewer
%
% Syntax: function C = gretna_gen_node_file(NodePos, NodeColor,
%                               NodeSize, NodeLable, OutputFile)
% Input:
%       NodePos:
%           The MNI position of nodes, N x 3 matrix.
%       NodeColor:
%           The color index of nodes, N x 1 matrix.
%       NodeSize:
%           The size of nodes, N x 1 matrix.
%       NodeLabel:
%           The label of nodes, N x 1 cell.
%       OutputFile:
%           The output filename of node file with path.
% Output:
%       C:
%           A cell of node file .
%
% Sandy Wang, BNU, BeiJing, 2015/03/06, sandywang.rest@gmail.com
% =========================================================================

C=[NodePos, NodeColor, NodeSize];
C=num2cell(C);
C=[C, NodeLabel];

fid=fopen(OutputFile, 'w');
Tmp=C';
fprintf(fid, '%g\t%g\t%g\t%d\t%f\t%s\n', Tmp{:});
fclose(fid);