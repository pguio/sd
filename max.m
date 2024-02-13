function [y, varargout] = max(varargin)
% function [y [, i]] = max(x)
% function [y [, i]] = max(x,[],dim)
% function [y [, i]] = max(x1,x2,...,xn)

%
% $Id: max.m,v 1.16 2011/11/08 11:38:04 patrick Exp $
%
% Copyright (c) 2001-2011 Patrick Guio <patrick.guio@gmail.com>
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

if nargin == 1,
  % max(x)
	x = varargin{1};
elseif nargin == 3 & isempty(varargin{2}) & isinteger(varargin{3}),
  % max(x,[],dim)
	x = varargin{1};
	dim = varargin{3};
else
  % max(x1,x2,...,xn)
	y = varargin{1};
	s = size(y.var);
	% makes an array with n+1 dimensions, where 1st dim is length n
	tmp = zeros([nargin, s]);
	for i=1:nargin,
		tmp(i, :) = varargin{i}.var(:);
	end
  [tmp,i] = max(tmp,[],1);
	y.var = reshape(tmp,s);
	if nargout==2,
	  varargout{1} = reshape(i,s);
	end
	return
end

if ~exist('dim'), % assume over all dimensions
	[y,i] = max(x.var(find(isfinite(x.var(:)))));
	if nargout==2,
	  varargout{1} = i;
	end
	return;
end;

y = sd;
[y.var,i] = max(x.var,[],dim);
% trick to squeeze only the reduced dimension
dims = size(x.var);
dims(dim) = [];
if length(dims)>1,
	y.var = reshape(y.var, dims);
	i = reshape(i, dims);
end
if nargout==2,
  varargout{1} = i;
end
y.varname = x.varname;
j=1;
for i=1:length(x.dims)
	if i~=dim,
		y.dims{j} = x.dims{i};
		y.dimsname{j} = x.dimsname{i};
		j = j+1;
	end
end

