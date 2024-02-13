function endval = end(this,k,n)
%END  Last index in an indexing expression of SD object array.
%
%   END serves as the last index in an indexing expression.  In
%   that context, END = SIZE(X,k) when used as part of the k-th index.
%   Examples of this use are, X(3:end) and X(1,1:2:end-1).  When using END
%   to grow an array, as in X(end+1) = 5, make sure X exists first.
%

%
% $Id: end.m,v 1.5 2011/03/26 15:09:33 patrick Exp $
%
% Copyright (c) 2007-2011 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 2.  of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

if n==1
	endval = length(this.var);
else
	sz = size(this.var);
	if (k>length(sz)) % if the index is greater than the object's dimensions
		endval = 1;
	else % else return the size of the desired index.
	  endval = size(this.var, k);
	end
end


