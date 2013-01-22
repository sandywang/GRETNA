function seed = psom_set_rand_seed(seed)
% Change the seed of the uniform and Gaussian rand number generator
%
% SYNTAX:
% SEED = PSOM_SET_RAND_SEED(SEED)
%
% _________________________________________________________________________
% INPUTS:
%
% SEED
%   (scalar, default sum(100*clock))) the seed of the random number
%   generator.
%       
% _________________________________________________________________________
% OUTPUTS:
%
% SEED
%   (scalar) the seed of the random number generator. It is identical to
%   the input, unless the default was used.
%
% _________________________________________________________________________
% SEE ALSO:
% RAND, RANDN, RANDSTREAM
%
% _________________________________________________________________________
% COMMENTS:
%
%   This function is, in general, simply equivalent to :
%   >> rand('state',seed)
%   >> randn('state',seed)
%
%   The exact method however depends on the version of Matlab and/or
%   Octave. Recent versions of Matlab use the RandStream mechanism instead.
%
%   This function should work for every version and language.
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008-2010.
% Centre de recherche de l'institut de Gériatrie de Montréal
% Département d'informatique et de recherche opérationnelle
% Université de Montréal, 2010-2011.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : random number generator, simulation

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

if nargin == 0
    seed = sum(100*clock);
end
if exist('OCTAVE_VERSION','builtin')
    rand('state',seed);  % Octave
    randn('state',seed); % Octave
else
    try
        RandStream.setDefaultStream(RandStream('mt19937ar','seed',seed)); % matlab 7.9+
    catch
        rand('state',seed);  % Matlab 5+
        randn('state',seed); % Matlab 5+
    end
end