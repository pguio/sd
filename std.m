function y=std(varargin)
% function y=std(x)
% function y=std(x,dim)
% function y=std(x1,x2,...)

%
% $Id: std.m,v 1.15 2011/03/26 15:09:33 patrick Exp $
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

if nargin==1,
	x = varargin{1};
elseif nargin==2 & isnumeric(varargin{2}),
	x = varargin{1};
	dim = varargin{2};
else

	y = varargin{1};
	s = size(y.var);
	tmp = zeros([nargin, s]);
	for i=1:nargin,
		tmp(i, :) = varargin{i}.var(:);
	end
	flag = 0; % normalise by (n-1)
	dim = 1;
	y.var = reshape(std(tmp,flag,dim),s);
	return
end

if ~exist('dim'), % assume over all dimensions
	y = std(x.var(find(isfinite(x.var(:)))));
	return;
end;

y = sd;
flag = 0; % normalise by (n-1)
y.var = std(x.var,flag,dim);
% trick to squeeze only the reduced dimension
dims = size(x.var);
dims(dim) = [];
if length(dims)>1,
	y.var = reshape(y.var,dims);
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

